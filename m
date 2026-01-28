Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6822E2DF4;
	Wed, 28 Jan 2026 15:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615428; cv=none; b=S8Y56F3VD6IfmHkTUk7HcDh3drwwFcNUwDvV8HmaLPS/OfoK5w/uh9h6zZaVaVoUhqspKRy4dqlCXE+UMlkyolUVet1pHkMQGzRkLUzy+50K4yjkbqSzxarF43o+PvV8B3HNBc+QM+lugvK7OTtsnT2SyCxHOhVLADSUJ8lqO3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615428; c=relaxed/simple;
	bh=QYJZudCO40mJwFXk8BpBmQExSeVjuIsxMqtvLyObrew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pnvd0YaGgx8wFUO4x97npl91Mx6FPHPJjAf4N4fAAzOglaeN+JO+ez8BW69thRJ0WP1SNs81WGm+mnAo3iP6ppOS8ujcNhbwuc+3+SufFH3ikZm8MkPV7ejl99IzNoSOJlGsRFJzjnIuegQsZhp9zSoR74ftEX1GdYqfsjfS1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXw3Qlu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXw3Qlu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD2FC4CEF1;
	Wed, 28 Jan 2026 15:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615427;
	bh=QYJZudCO40mJwFXk8BpBmQExSeVjuIsxMqtvLyObrew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXw3Qlu3CrIxBaM1k8Z7uL+51nTVFPocLzqo9Hn5ZL44Gvcf2Xxg+1fr+piEQfyAU
	 LJ0pW27dQICoamp8zrm/Iab1Yml7/oIMXZjcNlhXhwQnNjNJaH8yN/mKSKpZxRrwjP
	 OHdTkcgjzDXqimbSC8jiERmEvJP3Frpl9Nhod4dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	syzbot+0399100e525dd9696764@syzkaller.appspotmail.com,
	Khalid Aziz <khalid@kernel.org>,
	Bartlomiej Kubik <kubik.bartlomiej@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.12 158/169] fs/ntfs3: Initialize allocated memory before use
Date: Wed, 28 Jan 2026 16:24:01 +0100
Message-ID: <20260128145339.700647111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1301,7 +1301,7 @@ int ntfs_create_inode(struct mnt_idmap *
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = __getname();
+	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1734,10 +1734,9 @@ int ntfs_link_inode(struct inode *inode,
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
-	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
@@ -1773,7 +1772,7 @@ int ntfs_unlink_inode(struct inode *dir,
 		return -EINVAL;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 


