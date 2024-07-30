Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F33718A6A7;
	Tue, 30 Jul 2024 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360775; cv=none; b=WCSoJmcTCuCbNOeGeNADOmkEzr7M3msNwVII+D1GCTqldBXrLl6woR0Ci/mDsNoE8pEC05dQysQq9MWjzCDcr3EA5Sin5MCkN0v9BzNnSxpOOqr5r4mI5iUNUSpG+TxwgKHgninBN5I60akR8vNW11qCcYYj3aiCeTjrr7EvUEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360775; c=relaxed/simple;
	bh=Bbo7PU/ubNiNPr/gWmcHTFCnmy+JHoOLLTLn8lXCBFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n42oMwHmFz708dXd/e7eLW+FRav9SK5WuTejVMKsO5jHJTLPH7e43n7RnJlZe+P6h53+AZ3+9k7i8Jluvx1MVQZKLutoavGHTBAWLBZCiIzPEa3IkNAuQCKkuQf7WSTijy31r8OhmPATIHpjYChPC0S1Zix4srK817MBg3C2Xvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NK/2VgmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NK/2VgmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97017C4AF0C;
	Tue, 30 Jul 2024 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360775;
	bh=Bbo7PU/ubNiNPr/gWmcHTFCnmy+JHoOLLTLn8lXCBFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK/2VgmWg6xX7o8DiVI2o9VcxCMmiC00Rauy8S88OFgfBwlFfOoWx4u06b0jxAMw3
	 EcX2krO3u9Vdl4A5IhNn9ZwcKymD1JouiiJKLHOzY5g6BJFF4DAfOq6p6w+K1ID8U7
	 zBPEsU/rWO+mEUnPAuEUKnN8f97C0bedepRG+RPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 804/809] apparmor: unpack transition table if dfa is not present
Date: Tue, 30 Jul 2024 17:51:20 +0200
Message-ID: <20240730151756.736580904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit e0ff0cff1f6cdce0aa596aac04129893201c4162 ]

Due to a bug in earlier userspaces, a transition table may be present
even when the dfa is not. Commit 7572fea31e3e
("apparmor: convert fperm lookup to use accept as an index") made the
verification check more rigourous regressing old userspaces with
the bug. For compatibility reasons allow the orphaned transition table
during unpack and discard.

Fixes: 7572fea31e3e ("apparmor: convert fperm lookup to use accept as an index")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 42 ++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 5e578ef0ddffb..a6be77b665f6e 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -747,34 +747,42 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 			*info = "missing required dfa";
 			goto fail;
 		}
-		goto out;
+	} else {
+		/*
+		 * only unpack the following if a dfa is present
+		 *
+		 * sadly start was given different names for file and policydb
+		 * but since it is optional we can try both
+		 */
+		if (!aa_unpack_u32(e, &pdb->start[0], "start"))
+			/* default start state */
+			pdb->start[0] = DFA_START;
+		if (!aa_unpack_u32(e, &pdb->start[AA_CLASS_FILE], "dfa_start")) {
+			/* default start state for xmatch and file dfa */
+			pdb->start[AA_CLASS_FILE] = DFA_START;
+		}	/* setup class index */
+		for (i = AA_CLASS_FILE + 1; i <= AA_CLASS_LAST; i++) {
+			pdb->start[i] = aa_dfa_next(pdb->dfa, pdb->start[0],
+						    i);
+		}
 	}
 
 	/*
-	 * only unpack the following if a dfa is present
-	 *
-	 * sadly start was given different names for file and policydb
-	 * but since it is optional we can try both
+	 * Unfortunately due to a bug in earlier userspaces, a
+	 * transition table may be present even when the dfa is
+	 * not. For compatibility reasons unpack and discard.
 	 */
-	if (!aa_unpack_u32(e, &pdb->start[0], "start"))
-		/* default start state */
-		pdb->start[0] = DFA_START;
-	if (!aa_unpack_u32(e, &pdb->start[AA_CLASS_FILE], "dfa_start")) {
-		/* default start state for xmatch and file dfa */
-		pdb->start[AA_CLASS_FILE] = DFA_START;
-	}	/* setup class index */
-	for (i = AA_CLASS_FILE + 1; i <= AA_CLASS_LAST; i++) {
-		pdb->start[i] = aa_dfa_next(pdb->dfa, pdb->start[0],
-					       i);
-	}
 	if (!unpack_trans_table(e, &pdb->trans) && required_trans) {
 		*info = "failed to unpack profile transition table";
 		goto fail;
 	}
 
+	if (!pdb->dfa && pdb->trans.table)
+		aa_free_str_table(&pdb->trans);
+
 	/* TODO: move compat mapping here, requires dfa merging first */
 	/* TODO: move verify here, it has to be done after compat mappings */
-out:
+
 	*policy = pdb;
 	return 0;
 
-- 
2.43.0



