Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43814248C6;
	Sat, 12 Sep 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229047; cv=none; b=dwoCKInay/DDdB9Uv4MR/KSHtClzmuWQrSFhlmN/ckrF/w0b809CVcFtjLmnIi262b94l+TWUa31SXafqExF2pgtjaJ7yGLHOZPBCWUvOkxXHX3HIPr5hKCXN1iSCqGBwqmtNCqnX5YpJ1f0/2zFGQwCNJRmCDONYEMCF5GGODI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229047; c=relaxed/simple;
	bh=maRJ8ggSiUK82B3AlUAQuNjq2Hvaj02u7KC8RH+hOT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nevGqV2IPs8sk1H4T7VAB+YKI+VN5IpQXeBf3heToplUf8XaWOsZ6AKftzYpC4I4LxeTLQjRvQU9MqokxKZkl22QYqZ7OqQ0r/C77KzY8nGpNldjkDx7wVauBaqKb9B5ZBWpwnUQMl4O6Wb/JUsHbbdiF/tlYdSkg5r5KUPE8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltQnI3Nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltQnI3Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D900B1F000FF;
	Sat, 12 Sep 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229045;
	bh=u23I4Tn3EI67Rw+7IQXhJQbAXcPvaCgOtGHKHLXO2Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltQnI3Ndx3RvtCME/nBYF4xaF7zvYzQb6MFg8lhAMrT5usA1zjDR/BPyuhnCBohFM
	 vI/RmniwjMvmAOTaQKGdyGo7tb2Efof36kZhbqjqz8rVG/Vlvv0oGRD2tUIHyixOxs
	 720uBjL8Ct9gAXR8FzWWwPFmXqonfNw+lkce8g0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0468/1191] smack: simplify write handlers of sysfs entries
Date: Sat, 12 Sep 2026 08:53:16 +0200
Message-ID: <20260912065558.746184972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 6a4d175527bd6..ec8fa26490570 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1616,24 +1616,17 @@ static ssize_t smk_read_doi(struct file *filp, char __user *buf,
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
@@ -1682,22 +1675,14 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
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
@@ -1760,22 +1745,14 @@ static ssize_t smk_write_mapped(struct file *file, const char __user *buf,
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
@@ -2196,22 +2173,15 @@ static ssize_t smk_read_logging(struct file *filp, char __user *buf,
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
@@ -2854,22 +2824,15 @@ static ssize_t smk_read_ptrace(struct file *filp, char __user *buf,
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



