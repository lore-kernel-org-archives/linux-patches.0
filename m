Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987B8261B9C;
	Mon, 23 Mar 2026 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278142; cv=none; b=UWvY1W1UnhzWvID0zX6k3jnL/C8hsqR8Xg+vRg4QzjsrwWukwfof84992JFpgZFvne/1Xr0kGVSY1VV8gDz71l8WLeyHYe07YpbsHSWNLjWNCwxVtsGkzDAElvwS/CzwoOIZZFQpMzDpZvBOifOI0uBTwOoJkCBkC73C41ydI3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278142; c=relaxed/simple;
	bh=+fDKxp0Qvg7OseVEJAi4q1LkAADykoagDy0nzhJIrC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz9fn8bHdAYFW5F3qNNQ9Ce0Fseo3A4HmZFXeKwYN73lQ4WwoGmy5MuprDw9DeDWFOyt+BOmD/GYJro37jH2tMSxgnkhJk3/96cUFZMl3WWeE5fEkxZ5Uf9tjFRH44URQYc9B6A2xPjyg2GuoR6VUaV3Lr3P1h71KZ0zdtUPaRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2jKaHqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2jKaHqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A54C4CEF7;
	Mon, 23 Mar 2026 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278142;
	bh=+fDKxp0Qvg7OseVEJAi4q1LkAADykoagDy0nzhJIrC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2jKaHqtSIveWd6I0rQov5FAl45uinx1VZz0gK3xDV2aly/2YFUO86QCnwPWvA0AA
	 iffwoArQNfW5U4vhJEwXgNuOTtI+u/EIQh/+jhr9JEzY4oH+MwVdI1ByAAhzncH+W7
	 kz6yPSe1xTaye+6pDVBtNomvbFTpZ/j8jlQo/hck=
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
Subject: [PATCH 6.6 187/567] apparmor: validate DFA start states are in bounds in unpack_pdb
Date: Mon, 23 Mar 2026 14:41:47 +0100
Message-ID: <20260323134538.478682723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit 9063d7e2615f4a7ab321de6b520e23d370e58816 upstream.

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
 security/apparmor/policy_unpack.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -764,7 +764,17 @@ static int unpack_pdb(struct aa_ext *e,
 	if (!aa_unpack_u32(e, &pdb->start[AA_CLASS_FILE], "dfa_start")) {
 		/* default start state for xmatch and file dfa */
 		pdb->start[AA_CLASS_FILE] = DFA_START;
-	}	/* setup class index */
+	}
+
+	size_t state_count = pdb->dfa->tables[YYTD_ID_BASE]->td_lolen;
+
+	if (pdb->start[0] >= state_count ||
+	    pdb->start[AA_CLASS_FILE] >= state_count) {
+		*info = "invalid dfa start state";
+		goto fail;
+	}
+
+	/* setup class index */
 	for (i = AA_CLASS_FILE + 1; i <= AA_CLASS_LAST; i++) {
 		pdb->start[i] = aa_dfa_next(pdb->dfa, pdb->start[0],
 					       i);


