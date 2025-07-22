Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1C28BA96;
	Tue, 22 Jul 2025 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193611; cv=none; b=cvQWZ01nsKLSTKAC9J16HJJo0QCprxooNfdTeL7c3Xok9d97bv0e9FvCdOw2N3gjk1x8XoQu6FMiCNG4okad+AHisYU0tBEGIkigFsLw8eb5MtNPW1JZUc7IvtD3ncOs0lMUprOeUzUnrUE0Ih01FUQHwqvddpzNtb6sl4vUroQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193611; c=relaxed/simple;
	bh=buHslJC5sM/T+vAyoUMmYXTTWBVp+3UAGDbq5/am1K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4zAU02rkiuM37NRrxGgSrtgMcvamg0aiWSJSb6f7dm6msKJ3dDCkRz4+QgofkQLbyPZ4lm66AwwvOHR3p8Cmn/KdQGdgbb4O3y0rMb0soHDx9Lz2W/yaUyCtuu8TVyTWhtcIMN099R/g/DqitV0EZOYBeYj/gnojw5mmJWxNW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCz+7/1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCz+7/1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD92FC4CEF6;
	Tue, 22 Jul 2025 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193611;
	bh=buHslJC5sM/T+vAyoUMmYXTTWBVp+3UAGDbq5/am1K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCz+7/1c34l14vAgdo+ZfTPvJN3+aPreGd7ThOOv3EttjY+r8+a8zPZHx7CyR8YDP
	 41uttbw/wMrnGdDAtplq6yxQg7a0F0AvHNtZ4GoEAXYdbhRvb+jVC/+jBbVNHAkhSK
	 +1AzH4OMoMRbXylkbrIQU7Owx3cePlGkiCWtQ/qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 111/187] block: fix kobject leak in blk_unregister_queue
Date: Tue, 22 Jul 2025 15:44:41 +0200
Message-ID: <20250722134349.898992418@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3051247e4faa32a3d90c762a243c2c62dde310db ]

The kobject for the queue, `disk->queue_kobj`, is initialized with a
reference count of 1 via `kobject_init()` in `blk_register_queue()`.
While `kobject_del()` is called during the unregister path to remove
the kobject from sysfs, the initial reference is never released.

Add a call to `kobject_put()` in `blk_unregister_queue()` to properly
decrement the reference count and fix the leak.

Fixes: 2bd85221a625 ("block: untangle request_queue refcounting from sysfs")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250711083009.2574432-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1f9b45b0b9ee7..12a5059089a2f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -964,4 +964,5 @@ void blk_unregister_queue(struct gendisk *disk)
 	kobject_del(&disk->queue_kobj);
 
 	blk_debugfs_remove(disk);
+	kobject_put(&disk->queue_kobj);
 }
-- 
2.39.5



