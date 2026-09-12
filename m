Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C9F3542F8;
	Sat, 12 Sep 2026 09:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205980; cv=none; b=qoVV3lJS45h8V4Tze1Nc1PeBzK6WlPtgcOUT3g7XvRdXfJuFB+uYkgBVDLOIJ4YLF81r+OF4clWE/EUAHY2c+tarS+5CKUHpN73tLKGHM+mVqOql9megY1LHZaUYQ26meARryzYZew8nckor34QCElleU6FilUA1Npem/Y+YGic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205980; c=relaxed/simple;
	bh=82HgJe6JlbNlsYE4CH5AEkOk/LZ69rNDF5MupC99kNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPIzecxJwhidTZXKXAV3SrOmVCc84yhYeu+TnIP4vbCzID1EbgfxH/6vD7kslzV2jgvHkEf1mk7kP68m5Re0/ufJ1aVfFSQDF9tqDZYpIs7W/dZpEEG6AlNSo2s7sraSUwu64wzKGFCsxYZGaMFKSSYNUmLDxjQDdgt3deji+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4dse/tY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4dse/tY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064D81F000FF;
	Sat, 12 Sep 2026 09:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205979;
	bh=/YTKq4mGNxeODExyiJmvUtyHpP2R2DKROIsT53P2M3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4dse/tY6NG8WxMZeRGAFygx77lWvPoOxS0+JUcNvl7Wec2YKq/fSCBSJ9DPjKh2+
	 Le0VEJ/rcQW0yNl0mVn6Q02e5GDLn6J0BBYJj0qTSWOO49K4beJPNkSTpkQAVFIVZo
	 oikYSsh/9zd87rDdn9Yj6vBA5dd/PQ80D+Gg9wXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0112/1518] smack: simplify write handlers of sysfs entries
Date: Sat, 12 Sep 2026 08:38:01 +0200
Message-ID: <20260912065626.013377190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d27d9140dda2f..6b04c144b53b2 100644
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



