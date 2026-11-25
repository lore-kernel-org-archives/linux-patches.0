Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625278;
	b=PEmEhPpx7C7BNqP/xXAz7+pRj2b1C55RlFJIQj3HH4PJsUn7ANN4EicWPpGBrRsNLCYB
	 zRRHWJb1fb+WO8ZQISX2j+h+nbVyU37K+MQyDbkjIGNGJuKvZepyPydDCVgegYHUNUEAy
	 mhQMrkGVGpufEg/6wefi8rmPkMSFg9OJ5XD1hwHbAmhN2mJ8nX050/kPtGROEDlKcZyur
	 yDn9327XJ66TuQikqcUgk4YRqY6cbpMjBjdtOjmdtpBjju7sWdi9BU8FpbemdUmA3xdAp
	 U+7MNFnKXADocxa7jTQOEnBgnDRw1Ioax2BVDhOhjOFVK+ru0LcVWMTPMbzviyPCuKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfVo5Xd/082bod76RuGO0TuecF8qzjjxNmExD090qp4=;
	b=U6UoGPFfgPa2uM/gw7fepAjdY6S9nlj0jRnG/W66TEa7Zr/cHGxsRlHpqj9ggrFP00T+
	 O1k/vp4xDT9wViu2wSOj8NqEE6q8ngieOf2Vt52DQpVD/U+OpV8DtYSybIbnQmK3DBvnd
	 +/hOusul4gS/mJs2hi8YPPlSgIHQ7TQPRhRBkI4DlNEimaVh4e3ruAzz+PEC56uj7Ty6I
	 W3M+0NDgHWrHQUC6+NKMV1C1rdwi58R3j0cRyl+pzftwccKT8ZvEyC+r2tXguqYYXw9Sp
	 QYuOqORKLuIA7ui/F5MDaxX5W9dNCQ6jq4mYJLa2Ul1vygNNjyZidYCkzNi+6Z3JJsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5sTPBIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54210606A323;
	Wed, 25 Nov 2026 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5sTPBIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCD21F000CA;
	Wed, 25 Nov 2026 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625278;
	bh=IfVo5Xd/082bod76RuGO0TuecF8qzjjxNmExD090qp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5sTPBIrtEEObouPJUVlPoVRdrgOa4vT6H3Mf38nAG5KB3sMaTQKvXfF77mNppquU
	 kcRRTHdIqHeT10GMAVO5mI2853GIHEWlwtBwT+qUXYO+rp2QbBFRrLJBKiFZT9H8t9
	 I7NgZlm0QXYG6EXX2+dsX+QtCZJh/3HaAcxclFA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 462/816] dmaengine: ste_dma40: Recover coalesced cyclic callbacks
Date: Wed, 25 Nov 2026 15:33:30 +0100
Message-ID: <20261125143859.890342898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit db28400d92cd97005065dad230b8a5d72ab121cb ]

DMA40 has one terminal-count status bit per channel, so cyclic period
interrupts can coalesce.

Use the memory-side pointer displacement to queue the minimum observable
number of callbacks. If sampling fails, queue one callback and invalidate
the saved position; the next successful sample resynchronizes without
recounting it.

The pointer is modulo the cyclic buffer: a displacement of d periods can
mean d plus n complete iterations of the buffer. Report d, so the driver
could have missed n iterations of the buffer; DMA40 has no counter to
recover them. For an unchanged pointer, report one callback rather than
risk a spurious full-buffer burst.

This condition has not been seen in practice and is only a product of
review comments that the buffer can miss interrupts.

The preceding cyclic-residue fix ensures that every cyclic period fits in
one LLI, so each boundary corresponds to one client callback.

Fixes: 0c842b551063 ("dma40: cyclic xfer support")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-3-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 69 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 53e56b4be3fca..2c83eb05faa16 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -374,11 +374,14 @@ struct d40_lli_pool {
  * @cyclic_dma_addr: Start address of the cyclic buffer.
  * @cyclic_buf_len: Length of the cyclic buffer.
  * @cyclic_residue: Last valid cyclic residue sample.
+ * @cyclic_period_len: Length of one cyclic period.
+ * @cyclic_callback_pos: Position after the callbacks already queued.
  * @txd: DMA engine struct. Used for among other things for communication
  * during a transfer.
  * @node: List entry.
  * @is_in_client_list: true if the client owns this descriptor.
  * @cyclic: true if this is a cyclic job
+ * @cyclic_callback_pos_valid: Whether cyclic_callback_pos is reliable.
  *
  * This descriptor is used for both logical and physical transfers.
  */
@@ -395,12 +398,15 @@ struct d40_desc {
 	dma_addr_t			 cyclic_dma_addr;
 	size_t				 cyclic_buf_len;
 	size_t				 cyclic_residue;
+	size_t				 cyclic_period_len;
+	size_t				 cyclic_callback_pos;
 
 	struct dma_async_tx_descriptor	 txd;
 	struct list_head		 node;
 
 	bool				 is_in_client_list;
 	bool				 cyclic;
+	bool				 cyclic_callback_pos_valid;
 };
 
 /**
@@ -1479,6 +1485,61 @@ static bool d40_cyclic_offset(struct d40_chan *d40c, struct d40_desc *d40d,
 	return false;
 }
 
+static unsigned int d40_cyclic_periods_elapsed(struct d40_chan *d40c,
+					       struct d40_desc *d40d)
+{
+	size_t current_pos;
+	size_t delta;
+	size_t offset;
+	unsigned int periods;
+
+	if (!d40d->cyclic_period_len)
+		return 1;
+
+	if (!d40_cyclic_offset(d40c, d40d, &offset)) {
+		d40d->cyclic_callback_pos_valid = false;
+		return 1;
+	}
+
+	current_pos = rounddown(offset, d40d->cyclic_period_len);
+	if (!d40_residue(d40c) && current_pos != offset)
+		current_pos += d40d->cyclic_period_len;
+	if (current_pos == d40d->cyclic_buf_len)
+		current_pos = 0;
+
+	if (!d40d->cyclic_callback_pos_valid) {
+		/*
+		 * The previous interrupt was reported without a pointer
+		 * sample. Resynchronize without using the stale position,
+		 * which would count that callback again.
+		 */
+		d40d->cyclic_callback_pos = current_pos;
+		d40d->cyclic_callback_pos_valid = true;
+		return 1;
+	}
+
+	/*
+	 * The pointer wraps with the cyclic buffer, so its displacement is
+	 * only the minimum number of elapsed periods. Complete buffer laps
+	 * are not observable.
+	 */
+	delta = (current_pos + d40d->cyclic_buf_len -
+		 d40d->cyclic_callback_pos) % d40d->cyclic_buf_len;
+	periods = delta / d40d->cyclic_period_len;
+	if (!periods) {
+		/*
+		 * The TC status is a single latched bit. An unchanged pointer
+		 * cannot distinguish a complete lap from a repeated interrupt,
+		 * so do not amplify it into a buffer's worth of callbacks.
+		 */
+		periods = 1;
+	}
+
+	d40d->cyclic_callback_pos = current_pos;
+
+	return periods;
+}
+
 static bool d40_tx_is_linked(struct d40_chan *d40c)
 {
 	bool is_link;
@@ -1626,6 +1687,7 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 static void dma_tc_handle(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
+	unsigned int callbacks = 1;
 
 	/* Get first active entry from list */
 	d40d = d40_first_active_get(d40c);
@@ -1650,6 +1712,8 @@ static void dma_tc_handle(struct d40_chan *d40c)
 			if (d40d->lli_current == d40d->lli_len)
 				d40d->lli_current = 0;
 		}
+
+		callbacks = d40_cyclic_periods_elapsed(d40c, d40d);
 	} else {
 		d40_lcla_free_all(d40c, d40d);
 
@@ -1670,7 +1734,7 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		}
 	}
 
-	d40c->pending_tx++;
+	d40c->pending_tx += callbacks;
 	tasklet_schedule(&d40c->tasklet);
 
 }
@@ -2744,6 +2808,9 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		desc->cyclic_dma_addr = buf_addr;
 		desc->cyclic_buf_len = buf_len;
 		desc->cyclic_residue = buf_len;
+		desc->cyclic_period_len = period_len;
+		desc->cyclic_callback_pos = 0;
+		desc->cyclic_callback_pos_valid = true;
 	}
 
 	kfree(sg);
-- 
2.53.0



