Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6C433D4E2;
	Mon, 13 Apr 2026 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099671; cv=none; b=dKkcBncA+GZoAONBi7GjgTxmlUCfJEMgQbhAY68aSHf9fGHKgLnAbHufRhEyY3zeoFdlkVdkdSLkuv+axLDclhiT8mqOFf82zaJ4spjcWF9XSF+4bStKjFNzCoYDB+vP8LsCTDkMjL08a5p6wkWA4YouSotdnkBivx8g7IavA9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099671; c=relaxed/simple;
	bh=Hkw8gra5sRDQD5CqS87Ntfp6/FjQ3vHRPK3DCMYoJgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr1x1pV5LegOtGhmz7gErv+yO8Ebp7IbosqVCiwhCAyRkJzfbjojNJEIDYqrbbn7mrQu4FFvXFhheDQAIFH/qVMMDLm8fRK881h1oWzL5f0muuiabsea51ICYkAOWSXol/4e3UVlblYEtMrK6ZknHvWNH8UbawXN2zj/GTYaBVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrBreJyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrBreJyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B7C2BCAF;
	Mon, 13 Apr 2026 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099671;
	bh=Hkw8gra5sRDQD5CqS87Ntfp6/FjQ3vHRPK3DCMYoJgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrBreJyPEj4qdtDHA7DlkmjJprM2L08S3HPqvNRS1/GsWR+8MIGwM1V9iY9/5CiMo
	 BtVp8fn0/40v3RMazyQ+JmOts5YNVM/+RXEXYi4WKJFtgnVEAP9fJH2x33uSSUE0mO
	 wgOjTAvu2WOOitCW+gBR1/f37kEvTUqCbdrcF53A=
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
Subject: [PATCH 5.10 430/491] apparmor: validate DFA start states are in bounds in unpack_pdb
Date: Mon, 13 Apr 2026 18:01:15 +0200
Message-ID: <20260413155835.127014179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


