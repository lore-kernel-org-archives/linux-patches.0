Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042663;
	b=m0As+LSwuYw6vVpGJrLVtsEtGthanbMHy8vjNgYlTXvrna76mthXM4b3XilEb3UxVAMI
	 /orVzJQRc3QMhGktXuygDqTQftHVr0XzxS12C5/n8dPyu7sJazA4oFLfBXA38jaUnS0iH
	 eeYt9ZUucX8dyf6z0ryXYmGADSsG5+Ia9PT4DeQkGCzqAYLgsBEZTpT9weWxDbk41vCyQ
	 Tc+AiJQgKa2TVUQDWlgUiST1b3NYubwZ56qziBV4vHhSP8sbvrCrVTbS2aG+JOha8viDg
	 EfCByar1JEYOiW3AneNxkZM1mkFyMZGqwNZ7lA+8PSUe6nrD9cmEvuAZFKRHEGI+8nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mjy/sL+81zm2BYXo0FVCza0ZTzmn7qob9CiqlJDx7I=;
	b=Q6q94KdTM3q/Pd2wd0qKbVSzW7WuwvzJzAnzxiQMlDaDpP7Zyt/96Nj8EKgWY7V7CWAq
	 hArUqfRSmHFQvKnZOAPcNLTkySaF/3z/wzX1iY0ppMkICRT1gpRnlTExmsrb4yy9MIAtU
	 Gff8zgoII8xGJqdIdPULgwSu6IoAwiPxBYurKRfn6e6N0hduIHjm+cIzq/nC8IWFj53mC
	 SniR8G4XlBn+rBXFcs5Ai3LFlnAnE9yZz+WZPy5tC4yzkwjEwWaEHsTyOjsY+z4TNQ47C
	 /GdkViENd88P+EUaiCaFXEkPjMflso3YqZlqfHSDQFQKP5P/wzl0ifCI09mH2U9IUTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ar6kxTH6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F41C606A320;
	Wed, 18 Nov 2026 22:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ar6kxTH6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ACB1F000C4;
	Wed, 18 Nov 2026 22:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042663;
	bh=9mjy/sL+81zm2BYXo0FVCza0ZTzmn7qob9CiqlJDx7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ar6kxTH6Y8zL0ORbB0uHzN7yc55T3vvyDwxQjk1TXLVDZywT+SsQxcJmaVSXjbhci
	 J/jplkBoRe1FcoFZA6Dy3QPLEtiWqIokeSbqxiw3n1qNKgM2RalTAKG7QOZqGrTsYV
	 Oxqa+2Pk6g2eE1PDuadyM14Lz2ZakKQ65hZZ7MCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3252/3318] block: fix use-after-free of the disk in sync_bdevs()
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150457.202326251@linuxfoundation.org>
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
index c458d6097cf58..ac218cdb23bfe 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1086,6 +1086,15 @@ void sync_bdevs(bool wait)
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
@@ -1101,6 +1110,7 @@ void sync_bdevs(bool wait)
 			filemap_fdatawrite(inode->i_mapping);
 		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
+		put_device(&bdev->bd_device);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-- 
2.53.0



