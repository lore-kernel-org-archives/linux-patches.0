Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412952931F5;
	Sat, 12 Sep 2026 14:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222354; cv=none; b=SxW0Gjvh+aTl7dbU5erE915Zrz0iC8dny311UthvZW50Dju9rQ1/FBp0eiEQmiwxVD1wGZ7Jr18a1dn9ta40GqLXeWSX5ASfFmkPtphKqOkIAEho5l7egMNPxJ+23I+eV2x07jRKjzULo6PiQqrXiihhfBrh+friySW97Ghqxng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222354; c=relaxed/simple;
	bh=14yhBdgmgcNkg5y1AE8GJPt0+a/E0/Bj5f4VxUL5FAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSoYxQ1UcF4awirxSwZdlGNtOT9rZS6pBYJyllRew1zVGUcefzurpTPYW5FYVIHvyciSINBhD3jBVBj5Df244YoKd5nMMLARBtG8cciYntKVUF2ieAGvWXJ6B0ldoPyPVqd3RuzMOXKOGM9lnWCeCQOHWjD6W+n/duK66k0acHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OojtUxut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OojtUxut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B5D1F000FF;
	Sat, 12 Sep 2026 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222352;
	bh=Kx1XB9FfZPl6JRGYU0S/AZksXOf8jXrvQuyLkvCho00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OojtUxutEQnQXe9svYcWlbXNunnXlL12cCYCVQ8XdrKl2ZbmLjhV7n9VcUPjUuX1m
	 LPl12pnPWfTxPeuyUWQPmGKCDgVnl4Lk0u740pF2AnYKirmCr7qHb8k9tYaQ/aLc0l
	 IxWwUoCnVjiG0tk6/ftQhP7NRahgdBfVGgc2L4Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0568/1424] smack: restrict smackfs/{direct,mapped} values to 0-255
Date: Sat, 12 Sep 2026 08:50:00 +0200
Message-ID: <20260912065620.023829885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 96a4a92ac0932..e44f4e9f5d2be 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -299,7 +299,7 @@ int smack_populate_secattr(struct smack_known *skp);
  * Shared data.
  */
 extern int smack_enabled __initdata;
-extern int smack_cipso_auto_level[2];
+extern u8  smack_cipso_auto_level[2];
 #define smack_cipso_direct (+smack_cipso_auto_level[0])
 #define smack_cipso_mapped (+smack_cipso_auto_level[1])
 extern struct smack_known *smack_net_ambient;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index ab472058d2e43..0f304667d8578 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -92,7 +92,7 @@ struct smack_known *smack_net_ambient;
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



