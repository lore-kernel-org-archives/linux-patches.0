Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436DC3655E0;
	Tue, 12 May 2026 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609718; cv=none; b=TZtAVndKWLgIWIXiW9/KZ+4VZM4vzPWsPBCSRHlO6VaXUq8E4xCJ/M7Q/a0YkwlBX8A0mOlAo4KClsR69GZt+pzDJ9oZE6c7Lwo15mjfd7k9KwwebWszRIMWP3duO+V17no56wx8bcrujcRS3zTkco3GjXKyBqykcBEbCbGEVOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609718; c=relaxed/simple;
	bh=mwWwseQpzPKzIUFTcSUASX1bPM6EieXgnQoRPTEV/to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OE5fFyqcmnTn3A5D8/QJ2A33s8kXd/p3jWDw3GE/mWoxzTtfvxz4M3JTkyJNyb6K6PrIq2NDHxC8SoEHbu0p1VSslh9FQ9Dw9R/SotEWtSa5Vmr10f7xEltf9RcFD7Dry8iAHNkzzCc5UngWQxFQ6cFQZ2iUeW0k8qEcUbotZk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/DTuVd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/DTuVd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1192C2BCF5;
	Tue, 12 May 2026 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609718;
	bh=mwWwseQpzPKzIUFTcSUASX1bPM6EieXgnQoRPTEV/to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/DTuVd+F59uhQrmVRrgzMk3DTY7u6mTd7Rvo5oDdn/uStwybnizX3eA2KrIA805T
	 iJRG3JonlGNG9VJiNdpUOkPlLyJ8QuOTCDFTRy1AXbvw1LF5Z+iYPyGw7wKuFrkqrq
	 1v4NnybT8jmWEymjyGMekCfV9ZGyPTdZ0znCS30A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <linux@armlinux.org.uk>,
	Sam Edwards <CFSworks@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 305/307] net: stmmac: Prevent NULL deref when RX memory exhausted
Date: Tue, 12 May 2026 19:41:40 +0200
Message-ID: <20260512173946.572823547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit 0bb05e6adfa99a2ea1fee1125cc0953409f83ed8 ]

The CPU receives frames from the MAC through conventional DMA: the CPU
allocates buffers for the MAC, then the MAC fills them and returns
ownership to the CPU. For each hardware RX queue, the CPU and MAC
coordinate through a shared ring array of DMA descriptors: one
descriptor per DMA buffer. Each descriptor includes the buffer's
physical address and a status flag ("OWN") indicating which side owns
the buffer: OWN=0 for CPU, OWN=1 for MAC. The CPU is only allowed to set
the flag and the MAC is only allowed to clear it, and both must move
through the ring in sequence: thus the ring is used for both
"submissions" and "completions."

In the stmmac driver, stmmac_rx() bookmarks its position in the ring
with the `cur_rx` index. The main receive loop in that function checks
for rx_descs[cur_rx].own=0, gives the corresponding buffer to the
network stack (NULLing the pointer), and increments `cur_rx` modulo the
ring size. After the loop exits, stmmac_rx_refill(), which bookmarks its
position with `dirty_rx`, allocates fresh buffers and rearms the
descriptors (setting OWN=1). If it fails any allocation, it simply stops
early (leaving OWN=0) and will retry where it left off when next called.

This means descriptors have a three-stage lifecycle (terms my own):
- `empty` (OWN=1, buffer valid)
- `full` (OWN=0, buffer valid and populated)
- `dirty` (OWN=0, buffer NULL)

But because stmmac_rx() only checks OWN, it confuses `full`/`dirty`. In
the past (see 'Fixes:'), there was a bug where the loop could cycle
`cur_rx` all the way back to the first descriptor it dirtied, resulting
in a NULL dereference when mistaken for `full`. The aforementioned
commit resolved that *specific* failure by capping the loop's iteration
limit at `dma_rx_size - 1`, but this is only a partial fix: if the
previous stmmac_rx_refill() didn't complete, then there are leftover
`dirty` descriptors that the loop might encounter without needing to
cycle fully around. The current code therefore panics (see 'Closes:')
when stmmac_rx_refill() is memory-starved long enough for `cur_rx` to
catch up to `dirty_rx`.

Fix this by explicitly checking, before advancing `cur_rx`, if the next
entry is dirty; exit the loop if so. This prevents processing of the
final, used descriptor until stmmac_rx_refill() succeeds, but
fully prevents the `cur_rx == dirty_rx` ambiguity as the previous bugfix
intended: so remove the clamp as well. Since stmmac_rx_zc() is a
copy-paste-and-tweak of stmmac_rx() and the code structure is identical,
any fix to stmmac_rx() will also need a corresponding fix for
stmmac_rx_zc(). Therefore, apply the same check there.

In stmmac_rx() (not stmmac_rx_zc()), a related bug remains: after the
MAC sets OWN=0 on the final descriptor, it will be unable to send any
further DMA-complete IRQs until it's given more `empty` descriptors.
Currently, the driver simply *hopes* that the next stmmac_rx_refill()
succeeds, risking an indefinite stall of the receive process if not. But
this is not a regression, so it can be addressed in a future change.

Fixes: b6cb4541853c7 ("net: stmmac: avoid rx queue overrun")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221010
Cc: stable@vger.kernel.org
Suggested-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Link: https://patch.msgid.link/20260422044503.5349-1-CFSworks@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5469,9 +5469,12 @@ read_again:
 			break;
 
 		/* Prefetch the next RX descriptor */
-		rx_q->cur_rx = STMMAC_NEXT_ENTRY(rx_q->cur_rx,
-						priv->dma_conf.dma_rx_size);
-		next_entry = rx_q->cur_rx;
+		next_entry = STMMAC_NEXT_ENTRY(rx_q->cur_rx,
+					       priv->dma_conf.dma_rx_size);
+		if (unlikely(next_entry == rx_q->dirty_rx))
+			break;
+
+		rx_q->cur_rx = next_entry;
 
 		if (priv->extend_desc)
 			np = (struct dma_desc *)(rx_q->dma_erx + next_entry);
@@ -5609,7 +5612,6 @@ static int stmmac_rx(struct stmmac_priv
 
 	dma_dir = page_pool_get_dma_dir(rx_q->page_pool);
 	bufsz = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
-	limit = min(priv->dma_conf.dma_rx_size - 1, (unsigned int)limit);
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
@@ -5665,9 +5667,12 @@ read_again:
 		if (unlikely(status & dma_own))
 			break;
 
-		rx_q->cur_rx = STMMAC_NEXT_ENTRY(rx_q->cur_rx,
-						priv->dma_conf.dma_rx_size);
-		next_entry = rx_q->cur_rx;
+		next_entry = STMMAC_NEXT_ENTRY(rx_q->cur_rx,
+					       priv->dma_conf.dma_rx_size);
+		if (unlikely(next_entry == rx_q->dirty_rx))
+			break;
+
+		rx_q->cur_rx = next_entry;
 
 		if (priv->extend_desc)
 			np = (struct dma_desc *)(rx_q->dma_erx + next_entry);


