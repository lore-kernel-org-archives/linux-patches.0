Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645841F7545;
	Tue, 17 Dec 2024 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456634; cv=none; b=OQj/XT/qpr8TjaIW3oU8lvqVavUylizjeuB4On2RX5KP/a9IVte7ZH+yrKCZWr92STL3kLfcMdEpCSrlHMz7B/U+4BkoYVOovkw9NX2o/bsyxIX9rwtu7QyCR8PAFKVFLBrzSrmvOJiQEgIsxb0GymwtRFs176WEmYBb0gZtzuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456634; c=relaxed/simple;
	bh=k+cH4aAVjSIHypf5KMqPyL0vO7g+okue7lJPfzmxpcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/K74y9RNz91zc8Ub0hmU7kYDJdMMxVqt+JFQlurjIVibpoa4zIL79QEr3DWCbLWhHgvXi73on2DUczO+tXsiZKevhge2Prkg1JzVRJo7mGzp6J3riu+m+3vYcbEfKhfhLahp+ZczWjP6xl32z0olTYMDgEwNQqkZBj19E1leUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+TfGFzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+TfGFzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F99EC4CED3;
	Tue, 17 Dec 2024 17:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456633;
	bh=k+cH4aAVjSIHypf5KMqPyL0vO7g+okue7lJPfzmxpcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+TfGFzN3TCO3LBgt2F6On+T5gn7DvC1Rk0neOEen13gk56RiVtfzqx0y6qa9NseJ
	 lSH1oau2VLcWgjqKq8CAEoxYAaFy1hNy7E41uBkRsy0T+Et7wQFIBiHcoMjL+Gnfuj
	 /1ajkH8mcst397ESt51I85DA/dsmKZMyMxKxXEIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LongPing Wei <weilongping@oppo.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/172] block: get wp_offset by bdev_offset_from_zone_start
Date: Tue, 17 Dec 2024 18:07:55 +0100
Message-ID: <20241217170551.262260174@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LongPing Wei <weilongping@oppo.com>

[ Upstream commit 790eb09e59709a1ffc1c64fe4aae2789120851b0 ]

Call bdev_offset_from_zone_start() instead of open-coding it.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: LongPing Wei <weilongping@oppo.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20241107020439.1644577-1-weilongping@oppo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 6d21693f39b7..767bcbce74fa 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -568,7 +568,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
 	spin_lock_init(&zwplug->lock);
 	zwplug->flags = 0;
 	zwplug->zone_no = zno;
-	zwplug->wp_offset = sector & (disk->queue->limits.chunk_sectors - 1);
+	zwplug->wp_offset = bdev_offset_from_zone_start(disk->part0, sector);
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
 	zwplug->disk = disk;
-- 
2.39.5



