Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018706;
	b=MhfzpcFHOdEF5QdypGKoawkSKzd8K0diirfpSm1gBRFecc47DMPAhYkmLDhB+rsCm/Yv
	 7rm930KGMen1g5M/vD9KOadqfCkclyj5Jj9xYVV5fcAz0S/h0JS9fiVreCiHaW7s2YkmV
	 NUFG6HEl5hDFuMspohT3uPQ2nq9+EWJfRyRvpBJ9bNaA0he65XryyPA47c4L7MeZ6GvSx
	 FsOH2JF2J+AH4YvX7n+Wv4afd6dZTeeYuwxP3V74G28jfjlyg7bUFD8N46/7L+uhgy3FT
	 WNUwzBEr71ymvna0Iw+6xmAGo0Ethv4SP2C6nfS5qsJw0wxX8eYWnWIc+GUtTgWJf9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gic0ICne5snvgOd1kSpg3ExPMMmWSDoEF7J5PF+ulWU=;
	b=rDoaDLe4O07+FBKz55m2UW69GRGfelJMbeVA5X0n9bIsDwnhr+SXnjj/LU5eBEjN95UP
	 gOC7Bc6YksXMVDVh9orIE4zmS8e1En7iimcbrr7W6LIBAntwZJX1QkILZxqK5XD9TxhHT
	 3i4gT5IeFFfgREcTdmjDPXbxzpd9JpnzTyUNGoIR/ZSyFPC9ftbY7cuIdRPnVy9+Etv9W
	 ZOY642NTOtPvisnPcAN2JbLIjSv5cexZAiQYSuQmUwHagkTvxhJFm+UQ09EAanmB1NJ21
	 lhaX2J120Xn0WPF+5awZKHnl+NvwPR4XVqQRzxpMBRppUi+s7nT4UbOxhvUielUYDww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdVBU1gm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE39606A325;
	Wed, 18 Nov 2026 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdVBU1gm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A801F000C4;
	Wed, 18 Nov 2026 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018706;
	bh=Gic0ICne5snvgOd1kSpg3ExPMMmWSDoEF7J5PF+ulWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdVBU1gm3AZ2mXJqrGRFTWZJQIh4Ch51fYu/b5j8VkSJsa3rcRqhN9sgcHTfkhddP
	 h6/UlUQQqEgHpjEQ3zKpyQ15xeS8hdTAPpgNmc8EB9RxjzTra/MDOlxzQSFNcOFTjw
	 Z2x/W68ethR9Ww5P0e6SYmBQIo7IN079od1R0/Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1334/2651] dmaengine: ste_dma40: Recover coalesced cyclic callbacks
Date: Wed, 18 Nov 2026 15:42:54 +0100
Message-ID: <20261118150336.035385215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index eab9c09b4bfec..4b138aa313c83 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -384,11 +384,14 @@ struct d40_lli_pool {
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
@@ -405,12 +408,15 @@ struct d40_desc {
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
@@ -1487,6 +1493,61 @@ static bool d40_cyclic_offset(struct d40_chan *d40c, struct d40_desc *d40d,
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
@@ -1609,6 +1670,7 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 static void dma_tc_handle(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
+	unsigned int callbacks = 1;
 
 	/* Get first active entry from list */
 	d40d = d40_first_active_get(d40c);
@@ -1633,6 +1695,8 @@ static void dma_tc_handle(struct d40_chan *d40c)
 			if (d40d->lli_current == d40d->lli_len)
 				d40d->lli_current = 0;
 		}
+
+		callbacks = d40_cyclic_periods_elapsed(d40c, d40d);
 	} else {
 		d40_lcla_free_all(d40c, d40d);
 
@@ -1653,7 +1717,7 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		d40_desc_done(d40c, d40d);
 	}
 
-	d40c->pending_tx++;
+	d40c->pending_tx += callbacks;
 	tasklet_schedule(&d40c->tasklet);
 
 }
@@ -2638,6 +2702,9 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
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



