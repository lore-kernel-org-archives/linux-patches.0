Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF372E1724;
	Tue, 22 Jul 2025 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192900; cv=none; b=h/kWzOJrk39fYO57ijmJJ2QVPhgoyFcAz5Lp7zrjYZlC7zbS1Xk6B8B24n27RDvCdGBzYZY8ZFortudBCOUT8WECQ0GDdnKLZdhCxRYf/QK3o0+56agkPYQztmScZ1etnBN928+WyqPspWwkq9/FhC4JoZS3Jr3Qp7xCl5CWEvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192900; c=relaxed/simple;
	bh=wLznOGphXXB6l1E6KjSr3COvjX6dLEvwH+bogHgDtik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwmTMwvyUgE3lTLmmDdUuaVj6toeGV3heesRENSG4UwlM7ONxLDQE4W2LUV4u7kXm/kpXaibYOc+UFFku0fKWqqrD9FpZGE0BKIX7s0w8nNAjsfIc9T3nmIZnMm5GMDh6yKvASG3Lfxqi1jzy26XzzGi7/nxKE6oHaiuf4gVtO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Np3hb+qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Np3hb+qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55C6C4CEEB;
	Tue, 22 Jul 2025 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192900;
	bh=wLznOGphXXB6l1E6KjSr3COvjX6dLEvwH+bogHgDtik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Np3hb+qeMBXjF8xl/XnlSNTx2vAFNR9AU+Q8FVwtL/r2LcihIntOVb0OHOXlKTnGd
	 P/AHta8lfJj/DM+GOZc0tm7GusDtUpnEd4M/1Lr3RUJSMJvM1wouo6Stm3DRg//urG
	 U4EmwZKfsh9ClbP6PgGpOZ42eKjAphsA7t9W5R38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/158] block: fix kobject leak in blk_unregister_queue
Date: Tue, 22 Jul 2025 15:44:35 +0200
Message-ID: <20250722134344.154607545@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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
index 0e2520d929e1d..6a38f312e385c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -868,4 +868,5 @@ void blk_unregister_queue(struct gendisk *disk)
 	mutex_unlock(&q->sysfs_dir_lock);
 
 	blk_debugfs_remove(disk);
+	kobject_put(&disk->queue_kobj);
 }
-- 
2.39.5



