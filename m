Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020453;
	b=DIIAi5Xf+1LBYqvt0fI52vUWjGFp3C4mRd+i4l/Fg3cwwHTAvSobTW+f+BQoqBet+W2b
	 ShHWo4XYyVkciTQfUrgKZ2ceouP1MJDf7UUvZ4mcWGx2x5n+JYx7rvoxnInmDxjdy9eG2
	 vZABcu/gQ913du0Ap7aQMb8k7Hi/KLLdQhpeq90wcLpNNUu6HEE9a+fWYX+Vl2oILL+MF
	 vSnZhOJ9nne7cGpJTrTybJtI+dhfKcSSgihRKTHHyEw65zBt3HLxmjoEYft1IOZwJ4axa
	 Z+9jONB+PZA80SLZgB83NQyNxUyhP1LdZGQh8SvEbj4Vj6jYaRzEdPwnWe49nfhGyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bnnexgEdz2vQBhpd7f9kB3/kMxg/xhXpaB3HHZUHv4M=;
	b=SaA+dWOtDKHza/2TpBXU7g3X++UO4giiIvXJdXvaKSzN+fG7/x2pkJnfyJG3n/1vqL3N
	 vvifXpki/2sfzNzcgM7uCXWMcwsTyowMLpdN3HbsPH9ouHZLi7PR7Y2RBHDyPTbf4JgvR
	 RC58lk3H2YzLqHtIWs7GD8mUCknJCpaBX253fZ/5cTfbJJFHxGaNmxNGtDtwu0kxKNMfx
	 dSTp1NH7ct/s39QinVZc3JjAaB6j8s8bDZ9Hdc659TXoAimXjW2NqDoZPa3fNT5mz7R21
	 Fptp95GLahrEDv7hAL9AUd9H9PQo38GlYW0w/HF9WLWwVLBtyWuz3Aj2kE98SGhaA4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GFkh++/9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD4F606A31C;
	Wed, 18 Nov 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFkh++/9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4461F000C4;
	Wed, 18 Nov 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020453;
	bh=bnnexgEdz2vQBhpd7f9kB3/kMxg/xhXpaB3HHZUHv4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFkh++/93lOPFb5irGq4a9uJo5vlCymhdAppEOtC7eUKFzXqFzX/0WUtllGU5QOUs
	 ZaCyR8C4HprG4dtsN1BCICXiB/tjIzotXrK0MkUUtS02MwVV/Y4vpLprYy9dQxt6CV
	 K292imqAEUbbtN5zMZz90sCNhHALlDKhFs9wAMl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1956/2651] block: take the inode lock for buffered write fallback
Date: Wed, 18 Nov 2026 15:53:16 +0100
Message-ID: <20261118150356.961102829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d2e38951bab81..847db3841ff23 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -729,12 +729,22 @@ blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
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
@@ -823,14 +833,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
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



