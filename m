Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F922F0C5C;
	Mon, 22 Sep 2025 19:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570178; cv=none; b=Mm60pEgmkvdzSWzxMHNZjvdGCN99Ho608qSTWwBrtt7/uWfZOZm5cLzTH20Eob3TGu8UUS5aTrzOVAn08yNkj6VGTm1ak8bX/nV0/oO/6ZuIulgqcoPRUWTQRgNvri245C82pVP1d6mwnInfgak7joe9TO0cz4hwbwaggMOCDpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570178; c=relaxed/simple;
	bh=VVsHC8TeBgA6+DlVk4R1iuAUWs2UFOxzGBBZJ51xQ9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uREXiGQLupLP/Rf96xArSXCX2tjTBVPVkcOn9xrYABsbJaxRlThaPVGLbPwMSW6BLoxIfAWev/a+HdaAwHnkWGsM9sYG2YcQWNbXtQHrvOx140QX4FLj//lA6gfQGJcw08qi5grC+EGwEUGF0no5F4V2njcEjrMUsGumjd6G1h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7Dh1mAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7Dh1mAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6153AC4CEF0;
	Mon, 22 Sep 2025 19:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570178;
	bh=VVsHC8TeBgA6+DlVk4R1iuAUWs2UFOxzGBBZJ51xQ9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7Dh1mAqjbKSgCBpzUJePxMpJU/77eCONIu7lyT7vx0vKVMNiIM4UwZPEQWUpytv1
	 aSNQsk6SWgL/0zuqDkQ3g+ReBlO7PDOxP5Ty7gSKtUSardItf1Vp4RpftVxyg36DDn
	 lEmbkXZM5Dh2dMv8QdHt1pc/6eASgCc5MmeUYaj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Changhui Zhong <czhong@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 049/149] zram: fix slot write race condition
Date: Mon, 22 Sep 2025 21:29:09 +0200
Message-ID: <20250922192414.096023082@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit ce4be9e4307c5a60701ff6e0cafa74caffdc54ce upstream.

Parallel concurrent writes to the same zram index result in leaked
zsmalloc handles.  Schematically we can have something like this:

CPU0                              CPU1
zram_slot_lock()
zs_free(handle)
zram_slot_lock()
				zram_slot_lock()
				zs_free(handle)
				zram_slot_lock()

compress			compress
handle = zs_malloc()		handle = zs_malloc()
zram_slot_lock
zram_set_handle(handle)
zram_slot_lock
				zram_slot_lock
				zram_set_handle(handle)
				zram_slot_lock

Either CPU0 or CPU1 zsmalloc handle will leak because zs_free() is done
too early.  In fact, we need to reset zram entry right before we set its
new handle, all under the same slot lock scope.

Link: https://lkml.kernel.org/r/20250909045150.635345-1-senozhatsky@chromium.org
Fixes: 71268035f5d7 ("zram: free slot memory early during write")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Changhui Zhong <czhong@redhat.com>
Closes: https://lore.kernel.org/all/CAGVVp+UtpGoW5WEdEU7uVTtsSCjPN=ksN6EcvyypAtFDOUf30A@mail.gmail.com/
Tested-by: Changhui Zhong <czhong@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1794,6 +1794,7 @@ static int write_same_filled_page(struct
 				  u32 index)
 {
 	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_SAME);
 	zram_set_handle(zram, index, fill);
 	zram_slot_unlock(zram, index);
@@ -1831,6 +1832,7 @@ static int write_incompressible_page(str
 	kunmap_local(src);
 
 	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, PAGE_SIZE);
@@ -1854,11 +1856,6 @@ static int zram_write_page(struct zram *
 	unsigned long element;
 	bool same_filled;
 
-	/* First, free memory allocated to this slot (if any) */
-	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
-	zram_slot_unlock(zram, index);
-
 	mem = kmap_local_page(page);
 	same_filled = page_same_filled(mem, &element);
 	kunmap_local(mem);
@@ -1900,6 +1897,7 @@ static int zram_write_page(struct zram *
 	zcomp_stream_put(zstrm);
 
 	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);


