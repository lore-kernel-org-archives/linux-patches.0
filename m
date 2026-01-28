Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29C32ED24;
	Wed, 28 Jan 2026 11:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598817; cv=none; b=SPTVNfUJrv1aqTUhbR+rpTZzJvek472Wi43mEVwUbT2uj5VWvElfm5apNUIQsPw3LnhTWE8D80A8JLdxPBK/M2gWF5GtBUvPUUDC2cFB7TDjvNscMZmplVcclS0Mj586XjO7VwGZdFh8sju+8SphfTsUjFiup+TwK5M76TuoX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598817; c=relaxed/simple;
	bh=BgiXB7In8eS5F8lyvMzc04UwaVWYHBruSDxoHbq0m4M=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=VP7LWBO3UQpBX/Bzg9J9UXCMCMNSSfFIZEdAgi97kg9GQeiorfO73gSGV28Z5sYHChvQD7OB1vyuBmbD+3moafdglizPV6fi3KrEaGzJTRtTJxXCUD6gnzHNH2YTquwlDFJ8eupSiWR7Pr+BotrFKKnxEYX0HcDsEXbDen9fD+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hxy9K/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hxy9K/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB727C4CEF1;
	Wed, 28 Jan 2026 11:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769598817;
	bh=BgiXB7In8eS5F8lyvMzc04UwaVWYHBruSDxoHbq0m4M=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=0hxy9K/9yIHbdG31QKkhgQHAOkBD7SYhcGth+sJHkJZ7J2c/eEIxndWoO2VoGlIy6
	 SbkPGWX2JkSVaJn22+ajwyjVs2nBWio6Q7U3h8Mg1CwAgng/hkSA/omNbsqoMMUmc4
	 mbzFD8itzGwDfJ2CTAEb7/C2IA206EAxHZW2jwbY=
Subject: Patch "fs/ntfs3: Initialize allocated memory before use" has been added to the 6.12-stable tree
To: 1468888505@139.com,almaz.alexandrovich@paragon-software.com,gregkh@linuxfoundation.org,khalid@kernel.org,kubik.bartlomiej@gmail.com,ntfs3@lists.linux.dev,patches@lists.linux.dev,syzbot+0399100e525dd9696764@syzkaller.appspotmail.com,syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 28 Jan 2026 12:13:10 +0100
In-Reply-To: <20260123034231.3793689-1-1468888505@139.com>
Message-ID: <2026012810-germless-tipoff-33a4@gregkh>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     fs-ntfs3-initialize-allocated-memory-before-use.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-211330-greg=kroah.com@vger.kernel.org Fri Jan 23 04:43:03 2026
From: Li hongliang <1468888505@139.com>
Date: Fri, 23 Jan 2026 11:42:31 +0800
Subject: fs/ntfs3: Initialize allocated memory before use
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, kubik.bartlomiej@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, khalid@kernel.org, almaz.alexandrovich@paragon-software.com, ntfs3@lists.linux.dev
Message-ID: <20260123034231.3793689-1-1468888505@139.com>

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
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.12/exfat-fix-refcount-leak-in-exfat_find.patch
queue-6.12/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.12/wifi-ath11k-fix-rcu-stall-while-reaping-monitor-destination-ring.patch
