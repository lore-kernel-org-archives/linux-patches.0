Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622537;
	b=SwjEy9VO5Vq6ISlcjpVQbqCR3rfNKBZMFzrQ1D9uNokfcXxmmUw+0siF8DCeHaCLSwdD
	 u4aji9OzemRsViFBWWyrgaDKZr7EGv7XDcaKfW2J+6JtmlkftcFxz5M9sq+Tl/j6iuRvV
	 CIiuuLKYXFEImuX33dJo5MKxD9hG0AQ61EHu4oK/xBRoqpQOm/7mXMXxhhAfXJuPXWZAw
	 fjRz3ntVctnPZWzDBt2dxuktoCnhOnD3jMsC6o3AG4dMDUJMN4tV0+vsicJ3bDUI9Dggi
	 4I1Hs4VVsE0CT+bGLNULJwpL1GSQyp0w06gUoB941coBqad5PjTs7M3hyqtNDBfncsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wcEjgybxrUntnTtcLsfpIgN4ZhjY1e+lOo7NfRErlk=;
	b=rF9WZtHkBSjPkSQSrcMkJwnzNDVK4UuYEhIVvgL7atKidS7PPF33IW8ri4PYr+fMqGCC
	 OWDi3gATO6etG1nBh4BXV8/slzvrSkCFwd83dLvRaGXJMTOsaXjH7z9uyd3xlmKoys3sb
	 B4cgcEKFXdYD4yrQUTwTz613RFbk6AE/22ChMdS6XPzQhFuz9Y9DklZc9zNePh+Ut/JFn
	 pdvXXVnFXGI36qaZikSpLBPEmmFG02O8r2zeQ4bctc4zpwJ51BG17bZ7uITuS8S6CG355
	 ko/g9hL6XLzKCy5/4oghDnSxLKedztji1ZP922n22e3l9RyynWudcRNC7iqHMgg4orA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeqkRo3p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5489C606A31E;
	Wed, 25 Nov 2026 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeqkRo3p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED051F000C6;
	Wed, 25 Nov 2026 16:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622537;
	bh=9wcEjgybxrUntnTtcLsfpIgN4ZhjY1e+lOo7NfRErlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeqkRo3ph0Ljk+oytg1OzVbU08NOhwK3CvIyI3BzGoByWfSfFTtUIglCi9ugv3YSo
	 z5SP2+BznhrJPfhOH9WoW9ix9DFvqNzq3znEQf8eC6cBr1Qrqn7S2K2UzTea0IrcbX
	 YMG2BTwJtYhdeGNIGBwV38MpHbR2OfB1sw12NBoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.li@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 569/990] dmaengine: ste_dma40: Fix cyclic transfer residue
Date: Wed, 25 Nov 2026 15:32:16 +0100
Message-ID: <20261125143835.424041129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit c80edceff29ee212987c2d2c851b2cb2eb4b477a ]

DMA40 reads residue from the element count of the currently active LLI.
For a cyclic transfer this reports at most one period, not the bytes
remaining until the cyclic buffer wraps.

Once DMA40 advertises burst granularity, DMAengine PCM uses this residue
directly. For a four-period PCM buffer it consequently reports the
hardware pointer near three periods after every period interrupt. ALSA
eventually stops playback with -EIO although DMA period callbacks
continue.

Calculate cyclic residue from the current memory-side hardware pointer
instead. Read the destination pointer for capture and the source pointer
for playback. Sample the split logical channel pointer coherently and
retain the last valid residue during relink transitions.

Make at most three residue sampling attempts: one initial read plus two
retries. The retries let transient split-register updates or LLI relink
windows settle, while the limit prevents unbounded polling if hardware does
not yield a valid pointer.

This avoids counting terminal-count interrupts, which races with hardware
advancing to the next LLI and cannot account for coalesced interrupt
status. Also reject cyclic periods that expand into multiple LLIs because
logical cyclic LLIs each request a terminal-count interrupt and would
generate more than one callback per period.

Reject invalid cyclic geometries before dividing or constructing the
scatterlist as well.

Reported-by: Frank Li <Frank.li@oss.nxp.com>
Closes: https://lore.kernel.org/dmaengine/aq2wIPJW6viUxyy9@SMW015318/
Fixes: 15c606686541 ("dmaengine: ste_dma40: indicate granularity on channels")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-2-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ sashal: Replaced the kzalloc_objs() allocation call with kcalloc() for the scatterlist in dma40_prep_dma_cyclic(), since the newer helper is missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 106 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 101 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 21469034495d7..53e56b4be3fca 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -69,6 +69,9 @@ struct stedma40_platform_data {
 /* Maximum iterations taken before giving up suspending a channel */
 #define D40_SUSPEND_MAX_IT 500
 
+/* Maximum attempts to sample a stable cyclic residue position */
+#define D40_RESIDUE_MAX_ATTEMPTS 3
+
 /* Milliseconds */
 #define DMA40_AUTOSUSPEND_DELAY	100
 
@@ -368,6 +371,9 @@ struct d40_lli_pool {
  * @lli_len: Number of llis of current descriptor.
  * @lli_current: Number of transferred llis.
  * @lcla_alloc: Number of LCLA entries allocated.
+ * @cyclic_dma_addr: Start address of the cyclic buffer.
+ * @cyclic_buf_len: Length of the cyclic buffer.
+ * @cyclic_residue: Last valid cyclic residue sample.
  * @txd: DMA engine struct. Used for among other things for communication
  * during a transfer.
  * @node: List entry.
@@ -386,6 +392,9 @@ struct d40_desc {
 	int				 lli_len;
 	int				 lli_current;
 	int				 lcla_alloc;
+	dma_addr_t			 cyclic_dma_addr;
+	size_t				 cyclic_buf_len;
+	size_t				 cyclic_residue;
 
 	struct dma_async_tx_descriptor	 txd;
 	struct list_head		 node;
@@ -1412,6 +1421,64 @@ static u32 d40_residue(struct d40_chan *d40c)
 	return num_elt * d40c->dma_cfg.dst_info.data_width;
 }
 
+static bool d40_current_addr(struct d40_chan *d40c, dma_addr_t *addr)
+{
+	bool dst = d40c->dma_cfg.dir == DMA_DEV_TO_MEM;
+	void __iomem *high_reg;
+	void __iomem *low_reg;
+	u32 low;
+	u32 high;
+	u32 check;
+	int i;
+
+	if (chan_is_physical(d40c)) {
+		*addr = readl(chan_base(d40c) +
+			      (dst ? D40_CHAN_REG_SDPTR : D40_CHAN_REG_SSPTR));
+		return true;
+	}
+
+	if (dst) {
+		low_reg = &d40c->lcpa->lcsp2;
+		high_reg = &d40c->lcpa->lcsp3;
+	} else {
+		low_reg = &d40c->lcpa->lcsp0;
+		high_reg = &d40c->lcpa->lcsp1;
+	}
+
+	for (i = 0; i < D40_RESIDUE_MAX_ATTEMPTS; i++) {
+		high = readl(high_reg) & D40_MEM_LCSP1_SPTR_MASK;
+		low = readl(low_reg) & D40_MEM_LCSP0_SPTR_MASK;
+		check = readl(high_reg) & D40_MEM_LCSP1_SPTR_MASK;
+		if (high == check) {
+			*addr = low | high;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool d40_cyclic_offset(struct d40_chan *d40c, struct d40_desc *d40d,
+			      size_t *offset)
+{
+	dma_addr_t current_addr;
+	dma_addr_t current_offset;
+	int i;
+
+	for (i = 0; i < D40_RESIDUE_MAX_ATTEMPTS; i++) {
+		if (!d40_current_addr(d40c, &current_addr))
+			continue;
+
+		current_offset = current_addr - d40d->cyclic_dma_addr;
+		if (current_offset <= d40d->cyclic_buf_len) {
+			*offset = current_offset;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static bool d40_tx_is_linked(struct d40_chan *d40c)
 {
 	bool is_link;
@@ -2202,15 +2269,26 @@ static bool d40_is_paused(struct d40_chan *d40c)
 
 }
 
-static u32 stedma40_residue(struct dma_chan *chan)
+static u32 stedma40_residue(struct dma_chan *chan, dma_cookie_t cookie)
 {
 	struct d40_chan *d40c =
 		container_of(chan, struct d40_chan, chan);
+	struct d40_desc *d40d;
+	size_t offset;
 	u32 bytes_left;
 	unsigned long flags;
 
 	spin_lock_irqsave(&d40c->lock, flags);
-	bytes_left = d40_residue(d40c);
+	d40d = d40_first_active_get(d40c);
+	if (d40d && d40d->txd.cookie == cookie && d40d->cyclic &&
+	    d40d->cyclic_buf_len) {
+		if (d40_cyclic_offset(d40c, d40d, &offset))
+			d40d->cyclic_residue = d40d->cyclic_buf_len - offset;
+		bytes_left = d40d->cyclic_residue;
+	} else {
+		bytes_left = d40_residue(d40c);
+	}
+
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
 	return bytes_left;
@@ -2346,8 +2424,13 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	if (desc == NULL)
 		goto unlock;
 
-	if (sg_next(&sg_src[sg_len - 1]) == sg_src)
+	if (sg_next(&sg_src[sg_len - 1]) == sg_src) {
 		desc->cyclic = true;
+		if (desc->lli_len != sg_len) {
+			chan_err(chan, "Cyclic periods must fit in one LLI\n");
+			goto free_desc;
+		}
+	}
 
 	src_dev_addr = 0;
 	dst_dev_addr = 0;
@@ -2630,11 +2713,18 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		     size_t buf_len, size_t period_len,
 		     enum dma_transfer_direction direction, unsigned long flags)
 {
-	unsigned int periods = buf_len / period_len;
+	unsigned int periods;
 	struct dma_async_tx_descriptor *txd;
+	struct d40_desc *desc;
 	struct scatterlist *sg;
+	dma_addr_t buf_addr = dma_addr;
 	int i;
 
+	if (!buf_len || !period_len || buf_len % period_len)
+		return NULL;
+
+	periods = buf_len / period_len;
+
 	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_NOWAIT);
 	if (!sg)
 		return NULL;
@@ -2649,6 +2739,12 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 
 	txd = d40_prep_sg(chan, sg, sg, periods, direction,
 			  DMA_PREP_INTERRUPT);
+	if (txd) {
+		desc = container_of(txd, struct d40_desc, txd);
+		desc->cyclic_dma_addr = buf_addr;
+		desc->cyclic_buf_len = buf_len;
+		desc->cyclic_residue = buf_len;
+	}
 
 	kfree(sg);
 
@@ -2669,7 +2765,7 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 
 	ret = dma_cookie_status(chan, cookie, txstate);
 	if (ret != DMA_COMPLETE && txstate)
-		dma_set_residue(txstate, stedma40_residue(chan));
+		dma_set_residue(txstate, stedma40_residue(chan, cookie));
 
 	if (d40_is_paused(d40c))
 		ret = DMA_PAUSED;
-- 
2.53.0



