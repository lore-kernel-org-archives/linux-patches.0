Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6558E22579E;
	Wed, 25 Feb 2026 01:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983975; cv=none; b=u2P+/tiy50qbKbYI4tr5wS4j05bsBjY/g/TWLYr2xczJ8OjQ+fWE+3twCVfghzD1prpL1LN2H0MKYmgVk5N2+dHYpXDI0BmOgHT04e2AAnvvPQ65VhiI9hDJMMsakfKsGMFYSqcB5opdhIvBKkynwaFWqKj/ZYKfGW69JILJSBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983975; c=relaxed/simple;
	bh=zHBMs2IUMx63NZg4D3pe+5oqfYN2Jv3sEEvlGlYn67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMsa+WQqsUHFZjgZg8Y0fjPJquA8E2fR+YzBYOJ5AQSHgDX/DIOaYPGQDqwfPoDQzoPT52BF1xa7ZQNB4QOgOI9RUWMIUEonk843qcMQSqjpfuecdk2mWRkiB8zMIs8b5N64NXk3XEO3i2wc6UvEmbEoIO1LFbCZXMiOadXV5R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHCfNqYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHCfNqYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2491CC116D0;
	Wed, 25 Feb 2026 01:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983975;
	bh=zHBMs2IUMx63NZg4D3pe+5oqfYN2Jv3sEEvlGlYn67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHCfNqYKtBMte9k2ECWSmjeDDu/xGmc67RQBLQ37WoPlr7AmqdlERRyhY+EezTkkc
	 e4eOpPWsTd4ttk0tbV43ryTrUw555D9EcplJ22r0SxLalhbwAMtgp1wp7WNp7jcvSo
	 JrN4Uv20l6qGyPQRquojm0R9h0q5nsZ41mBPBJmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/641] smack: /smack/doi must be > 0
Date: Tue, 24 Feb 2026 17:18:30 -0800
Message-ID: <20260225012353.475356589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index b1e5e62f5cbd1..316c2ea401e8a 100644
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



