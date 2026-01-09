Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AF62F12D4;
	Fri,  9 Jan 2026 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959422; cv=none; b=jrND9ay1gtTZ2iTgD8Tl7xXkHYt0tWqgBiwixjvdiYtVlScZgT5YplHN4rei1ZXEsrGkKL+q3yUKCP2LonTBzo/ktxlTABbGMrmG0+JSj0lBizzo3o1LrFxjx+IO3HL8GtwcpCboKY/DgBeHicAj6l0WQcCuVrUC2c1roexMraU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959422; c=relaxed/simple;
	bh=/nc0GAoQ9FfSlTJQPIhst5+hgUyF6lWj5d7k+l7a6cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGC/XAyzkg1UYKY/AEgAmtcA++VXbDQjYJqVMrg2Wg8DakvRa3r1svtFOCaL9REyoLS9AQ512mQw0ocC7opl4xM+pDLwmwt9wYuX8V4T1FBXsFmnB3+I78dd6B82cKS8tslJ+QD2A266RFwjl40c2tMHxDeqaqL6pWTUK3bMcjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhu0vNvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhu0vNvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E18C19422;
	Fri,  9 Jan 2026 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959422;
	bh=/nc0GAoQ9FfSlTJQPIhst5+hgUyF6lWj5d7k+l7a6cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhu0vNvlpBOpd06He3gI1l/u/6QlbiVyeNao2brSMOZE7M66g2nUTphYvLPPK8Nz+
	 5n2DjAMlu00IDg7jon8a0SvPk3iwpEt51glEnxquitf1duFxp8yrVAvtL+U8rM0Jqv
	 taUK01oOSqgoQXK5Bzu0upXEx0HkuIjsDahsk1wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/737] smack: fix bug: unprivileged task can create labels
Date: Fri,  9 Jan 2026 12:33:06 +0100
Message-ID: <20260109112135.764018445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index d272cf8160d53..8d38f4a813171 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3687,8 +3687,8 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	struct task_smack *tsp = smack_cred(current_cred());
 	struct cred *new;
 	struct smack_known *skp;
-	struct smack_known_list_elem *sklep;
-	int rc;
+	char *labelstr;
+	int rc = 0;
 
 	if (!smack_privileged(CAP_MAC_ADMIN) && list_empty(&tsp->smk_relabel))
 		return -EPERM;
@@ -3699,28 +3699,41 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
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



