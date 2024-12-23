Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767FF17A597;
	Mon, 23 Dec 2024 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970751; cv=none; b=X0wQGUQFur5MR6Q4NQGjeQ+184ddhxIIoe8eF6uPR18uOnUEEDNKorNHIPqxts+rqDLrj43tDHgLEoek8akVigHebvaaNg4KvZsy+jk6mW7Uq2CmiSCQMe0Fy0gXULZ+T33wUe0e8tQfNxWVslRlzqMRItXStkjnf8Ue/bOlBJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970751; c=relaxed/simple;
	bh=bGrEaQhdqiiIQIBgk9j6V4P/EWQBDZGNBL99afOhy1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF3XTVSxP6cvePG4bYE/ZLaOg6TrTHh3RfxhGf0fR/eDk1Y0IfuX0Ijy1YgKiH++OnBJ8JY5UBn1QXLZ4Xyw4EsX2juWFIEcNsrR++P032gv5R7wer86lgKD4hw+4UDbACMRge7xyFrDT2P9QF2Yo9kSMK5eiLYjNYv7WHu0Gag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwQ2kliW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwQ2kliW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6573C4CED3;
	Mon, 23 Dec 2024 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970751;
	bh=bGrEaQhdqiiIQIBgk9j6V4P/EWQBDZGNBL99afOhy1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwQ2kliWCTT5KSgS8eIfXYu10nDYJYQMsQvusJSMoGebUNseQiR9dh0yvT6oCcqzW
	 stvJioRt94jkk+lT9sK1BGKjRJrXOZCYsbG4zRjPBDl1FdFg8x6VfAJH9zLlUA+tPr
	 EdO0BgDimxK5FUncwPo8odktbLxpfWtupqj6LbL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 58/83] zram: fix uninitialized ZRAM not releasing backing device
Date: Mon, 23 Dec 2024 16:59:37 +0100
Message-ID: <20241223155355.874444273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1168,12 +1168,16 @@ static void zram_meta_free(struct zram *
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
@@ -1722,11 +1726,6 @@ static void zram_reset_device(struct zra
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 


