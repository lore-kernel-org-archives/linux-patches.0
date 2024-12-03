Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13DA1F7591;
	Tue,  3 Dec 2024 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242789; cv=none; b=oEZNwFpjMMqgSGPxIp16QhOHT8nNliighJxrgCp8E1yNlv0Vmfx1xcWx5aKLTkGmexU0rSde4f9BzV/PTPaOE0EGwSIbgV05cdDtkWSUc5XZAQbKEuK+KWGBOgYM8sqwuDyJ6wmsukR8wIt+VkVh+dPV6FxNPPCWiTj1Wqgpt1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242789; c=relaxed/simple;
	bh=DfMXYfEm67FlzQCbogChsWAuC/Npj8eC6VIRtp4igAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGwYPx8bAhEyZLQkP2Wgk9yQC7RuLCYz6nTcK46EzwLLkDVg0AtYxaM7SlC2bYfJZjWoQ1xHOGVuF4wMJsQdP47anFXarf24ldEcAye6Sr1eMZ/Wg2gZ9PakyBNRGd3x0jWrB5IP15zbfJgob5Nr9mwQ0svqK0QjR2yd5ReVrA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCteNYeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCteNYeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F1EC4CECF;
	Tue,  3 Dec 2024 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242789;
	bh=DfMXYfEm67FlzQCbogChsWAuC/Npj8eC6VIRtp4igAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCteNYeZuPPKzIYNAtH6jkozKK7VRnZmKys7FxtVc31IutQFKzzsF25gWJgIDsl7A
	 kAVIGQ+Xk7xzCC9jMHP4xwh5DYd9LYNxp9jyTGOEaecQE56nJ3FPQPguaCnDLbM0dn
	 oG9gwk8Hk7ifSF4NncrSY1pI9DBuFHeH5eYvPE9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 810/826] block: Dont allow an atomic write be truncated in blkdev_write_iter()
Date: Tue,  3 Dec 2024 15:48:57 +0100
Message-ID: <20241203144815.351629138@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 2cbd51f1f8739fd2fdf4bae1386bcf75ce0176ba ]

A write which goes past the end of the bdev in blkdev_write_iter() will
be truncated. Truncating cannot tolerated for an atomic write, so error
that condition.

Fixes: caf336f81b3a ("block: Add fops atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241127092318.632790-1-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 2d01c90076813..13a67940d0408 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -677,6 +677,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct file *file = iocb->ki_filp;
 	struct inode *bd_inode = bdev_file_inode(file);
 	struct block_device *bdev = I_BDEV(bd_inode);
+	bool atomic = iocb->ki_flags & IOCB_ATOMIC;
 	loff_t size = bdev_nr_bytes(bdev);
 	size_t shorted = 0;
 	ssize_t ret;
@@ -696,7 +697,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
-	if (iocb->ki_flags & IOCB_ATOMIC) {
+	if (atomic) {
 		ret = generic_atomic_write_valid(iocb, from);
 		if (ret)
 			return ret;
@@ -704,6 +705,8 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	size -= iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
+		if (atomic)
+			return -EINVAL;
 		shorted = iov_iter_count(from) - size;
 		iov_iter_truncate(from, size);
 	}
-- 
2.43.0



