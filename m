Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32122366831;
	Tue, 12 May 2026 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609623; cv=none; b=kDu1Y3gwQ2vxbgUd7wOO1eapSbA74+9Nnqg19ODTaXdV6rN5AAJavusWGWNPXn0+gEDixOtyaYR3eyHw/4Fsj4wdwaNphue0D+t/1WXYjQP0ke1hwZGFwIjFLDRbaZxk2BKxO+KPg9LgM3iyrZ41DuEhOZ8QH8UCU7oXC9Lp+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609623; c=relaxed/simple;
	bh=pN95bPvlKC0jX3TSwhBR4rCCcXdKsZsWXheeU851UG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiDG/k7fAEeO8Dxsct1mx4XvQPaVMQk0fkKNbcsZacEpOVRTc9SKXIXQhsALfdfOVwVMNSYC7mynaDzUtiQZCp/UJxg+2mGHEMgFGQ79vu/14AWIq1iU655LrO9FxAN6T7OR/pFFllg78rnIGO3DCDINkz0UwwbRaPwR/doNt7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pf0LIKfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pf0LIKfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41FDC2BCB0;
	Tue, 12 May 2026 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609623;
	bh=pN95bPvlKC0jX3TSwhBR4rCCcXdKsZsWXheeU851UG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pf0LIKfsBvvd+vzFWOgF8ORo1lL666Bmw1KmLAfvBAgqAQTMlbTn58zSL96GBSVcI
	 eiMKBcDkw/uSx4S1jleacnEHVdo7AUnDnlXtb+PyhOnpc3fsdASbLYgQw9rv5q3085
	 btxx2EKWiVrF5dJjgxSYEVbMkhWh9JJtn18mXNEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 267/307] f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()
Date: Tue, 12 May 2026 19:41:02 +0200
Message-ID: <20260512173945.763470019@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -687,7 +687,7 @@ void f2fs_update_inode(struct inode *ino
 	ri->i_uid = cpu_to_le32(i_uid_read(inode));
 	ri->i_gid = cpu_to_le32(i_gid_read(inode));
 	ri->i_links = cpu_to_le32(inode->i_nlink);
-	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(inode->i_blocks) + 1);
+	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(READ_ONCE(inode->i_blocks)) + 1);
 
 	if (!f2fs_is_atomic_file(inode) ||
 			is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))


