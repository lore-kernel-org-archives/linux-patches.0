Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA65275AFD;
	Wed,  9 Sep 2026 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961701; cv=none; b=H1f8o2Ki9CcA1GpTxZbaNqxvAWpKsbRfVhRRjBsqOyGwCdlDspQqtOrhrXMU5H6aAmKpfAKt10t7oD/CPVutdec07LIRNzZpkzy2Upfig++r+IcnrhEyHMVtsdUZTW/l3esytJVAzsZkX4RCHPlw/nIdqpP1y9iBHCtun3kJSlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961701; c=relaxed/simple;
	bh=bacqDqUiL9MabGAZ5LddywZBfJUaQccfBJlh51cQoLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhrjp1bnay6V647fOiLOWJI1MH5d0KyqU1rvsTuaFJZDgTE5E4FxME3uckbPx2TnIOYUiUyRfriy4e9kQq4luJomGTXCuUbdxohDkECovVx4up5NVpF/ESZbHAqWfWv/Bk5nv+wwmyNuD4Mqc++qWm2s41BfUMNTeEUOhun26sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMKm1UbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMKm1UbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750211F00A3A;
	Wed,  9 Sep 2026 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961700;
	bh=YJXyqa/3//9ypWbDr4qXVO7AwIjL8CN8vLWsJvl9tOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMKm1UbKcYevPqTi5uUbSX2nwSfh+0EJs/xL0CTKMozVpxCE7eXXNoi7h236jTps/
	 t7RA6FxLR2kyy56OXDXCZYQW5kMKCzZVRTRoryGTTOlqtLbl8g2Uyg2hVqWly+hp1W
	 GdqbT2K3bA88YSgjjZrotoG8eAt6/gn1M46CSt6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 008/556] zram: fix slot lock bit position on big-endian 64-bit
Date: Wed,  9 Sep 2026 15:34:48 +0200
Message-ID: <20260909134230.756962550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit a8b5875741d416703e19ad8eeac6fce8a12bd6e4 ]

The slot lock is a bit operation on the whole __lock word, which flags and
ac_time alias as two u32s.  On little-endian the lock bit lands in the
position ZRAM_ENTRY_LOCK reserves in flags, so the aliasing works out.  On
64-bit big-endian it lands in ac_time instead: with
ZRAM_TRACK_ENTRY_ACTIME enabled, storing the access time from
mark_slot_accessed() or slot_free() wipes out the held lock bit, letting
another CPU take the same slot lock; an access time value with that bit
set makes the slot look locked forever.

Shift the lock bit into the flags half of the word on big-endian 64-bit.

Link: https://lore.kernel.org/20260810202241.2436603-1-devnexen@gmail.com
Fixes: 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    6 +++---
 drivers/block/zram/zram_drv.h |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -81,7 +81,7 @@ static __must_check bool slot_trylock(st
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
+	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK_BIT, lock)) {
 		mutex_acquire(&zram->table_lock_map, 0, 1, _RET_IP_);
 		lock_acquired(&zram->table_lock_map, _RET_IP_);
 		return true;
@@ -95,7 +95,7 @@ static void slot_lock(struct zram *zram,
 	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_acquire(&zram->table_lock_map, 0, 0, _RET_IP_);
-	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK_BIT, TASK_UNINTERRUPTIBLE);
 	lock_acquired(&zram->table_lock_map, _RET_IP_);
 }
 
@@ -104,7 +104,7 @@ static void slot_unlock(struct zram *zra
 	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_release(&zram->table_lock_map, _RET_IP_);
-	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
+	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK_BIT, lock);
 }
 
 static inline bool init_done(struct zram *zram)
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -15,6 +15,7 @@
 #ifndef _ZRAM_DRV_H_
 #define _ZRAM_DRV_H_
 
+#include <asm/byteorder.h>
 #include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
 
@@ -58,6 +59,19 @@ enum zram_pageflags {
 };
 
 /*
+ * The slot lock is a bit-wait lock on the whole __lock word, while
+ * flags and ac_time alias that word as two u32s.  The lock bit must
+ * land in the slot that ZRAM_ENTRY_LOCK reserves in attr.flags; on
+ * 64-bit big-endian the flags word maps to the upper half of __lock,
+ * so the bit position has to be shifted up.
+ */
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+#define ZRAM_ENTRY_LOCK_BIT  (ZRAM_ENTRY_LOCK + 32)
+#else
+#define ZRAM_ENTRY_LOCK_BIT  ZRAM_ENTRY_LOCK
+#endif
+
+/*
  * Allocated for each disk page.  We use bit-lock (ZRAM_ENTRY_LOCK bit
  * of flags) to save memory.  There can be plenty of entries and standard
  * locking primitives (e.g. mutex) will significantly increase sizeof()


