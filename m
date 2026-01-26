Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4E026F476;
	Mon, 26 Jan 2026 06:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769408391; cv=none; b=FP+20WOKhqiUcixRDkgMmY2LpB8xpJA9xQXWnnzf/pLUEqwIyyw1E0LM2G3zrSR15Rj32OLv6Fg37gvnPLk2Xw8xJ12GF5o0I0ztp7wlLLSnxpZ28yOn8bp1w6xfA/seuMusPoBLKWyQfohSzaatvDa13GMbGMIBD65pJURezd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769408391; c=relaxed/simple;
	bh=QAzkvnDSh8EVakRZGhTsfu60Tz5Q4n3XRLKkg6cjY8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VWZ8YuWyO8RXH0TCX4HaEO7F8Vk1qpIs2qzjeeYIowVU3OxDowWgjyHbGu8/twCMrQW+6zhTNHNLhXr9Mfc7spCU3zY52Mf82EgeAV4LHN3XhRGQ5IqZC69scqI3KywRI1b5reQs5qDDNxF0V/xv+tAYtbSZcGt3izaLKKhCHlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=ZVOVwXv2; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="ZVOVwXv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ZVOVwXv2gm+2UMBOBAQvd9n5mVnM/e0DGFGw2QqNgwVpJzKXVs9pApidUhJOZ6ZxmO4rj+0TKStvW
	 BGVLvJKRKfBzfHJrIm1/IGqGe+UhHF6KYKvl84mq6jKwuGoT3AKia4kCUk052nXs22TBGDAcmHwz6A
	 wmdo8HMh2JnJFaBM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-11-12089 (RichMail) with SMTP id 2f396977077642d-064a8;
	Mon, 26 Jan 2026 14:19:35 +0800 (CST)
X-RM-TRANSID:2f396977077642d-064a8
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	kubik.bartlomiej@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	almaz.alexandrovich@paragon-software.com,
	ntfs3@lists.linux.dev,
	khalid@kernel.org
Subject: [PATCH 6.1.y] fs/ntfs3: Initialize allocated memory before use
Date: Mon, 26 Jan 2026 14:19:33 +0800
Message-Id: <20260126061933.1206836-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>

[ Upstream commit a8a3ca23bbd9d849308a7921a049330dc6c91398 ]

KMSAN reports: Multiple uninitialized values detected:

- KMSAN: uninit-value in ntfs_read_hdr (3)
- KMSAN: uninit-value in bcmp (3)

Memory is allocated by __getname(), which is a wrapper for
kmem_cache_alloc(). This memory is used before being properly
cleared. Change kmem_cache_alloc() to kmem_cache_zalloc() to
properly allocate and clear memory before use.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Fixes: 78ab59fee07f ("fs/ntfs3: Rework file operations")
Tested-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Reported-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=332bd4e9d148f11a87dc

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Fixes: 78ab59fee07f ("fs/ntfs3: Rework file operations")
Tested-by: syzbot+0399100e525dd9696764@syzkaller.appspotmail.com
Reported-by: syzbot+0399100e525dd9696764@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0399100e525dd9696764

Reviewed-by: Khalid Aziz <khalid@kernel.org>
Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/ntfs3/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index e47eec61f237..b8ac0943e932 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1294,7 +1294,7 @@ struct inode *ntfs_create_inode(struct user_namespace *mnt_userns,
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = __getname();
+	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1698,10 +1698,9 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
-	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
@@ -1737,7 +1736,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 		return -EINVAL;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
-- 
2.34.1


