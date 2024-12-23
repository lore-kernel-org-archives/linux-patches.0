Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFD37E0FF;
	Mon, 23 Dec 2024 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970447; cv=none; b=H7f5WVzecPn7MclB0CVUwzlatsTwACpYoF4JqpnhWaToLw/83rhJNs+ud0dJA42jrSa8ALLUBUV8mSjsthf7M7TWxo3nhO65lWgAr+hAV8GSu5du2mlbkUsvE0nT33bQOxcI1LnhSvH/InjI3j+09LqL8j+hUrYtVLMCOx8JbiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970447; c=relaxed/simple;
	bh=Jx9KXYHw6VM2LGFQR6Lhndi20AA3B4fh1D3by7l4wj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COcY9oQwEICuRYnDffCT1SGsSVhnfbbFotqzU731909512o/X1m2WeED7ErpYWBvaYhsk9cRnJL+yc3AwqXatyrbX6cLyAKMMUv2CRq8sjvwjFifEOXAEsTm9rPHTvir7DPLkyoOLe8S3tAqsjPwsu+lK854855+2Xz9hLgaM/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYZpftnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYZpftnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242CDC4CED3;
	Mon, 23 Dec 2024 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970447;
	bh=Jx9KXYHw6VM2LGFQR6Lhndi20AA3B4fh1D3by7l4wj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYZpftnN+ZSrbiM4Y/GwfFLw9CmMRXKo7/YdJcaGy8J6LJtwxqohq2oJxov47tgjy
	 Lr8NlX2N5rGKXjp1hFpuou8QTEERX4xuXLugz3tr9P7rfyR665J7wklo7+W19+NuiT
	 YoUGaS9CKrbmBSF1bbTV2QdsXqIbZXpesjG8N9uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 086/116] zram: fix uninitialized ZRAM not releasing backing device
Date: Mon, 23 Dec 2024 16:59:16 +0100
Message-ID: <20241223155402.907380237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit 74363ec674cb172d8856de25776c8f3103f05e2f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1238,12 +1238,16 @@ static void zram_meta_free(struct zram *
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
@@ -2023,11 +2027,6 @@ static void zram_reset_device(struct zra
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 


