Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963D57405A;
	Mon,  6 Jan 2025 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177650; cv=none; b=kI+45LTjNsAUAPJE+hHpJAwmd0b0uT5VR0x3i2WohzlprZtIil5IZ1ANqD4tQadEjTTQoKujKL9q0Ft0FZ4O3pbZbU7joKr5d64c9kVK/2obBIkgOWeh6XAOCCz6+LDHYE/DOWpcoZ5010rKgkQ6+BrSpCQ+hc3wxzM0s3VAncY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177650; c=relaxed/simple;
	bh=BnC+zLrcqMGpTxHf261I67ULaTYMtQgfDbJ15BQtWcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsbSZ/PDIEdjdr4FZAWgmGrI+OCv1JRPG9A0j9DezsPbBqYRZYWlId92DtEsEgWtC6wulW6Bhe32Px0BrS6VBcyAiFjPfna6oFi7A5TZ+iv4E1h/80CrTVCayk/GT5nOQFIRcVvcNRcRG3guAkkMp0FW6wVMQyt1nQLmiFX+kBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT8sY+Iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT8sY+Iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A6C4CED2;
	Mon,  6 Jan 2025 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177650;
	bh=BnC+zLrcqMGpTxHf261I67ULaTYMtQgfDbJ15BQtWcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mT8sY+IzwIm/rYhOmXfjcqjT2B9DAQ27ddpKQuEyCr4X59Igk72fCHHppNUQopGBe
	 S35pIgahXjFcf1ss7wKMayBPA/XORJgWnf1xhSf0xlOgF6i112hA6F5lHJoF+7hT87
	 H/fVpoevUDqSklcAYYQoShpXdAwzS7gK5ibCWAKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/156] btrfs: use bio_is_zone_append() in the completion handler
Date: Mon,  6 Jan 2025 16:14:57 +0100
Message-ID: <20250106151142.169739137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6c3864e055486fadb5b97793b57688082e14b43b ]

Otherwise it won't catch bios turned into regular writes by the block
level zone write plugging. The additional test it adds is for emulated
zone append.

Fixes: 9b1ce7f0c6f8 ("block: Implement zone append emulation")
CC: stable@vger.kernel.org # 6.12
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 3d2376caedfa..31f96c2d8691 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -355,7 +355,7 @@ static void btrfs_simple_end_io(struct bio *bio)
 		INIT_WORK(&bbio->end_io_work, btrfs_end_bio_work);
 		queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
 	} else {
-		if (bio_op(bio) == REQ_OP_ZONE_APPEND && !bio->bi_status)
+		if (bio_is_zone_append(bio) && !bio->bi_status)
 			btrfs_record_physical_zoned(bbio);
 		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 	}
@@ -398,7 +398,7 @@ static void btrfs_orig_write_end_io(struct bio *bio)
 	else
 		bio->bi_status = BLK_STS_OK;
 
-	if (bio_op(bio) == REQ_OP_ZONE_APPEND && !bio->bi_status)
+	if (bio_is_zone_append(bio) && !bio->bi_status)
 		stripe->physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 
 	btrfs_bio_end_io(bbio, bbio->bio.bi_status);
@@ -412,7 +412,7 @@ static void btrfs_clone_write_end_io(struct bio *bio)
 	if (bio->bi_status) {
 		atomic_inc(&stripe->bioc->error);
 		btrfs_log_dev_io_error(bio, stripe->dev);
-	} else if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+	} else if (bio_is_zone_append(bio)) {
 		stripe->physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	}
 
-- 
2.39.5



