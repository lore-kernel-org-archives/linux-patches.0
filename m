Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18843D1CBB;
	Tue,  3 Feb 2026 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136201; cv=none; b=KX/QvrByr1pUWl936xdC2RzrSGQK6/y4g2BM4bmuKaoEYfIpr/0QcmPpKlFujSbM1EEaKgHf14XKLffJ6KdVT205uS60Exf4Z+PNsTYF3rQ/IAYTg8yVoChpSQUP/orB4Sz6fruolbHH5jhyd2CTcq7SflNnhgGsG7BVDon+3WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136201; c=relaxed/simple;
	bh=sdLmQLcnydUHstsDBoGkNnn6uT6GvcElNsNHBQUkxpQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=OBaz/q8uaMThKYIpgFOKR6QVak/R6xdgm3zq+nyHAlkZxV5XTJRzCd98SsOYxavLvtrtUOH1YjVZ70aeg3aChQTheXJb7yqVac8G3stPuOtZrMlHmiO/Xt9lkN1dxwYJG+YrwgOkdp7dR/xd3yiyU1Lvm6k/Fd4sKfKFWy+SAck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siAcbDV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siAcbDV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23684C19421;
	Tue,  3 Feb 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770136200;
	bh=sdLmQLcnydUHstsDBoGkNnn6uT6GvcElNsNHBQUkxpQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=siAcbDV0CseK8cC9D2O+Ad74sbhLyEP+ISS/zlhX6/v3pzu2mTEnIDF9ohDMrOv0j
	 T7zKxEEek8OklhxJWVCchvdmg3JLZ1lQ6/mcCZCrixo5J4JWBM2FvhQWp7jm/oDs5d
	 RnWOqzOVLK4FBnoDSk945lp0GvTUGFXKJ6ev5MmI=
Subject: Patch "fs/ntfs3: Initialize allocated memory before use" has been added to the 5.15-stable tree
To: 1468888505@139.com,almaz.alexandrovich@paragon-software.com,gregkh@linuxfoundation.org,khalid@kernel.org,kubik.bartlomiej@gmail.com,ntfs3@lists.linux.dev,patches@lists.linux.dev,syzbot+0399100e525dd9696764@syzkaller.appspotmail.com,syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 17:29:22 +0100
In-Reply-To: <20260126061956.1206899-1-1468888505@139.com>
Message-ID: <2026020322-imbecile-revivable-e02f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    fs/ntfs3: Initialize allocated memory before use

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     fs-ntfs3-initialize-allocated-memory-before-use.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Mon Jan 26 07:20:00 2026
From: Li hongliang <1468888505@139.com>
Date: Mon, 26 Jan 2026 14:19:56 +0800
Subject: fs/ntfs3: Initialize allocated memory before use
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, kubik.bartlomiej@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, almaz.alexandrovich@paragon-software.com, ntfs3@lists.linux.dev, khalid@kernel.org
Message-ID: <20260126061956.1206899-1-1468888505@139.com>

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
@@ -1298,7 +1298,7 @@ struct inode *ntfs_create_inode(struct u
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = __getname();
+	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1694,10 +1694,9 @@ int ntfs_link_inode(struct inode *inode,
 	struct ATTR_FILE_NAME *de_name;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
-	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
@@ -1742,7 +1741,7 @@ int ntfs_unlink_inode(struct inode *dir,
 		return -EINVAL;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-5.15/fs-ntfs3-initialize-allocated-memory-before-use.patch
