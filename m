Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838A92BAF7;
	Wed, 25 Feb 2026 01:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983068; cv=none; b=ByxRqn6gb0h+x1Xf27nyWGr9Cuj55q9Qu2T4J6jL9wBPrDU0bKioQqyVl8BKnv8UQkvZ0rsyDNJuQRYgchQq/l0VJ2E0UUvBShIWt/weX+S3TEeLI72EKVZfHGu/ByfNEhJEPVi/NRT5iIELSUeSp6AXYkRZ1/jJvrEo2W5FX5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983068; c=relaxed/simple;
	bh=CRjd7X6hPXjTQJ5EmR/YJg1UpSuwUbLmNqPCQyxMfMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4VesWxbnK5LIY44/0bHfp9TxycWF9swExEqFpUj7673NujfzAq1Ix8wJsuOcOik1tXD9PyuwAbM1rclkYECC5wzQYgUQ9ZIP/jQA35q/bu/UF60cBNSu7pTPClOH4ik/b6cyq+MQ4EYoYEGkRYlKRfQwqmlMtSipY8ue0DrJY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0kBwhbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0kBwhbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4978CC116D0;
	Wed, 25 Feb 2026 01:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983068;
	bh=CRjd7X6hPXjTQJ5EmR/YJg1UpSuwUbLmNqPCQyxMfMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0kBwhbkS71F0TS9+Af5oXBS/CWN1e08Kpj/rht+Hn1QJgB+zwQXJwxSLBPybheNR
	 OlpOKsYnCkRc83dVP7hxgfb3dlga+iCx7uYYOV7ZQ8/dO3yNffd/RRiu6jPERk8AGY
	 f8xkf6wKPdK7JhgoCvZThT4sMVil0dsgTBKD3Alw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 231/781] smack: /smack/doi must be > 0
Date: Tue, 24 Feb 2026 17:15:40 -0800
Message-ID: <20260225012405.376485059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2a9d3f2ebbe13..e611e0fb56209 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -141,7 +141,7 @@ struct smack_parsed_rule {
 	int			smk_access2;
 };
 
-static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
+static u32 smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 /*
  * Values for parsing cipso rules
@@ -1562,7 +1562,7 @@ static ssize_t smk_read_doi(struct file *filp, char __user *buf,
 	if (*ppos != 0)
 		return 0;
 
-	sprintf(temp, "%d", smk_cipso_doi_value);
+	sprintf(temp, "%lu", (unsigned long)smk_cipso_doi_value);
 	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
 
 	return rc;
@@ -1581,7 +1581,7 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	char temp[80];
-	int i;
+	unsigned long u;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -1594,10 +1594,12 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 
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



