Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A133B1EFE;
	Sat, 12 Sep 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238165; cv=none; b=mT78UgMZrgSpU2bA1ZheubWJsGXu+WkpT8TCMqbaap9+vQOr5jzAHuGKDOZr9UPZrRCUYKJrmVkxKSWUpOykUfyC1iR5zHaHzFv4brAuk/OwMHZy4r+Mrja6NDzBxT51s3ZFYhi738dzzU5U1So9aPzvGKb5GWwkBCGrSvmebYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238165; c=relaxed/simple;
	bh=Q9E8qywpwOOiTMtqvInJKoKZ13zxGgqFNFj/NQ9N3us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYLyoIhekzvDFFRZnTfsTRO0m7e50hVFB85Za7FMC2DoS/vsQjrNa/p1/LzwcRDyqut9OEStCei32kk4wDwhU6JfBi/KqIA8zUVa9wTzTfIK9UIPTQ2UOzXr2dFF9oqorxF03zn19uDlRnL3gKmb8p6SWU988JYujU3CpepraMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Disr/2Ie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Disr/2Ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4E81F00898;
	Sat, 12 Sep 2026 18:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238158;
	bh=uqkiuJgwngbhLntzKlVC5mUSdo84HeItkilnN+GPUjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Disr/2Iek/aK6qR4gPHgoy8HVWmOAqpVfrfp01r/I5srqvXLTvAVjcckzzv/bGTOg
	 fnNg4mA4XMxrG7Kqqa5rs4Eh7xM9jWFcT7cnXxd+YH9QQiRKOlwg58LNRS+zj4i103
	 2gV4SPgC06xnr7/TDbXq4RJ8Csts2QMKGKm2ezOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/935] smack: restrict smackfs/{direct,mapped} values to 0-255
Date: Sat, 12 Sep 2026 08:57:08 +0200
Message-ID: <20260912065535.951450498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit a7c44fd9f80e37763acf9cd3c87a58058d206427 ]

Both smackfs/direct and smackfs/mapped incorrectly accept
the full range of integer values. For example:

    # cd /sys/fs/smackfs/
    # cat direct ; echo
    250

    # cat cipso2
    @ 250/2
    _ 250/2,4,5,6,7,8
    * 250/3,5,7
    ^ 250/2,4,5,6,7
    ? 250/3,4,5,6,7,8

    # echo -1234 >direct ; cat direct ; echo
    -1234
    # cat cipso2
    @ -1234/2
    _ -1234/2,4,5,6,7,8
    * -1234/3,5,7
    ^ -1234/2,4,5,6,7
    ? -1234/3,4,5,6,7,8
    #

I noticed two things regarding this:

1) sensitivity levels are truncated to 8 bits when labeling
   outgoing packets (0x2e = 46 for the -1234 example above)

2) the reverse process fails: incoming packets with sensitivity
   level 46 do not match these smackfs/cipso2 entries.

Even observation (1) on its own warrants a fix.

This patch restricts smackfs/direct and smackfs/mapped
accepted values to the 0-255 range.

Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")
Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h   |  2 +-
 security/smack/smackfs.c | 26 ++++++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2a2eb2a8ca96e..6186744e6c767 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -304,7 +304,7 @@ int smack_populate_secattr(struct smack_known *skp);
  * Shared data.
  */
 extern int smack_enabled __initdata;
-extern int smack_cipso_auto_level[2];
+extern u8  smack_cipso_auto_level[2];
 #define smack_cipso_direct (+smack_cipso_auto_level[0])
 #define smack_cipso_mapped (+smack_cipso_auto_level[1])
 extern struct smack_known *smack_net_ambient;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 1b5147578bfe2..e3e50df5e8f94 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -91,7 +91,7 @@ struct smack_known *smack_net_ambient;
  * secid is contained directly in the category set.
  * It can be reset via smackfs/mapped
  */
-int smack_cipso_auto_level[2] = {
+u8 smack_cipso_auto_level[2] = {
 	SMACK_CIPSO_DIRECT_DEFAULT,
 	SMACK_CIPSO_MAPPED_DEFAULT,
 };
@@ -1659,17 +1659,15 @@ static const struct file_operations smk_doi_ops = {
 static ssize_t smk_read_cipso_auto_level(struct file *filp, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	char temp[80];
-	ssize_t rc;
+	char temp[sizeof "255"];
+	int n;
 
 	if (*ppos != 0)
 		return 0;
 
-	sprintf(temp, "%d", smack_cipso_auto_level[
-			      smk_cipso_auto_level_idx(filp)]);
-	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
-
-	return rc;
+	n = sprintf(temp, "%u", (unsigned int)smack_cipso_auto_level[
+		smk_cipso_auto_level_idx(filp)]);
+	return simple_read_from_buffer(buf, count, ppos, temp, n);
 }
 
 /**
@@ -1685,13 +1683,16 @@ static ssize_t
 smk_write_cipso_auto_level(struct file *filp, const char __user *buf,
 			   size_t count, loff_t *ppos)
 {
-	struct smack_known *skp;
-	int i, ret, idx, old_lvl;
+	int ret, idx;
+	u8  i, old_lvl;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
-
-	ret = kstrtos32_from_user(buf, count, 10, &i);
+	/*
+	 * draft-ietf-cipso-ipsecurity-01 (CIPSO 2.2), 3.4.2.4:
+	 * "Sensitivity Level is 1 octet in length. Its value is from 0 to 255"
+	 */
+	ret = kstrtou8_from_user(buf, count, 10, &i);
 	if (unlikely(ret))
 		return ret;
 
@@ -1704,6 +1705,7 @@ smk_write_cipso_auto_level(struct file *filp, const char __user *buf,
 	old_lvl = smack_cipso_auto_level[idx];
 
 	if (old_lvl != i) {
+		struct smack_known *skp;
 		mutex_lock(&smack_known_lock);
 		list_for_each_entry_rcu(skp, &smack_known_list, list)
 			if (skp->smk_netlabel.attr.mls.lvl ==
-- 
2.53.0



