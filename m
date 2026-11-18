Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041247;
	b=CNQH7Lk1uAHGQj4mIJDKYTT39SkV+vnNbYuDirzon0Wobe9AXDfNVaUkfjQUp8kmbhf2
	 29F+gPV7RN9YOtkoBU2yr/u8Y6rRh3iGq2RFoId2zU+zc4IWInzqZ9ihskOILYneMdER/
	 Bbk4IP84wWm8qPzkRMyOFGJBUZ7xuwmHqpgSKxKDU5he5XeooTOvW+mDt+PiZWipdpgVR
	 0yZf7mjcsNw+4LgYjDeaq1rPfncsx8kFCvo9n1+N1b+OSy+47yNZIH+xEW+o6OqgCLdzk
	 4464oA7sz70E43M7B/6e8gA85vLKNUVa4N7AoavqdeTRa/iM2eScdaQASPqte6ATOfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sGlOlQlN/LVJxGgBgWxBZLJ4DeFSajUybQMjff4eFVo=;
	b=g/V3zckfqdCOZMNYYa69FW1JBL/nU3efMgJ9MhNBT2bMyB1uKEkTFcFvwsQrSE0h4KXC
	 /1cs9yLalEB4M7U62i09xTZvrmelwZMr/euiqn/4SbNUwO66xarh+iiF6BmAU3t5VwTHg
	 PM2fp7E2SLDKk2rn0zsmxhOJMZ7wL6bvtXCRjRbC0RhOqZB+ZlvksAJXRUfVeF7dwuc36
	 9ze2kAQP8sS7OJqwGUu4zrfnPeNU4ndzlvTLXBF8aAIXX9YGX6HfRa5cDHKEpalk88IYl
	 Y/NXM47ks3px6t0bZUrvLb//DU6PrKygd7Dp/e4hHS5IBS6tdCy2BWTRkJfA3WkQyhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zp/fAmcU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62766606A320;
	Wed, 18 Nov 2026 22:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zp/fAmcU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A5D1F000C4;
	Wed, 18 Nov 2026 22:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041247;
	bh=sGlOlQlN/LVJxGgBgWxBZLJ4DeFSajUybQMjff4eFVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zp/fAmcUPSLhM/TNWM3I9ggpOp+TrorHAhsUr17YjvVLaA6CF/S8GlMMuYxHHmYbr
	 h2w0P08tDw5ARXULeZsSmjM0dtTQRJCWc95Bvq2XBf768dB8O7q9EONOEr0tyW1NTO
	 AhL/p48ogFi8HUd85r5dSTcACQ1N7AmFILWf/FQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2744/3318] block: honor IOCB_NOWAIT in the block device buffered read path
Date: Wed, 18 Nov 2026 15:56:06 +0100
Message-ID: <20261118150443.092624600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit d16519a561f4ccc2cebbf52831435833cac1fec6 ]

blkdev_read_iter() takes inode_lock_shared() unconditionally around
filemap_read(). Unlike blkdev_write_iter(), it does not reject
IOCB_NOWAIT for buffered I/O, so a non-blocking read, or the buffered
tail of a short IOCB_NOWAIT direct read, blocks behind set_blocksize()
holding i_rwsem across sync_blockdev().

A preadv2(RWF_NOWAIT) issued while another thread changes the block
size with a dirty page cache blocks for as long as sync_blockdev()
takes, 4 to 6 seconds on a scsi_debug device with delay=5.

Use inode_trylock_shared() for IOCB_NOWAIT and return the bytes the
direct path already read, or -EAGAIN if none, when the lock is
contended, preserving NOWAIT semantics.

Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-4-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 0daa21b0369eb..8de3bdfdd9984 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -740,7 +740,15 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
 	 * changing i_blkbits/folio order and punching out the pagecache.
 	 */
-	inode_lock_shared(bd_inode);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock_shared(bd_inode)) {
+			if (!ret)
+				ret = -EAGAIN;
+			goto reexpand;
+		}
+	} else {
+		inode_lock_shared(bd_inode);
+	}
 	ret = filemap_read(iocb, to, ret);
 	inode_unlock_shared(bd_inode);
 
-- 
2.53.0



