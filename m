Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC941E522;
	Thu, 30 Jan 2025 14:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247016; cv=none; b=HsoruUBsc1a5mKqB2Vh7HPoNRJ4dvqW/NI8ST5UA1TS6H2Ij1FIu2rqMJyHjypk+7FYAZA27BbH6swsSjaEsIzR5jhSRCyNbycO1f6Y2S2ZdDUj5Pae7w3YLUzqJFyhb11M69au5HmWoak3uAj1t7HX84btg/QRpW2KOXlzFnhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247016; c=relaxed/simple;
	bh=XH1OJ6WSUNMCWPR2hszxTkJBf0FLHtAgMg3J1OipIp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCaad67+bEzjozKZRDLQalJJYNBshqq9S4nDIMy2wCy4Ah4WarhmCdvBu3ibh7OQdXXtwbqDiYqUyICTMyyTNqEg3qLYz6cJ3xQNNdAYrA9NV9RaoWjJdCT229srs3T8kYRAY1wxks29bgA70GXknoTKzE98j9s4q7jfEz3C034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFQZzj4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFQZzj4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63000C4CED2;
	Thu, 30 Jan 2025 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247016;
	bh=XH1OJ6WSUNMCWPR2hszxTkJBf0FLHtAgMg3J1OipIp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFQZzj4KeoZR6oPyMkn2uANHTcBLxNZph1xvk6OjXAmB+Ia49HriPqXR/Gs9gYh6c
	 cCUpVIomIj7prxAoPU6oMLbXnefYPQu8Tverx47VNQWYu6YLq3YZdLLOggYHm4bAYo
	 uA+ELwt1S+g2qn9ii1qSNPjBAqflcsw7yA4GJOIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/133] loop: let set_capacity_revalidate_and_notify update the bdev size
Date: Thu, 30 Jan 2025 15:00:42 +0100
Message-ID: <20250130140144.653039402@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3b4f85d02a4bd85cbea999a064235a47694bbb7b ]

There is no good reason to call revalidate_disk_size separately.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7444cc2a6c86..198f7ce3234b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -238,12 +238,8 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
  */
 static void loop_set_size(struct loop_device *lo, loff_t size)
 {
-	struct block_device *bdev = lo->lo_device;
-
-	bd_set_nr_sectors(bdev, size);
-
-	if (!set_capacity_revalidate_and_notify(lo->lo_disk, size, false))
-		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+	if (!set_capacity_revalidate_and_notify(lo->lo_disk, size, true))
+		kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 }
 
 static inline int
-- 
2.39.5



