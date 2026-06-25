Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB802253EE;
	Thu, 25 Jun 2026 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392987; cv=none; b=uDMO19084OxIQ78yQgDZ0DD76wwQs4aG5bQafgoUEr/SfeH7JWOwTZKx7bZ49p6kZws36Sq+81/RfcKUtke9YIr4ZkVhOHHtQbQtV0ozdvb9zm65erQeXQuFpE8nbw9+ekYsnQlOMH2LPAetnN5ohHgSNKD+7LywUpiQlZJdpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392987; c=relaxed/simple;
	bh=PJghpI4TUmaraEjGLsvue4B7CRHz2KFKR8OxjkSPgNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqN3T3UZRGdgcy8voOuQ0vHgDiRcc1Cv4jvANjfRrrvuPu86TAissNh2UjK+QD1Qm5xtvg2gfJjIjWtws02Huvi7+h5ZoldkIppdT6IjePpJmnBSgkdGITQaCNm1e6Xl8k0aWHm48mMugaqDZwLSvjLPUUVw5cHiI/E/lZkX33s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z901PDth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z901PDth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7233B1F00A3A;
	Thu, 25 Jun 2026 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392985;
	bh=eTIVKaKdnLwa3k3V6V4jMPKuL3dLCgdT4nRrhaSLRYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z901PDthXmtABG1kQrqIoZwDqJ1qmFguWIwd3Mlmmad95KqBr3pwjOOytVFHT/br1
	 n3wHeMOCN9b1qJIJWT2BIiynM4HSjFUNrN7Qgcu4+7bk5z7epBoDIyu2zAXnhINqEG
	 TEFVKOxgwexgwdpqmO1eS74n7C6DthZYWms2B1sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 07/49] firmware: samsung: acpm: Fix false timeouts and Use-After-Free in polling
Date: Thu, 25 Jun 2026 14:03:19 +0100
Message-ID: <20260625125638.563596935@linuxfoundation.org>
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

[ Upstream commit c889b146478885344a220dd468e5a08de088cbc5 ]

Sashiko identified severe races in the polling state machine [1].

In the ACPM driver's polling mode, threads waited for responses by
monitoring the globally shared 'bitmap_seqnum'. This caused false
timeouts because if a thread processed its response and freed the
sequence number, a concurrent TX thread could immediately reallocate
it before the polling thread woke up.

Additionally, the driver suffered from a cross-thread Use-After-Free
(UAF) preemption race. Previously, acpm_get_rx() cleared the sequence
number of whichever RX message it drained from the hardware queue. This
meant Thread A could globally free Thread B's sequence slot while
Thread B was asleep. A new Thread C could then steal the slot,
overwrite the buffer, and leave Thread B to wake up to corrupted state
or a timeout.

Fix this by rewriting the polling state machine:
1. Decouple polling from the global allocator by introducing a per-slot
   'completed' flag, synchronized via smp_store_release() and
   smp_load_acquire().
2. Strip acpm_get_saved_rx() out of acpm_get_rx() to make it a pure
   queue-draining function. Introduce a 'native_match' boolean argument
   which evaluates to true only if the thread natively processed its
   own sequence number during the call. This explicitly informs the
   polling loop whether it must retrieve its payload from the
   cross-thread cache.
3. Centralize the cache fallback and sequence number free (clear_bit)
   inside the polling loop. Crucially, the free operation now strictly
   targets the thread's own TX sequence number (xfer->txd[0]), rather
   than the drained RX sequence number. This enforces strict ownership:
   a thread only ever frees its own allocated sequence slot, and only
   at the exact moment it completes its poll, eliminating the UAF
   window.

Furthermore, explicitly guard the 'native_match' assignment with an
if (rx_seqnum == tx_seqnum) check, even for zero-length (no payload)
responses. While an unguarded assignment wouldn't crash (because the
cache fallback acpm_get_saved_rx() safely returns early on zero-length
transfers) doing so would "lie" to the state machine. If a thread
drained the queue and found another thread's zero-length message,
setting native_match = true would falsely convince the polling loop
that it natively handled its own response. Maintaining a rigorous state
machine requires that native_match is only set when a thread explicitly
processes its own sequence number.

Cc: stable@vger.kernel.org
Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Closes: https://sashiko.dev/#/patchset/20260429-acpm-fixes-sashiko-reports-v3-0-47cf74ab09ad%40linaro.org [1]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260505-acpm-fixes-sashiko-reports-v5-5-43b5ee7f1674@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm.c |   68 +++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 20 deletions(-)

--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -105,11 +105,14 @@ struct acpm_queue {
  * @cmd:	pointer to where the data shall be saved.
  * @n_cmd:	number of 32-bit commands.
  * @rxcnt:	expected length of the response in 32-bit words.
+ * @completed:	flag indicating if the firmware response has been fully
+ *		processed.
  */
 struct acpm_rx_data {
 	u32 *cmd;
 	size_t n_cmd;
 	size_t rxcnt;
+	bool completed;
 };
 
 #define ACPM_SEQNUM_MAX    64
@@ -204,26 +207,28 @@ static void acpm_get_saved_rx(struct acp
 
 	rx_seqnum = FIELD_GET(ACPM_PROTOCOL_SEQNUM, rx_data->cmd[0]);
 
-	if (rx_seqnum == tx_seqnum) {
+	if (rx_seqnum == tx_seqnum)
 		memcpy(xfer->rxd, rx_data->cmd, xfer->rxcnt * sizeof(*xfer->rxd));
-		clear_bit(rx_seqnum - 1, achan->bitmap_seqnum);
-	}
 }
 
 /**
  * acpm_get_rx() - get response from RX queue.
  * @achan:	ACPM channel info.
  * @xfer:	reference to the transfer to get response for.
+ * @native_match: pointer to a boolean set to true if the thread natively
+ *                processed its own sequence number during this call.
  *
  * Return: 0 on success, -errno otherwise.
  */
-static int acpm_get_rx(struct acpm_chan *achan, const struct acpm_xfer *xfer)
+static int acpm_get_rx(struct acpm_chan *achan, const struct acpm_xfer *xfer,
+		       bool *native_match)
 {
 	u32 rx_front, rx_seqnum, tx_seqnum, seqnum;
 	const void __iomem *base, *addr;
 	struct acpm_rx_data *rx_data;
 	u32 i, val, mlen;
-	bool rx_set = false;
+
+	*native_match = false;
 
 	guard(mutex)(&achan->rx_lock);
 
@@ -232,10 +237,8 @@ static int acpm_get_rx(struct acpm_chan
 
 	tx_seqnum = FIELD_GET(ACPM_PROTOCOL_SEQNUM, xfer->txd[0]);
 
-	if (i == rx_front) {
-		acpm_get_saved_rx(achan, xfer, tx_seqnum);
+	if (i == rx_front)
 		return 0;
-	}
 
 	base = achan->rx.base;
 	mlen = achan->mlen;
@@ -259,8 +262,13 @@ static int acpm_get_rx(struct acpm_chan
 		if (rx_data->rxcnt) {
 			if (rx_seqnum == tx_seqnum) {
 				__ioread32_copy(xfer->rxd, addr, xfer->rxcnt);
-				rx_set = true;
-				clear_bit(seqnum, achan->bitmap_seqnum);
+				/*
+				 * Signal completion to the polling thread.
+				 * Pairs with smp_load_acquire() in polling
+				 * loop.
+				 */
+				smp_store_release(&rx_data->completed, true);
+				*native_match = true;
 			} else {
 				/*
 				 * The RX data corresponds to another request.
@@ -270,9 +278,21 @@ static int acpm_get_rx(struct acpm_chan
 				 */
 				__ioread32_copy(rx_data->cmd, addr,
 						rx_data->rxcnt);
+				/*
+				 * Signal completion to the polling thread.
+				 * Pairs with smp_load_acquire() in polling
+				 * loop.
+				 */
+				smp_store_release(&rx_data->completed, true);
 			}
 		} else {
-			clear_bit(seqnum, achan->bitmap_seqnum);
+			/*
+			 * Signal completion to the polling thread.
+			 * Pairs with smp_load_acquire() in polling loop.
+			 */
+			smp_store_release(&rx_data->completed, true);
+			if (rx_seqnum == tx_seqnum)
+				*native_match = true;
 		}
 
 		i = (i + 1) % achan->qlen;
@@ -281,13 +301,6 @@ static int acpm_get_rx(struct acpm_chan
 	/* We saved all responses, mark RX empty. */
 	writel(rx_front, achan->rx.rear);
 
-	/*
-	 * If the response was not in this iteration of the queue, check if the
-	 * RX data was previously saved.
-	 */
-	if (!rx_set)
-		acpm_get_saved_rx(achan, xfer, tx_seqnum);
-
 	return 0;
 }
 
@@ -302,6 +315,7 @@ static int acpm_dequeue_by_polling(struc
 				   const struct acpm_xfer *xfer)
 {
 	struct device *dev = achan->acpm->dev;
+	bool native_match;
 	ktime_t timeout;
 	u32 seqnum;
 	int ret;
@@ -310,12 +324,25 @@ static int acpm_dequeue_by_polling(struc
 
 	timeout = ktime_add_us(ktime_get(), ACPM_POLL_TIMEOUT_US);
 	do {
-		ret = acpm_get_rx(achan, xfer);
+		ret = acpm_get_rx(achan, xfer, &native_match);
 		if (ret)
 			return ret;
 
-		if (!test_bit(seqnum - 1, achan->bitmap_seqnum))
+		/*
+		 * Safely check if our specific transaction has been processed.
+		 * smp_load_acquire prevents the CPU from speculatively
+		 * executing subsequent instructions before the transaction is
+		 * synchronized.
+		 */
+		if (smp_load_acquire(&achan->rx_data[seqnum - 1].completed)) {
+			/* Retrieve payload if another thread cached it for us */
+			if (!native_match)
+				acpm_get_saved_rx(achan, xfer, seqnum);
+
+			/* Relinquish ownership of the sequence slot */
+			clear_bit(seqnum - 1, achan->bitmap_seqnum);
 			return 0;
+		}
 
 		/* Determined experimentally. */
 		udelay(20);
@@ -380,6 +407,7 @@ static void acpm_prepare_xfer(struct acp
 
 	/* Clear data for upcoming responses */
 	rx_data = &achan->rx_data[achan->seqnum - 1];
+	rx_data->completed = false;
 	memset(rx_data->cmd, 0, sizeof(*rx_data->cmd) * rx_data->n_cmd);
 	/* zero means no response expected */
 	rx_data->rxcnt = xfer->rxcnt;


