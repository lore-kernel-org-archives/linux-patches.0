Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F06625D904;
	Tue, 11 Mar 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707187; cv=none; b=JxGEaJ9hwAqmMwILzEyCQscTTO7pIjy+5mVStH1uKan7A6AmkgvZ2w8YbrqtUL4Nir4K4HNFWEiPo7puabpGFeVr/YMHOS1gYlhwvod63gx3nJxfe3HumOe3oUg2k+94RhtI4gpXdLwnpokFq9DXxe5O4fDjffB6ibF5CSOnCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707187; c=relaxed/simple;
	bh=/C/IO6lNndSSRpvdZbpMSEIzngSQyxV2XRoWTGjgEW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByC+r5/zOpVPGEP9uKVsIKOdyrrGi4dlNB5FqHC2suavtH7b8QiFmtEzUlyVlgfGoE020jMoSUUUSjg7iEnRe4qxRLV5zXoEl04B5fMbPRS9C6J9cgAL0JYBV+OOj7ODtugUOwagy928xE2bxWWFFCI5uVAXDJUbUcusuQEQ0YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3jBNucG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3jBNucG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D810C4CEE9;
	Tue, 11 Mar 2025 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707187;
	bh=/C/IO6lNndSSRpvdZbpMSEIzngSQyxV2XRoWTGjgEW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3jBNucGvqk1QwDXs4SP9IL5zORUQ/tANxLtLovillX1SNd/0BmaTI53Bp26Ispep
	 9Fa3vLk+oYD3eJ6y353NDG12a815fn/DILhOXuJUtL5TvPAtybWVF6frjABNOThOMZ
	 M9ZR+dDxKshIlDR1IgpEAQ5uVa/YOCJOjZWrzIOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.10 303/462] f2fs: fix to wait dio completion
Date: Tue, 11 Mar 2025 15:59:29 +0100
Message-ID: <20250311145810.333741414@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 96cfeb0389530ae32ade8a48ae3ae1ac3b6c009d upstream.

It should wait all existing dio write IOs before block removal,
otherwise, previous direct write IO may overwrite data in the
block which may be reused by other inode.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -957,6 +957,13 @@ int f2fs_setattr(struct dentry *dentry,
 				return err;
 		}
 
+		/*
+		 * wait for inflight dio, blocks should be removed after
+		 * IO completion.
+		 */
+		if (attr->ia_size < old_size)
+			inode_dio_wait(inode);
+
 		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		down_write(&F2FS_I(inode)->i_mmap_sem);
 
@@ -1777,6 +1784,12 @@ static long f2fs_fallocate(struct file *
 	if (ret)
 		goto out;
 
+	/*
+	 * wait for inflight dio, blocks should be removed after IO
+	 * completion.
+	 */
+	inode_dio_wait(inode);
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		if (offset >= inode->i_size)
 			goto out;


