Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2111836C9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302349; cv=none; b=p1eveRFwA1zW/kuOboWaTF9XUd8Vy9dWJThAmRcGIzcAKdvFeUSfWboPfU1celicaZl4VAZ4cNgAmhuSLA5O6+VAr8GNJdIHDchre6enVdorBOo1JvsDYHFvoWBpHE75IKVZEtrbg0rMxYbfrhpxsgwHKzi6HPTtKTKA0VaOuHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302349; c=relaxed/simple;
	bh=8b3ytZKyakhWszDa+Xb+gP7WFoYZMKGI0BY0lnAaIvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQwWRdi6ey/KHuey+00TvifSCCOxzSppA6PIQKaTJKvJ4Wxcsd8wOxA8OztmyGQcKU6r/98+Ilt5UMffWTVBOjC4u4iyGqeae8GJ9KOy+V1doXJ+38dvGweO7smOiklPq7frwKHxfLlUG7OknPMJvup3B6HHyxUeYL6hBZ1mMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rsD6PK3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rsD6PK3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C51C19423;
	Sat, 28 Feb 2026 18:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302349;
	bh=8b3ytZKyakhWszDa+Xb+gP7WFoYZMKGI0BY0lnAaIvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsD6PK3RVqg3S2spQfAkiJcgMz4ZKPhPSCSarQK1Olrw19t5V5pXLSolXzuyAoR/3
	 +Q2ciBq/B4/T/2TbLEyZ2PD7SOUH7mel7weoBSYBCNViOgo95SS/1z4xEA3tf6eYBA
	 2QMnes5+DkuO97CkrslWFjgEobn34UA0f12AjCsq8LFGR6IGWBZ+8cRZeK7XmuTy7C
	 EmxsbaxprYyDwPmlhM/apEm576c45hqj3qYlkwu78+XwIBtNl2dNGAvPRyFSmUNYQ5
	 LEBr1symDzYj6O14D7dz8NmtHx5zZCMu0cmhRIICR+GUA4HKHErGfNaRmdY2MU5rwm
	 KRlHSi8vIU9mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/232] smack: /smack/doi must be > 0
Date: Sat, 28 Feb 2026 13:08:46 -0500
Message-ID: <20260228181127.1592657-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 9dca3672d82b4..136d89efdc0c2 100644
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

