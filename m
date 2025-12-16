Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1642235CB96;
	Tue, 16 Dec 2025 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886771; cv=none; b=Ln99MixGBvRlICjw0zjpVvrdSBoD5YboBJ+yT4a2WyqHFMX/3hj4Vf5jPWgQKMkJIyWV+cMDKPW8s5YS6PL5psfTAaRmT6sTJiFebicmDazJj15l6tSpdruJ8dMeKIfEJbNJIHD6SKzfMs76OGL7V28Vhapv/sXjnQ5HxZchF8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886771; c=relaxed/simple;
	bh=+nT3JZLj0tmlgD0zkLFFD+rOafgRv590qqmAbb0RsL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTpFR8Iqp4eSXkSwIdczUNX+A9DkaBhAqx67X6msLrkKyIz+xzJyYQw9zTR2RipZ7hdsOMRLLj6J3VPXPbPyP868qcpHzf+bmMNW4NaakYOMg33L5YZ5MTYjR6zga344+RvUaMyJ5oJh9JMnH/e4uJnCxhSFgBnRU/tevKlnzIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS2U73Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS2U73Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C60C4CEF5;
	Tue, 16 Dec 2025 12:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886770;
	bh=+nT3JZLj0tmlgD0zkLFFD+rOafgRv590qqmAbb0RsL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pS2U73ZaAI+FlPvVBm1yd/f/cL3U+8RB6PQCTT8uSai6jQt7mq2nVMW8Y6snSVVXa
	 T6ncheVGwpn+WzrmWovVKFMgr9p9OsbYAaQNztocvIf2PmgZunMp5JBbw67/1ztbZ1
	 4NiFv7zTZKQhnQYHRD1ogS5xgYMkyszwUq4A4NQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/614] smack: fix bug: unprivileged task can create labels
Date: Tue, 16 Dec 2025 12:06:13 +0100
Message-ID: <20251216111401.524638294@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit c147e13ea7fe9f118f8c9ba5e96cbd644b00d6b3 ]

If an unprivileged task is allowed to relabel itself
(/smack/relabel-self is not empty),
it can freely create new labels by writing their
names into own /proc/PID/attr/smack/current

This occurs because do_setattr() imports
the provided label in advance,
before checking "relabel-self" list.

This change ensures that the "relabel-self" list
is checked before importing the label.

Fixes: 38416e53936e ("Smack: limited capability for changing process label")
Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 41 +++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d16453801a79e..07dbc4cd303a7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3778,8 +3778,8 @@ static int do_setattr(u64 attr, void *value, size_t size)
 	struct task_smack *tsp = smack_cred(current_cred());
 	struct cred *new;
 	struct smack_known *skp;
-	struct smack_known_list_elem *sklep;
-	int rc;
+	char *labelstr;
+	int rc = 0;
 
 	if (!smack_privileged(CAP_MAC_ADMIN) && list_empty(&tsp->smk_relabel))
 		return -EPERM;
@@ -3790,28 +3790,41 @@ static int do_setattr(u64 attr, void *value, size_t size)
 	if (attr != LSM_ATTR_CURRENT)
 		return -EOPNOTSUPP;
 
-	skp = smk_import_entry(value, size);
-	if (IS_ERR(skp))
-		return PTR_ERR(skp);
+	labelstr = smk_parse_smack(value, size);
+	if (IS_ERR(labelstr))
+		return PTR_ERR(labelstr);
 
 	/*
 	 * No process is ever allowed the web ("@") label
 	 * and the star ("*") label.
 	 */
-	if (skp == &smack_known_web || skp == &smack_known_star)
-		return -EINVAL;
+	if (labelstr[1] == '\0' /* '@', '*' */) {
+		const char c = labelstr[0];
+
+		if (c == *smack_known_web.smk_known ||
+		    c == *smack_known_star.smk_known) {
+			rc = -EPERM;
+			goto free_labelstr;
+		}
+	}
 
 	if (!smack_privileged(CAP_MAC_ADMIN)) {
-		rc = -EPERM;
+		const struct smack_known_list_elem *sklep;
 		list_for_each_entry(sklep, &tsp->smk_relabel, list)
-			if (sklep->smk_label == skp) {
-				rc = 0;
-				break;
-			}
-		if (rc)
-			return rc;
+			if (strcmp(sklep->smk_label->smk_known, labelstr) == 0)
+				goto free_labelstr;
+		rc = -EPERM;
 	}
 
+free_labelstr:
+	kfree(labelstr);
+	if (rc)
+		return -EPERM;
+
+	skp = smk_import_entry(value, size);
+	if (IS_ERR(skp))
+		return PTR_ERR(skp);
+
 	new = prepare_creds();
 	if (new == NULL)
 		return -ENOMEM;
-- 
2.51.0



