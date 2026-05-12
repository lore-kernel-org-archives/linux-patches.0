Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FF9292918;
	Tue, 12 May 2026 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608807; cv=none; b=FAZEENEZZDc1ndzaJl8+dk4k4X+Mvx5EGLwUHT9xr311lm6ZNzPu0vO91aNR0L/qSQd4flitit1o8lqeO+P5S58QXPIBs3c0Y0bxQn1OmTM5AQ7HNzRY6K8Iby7GHWiTN/+X2GnwA8TLgCruKjIdStz0QiRd+uGxkdYe25Gus2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608807; c=relaxed/simple;
	bh=17IWpaHPE3kwCPA4ONMQdB9ST0r1KXWsXVFF+0lyqHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHrkWv4bhLWr0z1CndUHdcTWH04DA0CKf6S4dp5DUVzbaoXx4Of1Jt6SeuOvm3RCyvAuON0ftHcVcUu/Y5wZC1bOuXs+Xq2FmmUOfpkVTNBL9vMJRIq7lodyitVyn8Kd7s6LwfIc0jl2F2VNaQJJYu04TdYn8wKPtOCYeOQ43LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEOaUwbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEOaUwbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C424AC2BCB0;
	Tue, 12 May 2026 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608807;
	bh=17IWpaHPE3kwCPA4ONMQdB9ST0r1KXWsXVFF+0lyqHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEOaUwbcPje1WqgyTL+ToGoZmBQkuO39DzeN+hSb7qLcRHErfuz01vAwS1lXfxmWi
	 0zKYd5YBHML3aKw3KebuPe85jxAjGzKjfpgWE/T3Vb1poun8linF9E7K8pIZxlf7jA
	 Q3rHq4yZ9A+x53Lfac+T8+OkebIzUZ3KODNHIdsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 223/270] f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()
Date: Tue, 12 May 2026 19:40:24 +0200
Message-ID: <20260512173943.140004073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -677,7 +677,7 @@ void f2fs_update_inode(struct inode *ino
 	ri->i_uid = cpu_to_le32(i_uid_read(inode));
 	ri->i_gid = cpu_to_le32(i_gid_read(inode));
 	ri->i_links = cpu_to_le32(inode->i_nlink);
-	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(inode->i_blocks) + 1);
+	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(READ_ONCE(inode->i_blocks)) + 1);
 
 	if (!f2fs_is_atomic_file(inode) ||
 			is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))


