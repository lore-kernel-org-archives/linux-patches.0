Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476B83DD519;
	Mon,  4 May 2026 13:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902863; cv=none; b=B0thlKsEBrsQ0J4wetYYPrPpTxVNOkW/yiiAK/gHN4FqMp/K4c2XJ3AAX9w5HpA4fYVAwmj0v5y74Vgf5RgNTFh2cYI0IYHtrmEoNsTWtdKJv47XlUDqBY42FIUZHp7J31ryhlJE+8tcPE0/TkxpU6S//LRIeKIUvg3Ebe458pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902863; c=relaxed/simple;
	bh=jVIVqYJQWXh9n2tWFZEAbSapcDvvLUEc2db1E0zPyEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HE08e1hDb8/jE/PnZfymNFqpmSZwl1XUud70PXgKkcYuCrE6RMJj+hyqMQp9fj8d8AEfLVTxIbRGPGhB3msBbRTDYgBKjMC4DOy6kZD2f86Hwsqj6tBjpiolaCf+QXu26i0AIP8Qj5i7dx+a6CyRGEPYgkBd4xSiFDwjkMsvbUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/MWuRmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/MWuRmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD1AC2BCB8;
	Mon,  4 May 2026 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902862;
	bh=jVIVqYJQWXh9n2tWFZEAbSapcDvvLUEc2db1E0zPyEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/MWuRmOgKAeMew3Zq5aQkBHmJ2NJT2CPo0EnHkDMPscwl/M4Rbq6FKypVoRCmkfm
	 /hXJtkxvpPnM+AbhYkdChztrOeF1QA0EXE1vi9kpgkyH7quVHJ7tV8Nfhx/HZcXsv7
	 H/Za0ZGxgIGDgnfWR1Dr2ezuN+7VqeYynRecA+KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ayush Singh <ayushdevel1325@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Alex Elder <elder@kernel.org>,
	Weigang He <geoffreyhe2@gmail.com>
Subject: [PATCH 7.0 012/307] greybus: gb-beagleplay: fix sleep in atomic context in hdlc_tx_frames()
Date: Mon,  4 May 2026 15:48:17 +0200
Message-ID: <20260504135143.289213342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

commit 6b526dca0966f2370835765019a54319b78fca8d upstream.

hdlc_append() calls usleep_range() to wait for circular buffer space,
but it is called with tx_producer_lock (a spinlock) held via
hdlc_tx_frames() -> hdlc_append_tx_frame()/hdlc_append_tx_u8()/etc.
Sleeping while holding a spinlock is illegal and can trigger
"BUG: scheduling while atomic".

Fix this by moving the buffer-space wait out of hdlc_append() and into
hdlc_tx_frames(), before the spinlock is acquired.  The new flow:

 1. Pre-calculate the worst-case encoded frame length.
 2. Wait (with sleep) outside the lock until enough space is available,
    kicking the TX consumer work to drain the buffer.
 3. Acquire the spinlock, re-verify space, and write the entire frame
    atomically.

This ensures that sleeping only happens without any lock held, and
that frames are either fully enqueued or not written at all.

This bug is found by CodeQL static analysis tool (interprocedural
sleep-in-atomic query) and my code review.

Fixes: ec558bbfea67 ("greybus: Add BeaglePlay Linux Driver")
Cc: stable <stable@kernel.org>
Cc: Ayush Singh <ayushdevel1325@gmail.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Link: https://patch.msgid.link/20260330120801.981506-1-geoffreyhe2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/greybus/gb-beagleplay.c |  107 +++++++++++++++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 17 deletions(-)

--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -242,30 +242,26 @@ static void hdlc_write(struct gb_beaglep
 }
 
 /**
- * hdlc_append() - Queue HDLC data for sending.
+ * hdlc_append() - Queue a single HDLC byte for sending.
  * @bg: beagleplay greybus driver
  * @value: hdlc byte to transmit
  *
- * Assumes that producer lock as been acquired.
+ * Caller must hold tx_producer_lock and must have ensured sufficient
+ * space in the circular buffer before calling (see hdlc_tx_frames()).
  */
 static void hdlc_append(struct gb_beagleplay *bg, u8 value)
 {
-	int tail, head = bg->tx_circ_buf.head;
+	int head = bg->tx_circ_buf.head;
+	int tail = READ_ONCE(bg->tx_circ_buf.tail);
 
-	while (true) {
-		tail = READ_ONCE(bg->tx_circ_buf.tail);
-
-		if (CIRC_SPACE(head, tail, TX_CIRC_BUF_SIZE) >= 1) {
-			bg->tx_circ_buf.buf[head] = value;
-
-			/* Finish producing HDLC byte */
-			smp_store_release(&bg->tx_circ_buf.head,
-					  (head + 1) & (TX_CIRC_BUF_SIZE - 1));
-			return;
-		}
-		dev_warn(&bg->sd->dev, "Tx circ buf full");
-		usleep_range(3000, 5000);
-	}
+	lockdep_assert_held(&bg->tx_producer_lock);
+	if (WARN_ON_ONCE(CIRC_SPACE(head, tail, TX_CIRC_BUF_SIZE) < 1))
+		return;
+
+	bg->tx_circ_buf.buf[head] = value;
+	/* Ensure buffer write is visible before advancing head. */
+	smp_store_release(&bg->tx_circ_buf.head,
+			  (head + 1) & (TX_CIRC_BUF_SIZE - 1));
 }
 
 static void hdlc_append_escaped(struct gb_beagleplay *bg, u8 value)
@@ -313,13 +309,90 @@ static void hdlc_transmit(struct work_st
 	spin_unlock_bh(&bg->tx_consumer_lock);
 }
 
+/**
+ * hdlc_encoded_length() - Calculate worst-case encoded length of an HDLC frame.
+ * @payloads: array of payload buffers
+ * @count: number of payloads
+ *
+ * Returns the maximum number of bytes needed in the circular buffer.
+ */
+static size_t hdlc_encoded_length(const struct hdlc_payload payloads[],
+				  size_t count)
+{
+	size_t i, payload_len = 0;
+
+	for (i = 0; i < count; i++)
+		payload_len += payloads[i].len;
+
+	/*
+	 * Worst case: every data byte needs escaping (doubles in size).
+	 * data bytes = address(1) + control(1) + payload + crc(2)
+	 * framing    = opening flag(1) + closing flag(1)
+	 */
+	return 2 + (1 + 1 + payload_len + 2) * 2;
+}
+
+#define HDLC_TX_BUF_WAIT_RETRIES	500
+#define HDLC_TX_BUF_WAIT_US_MIN	3000
+#define HDLC_TX_BUF_WAIT_US_MAX	5000
+
+/**
+ * hdlc_tx_frames() - Encode and queue an HDLC frame for transmission.
+ * @bg: beagleplay greybus driver
+ * @address: HDLC address field
+ * @control: HDLC control field
+ * @payloads: array of payload buffers
+ * @count: number of payloads
+ *
+ * Sleeps outside the spinlock until enough circular-buffer space is
+ * available, then verifies space under the lock and writes the entire
+ * frame atomically.  Either a complete frame is enqueued or nothing is
+ * written, avoiding both sleeping in atomic context and partial frames.
+ */
 static void hdlc_tx_frames(struct gb_beagleplay *bg, u8 address, u8 control,
 			   const struct hdlc_payload payloads[], size_t count)
 {
+	size_t needed = hdlc_encoded_length(payloads, count);
+	int retries = HDLC_TX_BUF_WAIT_RETRIES;
 	size_t i;
+	int head, tail;
+
+	/* Wait outside the lock for sufficient buffer space. */
+	while (retries--) {
+		/* Pairs with smp_store_release() in hdlc_append(). */
+		head = smp_load_acquire(&bg->tx_circ_buf.head);
+		tail = READ_ONCE(bg->tx_circ_buf.tail);
+
+		if (CIRC_SPACE(head, tail, TX_CIRC_BUF_SIZE) >= needed)
+			break;
+
+		/* Kick the consumer and sleep — no lock held. */
+		schedule_work(&bg->tx_work);
+		usleep_range(HDLC_TX_BUF_WAIT_US_MIN, HDLC_TX_BUF_WAIT_US_MAX);
+	}
+
+	if (retries < 0) {
+		dev_warn_ratelimited(&bg->sd->dev,
+				     "Tx circ buf full, dropping frame\n");
+		return;
+	}
 
 	spin_lock(&bg->tx_producer_lock);
 
+	/*
+	 * Re-check under the lock.  Should not fail since
+	 * tx_producer_lock serialises all producers and the
+	 * consumer only frees space, but guard against it.
+	 */
+	head = bg->tx_circ_buf.head;
+	tail = READ_ONCE(bg->tx_circ_buf.tail);
+	if (unlikely(CIRC_SPACE(head, tail, TX_CIRC_BUF_SIZE) < needed)) {
+		spin_unlock(&bg->tx_producer_lock);
+		dev_warn_ratelimited(&bg->sd->dev,
+				     "Tx circ buf space lost, dropping frame\n");
+		return;
+	}
+
 	hdlc_append_tx_frame(bg);
 	hdlc_append_tx_u8(bg, address);
 	hdlc_append_tx_u8(bg, control);


