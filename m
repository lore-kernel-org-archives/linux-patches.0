Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3C2346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302098; cv=none; b=E82GailMViInAYgMSHLT2NH3+V0vFD+Uuc5gXLRMYqasa5EDJUeuT3PcoPNWV/uhva3EhZLseCbwhq/P8UltGu/r+1Iab16OcRuJpXsn3EEFTCGw1UEd4NmyrQO6EauKU2Ifg8YuD3bh8aJslwmrX/JhOJhcqYZNbKFAcT1Yndw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302098; c=relaxed/simple;
	bh=g10O2WvfYjfPwPhl5f25B1KCWWw7OOjKWV9rkdzcH1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvOWqmbYwLj2yUuKODrqHgfT2Gjgs0MX1J7HlO6FT6ivMHOmDKsNj9qS1N0d1ojYnIE0YIKlIsfYbHr53O/RAGx5ucstgh0EaPLyIw0K5mVOBCyxJeFREMDfRZjcwmoJup86ifeUGRsbsyiX7sCCpaSjo+K9JDat0QY5EyzS6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uMFjjDss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMFjjDss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9C8C19423;
	Sat, 28 Feb 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302098;
	bh=g10O2WvfYjfPwPhl5f25B1KCWWw7OOjKWV9rkdzcH1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMFjjDssJQ5LGtCELZUl6wHlXsat0DeTs986bp3WiJ6rjqTrswCwtDReDrRCs+iLe
	 OmCkJBLlRj9LKA3ERJyhtOgdGMvjILG8zxClQYLMNIeiVgJjrb6NkDoc1U2qHHrK7J
	 qPTB6FLFaSdBcQWT4VHvtLjOZjd+40nXu7HC68om+fOY4ddeE4/HfxPf/MWOikRYT1
	 i3F89fP5nSipt7rBRR6Lr35Puzwaqf494uHs064TF+I7Ryksz1Ok7ZMk6MA+0tLFSM
	 HdbADg7XQie+QS49l8CYc3kR+EZLxTWuMfSNWdPAKPuB9oG4br3Ou8nIZs5gTwRrSI
	 BPc+CwC3P5TYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/283] smack: /smack/doi must be > 0
Date: Sat, 28 Feb 2026 13:03:46 -0500
Message-ID: <20260228180709.1583486-84-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

