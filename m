Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5491FF1C8;
	Tue, 30 Sep 2025 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244586; cv=none; b=OaisQwQogus9Df65q5SU9nRbl7ul6MmW35NGPduGB06ajbPrcq9nem18vCSbRDoqQ6q1UWZ1YvLPhY8bMrQ5Nw+goAJ4KMVqwzAwdeTfrxGi7ERHUuKZLfojxxfb20f2IuZlyoCX7iEzwSCaAarb9UQ6T2B0NFzVqYbUmm4niMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244586; c=relaxed/simple;
	bh=md24eNf8GWe9EnGpWR+RvUmMBFm5zEFRkaCxC2nzlmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBrOb9y/W5gfksmiCQwFpEhwbBrUrR9VNqQp/qhqISno6/nSPraM5mZDrBOrlqIslafrl/UCBZfrs9FI6dOqLavPioppiOTKcwHNZx7+6Y+gXiwX4R4Y8AKi8mCD5V8cxbNKhs42MftW+ShVEa/CLKOkYZvEclezpOdyEUSkdGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwpcfLhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwpcfLhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47384C4CEF0;
	Tue, 30 Sep 2025 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244586;
	bh=md24eNf8GWe9EnGpWR+RvUmMBFm5zEFRkaCxC2nzlmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwpcfLhEyxUC5YEUtg1ejZBTB15P/lT8BH0105WmpXXI/IjFrpl2L4vIOe1Z9H8Uy
	 dAH9TbMQR4lC5SUDV74UMfUTEhYji5Zp0yJQdDI2PhmuDRij6qFHr6IvCJN2duhjkH
	 Ou65/kR+4Hmmf/lRoeUfnCFsThTBaJD1kI10r38g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 051/143] NFSv4.2: Protect copy offload and clone against eof page pollution
Date: Tue, 30 Sep 2025 16:46:15 +0200
Message-ID: <20250930143833.265857194@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b2036bb65114c01caf4a1afe553026e081703c8c ]

The NFSv4.2 copy offload and clone functions can also end up extending
the size of the destination file, so they too need to call
nfs_truncate_last_folio().

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 4b0e35a0d89dd..6a0b5871ba3b0 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -363,22 +363,27 @@ static int process_copy_commit(struct file *dst, loff_t pos_dst,
 
 /**
  * nfs42_copy_dest_done - perform inode cache updates after clone/copy offload
- * @inode: pointer to destination inode
+ * @file: pointer to destination file
  * @pos: destination offset
  * @len: copy length
+ * @oldsize: length of the file prior to clone/copy
  *
  * Punch a hole in the inode page cache, so that the NFS client will
  * know to retrieve new data.
  * Update the file size if necessary, and then mark the inode as having
  * invalid cached values for change attribute, ctime, mtime and space used.
  */
-static void nfs42_copy_dest_done(struct inode *inode, loff_t pos, loff_t len)
+static void nfs42_copy_dest_done(struct file *file, loff_t pos, loff_t len,
+				 loff_t oldsize)
 {
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
 	loff_t newsize = pos + len;
 	loff_t end = newsize - 1;
 
-	WARN_ON_ONCE(invalidate_inode_pages2_range(inode->i_mapping,
-				pos >> PAGE_SHIFT, end >> PAGE_SHIFT));
+	nfs_truncate_last_folio(mapping, oldsize, pos);
+	WARN_ON_ONCE(invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
+						   end >> PAGE_SHIFT));
 
 	spin_lock(&inode->i_lock);
 	if (newsize > i_size_read(inode))
@@ -411,6 +416,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 	struct nfs_server *src_server = NFS_SERVER(src_inode);
 	loff_t pos_src = args->src_pos;
 	loff_t pos_dst = args->dst_pos;
+	loff_t oldsize_dst = i_size_read(dst_inode);
 	size_t count = args->count;
 	ssize_t status;
 
@@ -485,7 +491,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 			goto out;
 	}
 
-	nfs42_copy_dest_done(dst_inode, pos_dst, res->write_res.count);
+	nfs42_copy_dest_done(dst, pos_dst, res->write_res.count, oldsize_dst);
 	nfs_invalidate_atime(src_inode);
 	status = res->write_res.count;
 out:
@@ -1252,6 +1258,7 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 	struct nfs42_clone_res res = {
 		.server	= server,
 	};
+	loff_t oldsize_dst = i_size_read(dst_inode);
 	int status;
 
 	msg->rpc_argp = &args;
@@ -1286,7 +1293,7 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 		/* a zero-length count means clone to EOF in src */
 		if (count == 0 && res.dst_fattr->valid & NFS_ATTR_FATTR_SIZE)
 			count = nfs_size_to_loff_t(res.dst_fattr->size) - dst_offset;
-		nfs42_copy_dest_done(dst_inode, dst_offset, count);
+		nfs42_copy_dest_done(dst_f, dst_offset, count, oldsize_dst);
 		status = nfs_post_op_update_inode(dst_inode, res.dst_fattr);
 	}
 
-- 
2.51.0



