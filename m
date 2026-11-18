Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057075;
	b=mt5oujhsTABCqP62DwSEjBEepReZPDfBOr57Jhmch3NK/Q2z/LH/KEMnN1LYb+mmm1HR
	 CDNUJqB9Ddvgbi1QPY4xLn2ykYa9iYy6hBZ4KZEZQOiSr5gNm1Wk/9tlWfDE1lmYTPC7y
	 or5uyyddicc4o0QhKpEUwxgI4Hy8SC4vbk6txO6gUqBjKxuh/j0Mj7rBAAIPj6eeZnArr
	 0RTMJMHkLODS2YfbHL+SpOD9PB2BrV3eUQhvo74lBezYHMqdXUzEpgYWBkiOpNBTWBe8e
	 5jI8j80BLdftf8GRQx+zdqE31X0m4c7aOcCSvYy3hKOn/Sliz3ZLg3C9k49lfkAioXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBszGzDm+W4z3FCfIuzIOBsWdy1zTlxWgnppOXit1pI=;
	b=qmb+q35Dlky/duRA+c4QEd53UMJk2in0GuIWA1+s1fpXRjyJ6X+u/+0UtykrtX+AgqVM
	 bU1HSOrAQHldQtuFEyobgovdxe+nUoDI3P40RZpazZ2KdYvDtUTKb8JcO952hAsoFXKE0
	 UzjNkd1neTwq0C2GrrZSs7c6KO2kpF6xBroqtCPFg1zWcPh4muYIyAYCh9P79AteGxcEY
	 ESdWez/ncuTzHaBtwIpDi5OXYerEWl4OTT39GKUKEr2OTrpF3x3BKMKdwE5FGcVd5hw5H
	 BTgx5edl+AqbNAM4oTi9aH7z7X6fODQGYZgZmx5Mt22d7+2jd0W305EJQd33/fKDE0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsyKxdSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02E606A325;
	Thu, 19 Nov 2026 02:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsyKxdSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319411F000C6;
	Thu, 19 Nov 2026 02:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057075;
	bh=vBszGzDm+W4z3FCfIuzIOBsWdy1zTlxWgnppOXit1pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsyKxdSI81BjKSSYZkHIbw5O4ulVTsoJ4pRjKk42eQK23dO69XrkmkDe5Ef5WsojL
	 z8+PKXSGopscDsXlg0LC7+jsRQ5S3NI4h7uca8x3lRj9opbyv5tUNeu/1wbCIKUdH1
	 HgOS8OYEMSDmpQsz+gpTQs3gq5wjaarLBGFqs8Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2174/2214] block: fix use-after-free of the disk in sync_bdevs()
Date: Wed, 18 Nov 2026 16:04:10 +0100
Message-ID: <20261118150137.364955973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8f64f3ce27711..96ceb1fb326ac 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1058,6 +1058,15 @@ void sync_bdevs(bool wait)
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
 		if (!bdev->bd_openers) {
 			; /* skip */
@@ -1073,6 +1082,7 @@ void sync_bdevs(bool wait)
 			filemap_fdatawrite(inode->i_mapping);
 		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
+		put_device(&bdev->bd_device);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-- 
2.53.0



