Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFB63F44F7;
	Fri, 15 May 2026 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861338; cv=none; b=soovh5R0Uumv9Eu3JCwezXON9JUYGo3Wb+9TH7r7yA3NUhi636irdyKDnE5bvnM9E/3EbEdLT6Gm5zdtTNKJp+Y9X82igJn44lGhY4X5r7brfwz9qM46u/Mppc71p6sPgo/KZVP0N2lYRqnTYAu+MCaBa5czPoCOsNKQJat2g18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861338; c=relaxed/simple;
	bh=iZxK6imc4LxvzAaMKCwEbm6U46A3CAZ+SgDgRnAlkA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9OH+sl+G4YabIiM43wQpUHQjBvKVc+xdpM0RpPKh/tzipVkyitRdhOJTiF/Pnp/mCYcbQ/LH+XI9nGsErpndGQVPpveXc3KdT1pDiau/uQoPjUtGMKesxGWhynDD0VJ9o9Vxv73ix+bhRLfHWerRCwN5mKgKiCXWJsW2oMWMHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEeoc8PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEeoc8PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882BFC2BCB0;
	Fri, 15 May 2026 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861338;
	bh=iZxK6imc4LxvzAaMKCwEbm6U46A3CAZ+SgDgRnAlkA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEeoc8PHtRna9ktieNgSGvLIJFXZPfvvYGasCFUK+EWynHemX/62J+2ur4wfX1q2K
	 VrfxwCBEchKzncECsmSFm9IF7E21cRdr0lKW65M6Tl7EnumAFcsiRYbilk9Y2XK4B9
	 YLeRS7XYCY5VHfgkYM9Tj+wQzvUgH0cGxnM8X+uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 288/474] f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()
Date: Fri, 15 May 2026 17:46:37 +0200
Message-ID: <20260515154721.232539516@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 5471834a96fb697874be2ca0b052e74bcf3c23d1 upstream.

f2fs_update_inode() reads inode->i_blocks without holding i_lock to
serialize it to the on-disk inode, while concurrent truncate or
allocation paths may modify i_blocks under i_lock.  Since blkcnt_t is
u64, this risks torn reads on 32-bit architectures.

Following the approach in ext4_inode_blocks_set(), add READ_ONCE() to prevent
potential compiler-induced tearing.

Fixes: 19f99cee206c ("f2fs: add core inode operations")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -665,7 +665,7 @@ void f2fs_update_inode(struct inode *ino
 	ri->i_uid = cpu_to_le32(i_uid_read(inode));
 	ri->i_gid = cpu_to_le32(i_gid_read(inode));
 	ri->i_links = cpu_to_le32(inode->i_nlink);
-	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(inode->i_blocks) + 1);
+	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(READ_ONCE(inode->i_blocks)) + 1);
 
 	if (!f2fs_is_atomic_file(inode) ||
 			is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))


