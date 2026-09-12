Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572213BCD19;
	Sat, 12 Sep 2026 07:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196883; cv=none; b=OGoHICveCpKDZnahApFK1iEXXJKJp3OpZ7zdwlbUAwOWGEDBLWbEjpqRbiX2l3Tf8yZ0xwsf+SC5rmcxE9X2zlyEDtELDH2XmUEExhPpK3pbG3ka6A14ualOd/UGMkifMi6Br+1O1Afz4Xs4yMQgPvvs+FJMQo1qPnZbe2Kx4fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196883; c=relaxed/simple;
	bh=YbKTtgRCuwYnbzLbVxp1fJfgZ/0DF0waVUXe8lqNBEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfMHYEs0z6x5x2XE+TpCcSTtmvn1DQx1XFIoH+hK7CHcq4tUDKG01osU6IU1keHe3vj5MQgR5Cf9E1fZL/WFbGr0e0rgJbdKY4231eN5DcdScAXixqiyMiEbGj/d3juiIAwtFKgtzr/QLPStgHhIheU64TsW7/K2DRJzSWQ5atA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mamtsRB6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mamtsRB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF381F000FF;
	Sat, 12 Sep 2026 07:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196882;
	bh=mu+gnr8a/aPfbsnZRgtM1vl7pyjZm+8edjLmBzzDDhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mamtsRB69IA1UrsNTwHrxRBNbC/Tb1kyqgfVxMfQ8gXw43NuZfn8U9QEUXBp03ElD
	 E4wJlBMPTWSNM/eiTj8MdT60R+AuMApEnipyMnu0IEwTLOQBCnYaXQU9MAvtBv6x7S
	 85oYxJR5iXNt7Rf00uqc0fNvQt64K1rTewxg8Rqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0057/1815] smack: simplify write handlers of sysfs entries
Date: Sat, 12 Sep 2026 08:30:07 +0200
Message-ID: <20260912065650.354255793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit b78fede1c69a090d377bf80417ce1f7f7f314534 ]

Use the convenient 'kstrto{u,s}32_from_user()' to simplify write
handlers of /smack/{doi,direct,mapped,logging,ptrace} sysfs entries.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: 577dc3b6a8cf ("smack: deduplicate smackfs/{direct,mapped} file_operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 81 +++++++++++-----------------------------
 1 file changed, 22 insertions(+), 59 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 6e62dcb36f74f..f60d5469043ed 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1598,24 +1598,17 @@ static ssize_t smk_read_doi(struct file *filp, char __user *buf,
 static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	char temp[80];
-	unsigned long u;
+	int ret;
+	u32 u;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (count >= sizeof(temp) || count == 0)
-		return -EINVAL;
-
-	if (copy_from_user(temp, buf, count) != 0)
-		return -EFAULT;
-
-	temp[count] = '\0';
+	ret = kstrtou32_from_user(buf, count, 10, &u);
+	if (unlikely(ret))
+		return ret;
 
-	if (kstrtoul(temp, 10, &u))
-		return -EINVAL;
-
-	if (u == CIPSO_V4_DOI_UNKNOWN || u > U32_MAX)
+	if (u == CIPSO_V4_DOI_UNKNOWN)
 		return -EINVAL;
 
 	return smk_cipso_doi(u, GFP_KERNEL) ? : count;
@@ -1664,22 +1657,14 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	struct smack_known *skp;
-	char temp[80];
-	int i;
+	int i, ret;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (count >= sizeof(temp) || count == 0)
-		return -EINVAL;
-
-	if (copy_from_user(temp, buf, count) != 0)
-		return -EFAULT;
-
-	temp[count] = '\0';
-
-	if (sscanf(temp, "%d", &i) != 1)
-		return -EINVAL;
+	ret = kstrtos32_from_user(buf, count, 10, &i);
+	if (unlikely(ret))
+		return ret;
 
 	/*
 	 * Don't do anything if the value hasn't actually changed.
@@ -1742,22 +1727,14 @@ static ssize_t smk_write_mapped(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	struct smack_known *skp;
-	char temp[80];
-	int i;
+	int i, ret;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (count >= sizeof(temp) || count == 0)
-		return -EINVAL;
-
-	if (copy_from_user(temp, buf, count) != 0)
-		return -EFAULT;
-
-	temp[count] = '\0';
-
-	if (sscanf(temp, "%d", &i) != 1)
-		return -EINVAL;
+	ret = kstrtos32_from_user(buf, count, 10, &i);
+	if (unlikely(ret))
+		return ret;
 
 	/*
 	 * Don't do anything if the value hasn't actually changed.
@@ -2179,22 +2156,15 @@ static ssize_t smk_read_logging(struct file *filp, char __user *buf,
 static ssize_t smk_write_logging(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	char temp[32];
-	int i;
+	int i, ret;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (count >= sizeof(temp) || count == 0)
-		return -EINVAL;
-
-	if (copy_from_user(temp, buf, count) != 0)
-		return -EFAULT;
+	ret = kstrtos32_from_user(buf, count, 10, &i);
+	if (unlikely(ret))
+		return ret;
 
-	temp[count] = '\0';
-
-	if (sscanf(temp, "%d", &i) != 1)
-		return -EINVAL;
 	if (i < 0 || i > 3)
 		return -EINVAL;
 	log_policy = i;
@@ -2838,22 +2808,15 @@ static ssize_t smk_read_ptrace(struct file *filp, char __user *buf,
 static ssize_t smk_write_ptrace(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	char temp[32];
-	int i;
+	int i, ret;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (*ppos != 0 || count >= sizeof(temp) || count == 0)
-		return -EINVAL;
-
-	if (copy_from_user(temp, buf, count) != 0)
-		return -EFAULT;
+	ret = kstrtos32_from_user(buf, count, 10, &i);
+	if (unlikely(ret))
+		return ret;
 
-	temp[count] = '\0';
-
-	if (sscanf(temp, "%d", &i) != 1)
-		return -EINVAL;
 	if (i < SMACK_PTRACE_DEFAULT || i > SMACK_PTRACE_MAX)
 		return -EINVAL;
 	smack_ptrace_rule = i;
-- 
2.53.0



