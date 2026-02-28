Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F85338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301741; cv=none; b=Wzznose8WMK7iUMp6SSGygk7AANs1BuLguIInKLK6F88pAwQaWngyScZqKpKEQf7/Cbv9DQf8zs65ADqgp8ajubD1/yKS4v5Wn8JVsEotaoL5BOOstm59fpsiXYA2nBgChfBLTFbk+Be6EJsPVRDx+6+eDur8ayDZJtYXCFB9JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301741; c=relaxed/simple;
	bh=g10O2WvfYjfPwPhl5f25B1KCWWw7OOjKWV9rkdzcH1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huJSZphFvYYGE+brFBqeY7LOD6PirztzlIBo/z+e+3ouqPVktYH+EZehKSxuvvPI6M6BY2GZbhXX1X/lzJZ7lYzkJ9vTwEDke/N4RemeBwQlOzfgf+rUHn2EDouXFo/vivh7Mnw200hpo7SA+du5O4wN4trZwzluIBH3XIqLNo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CE0foN3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CE0foN3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D65C19423;
	Sat, 28 Feb 2026 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301741;
	bh=g10O2WvfYjfPwPhl5f25B1KCWWw7OOjKWV9rkdzcH1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CE0foN3gqJogJoFKV6s/FDzhi5ZlOajNg06VAAxbWBKvjwspoOVJK7FPxNZQ70K6v
	 +2ByatO2tqh7ypFwCGGnl9SDOSlw5LE4ynURqLRCRZwPb0/bmn0drJBzW3r9y1RDmm
	 U3XDqcgvTscHwtqvsRKYa/GMqkttnc9wnJRi3ECtrBMjPmKKwD/9FsbK59HwUAJ4sX
	 jvWPDtwIlknVXxmub2GKVx122pfhj9O7dZg6t7iphaWI3HHS8zIkONYX2BFkoXcdDS
	 0kRace68VQfJGF6pJFbEt7/uqsyvwgQbzywCs//emT14esBcaBvYPXfl+ZYYlSzvFJ
	 xKIDok2JISfKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/385] smack: /smack/doi must be > 0
Date: Sat, 28 Feb 2026 12:56:04 -0500
Message-ID: <20260228180011.1568201-142-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 19c013e1551bf51e1493da1270841d60e4fd3f15 ]

/smack/doi allows writing and keeping negative doi values.
Correct values are 0 < doi <= (max 32-bit positive integer)

(2008-02-04, Casey Schaufler)
Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 1e35c9f807b2b..a130007397562 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -139,7 +139,7 @@ struct smack_parsed_rule {
 	int			smk_access2;
 };
 
-static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
+static u32 smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 /*
  * Values for parsing cipso rules
@@ -1580,7 +1580,7 @@ static ssize_t smk_read_doi(struct file *filp, char __user *buf,
 	if (*ppos != 0)
 		return 0;
 
-	sprintf(temp, "%d", smk_cipso_doi_value);
+	sprintf(temp, "%lu", (unsigned long)smk_cipso_doi_value);
 	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
 
 	return rc;
@@ -1599,7 +1599,7 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	char temp[80];
-	int i;
+	unsigned long u;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -1612,10 +1612,12 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 
 	temp[count] = '\0';
 
-	if (sscanf(temp, "%d", &i) != 1)
+	if (kstrtoul(temp, 10, &u))
 		return -EINVAL;
 
-	smk_cipso_doi_value = i;
+	if (u == CIPSO_V4_DOI_UNKNOWN || u > U32_MAX)
+		return -EINVAL;
+	smk_cipso_doi_value = u;
 
 	smk_cipso_doi();
 
-- 
2.51.0

