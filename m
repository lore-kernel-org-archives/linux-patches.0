Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CC124E4A1;
	Mon, 13 Apr 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098497; cv=none; b=D2XEJQu0XNXCNVO9AhW98R+s5S81+Z2TFpd6As0RLqk1H+ce7OHs7PbqdAxD+cDok+qn4wKyhHhd/qVoEZiBAXuA6jzSFnMio0R4YZh4EjXkxJYtBM35lQ4YXcpSXvgjLCPsp1UgPGEFPJRYBznPr+QJ27Y+c8o/eupIz/SV8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098497; c=relaxed/simple;
	bh=PUkptJhKe6aZ6wjl3x3aJdvHvB3MJEoNGSi9lDqKjwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YN9z1UFLPYI+0aasA1ovqj9NqRlM1775SoA1jBl3R33P/8LkYnOrsZgIRAlwXoTD4yNksfCsLFqCM2KoeK4MDAlk5ytFZOnu7CC2FyjMDV4Me54SKtGmTbcvtaQIeZPaNg6RsquhsyiNVGBFKdkjkBzCIB43sZRCiOFNUHdqTno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QASTLKab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QASTLKab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2D5C2BCAF;
	Mon, 13 Apr 2026 16:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098496;
	bh=PUkptJhKe6aZ6wjl3x3aJdvHvB3MJEoNGSi9lDqKjwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QASTLKab4/qXZZcXO2jJLEJ96g2tFTpn3xXmSkPB8wy2AEz/emjExuetZ3SA6iQ5U
	 2Q7XW17iAD6fuOl1JhUEBWRWjU/XHR5n6JEj7iCYbt7eBf3vy2numfVXa+kJQlG3CY
	 r5zCIrs/gMk2ikeB3GL30tTXO7yJJ8Pd/gphSOmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 515/570] apparmor: validate DFA start states are in bounds in unpack_pdb
Date: Mon, 13 Apr 2026 18:00:46 +0200
Message-ID: <20260413155849.739653022@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit 9063d7e2615f4a7ab321de6b520e23d370e58816 upstream.

Backport for conflicts caused by
  ad596ea74e74 ("apparmor: group dfa policydb unpacking")
  - rearrange and consolidated the unpack.

  b11e51dd7094 ("apparmor: test: make static symbols visible during kunit testing")
  - rename function and make it visible to kunit tests

Start states are read from untrusted data and used as indexes into the
DFA state tables. The aa_dfa_next() function call in unpack_pdb() will
access dfa->tables[YYTD_ID_BASE][start], and if the start state exceeds
the number of states in the DFA, this results in an out-of-bound read.

==================================================================
 BUG: KASAN: slab-out-of-bounds in aa_dfa_next+0x2a1/0x360
 Read of size 4 at addr ffff88811956fb90 by task su/1097
 ...

Reject policies with out-of-bounds start states during unpacking
to prevent the issue.

Fixes: ad5ff3db53c6 ("AppArmor: Add ability to load extended policy")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -841,9 +841,18 @@ static struct aa_profile *unpack_profile
 			error = -EPROTO;
 			goto fail;
 		}
-		if (!unpack_u32(e, &profile->policy.start[0], "start"))
+		if (!unpack_u32(e, &profile->policy.start[0], "start")) {
 			/* default start state */
 			profile->policy.start[0] = DFA_START;
+		} else {
+			size_t state_count = profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen;
+
+			if (profile->policy.start[0] >= state_count) {
+				info = "invalid dfa start state";
+				goto fail;
+			}
+		}
+
 		/* setup class index */
 		for (i = AA_CLASS_FILE; i <= AA_CLASS_LAST; i++) {
 			profile->policy.start[i] =
@@ -864,9 +873,17 @@ static struct aa_profile *unpack_profile
 		info = "failed to unpack profile file rules";
 		goto fail;
 	} else if (profile->file.dfa) {
-		if (!unpack_u32(e, &profile->file.start, "dfa_start"))
+		if (!unpack_u32(e, &profile->file.start, "dfa_start")) {
 			/* default start state */
 			profile->file.start = DFA_START;
+		} else {
+			size_t state_count = profile->file.dfa->tables[YYTD_ID_BASE]->td_lolen;
+
+			if (profile->file.start >= state_count) {
+				info = "invalid dfa start state";
+				goto fail;
+			}
+		}
 	} else if (profile->policy.dfa &&
 		   profile->policy.start[AA_CLASS_FILE]) {
 		profile->file.dfa = aa_get_dfa(profile->policy.dfa);


