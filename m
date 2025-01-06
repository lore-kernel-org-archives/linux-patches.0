Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572BD153814;
	Mon,  6 Jan 2025 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178856; cv=none; b=ViTjLrwx4vkrdKIRbvaHfY+m2+BNfUjSMqwfUqE9OLumZKd+p6HGLhtOFyvLq2NlLGLJewUffLtR+yqPxQwJx4cP8L0H0Q0/nShrhfMb2hMWo52H+pqV9QJ1+5xxHx7yrsbqFdAPiG/aboZZVZxIJZQdzHKKGznAtYb+Z86RGtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178856; c=relaxed/simple;
	bh=KCx1SQJsZL2xspaI2COlHTheMrR9JQfhCGxJKsRf3Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9Qmw6pQGfrzDV0IAs/I4dwKZ3W6/9r6cvM/8LjxsB70CzIyQV9OnO8729PwfC/TFkomF75pEl0X96t/DvUzT4AuVxDEHhjbaRVVJqE01k/Cqxwds2sn6us6aIriXuJE9OnCqrbbkkmW/1BfetGuMtkHvoVhWNDGVED5oQxYUK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iExLrjaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iExLrjaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4D0C4CED2;
	Mon,  6 Jan 2025 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178856;
	bh=KCx1SQJsZL2xspaI2COlHTheMrR9JQfhCGxJKsRf3Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iExLrjaOpp26q1hzqZzZ7PaUBET5/572Ml0fx8wLEalv+NUNTDVm7JoAM3At181Wr
	 bqxq06V8fL6uvHW3bnY+blIS3Q/EJPrGW5QAF9dNHRiFMpVRyrcgeFgucZP3dycDSt
	 R2BLWXXBhVobBRZqZGz8l4k/gFW8ba8vWlYpYMS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/168] zram: fix uninitialized ZRAM not releasing backing device
Date: Mon,  6 Jan 2025 16:17:04 +0100
Message-ID: <20250106151142.833223628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

[ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]

Setting backing device is done before ZRAM initialization.  If we set the
backing device, then remove the ZRAM module without initializing the
device, the backing device reference will be leaked and the device will be
hold forever.

Fix this by always reset the ZRAM fully on rmmod or reset store.

Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9eed579d02f0..02efa0ca242a 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1150,12 +1150,16 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 	size_t num_pages = disksize >> PAGE_SHIFT;
 	size_t index;
 
+	if (!zram->table)
+		return;
+
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
 		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
+	zram->table = NULL;
 }
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
@@ -1699,11 +1703,6 @@ static void zram_reset_device(struct zram *zram)
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
-- 
2.39.5



