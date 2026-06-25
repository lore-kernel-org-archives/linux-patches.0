Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2128725B;
	Thu, 25 Jun 2026 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392990; cv=none; b=uMw0/4+vmf1N9V113s6HtWzcZHtsOM/mNvuPF5gYj+UzMSz4yRXJWBF6sDuYihE6+qGX5roJgZPcd+HJ+/TniZ9aqzYNN7kSI5dPfbFuL7JOBo15j8MH7iqlCvJM2C8xNJBdsCtTpCSRWvcpSTNEMcOWpN0NlpiqPC0bRBZrZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392990; c=relaxed/simple;
	bh=CCzr2q16ugTwMFT8cBvTX+ZskySFXk3pet82iNM6Bqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVWoVdKaxTTevOQEQJ4qCfrk6Lg6FN1oHNDAgWYIQLwcVlJ0B9tdcww4dfI6h4zfeDkLbbjUJE7b4QkgucpOYAwNbMSGhk70pyFCIut5lRFjIK0qXSc2/7zIn1xewJ4NjEHlz/TuOa5bj8qOGO6wFZ5Zj7fI+iEm6AHO+vpTGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJpqoN8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJpqoN8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1B61F000E9;
	Thu, 25 Jun 2026 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392988;
	bh=Abl3kA5/dX5N4FznMx6xCKGJK39bsmfjhzSz3qZfuow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJpqoN8ZEYHlIl2KiYLXicsgMWfvvi0dLGDnAKwjGdiTzH3EGOu7hEmj/dKu6WF4C
	 /RSIZjW803m42ur6b+LMQCr5/PmwpZUG+I0sg84lhAYv7nMOODj8etaSZSS9NUEEis
	 pMoZjZXqA8FzNVH7bfp4k0rBiRHAKf6zgBZNifSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 08/49] firmware: samsung: acpm: Fix missing LKMM barriers in sequence allocator
Date: Thu, 25 Jun 2026 14:03:20 +0100
Message-ID: <20260625125638.666531247@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit bf296f83a3ddab1ab875edc4e8862cb10553064f ]

Sashiko identified memory ordering races in [1].

The ACPM driver uses a globally shared 'bitmap_seqnum' to track
available sequence numbers. Even though threads now strictly free their
own sequence numbers, the allocation and freeing of these bits across
concurrent threads are effectively lockless operations and require
explicit LKMM memory barriers.

Previously, the driver used plain bitwise operators (test_bit, set_bit,
clear_bit), which lack ordering guarantees. This creates two race
conditions on weakly ordered architectures like ARM64:

1. Polling Release Violation: The polling thread copies its payload and
   calls clear_bit(). Without a release barrier, the CPU can reorder
   the memory operations, making the cleared bit globally visible
   before the payload reads have fully completed.
2. TX Acquire Violation: The TX thread loops on test_bit(), calls
   set_bit(), and then wipes the payload buffer via memset(). Without
   an acquire barrier, the CPU can speculatively execute the memset()
   before the bit is safely and formally claimed.

If these reorderings overlap, a new TX thread can claim the sequence
number and overwrite the buffer while the original polling thread is
still actively reading from it.

Fix this by upgrading the bitwise operators. Wrap the TX allocation in
test_and_set_bit_lock() to establish formal LKMM Acquire semantics, and
pair it with clear_bit_unlock() in the polling path to enforce Release
semantics.

Cc: stable@vger.kernel.org
Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Closes: https://sashiko.dev/#/patchset/20260423-acpm-fixes-sashiko-reports-v1-0-2217b790925e%40linaro.org [1]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260505-acpm-fixes-sashiko-reports-v5-6-43b5ee7f1674@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -7,7 +7,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bitmap.h>
-#include <linux/bits.h>
+#include <linux/bitops.h>
 #include <linux/cleanup.h>
 #include <linux/container_of.h>
 #include <linux/delay.h>
@@ -340,7 +340,7 @@ static int acpm_dequeue_by_polling(struc
 				acpm_get_saved_rx(achan, xfer, seqnum);
 
 			/* Relinquish ownership of the sequence slot */
-			clear_bit(seqnum - 1, achan->bitmap_seqnum);
+			clear_bit_unlock(seqnum - 1, achan->bitmap_seqnum);
 			return 0;
 		}
 
@@ -397,11 +397,18 @@ static void acpm_prepare_xfer(struct acp
 	struct acpm_rx_data *rx_data;
 	u32 *txd = (u32 *)xfer->txd;
 
-	/* Prevent chan->seqnum from being re-used */
+	/*
+	 * Prevent chan->seqnum from being re-used.
+	 * test_and_set_bit_lock() provides formal LKMM Acquire semantics.
+	 * It pairs with the RX thread's clear_bit_unlock() to ensure the CPU
+	 * does not speculatively execute the rx_data buffer wipe (memset)
+	 * before the sequence number is safely claimed.
+	 */
 	do {
 		if (++achan->seqnum == ACPM_SEQNUM_MAX)
 			achan->seqnum = 1;
-	} while (test_bit(achan->seqnum - 1, achan->bitmap_seqnum));
+		/* Flag the index based on seqnum. (seqnum: 1~63, bitmap: 0~62) */
+	} while (test_and_set_bit_lock(achan->seqnum - 1, achan->bitmap_seqnum));
 
 	txd[0] |= FIELD_PREP(ACPM_PROTOCOL_SEQNUM, achan->seqnum);
 
@@ -411,9 +418,6 @@ static void acpm_prepare_xfer(struct acp
 	memset(rx_data->cmd, 0, sizeof(*rx_data->cmd) * rx_data->n_cmd);
 	/* zero means no response expected */
 	rx_data->rxcnt = xfer->rxcnt;
-
-	/* Flag the index based on seqnum. (seqnum: 1~63, bitmap: 0~62) */
-	set_bit(achan->seqnum - 1, achan->bitmap_seqnum);
 }
 
 /**


