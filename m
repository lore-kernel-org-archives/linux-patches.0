Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DF51AA782;
	Wed, 20 Nov 2024 13:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107715; cv=none; b=gomP0+J/hGGjqou/E3/1etlp3AIXe5/RWN4zfeIeRKi+yVvlgVCnFG/skdxT9adeCRj4HGPmaOUGLc62LStPwi0CT1D0EISEUK+8X7dAyiJ7DciorFGTC7QdqkwcRO7VE7+6IjyWuNBO492NnQiTtm3Xc+MRNv2ZbsinIwqvz3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107715; c=relaxed/simple;
	bh=7GEFDIXHD1s3So54glhHE7n+zavhQnQS6aA9+A7ng4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHBrGTfM9B1DulOgdIHr97WNBMV94olFP6xQjfKw1Yw2w7WluwraVhxv79bNxsDMlVi+b2fYc28zQgdLtPRqTGXReH6aXnU7fpkGahaULcEa+P0SEK02PlccJhcu+1v9kn12L51vC5ajw/icaQ6rIrrwAWyzmlqUBfwGFKZgAgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFemKhBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFemKhBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F352C4CED1;
	Wed, 20 Nov 2024 13:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107715;
	bh=7GEFDIXHD1s3So54glhHE7n+zavhQnQS6aA9+A7ng4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFemKhBI+RAREE/PHlXHX4TiZd2K13e1cobL6VeR3+G5birDD54V4JHatQGnBI7ub
	 NFz4MYeVLRSb0zxXhdwJRrzKq0C95IhgGeY+fc8f8TuSXTcaDzfTSHFsZ2wihXBNQL
	 qhed7ogUirSX01e0TjI0PWy87q/6zkzrMlwD8IYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	ericvh@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eb83fe1cce5833cd66a0@syzkaller.appspotmail.com,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 57/73] fs/9p: fix uninitialized values during inode evict
Date: Wed, 20 Nov 2024 13:58:43 +0100
Message-ID: <20241120125810.980718603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 6630036b7c228f57c7893ee0403e92c2db2cd21d ]

If an iget fails due to not being able to retrieve information
from the server then the inode structure is only partially
initialized.  When the inode gets evicted, references to
uninitialized structures (like fscache cookies) were being
made.

This patch checks for a bad_inode before doing anything other
than clearing the inode from the cache.  Since the inode is
bad, it shouldn't have any state associated with it that needs
to be written back (and there really isn't a way to complete
those anyways).

Reported-by: syzbot+eb83fe1cce5833cd66a0@syzkaller.appspotmail.com
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
(cherry picked from commit 1b4cb6e91f19b81217ad98142ee53a1ab25893fd)
[Xiangyu: CVE-2024-36923 Minor conflict resolution due to missing 4eb31178 ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -392,17 +392,20 @@ void v9fs_evict_inode(struct inode *inod
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 	__le32 version;
 
-	truncate_inode_pages_final(&inode->i_data);
-	version = cpu_to_le32(v9inode->qid.version);
-	fscache_clear_inode_writeback(v9fs_inode_cookie(v9inode), inode,
+	if (!is_bad_inode(inode)) {
+		truncate_inode_pages_final(&inode->i_data);
+		version = cpu_to_le32(v9inode->qid.version);
+		fscache_clear_inode_writeback(v9fs_inode_cookie(v9inode), inode,
 				      &version);
-	clear_inode(inode);
-	filemap_fdatawrite(&inode->i_data);
-
-	fscache_relinquish_cookie(v9fs_inode_cookie(v9inode), false);
-	/* clunk the fid stashed in writeback_fid */
-	p9_fid_put(v9inode->writeback_fid);
-	v9inode->writeback_fid = NULL;
+		clear_inode(inode);
+		filemap_fdatawrite(&inode->i_data);
+		if (v9fs_inode_cookie(v9inode))
+			fscache_relinquish_cookie(v9fs_inode_cookie(v9inode), false);
+		/* clunk the fid stashed in writeback_fid */
+		p9_fid_put(v9inode->writeback_fid);
+		v9inode->writeback_fid = NULL;
+	} else
+		clear_inode(inode);
 }
 
 static int v9fs_test_inode(struct inode *inode, void *data)


