Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C424D151CEA;
	Tue, 23 Jan 2024 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969367; cv=none; b=Sju/qdgWI0a3/t4eSDDiFMhYMSQDRdED0n64BhzmusY4zY5yhZJ1a0cMQDvOj7Envtr1bJ7+oERpaJFUh+ojkTSJMQp22KHIEtrf9IlWvhYXDs0rH8XUggHCRARlkNSv/z9rFZJr+jf9jLN6Rdzhc5spS53NM7+8Oiz5/zr/mio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969367; c=relaxed/simple;
	bh=zXcoTGpO6QWLAwCOzNCOqi0u+94ptEDsBRFkdivTMHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB1ufdcLk1IVROJR2sCQPlFTA4uOlgbOdntP9i+CCV44wFCdoXO/0GYiVEzDIbTJpWUaFzqdZaF2UILU5P1w8cQIvmSVLCBeCb2bsndGiWX8PynEGU23u1FH/2kaSADkUsZ0+yYL8gj4DI/k+ioJ1xVn7cG4X0ERtk/oCnwH8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4YEstGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4YEstGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593DDC433F1;
	Tue, 23 Jan 2024 00:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969367;
	bh=zXcoTGpO6QWLAwCOzNCOqi0u+94ptEDsBRFkdivTMHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4YEstGR8JtAYdU14oY0nbJfRWOAtkhG8SxZwb5tkSyUH3vUeu9VbR71UbBn1FG0Z
	 06B1eDJx/R3mN9c5IeesVVHITZo0bN04Rdbtwg3IuTxiCb1AUaE+K5wENo9dYx0bvR
	 H/LvgjbehHXm+5Mfn/d5faxmGS6XA5pmsnsAkiLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 199/641] block: add check of minors and first_minor in device_add_disk()
Date: Mon, 22 Jan 2024 15:51:43 -0800
Message-ID: <20240122235824.187897021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 4c434392c4777881d01beada6701eff8c76b43fe ]

'first_minor' represents the starting minor number of disks, and
'minors' represents the number of partitions in the device. Neither
of them can be greater than MINORMASK + 1.

Commit e338924bd05d ("block: check minor range in device_add_disk()")
only added the check of 'first_minor + minors'. However, their sum might
be less than MINORMASK but their values are wrong. Complete the checks now.

Fixes: e338924bd05d ("block: check minor range in device_add_disk()")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231219075942.840255-1-linan666@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 13db3a7943d8..d74fb5b4ae68 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -432,7 +432,9 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 				DISK_MAX_PARTS);
 			disk->minors = DISK_MAX_PARTS;
 		}
-		if (disk->first_minor + disk->minors > MINORMASK + 1)
+		if (disk->first_minor > MINORMASK ||
+		    disk->minors > MINORMASK + 1 ||
+		    disk->first_minor + disk->minors > MINORMASK + 1)
 			goto out_exit_elevator;
 	} else {
 		if (WARN_ON(disk->minors))
-- 
2.43.0



