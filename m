Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41DB35A952;
	Fri,  9 Jan 2026 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961513; cv=none; b=hiH6XTqRSumZy6ZS/gFUt9gMKzLD6GfBPB93bxHcLlApQu9J1UAY45ASOvz23R21DA7MxdgvTh2eQij1MCFCjsQhQIXFlnOh9CCX2LeKefttpT8h3eoMt53FLxxko4AHeFIpkBKHf9Lf7rySFVpG9dAlvCZ7qeMOFoqKeU4nLvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961513; c=relaxed/simple;
	bh=kH43g4IVttJl/53DLlapi8WmT0UlYytzNReEKlkUf54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTbNY7Pd22dh5q6wub23uyYGra6QYTrBisUVo1YJsEB0wISALiNPC8WK0PymCCe93hd+c2cETT4eNXcfGer0vNIhEAJzX2uJmrJaJIrDcWApJXq5JlU7DhY9xJKP7AOB3ZUjgXUCc2w9d3bKtM6MA/ZIfaxuWi/xlRbl0cV303U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xv/mSms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xv/mSms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F7CC4CEF1;
	Fri,  9 Jan 2026 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961512;
	bh=kH43g4IVttJl/53DLlapi8WmT0UlYytzNReEKlkUf54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xv/mSmsip3WdPNJt6V4e2H2SJglLX5Z/IuAgfKb4fBjKCEA0JgWneCDk2MhNgs7B
	 SveO/RJP+AGU9lPAU/83Wz0TjcIJLVf4XTmYFfd8ulo/hjREiqh//vPByzt7b9P+XY
	 nXn4veo2CSjlylNl23NYXwBNOOdRzgdSvuhdspwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/634] smack: fix bug: unprivileged task can create labels
Date: Fri,  9 Jan 2026 12:35:19 +0100
Message-ID: <20260109112118.992578447@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 285103ffc75c6..4b252646081b4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3624,8 +3624,8 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	struct task_smack *tsp = smack_cred(current_cred());
 	struct cred *new;
 	struct smack_known *skp;
-	struct smack_known_list_elem *sklep;
-	int rc;
+	char *labelstr;
+	int rc = 0;
 
 	if (!smack_privileged(CAP_MAC_ADMIN) && list_empty(&tsp->smk_relabel))
 		return -EPERM;
@@ -3636,28 +3636,41 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
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



