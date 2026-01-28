Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513C279794;
	Wed, 28 Jan 2026 14:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769610411; cv=none; b=Q8W85FhCPNd7SoNQjIfUjxvAy9nRHEe+PaYXN+I4T5QIt0wCWm0qR6PdRQe1vr6qWPRDwfgeiSio9K5QMuDpOhMbWvT0cE/+Ketv1IsyCwD/xJAsd/TZLGK6q85BzxILX7IHXBR+kDMSLpOjkfftuicDiNjtcJS+zg+AtG+mwlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769610411; c=relaxed/simple;
	bh=vxVtddPUUeVlSjhjy//2jICkO4QVc+Y88qCQSynG68o=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=fEN1UxSB+Wq0O6RKDpAC9n3Z1DmUPWdoyKQWB1TpYXZ9hEA4OxX8Iho3209bTPUwl+e6HhkD1Ay44w78sP3xlmvIvkCVCbCobn+N8z1EU+wS5u8mV5LoPWq4XjaqEPT4PLNCoi/cuaceZDTtzjYvvEHs1bzclOjVE8bM1YJo94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urvfRGzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urvfRGzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A356C4CEF1;
	Wed, 28 Jan 2026 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769610410;
	bh=vxVtddPUUeVlSjhjy//2jICkO4QVc+Y88qCQSynG68o=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=urvfRGzJ+kTIilb6HfjmxMm9OX4yQTnCQfJE+52Jtrntgc2MyQISTcxkEYbALR6jH
	 GcxpkM5b4T+r79pesQ6SEWoZ+vUj8q+4/JMlaAeUDOCBbGUkvStsdBKuohlXjOVl5N
	 yNRqTH38ojpi3/8Gp/e6zMna8k9z1/jWOy/BEtCY=
Subject: Patch "fs/ntfs3: Initialize allocated memory before use" has been added to the 6.6-stable tree
To: 1468888505@139.com,almaz.alexandrovich@paragon-software.com,gregkh@linuxfoundation.org,khalid@kernel.org,kubik.bartlomiej@gmail.com,ntfs3@lists.linux.dev,patches@lists.linux.dev,syzbot+0399100e525dd9696764@syzkaller.appspotmail.com,syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 28 Jan 2026 15:24:54 +0100
In-Reply-To: <20260123065753.4067735-1-1468888505@139.com>
Message-ID: <2026012854-backtrack-sled-263a@gregkh>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     fs-ntfs3-initialize-allocated-memory-before-use.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-211342-greg=kroah.com@vger.kernel.org Fri Jan 23 08:03:23 2026
From: Li hongliang <1468888505@139.com>
Date: Fri, 23 Jan 2026 14:57:53 +0800
Subject: fs/ntfs3: Initialize allocated memory before use
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, kubik.bartlomiej@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, khalid@kernel.org, almaz.alexandrovich@paragon-software.com, ntfs3@lists.linux.dev
Message-ID: <20260123065753.4067735-1-1468888505@139.com>

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
@@ -1327,7 +1327,7 @@ struct inode *ntfs_create_inode(struct m
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = __getname();
+	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1756,10 +1756,9 @@ int ntfs_link_inode(struct inode *inode,
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
-	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
@@ -1795,7 +1794,7 @@ int ntfs_unlink_inode(struct inode *dir,
 		return -EINVAL;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.6/drm-amdgpu-csa-unmap-use-uninterruptible-lock.patch
queue-6.6/wifi-ath11k-fix-rcu-stall-while-reaping-monitor-destination-ring.patch
queue-6.6/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
