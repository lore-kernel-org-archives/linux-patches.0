Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01312BE7C0;
	Wed,  4 Feb 2026 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218265; cv=none; b=iMmKeasSoDk/uppyLK/9/wE/MZgNM7ICnEPz+jck6sxFvjSyXesmS+9sk2QRn2yT/pp1tQzcT9AAj2ajbHHLN+IzPi0on8tukps/Uj+oJbRAA1TnDYWIgf4kcnSVHNDN3pny06pMLafriEqB60hxgQeKl9ZKbBcoaOeHGBzWz6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218265; c=relaxed/simple;
	bh=r6rEZUqso2UNF5OWHXB/6OqyFYD9igul1k/WsROAvlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqjBrM8zXmk4JA/nBfxwTgyT+26RR4x52PoDZAkt11veBdEfCb4P/i7wE/X9jtAXPJ9GG613KZHd0fWX20acUfNHepUrNX3WHhuIehKzfBDEF7xK5e3ispWWhqQS8dyP4n4/cAnwQzvDuGUy+WYzS3yiR2n72rOJyadAn6zeofI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNpqejFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNpqejFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66A4C4CEF7;
	Wed,  4 Feb 2026 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218265;
	bh=r6rEZUqso2UNF5OWHXB/6OqyFYD9igul1k/WsROAvlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNpqejFqJU/7nuJGfkofzu0wZAKYXwcYUQMyoZBb9baIafD9QjtJVlTUWMvt4SWHG
	 lfuxh46/JZrGFPMEG6PsjN0lGW74lPxvge8tidW1H+z/jZ8b49p4+gZVxp6u8eCmfM
	 ijVV/w5OCg3MsHqQw1Ew80k200hXnSxPKmDC3QTQ=
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
Subject: [PATCH 6.1 260/280] fs/ntfs3: Initialize allocated memory before use
Date: Wed,  4 Feb 2026 15:40:34 +0100
Message-ID: <20260204143919.053961151@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1294,7 +1294,7 @@ struct inode *ntfs_create_inode(struct u
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = __getname();
+	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1698,10 +1698,9 @@ int ntfs_link_inode(struct inode *inode,
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
-	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
@@ -1737,7 +1736,7 @@ int ntfs_unlink_inode(struct inode *dir,
 		return -EINVAL;
 
 	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 


