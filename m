Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022224;
	b=NQtIWi/GMqFnYfbvlNTKfDsF1oKnv3hfooSrrI0xbYre00CcZbQFCpUJhyD3TJtJu0HX
	 tYi5sjEqme4OHvCmQ1279fPjCtYgOkItV4zwwGs6D+rh2Aq6Z57VzXxBDNPFXyKrt0tPr
	 xiFn0Y7k4oxSCTbLBmfDWz4kj0QhtVj/SHPyo+PMxVHst5AwZT6m1/PL9fb2MepbsOHuN
	 YOXPdDAQ0JzhRqw6duR6/nqYop0RYXLn1pLXPlUWOkSDTeoSerqcV5hvg89YnXGUh/q8Z
	 m9FKEAEAyHoacVekTOgTm2rP6MerRClPV0psQWSlW3v7YHkCiLvf4+m8raoBWXpLv0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iMGCrqdOmOajapBUnWyYw75jFpgvwpAxqoJx6KCCd3M=;
	b=mE8Wz8ex4Xd3b+s0R1vu3tm9HFf/IvQFEzfDzZJawHuSmdII+Q+XqeOsZjVxOU1fulft
	 OOyjOwjHAkS4Z3ow2cblwUMF3sW5CQwDmpBl73uY6F4ZvAflgoNEiuXfOMlB2AbISDuTt
	 /9/V+TqJ/1QnL79OduGlq+mclT0UTS91aDe9q8Ua0lggbB28+1reK6bStpCfwHB3MWyZY
	 94flCMTRf1/lQGp2nIaAYDnbHuOoaZg7ON4Nd7Rbv20aft104oAK2MZ2JCNarRZ904M0R
	 Gn64Ds2t66553UjSHUnAYq5OYbdKJZ8hPuxI04dCk+5WjpTpyNCGV1CXlRDQZsIb6vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5PKqn5s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD256606A31C;
	Wed, 18 Nov 2026 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5PKqn5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB641F000C4;
	Wed, 18 Nov 2026 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022224;
	bh=iMGCrqdOmOajapBUnWyYw75jFpgvwpAxqoJx6KCCd3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5PKqn5s+Qduxh/GAuHa6K0pJEzTltv1E9Ax44c9svM3ZdhlGpKLQ8fh5i7TtSXSS
	 CeI7OxL9vtE9w/uVvBcSQgkGhMpBO0Ciflkeid1T1W8KXckL181aoD3SocR2AdGnSO
	 s6CVidjqTVoYwjqZEyJC/nl0RlXYDV+vHvLDjkhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2579/2651] block: fix use-after-free of the disk in sync_bdevs()
Date: Wed, 18 Nov 2026 16:03:39 +0100
Message-ID: <20261118150417.175587145@linuxfoundation.org>
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
index 5efb259ab3a7f..f20f91b3176e8 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1366,6 +1366,15 @@ void sync_bdevs(bool wait)
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
@@ -1381,6 +1390,7 @@ void sync_bdevs(bool wait)
 			filemap_fdatawrite(inode->i_mapping);
 		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
+		put_device(&bdev->bd_device);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-- 
2.53.0



