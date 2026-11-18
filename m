Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033160;
	b=gT94xofnBy7r039cNBPYxWmnylHKbmgKybDAm497e7df3hAAD+oEm5Eg26QJdZjMwTpE
	 PifyogPwTn6m1nsg/BdO/Cppyi3SWJaefBYVjODahpEiYeUixzuHo5VueCoSVFAo7tTkw
	 y1QIfyHdK/LPpwh2vP8K4EKFA9ECUNo4mxo3mdXvutjf48ajH15cZqFmLawkar1UgWjuD
	 eDMVhyXdq429SAEuWku23yAhr60XhmKJCpN+C5q31pIctAjDIxFWc5Fv5avU767HpzJ9j
	 02w6CMCUnl7Sbr4g0SxgPD4FO7xQ5RlOl5f1oM+gutMMznLgPPwSvd86n9o+SeomYNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0dVxlvkrg8Ntg3neielMorOaPdYeoQnOLWJQTNw62Co=;
	b=Uq9fXEMWxVKmy+4jU2orFUaMvX04XlM7DF39TN6hslQI3SOzb3nE/ekSj3ugZoyBZc6H
	 1VBp3ZHvhbfyDPsLEMfrxqatCmg3/lbYRHjKgMVJ+K16mrx40E9CEYNsIA2urrgdqX9GB
	 kzbGA4UwHYUmLWbF4BqoKq4MeuCRketcjuUolklSIWK/epswc2ffSIrCLD7D7xed2TOSk
	 noPzFpNCXf3lzVzqKmuFLmwUHfn5gC2V/xyv7TCVRRtCZmt+HQZquqt26J0OjTI9h3wn9
	 jJ468gyvmg6mTLV+DR4JHDu30mx9kOdwg4rZkl51y4GDiy5PNSG9CsdKGD4PP+Bp8xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jr0mGoy8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840C606A31C;
	Wed, 18 Nov 2026 20:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jr0mGoy8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253201F000C8;
	Wed, 18 Nov 2026 20:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033160;
	bh=0dVxlvkrg8Ntg3neielMorOaPdYeoQnOLWJQTNw62Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jr0mGoy8rSXQsjd90JW/qRdIam9vAXFCRESdRIykdkhK1punQGEGyZNSmkrEk5oS7
	 MQyz/UkuMeyIMKHVZeS2Ytc2B6qNcoENlYHqWenJO/JRozByEN49yASKg+HkAVZk0Q
	 BV4bF0S566z8YFsRGfWtiDgZyYkQdEEtafbAJcSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1669/1756] block: fix use-after-free of the disk in sync_bdevs()
Date: Wed, 18 Nov 2026 16:03:16 +0100
Message-ID: <20261118150116.143840585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 57aa344dc04a5..dc66a9bec5e33 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1274,6 +1274,15 @@ void sync_bdevs(bool wait)
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
@@ -1289,6 +1298,7 @@ void sync_bdevs(bool wait)
 			filemap_fdatawrite(inode->i_mapping);
 		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
+		put_device(&bdev->bd_device);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-- 
2.53.0



