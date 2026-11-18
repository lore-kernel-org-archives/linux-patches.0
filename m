Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026896;
	b=Igkfqs+672Dcny3UoKiOOPZf8MkEzT7bjoJ+4eKxKXl+VjGR47pZ7lNYb0M7DOGaj2LN
	 R/XLDGgzOxPwr4p0K3NTLz2Hja7ttXQw4njsgYijpg9P1kbVgvQ1SeVexCmhoKf7XzEEM
	 OYtx4F6D3yw3XskgdSuYmCIt+2O+oTH6nm9Ce/rCQ3F4AiRtsjJBb6wj621uDqlrQ8bHM
	 +GUGkbn1OtBgv3v8CI4LonfJBBWZleB/Vh9OCJxH/wvuIcb26XTGcJ2j3Z3mgek48ltHZ
	 63z67+jvYfzU4Lbq9QTn5Yp2by+DR75H9chQCky396O0G46Bxf2bA0Ko3FHtPiosCCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1oGBlJZA/emrNJx0iuiLGKArdFyOlU9O45o4/nibqc=;
	b=ZDJRcyfqm2I+X5JxDQv6UOF9iepbXXZntbWwY9nQqroDPW8UCpNlfw03fN4F6/LGsgIf
	 UCfZVxMzrGfygj32lgDCx7QBajVImfld9Pu3iyJ1uWQjnkxoVXanX4Mm2XyND66+1HXjh
	 yXvq4pwIop/JFU+IyNS1NCKLhOK5xfQQ+TtHn/9o5rqIjPLTFz1RcFVipFnil6qZkRCHO
	 tF6aSP1u1NZqVEQ+X//91vhCZ3hFrAx5wwVMAo8EEoj1ZxnaSZ6fIkETJNK/ApVEyW+L/
	 K6AiHIXCvwQuRJ3P+npsO8Za47prROFP7KyIRHs3uo89KHYh58lCuRfdODI/f+809DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shwDcFoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB1606A33F;
	Wed, 18 Nov 2026 18:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shwDcFoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281A41F000C4;
	Wed, 18 Nov 2026 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026896;
	bh=B1oGBlJZA/emrNJx0iuiLGKArdFyOlU9O45o4/nibqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shwDcFoCewDKMtLjKAIgvOBEVsrFQFOB/tL9uCYaSH44fkWp0nBuz5kjiRTWxTSxp
	 XeTHTDs/n/El+TUcWWZOGnBsLdODVtyrwB4mGzI7DIWsWoichaJjue38I5la4h7D1K
	 hd7bWeh3O9zFobiEH6rzWW4tQWcVGeJbTa2JUhig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1596/2151] block: take the inode lock for buffered write fallback
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150220.020876403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 1b1be9ea4e34ccede1e7cf9ff2b6317328a5b6ad ]

Commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") added shared inode locking around ordinary buffered writes,
but missed the direct-I/O fallback path.

Move the lock into blkdev_buffered_write() so both paths serialize
with set_blocksize().

Also correct the comment claiming that this path takes invalidate_lock;
it only takes i_rwsem.

Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261015091105.1315605-3-sunjunchao@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index c7cd9f89c352c..68b55d3c0876e 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -757,12 +757,22 @@ blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t blkdev_buffered_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct inode *inode = bdev_file_inode(iocb->ki_filp);
+	ssize_t ret;
+
 	/* Buffered fallback waits for writeback, which NOWAIT cannot allow. */
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
-	return iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops, NULL,
-			NULL);
+	/*
+	 * Take i_rwsem to avoid racing with set_blocksize() changing
+	 * i_blkbits/folio order and truncating the page cache.
+	 */
+	inode_lock_shared(inode);
+	ret = iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops, NULL,
+					NULL);
+	inode_unlock_shared(inode);
+	return ret;
 }
 
 /*
@@ -851,14 +861,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			need_sync = true;
 		}
 	} else {
-		/*
-		 * Take i_rwsem and invalidate_lock to avoid racing with
-		 * set_blocksize changing i_blkbits/folio order and punching
-		 * out the pagecache.
-		 */
-		inode_lock_shared(bd_inode);
 		ret = blkdev_buffered_write(iocb, from);
-		inode_unlock_shared(bd_inode);
 		need_sync = true;
 	}
 
-- 
2.53.0



