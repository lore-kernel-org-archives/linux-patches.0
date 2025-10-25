Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02ED3090DE;
	Sat, 25 Oct 2025 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409734; cv=none; b=alnfSSsE2pxknukiGdYkraLVNXrobm+XnsoISCOOVHzVR+++pEdf4zwLcpy9t+yz2Tdwd128qIOQbjT80OTK4WxZrAN/NmSq0ahfUck5mgopMcZt7BXOJh0qsrybcdJNXTmzANGS7kj0sGpHgKkhDyVIYMjWVBGqMj99YOGvNS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409734; c=relaxed/simple;
	bh=IJFWxoj37kIAdOl8GO0f0EK+bwl+SAL8ePcWRoG5srQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTwmYQ3gox3ibq6dCiaZrWJJZtxJrFgoc3sdo5KwNO8rhQyb5MrPYQrkK9SINLI4WnqJ0qCx8wY+6dqbxaXCKqXtzRsJo8nwS8zaVuIz7KIGWC2Z2Dox09qXaj6mu4YHTsLqno99l96yUBnV0UeuvrWsJnbNGMba6sorHtHt36w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKcnJk8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKcnJk8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95519C4CEF5;
	Sat, 25 Oct 2025 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409734;
	bh=IJFWxoj37kIAdOl8GO0f0EK+bwl+SAL8ePcWRoG5srQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKcnJk8N94H9W32wYu2MHOHshK33sYy7rxuzXPSg6bC2al8/GKvWpxwA++TJ19Yvm
	 ghJ5e2HsOGOuiQ8xJdGKnOQP9dlmp18P2QA7TU611I63VaBJh3RkqWBd/AQi5BzdGF
	 oxzS6aJkcCAzoUAeLX87HtH5X0nvWYj2HMrg4VlHwozkTuwyLqP+1MM+5t5iR1+hBv
	 34EzHYYWb/8ZPpQbERhRELEtI2jY2OGYqJgi1FeamgBd2fAObGou+ZLuasmkxq6Mqc
	 11Ca9s3RLjBUJuleaOD6BZm2xC7ruLDqVxIxc0hp3bLU/NO2l3QWx1xHS20CzKCktD
	 MX9wHlIbBx6+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Andreatta <thomasandreatta2000@gmail.com>,
	Thomas Andreatta <thomas.andreatta2000@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	thorsten.blum@linux.dev,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] dmaengine: sh: setup_xref error handling
Date: Sat, 25 Oct 2025 12:01:12 -0400
Message-ID: <20251025160905.3857885-441-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Andreatta <thomasandreatta2000@gmail.com>

[ Upstream commit d9a3e9929452780df16f3414f0d59b5f69d058cf ]

This patch modifies the type of setup_xref from void to int and handles
errors since the function can fail.

`setup_xref` now returns the (eventual) error from
`dmae_set_dmars`|`dmae_set_chcr`, while `shdma_tx_submit` handles the
result, removing the chunks from the queue and marking PM as idle in
case of an error.

Signed-off-by: Thomas Andreatta <thomas.andreatta2000@gmail.com>
Link: https://lore.kernel.org/r/20250827152442.90962-1-thomas.andreatta2000@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Previously, `sh_dmae_setup_xfer()` unconditionally programmed
    DMARS/CHCR and ignored failures, so if the channel was busy (e.g.,
    `dmae_is_busy()`), programming would silently fail. The engine then
    proceeded as if configured, risking misconfigured or stalled
    transfers. The former code path and even an in-code TODO
    acknowledged this gap (see drivers/dma/sh/shdma-base.c:70, prior to
    this change).
  - This patch converts `.setup_xfer` to return an `int`, propagates
    errors from `dmae_set_dmars()` and `dmae_set_chcr()`, and makes
    `shdma_tx_submit()` unwind cleanly on failure.

- Key changes (small and contained)
  - drivers/dma/sh/shdma-base.c:133
    - Now checks the return of `ops->setup_xfer(schan,
      schan->slave_id)`. On error, it:
      - Logs the error.
      - Removes all chunks for this transaction from `ld_queue` and
        marks them `DESC_IDLE` (drivers/dma/sh/shdma-base.c:137–143).
      - Balances runtime PM by calling `pm_runtime_put()`
        (drivers/dma/sh/shdma-base.c:145–147).
      - Returns a negative error code via `tx_submit`, which is
        supported by the DMAengine API (`dma_submit_error(cookie)`).
  - drivers/dma/sh/shdmac.c:303
    - `sh_dmae_setup_xfer()` now returns `int`. It propagates failures
      from:
      - `dmae_set_dmars(sh_chan, cfg->mid_rid)`
        (drivers/dma/sh/shdmac.c:313–315).
      - `dmae_set_chcr(sh_chan, cfg->chcr)`
        (drivers/dma/sh/shdmac.c:317–319).
    - For MEMCPY (`slave_id < 0`), it still calls `dmae_init(sh_chan)`
      with no error (drivers/dma/sh/shdmac.c:321–323).
  - include/linux/shdma-base.h:99
    - `struct shdma_ops` changes `setup_xfer` from `void
      (*setup_xfer)(...)` to `int (*setup_xfer)(...)`, enabling error
      propagation while remaining internal to the SH DMAC driver family.

- Why it fits stable criteria
  - Bug fix that affects users: prevents silent misconfiguration when
    programming fails due to a busy channel, a real condition indicated
    by the underlying helpers (`dmae_set_dmars`/`dmae_set_chcr`).
  - Minimal and localized: confined to the SH DMA engine base and
    implementation; only one implementer of `shdma_ops->setup_xfer`
    exists (drivers/dma/sh/shdmac.c:662 for the ops table), so the API
    change is self-contained.
  - Low regression risk:
    - `tx_submit` returning negative errors is standard; clients
      typically check with `dma_submit_error(cookie)`.
    - On error, descriptors are unqueued and returned to `ld_free`, and
      runtime PM is balanced; no dangling state.
    - No functional change on success paths; MEMCPY path unchanged
      except for return value plumbing.
  - No architectural changes or feature additions; this is targeted
    error handling and cleanup.
  - Touches a driver-level subsystem, not core kernel frameworks.

- Side-effects considered
  - Behavior now fails fast instead of silently proceeding on hardware
    programming failure; this is an intended correctness improvement.
  - Header change is internal to the SH DMAC base and its only in-tree
    user; it should not impact other DMA drivers.

Overall, this is a straightforward, self-contained bug fix that improves
robustness and correctness with minimal risk, making it a good candidate
for stable backport.

 drivers/dma/sh/shdma-base.c | 25 +++++++++++++++++++------
 drivers/dma/sh/shdmac.c     | 17 +++++++++++++----
 include/linux/shdma-base.h  |  2 +-
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 6b4fce453c85c..834741adadaad 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -129,12 +129,25 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 			const struct shdma_ops *ops = sdev->ops;
 			dev_dbg(schan->dev, "Bring up channel %d\n",
 				schan->id);
-			/*
-			 * TODO: .xfer_setup() might fail on some platforms.
-			 * Make it int then, on error remove chunks from the
-			 * queue again
-			 */
-			ops->setup_xfer(schan, schan->slave_id);
+
+			ret = ops->setup_xfer(schan, schan->slave_id);
+			if (ret < 0) {
+				dev_err(schan->dev, "setup_xfer failed: %d\n", ret);
+
+				/* Remove chunks from the queue and mark them as idle */
+				list_for_each_entry_safe(chunk, c, &schan->ld_queue, node) {
+					if (chunk->cookie == cookie) {
+						chunk->mark = DESC_IDLE;
+						list_move(&chunk->node, &schan->ld_free);
+					}
+				}
+
+				schan->pm_state = SHDMA_PM_ESTABLISHED;
+				ret = pm_runtime_put(schan->dev);
+
+				spin_unlock_irq(&schan->chan_lock);
+				return ret;
+			}
 
 			if (schan->pm_state == SHDMA_PM_PENDING)
 				shdma_chan_xfer_ld_queue(schan);
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 093e449e19eee..603e15102e45e 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -300,21 +300,30 @@ static bool sh_dmae_channel_busy(struct shdma_chan *schan)
 	return dmae_is_busy(sh_chan);
 }
 
-static void sh_dmae_setup_xfer(struct shdma_chan *schan,
-			       int slave_id)
+static int sh_dmae_setup_xfer(struct shdma_chan *schan, int slave_id)
 {
 	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
 						    shdma_chan);
 
+	int ret = 0;
 	if (slave_id >= 0) {
 		const struct sh_dmae_slave_config *cfg =
 			sh_chan->config;
 
-		dmae_set_dmars(sh_chan, cfg->mid_rid);
-		dmae_set_chcr(sh_chan, cfg->chcr);
+		ret = dmae_set_dmars(sh_chan, cfg->mid_rid);
+		if (ret < 0)
+			goto END;
+
+		ret = dmae_set_chcr(sh_chan, cfg->chcr);
+		if (ret < 0)
+			goto END;
+
 	} else {
 		dmae_init(sh_chan);
 	}
+
+END:
+	return ret;
 }
 
 /*
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 6dfd05ef5c2d9..03ba4dab2ef73 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -96,7 +96,7 @@ struct shdma_ops {
 	int (*desc_setup)(struct shdma_chan *, struct shdma_desc *,
 			  dma_addr_t, dma_addr_t, size_t *);
 	int (*set_slave)(struct shdma_chan *, int, dma_addr_t, bool);
-	void (*setup_xfer)(struct shdma_chan *, int);
+	int (*setup_xfer)(struct shdma_chan *, int);
 	void (*start_xfer)(struct shdma_chan *, struct shdma_desc *);
 	struct shdma_desc *(*embedded_desc)(void *, int);
 	bool (*chan_irq)(struct shdma_chan *, int);
-- 
2.51.0

