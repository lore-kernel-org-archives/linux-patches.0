Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028224;
	b=OZu5x8aNcVGDY+/ypuJxi6T4gAVB6RM2hsApMTf2uIRqTnBCE3VFoDqNRq9GKQWhK5xT
	 65E84p3n8QdjVOQMKzATYSNO10ZFFK+q6+C3S115dGD/nELi089/b4VxuO/OJeFhPuAgM
	 Rl3czBGIFvy5RyXI+jzSZmXp2u6QKxi4/ZBPuardaAiRq8jw3VFIQfSDTePSly4+GXerr
	 0WHOvnoaJeabxjwjVA+3/MSLbYMCrAOm1KngIbz+GOq9qo1a2DERrWELp2zOJafsV/fN/
	 R2auXX4Supo6XUOy8bYWsujMu9P/G30DJUt4GaG7aFUOsSqFfmkiYjF1wVEJdfKDySw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B4310r+0vaqHsyrJVLFX7qnL8bgXSU4D/lDpXHDuCQw=;
	b=Lz2FbwWsqq2FVZbLuQHv71BkaJKVF8G6Ap8/zltce4BeiYgaI+0gx34f/NB3fpP7ymRz
	 0+YzgcwED12ujfWPU0fK7r2t3D1xT9xAaAQvozBjjbBCaoidPfvcl3IhrMKz7VzGHqDQX
	 hFgyWZSWxiTw37Vn0BmUUd6E4Is4bnE6p4w9m8NwnDqg0VfaKK3HnVD/95l5UlIC65ZKH
	 Tmk3+kURo7XlNVcgNekOc+NEyfVlws1tsOxq7dQTo4Ot764bvQmhNfEWmrMSVsuYDD71O
	 gXz40G5/u69dQ3pIjVgpZTcGhhEi9ci9HzHymXdtgvMqja5lo0hGvW4TPKk4L2dIryg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WaY8ynOF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62387606A31C;
	Wed, 18 Nov 2026 18:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WaY8ynOF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26D11F000C4;
	Wed, 18 Nov 2026 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028224;
	bh=B4310r+0vaqHsyrJVLFX7qnL8bgXSU4D/lDpXHDuCQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaY8ynOFnwBmg4vzObnirFetyl2CsWTsYfsTon4Xxk4TJTLewYhSG3yQCyocg5/rR
	 H+2tqK5jRvuPfcNy01Pxpelp22Uaz/dhCBhjPCh5dqlCEWqNwJ+0awDAbtaWyl6P0m
	 FcMA5HaWXPouYblCMmrWBYRBqtnysh06esMolYDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2069/2151] block: fix use-after-free of the disk in sync_bdevs()
Date: Wed, 18 Nov 2026 16:03:24 +0100
Message-ID: <20261118150237.088054728@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit cebb1c2331c2af1b7f1c822ac672a7f77b54bd90 ]

sync_bdevs() holds a reference to the bdev inode while it takes
bd_disk->open_mutex. For a partition the inode doesn't keep the gendisk
alive, the device reference does: part_release() drops the disk as soon
as the last reference to the partition device is gone. A sync(2) racing
with the last close of a partition of an already deleted disk locks a
freed open_mutex.

Take a device reference before touching the disk, like
blkdev_get_no_open() does, and skip the bdev if it's on its way out.

Fixes: a8698707a183 ("block: move bd_mutex to struct gendisk")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-5-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index 3acf3e9d33739..e7d403dd70880 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1298,6 +1298,15 @@ void sync_bdevs(bool wait)
 		old_inode = inode;
 		bdev = I_BDEV(inode);
 
+		/*
+		 * The inode does not keep the gendisk of a partition alive, the
+		 * device does.
+		 */
+		if (!kobject_get_unless_zero(&bdev->bd_device.kobj)) {
+			spin_lock(&blockdev_superblock->s_inode_list_lock);
+			continue;
+		}
+
 		mutex_lock(&bdev->bd_disk->open_mutex);
 		if (!atomic_read(&bdev->bd_openers)) {
 			; /* skip */
@@ -1313,6 +1322,7 @@ void sync_bdevs(bool wait)
 			filemap_fdatawrite(inode->i_mapping);
 		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
+		put_device(&bdev->bd_device);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-- 
2.53.0



