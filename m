Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6891547D8;
	Mon,  6 Jan 2025 15:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178454; cv=none; b=tRRrFTxEKgb4nyW3bQAxrOHJiVvTa94aOyOuUhlg7agvpttxR4srNracFIha9LVzpgR7ntCm9VXd5M+3CuB2GUM3wsJFjrTdBy8b9tkzi5WKvW9krHWYHJertUSMcDaj0djKUAID5WAvAcJNAo1pqVVJxPdPZH1YSda0vZ4HsvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178454; c=relaxed/simple;
	bh=XH1OJ6WSUNMCWPR2hszxTkJBf0FLHtAgMg3J1OipIp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyg/k6A7nZSftvOrAU4jI0fxWEvv75zYFRFqlHrnsqL+ODTnhEjv+eI0P4gE61AYonSW/NMJ5GZUbGIv+SueiBXDPZ9wvQTYghfSNzd63nQyP2XHvLtnyZf/Z3FHD+o+E4DlldfFdJZ3/djdKsuS8o+5rgpIsACJ1BP2O/vHg3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGp9jeOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGp9jeOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CCBC4CED6;
	Mon,  6 Jan 2025 15:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178454;
	bh=XH1OJ6WSUNMCWPR2hszxTkJBf0FLHtAgMg3J1OipIp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGp9jeOLfphzLZQqVna05/wnZ1Q0Q7IpgcuEhTl51YMSDOjwdhgyWAiaIEfc1ekTu
	 pVnQWxFRfkmbl2gehuyZmbYElDT0Qr362FFgC0AI+hShJyJqT681IXZ4HIjBTt6/sx
	 YlWYUGWzmPFdStQhv537xlnpiR7LXCExLjB9nTtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/138] loop: let set_capacity_revalidate_and_notify update the bdev size
Date: Mon,  6 Jan 2025 16:16:56 +0100
Message-ID: <20250106151136.714988655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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



