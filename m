Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999B31F9BC;
	Mon, 13 Apr 2026 17:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099790; cv=none; b=HMfGAblA0aPiA2T1/EtNASSn70eoviZejvsd/uYhCbIv+jo2lbEgM3fD7lfGFigsZnBLLIsWQCcR8IKqouaeljZxxp4bv4BJgJ4WSJeRbExNzgvilhxvkjhLoZ31osV3jVljWS0JvKGF5P7odV18t8QQcoMmTMGklJsP+klgUS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099790; c=relaxed/simple;
	bh=0awSUxilXjl6HeknFGDwUibF8VBdpGT+5JERLRPr3Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVXCjR5cz8IrUzy74SCbP1IZVW/5vlvIumFeggSqU0aGf1R4BC+wsktdn3hCluozY/Fcf9CGyhtxR1+WF1dqLUdbWfDZwZZorfAwRpLwrdVJk7Y6Ha+iX5gWAxy017Rwl8KN/bEQhFNAkFYheAkim4XT47Iir9X/jV/tJGw+xP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVE2Amxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVE2Amxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D56C2BCAF;
	Mon, 13 Apr 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099790;
	bh=0awSUxilXjl6HeknFGDwUibF8VBdpGT+5JERLRPr3Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVE2Amxjf1BVXsGiYbg6ojNV7okxuBy2pUE4Wn8i1dJpXM5W5wXUbWduOLro2TaEy
	 ZHYTztd3LElF5DrnqafNPkw8yzhpyZrosSFWxWpJ5KHrnG+SbrNus4Jxl/PXVMOJDJ
	 AiCg+h7QTImmITUV2DjimSfD7Zcq0va2779U6McY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Ossman <pierre@ossman.eu>,
	Russell King <linux@armlinux.org.uk>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/491] mmc: core: Drop reference counting of the bus_ops
Date: Mon, 13 Apr 2026 18:02:00 +0200
Message-ID: <20260413155836.832724108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit e9ce2ce17da626d930812199568bd426b2832f57 ]

When the mmc_rescan work is enabled for execution (host->rescan_disable),
it's the only instance per mmc host that is allowed to set/clear the
host->bus_ops pointer.

Besides the mmc_rescan work, there are a couple of scenarios when the
host->bus_ops pointer may be accessed. Typically, those can be described as
as below:

*)
Upper mmc driver layers (like the mmc block device driver or an SDIO
functional driver) needs to execute a host->bus_ops callback. This can be
considered as safe without having to use some special locking mechanism,
because they operate on top of the struct mmc_card. As long as there is a
card to operate upon, the mmc core guarantees that there is a host->bus_ops
assigned as well. Note that, upper layer mmc drivers are of course
responsible to clean up from themselves from their ->remove() callbacks,
otherwise things would fall apart anyways.

**)
Via the mmc host instance, we may need to force a removal of an inserted
mmc card. This happens when a mmc host driver gets unbind, for example. In
this case, we protect the host->bus_ops pointer from concurrent accesses,
by disabling the mmc_rescan work upfront (host->rescan_disable). See
mmc_stop_host() for example.

This said, it seems like the reference counting of the host->bus_ops
pointer at some point have become superfluous. As this is an old mechanism
of the mmc core, it a bit difficult to digest the history of when that
could have happened. However, let's drop the reference counting to avoid
unnecessary code-paths and lockings.

Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210212131610.236843-1-ulf.hansson@linaro.org
Stable-dep-of: 901084c51a0a ("mmc: core: Avoid bitfield RMW for claim/retune flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c  |   89 ++---------------------------------------------
 include/linux/mmc/host.h |    2 -
 2 files changed, 4 insertions(+), 87 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1389,62 +1389,12 @@ void mmc_power_cycle(struct mmc_host *ho
 }
 
 /*
- * Cleanup when the last reference to the bus operator is dropped.
- */
-static void __mmc_release_bus(struct mmc_host *host)
-{
-	WARN_ON(!host->bus_dead);
-
-	host->bus_ops = NULL;
-}
-
-/*
- * Increase reference count of bus operator
- */
-static inline void mmc_bus_get(struct mmc_host *host)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-	host->bus_refs++;
-	spin_unlock_irqrestore(&host->lock, flags);
-}
-
-/*
- * Decrease reference count of bus operator and free it if
- * it is the last reference.
- */
-static inline void mmc_bus_put(struct mmc_host *host)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-	host->bus_refs--;
-	if ((host->bus_refs == 0) && host->bus_ops)
-		__mmc_release_bus(host);
-	spin_unlock_irqrestore(&host->lock, flags);
-}
-
-/*
  * Assign a mmc bus handler to a host. Only one bus handler may control a
  * host at any given time.
  */
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops)
 {
-	unsigned long flags;
-
-	WARN_ON(!host->claimed);
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	WARN_ON(host->bus_ops);
-	WARN_ON(host->bus_refs);
-
 	host->bus_ops = ops;
-	host->bus_refs = 1;
-	host->bus_dead = 0;
-
-	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 /*
@@ -1452,18 +1402,7 @@ void mmc_attach_bus(struct mmc_host *hos
  */
 void mmc_detach_bus(struct mmc_host *host)
 {
-	unsigned long flags;
-
-	WARN_ON(!host->claimed);
-	WARN_ON(!host->bus_ops);
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	host->bus_dead = 1;
-
-	spin_unlock_irqrestore(&host->lock, flags);
-
-	mmc_bus_put(host);
+	host->bus_ops = NULL;
 }
 
 void _mmc_detect_change(struct mmc_host *host, unsigned long delay, bool cd_irq)
@@ -2260,32 +2199,15 @@ void mmc_rescan(struct work_struct *work
 		host->trigger_card_event = false;
 	}
 
-	mmc_bus_get(host);
-
 	/* Verify a registered card to be functional, else remove it. */
-	if (host->bus_ops && !host->bus_dead)
+	if (host->bus_ops)
 		host->bus_ops->detect(host);
 
 	host->detect_change = 0;
 
-	/*
-	 * Let mmc_bus_put() free the bus/bus_ops if we've found that
-	 * the card is no longer present.
-	 */
-	mmc_bus_put(host);
-	mmc_bus_get(host);
-
 	/* if there still is a card present, stop here */
-	if (host->bus_ops != NULL) {
-		mmc_bus_put(host);
+	if (host->bus_ops != NULL)
 		goto out;
-	}
-
-	/*
-	 * Only we can add a new handler, so it's safe to
-	 * release the lock here.
-	 */
-	mmc_bus_put(host);
 
 	mmc_claim_host(host);
 	if (mmc_card_is_removable(host) && host->ops->get_cd &&
@@ -2356,18 +2278,15 @@ void mmc_stop_host(struct mmc_host *host
 	/* clear pm flags now and let card drivers set them as needed */
 	host->pm_flags = 0;
 
-	mmc_bus_get(host);
-	if (host->bus_ops && !host->bus_dead) {
+	if (host->bus_ops) {
 		/* Calling bus_ops->remove() with a claimed host can deadlock */
 		host->bus_ops->remove(host);
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
 		mmc_power_off(host);
 		mmc_release_host(host);
-		mmc_bus_put(host);
 		return;
 	}
-	mmc_bus_put(host);
 
 	mmc_claim_host(host);
 	mmc_power_off(host);
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -403,7 +403,6 @@ struct mmc_host {
 	/* group bitfields together to minimize padding */
 	unsigned int		use_spi_crc:1;
 	unsigned int		claimed:1;	/* host exclusively claimed */
-	unsigned int		bus_dead:1;	/* bus has been released */
 	unsigned int		doing_init_tune:1; /* initial tuning in progress */
 	unsigned int		can_retune:1;	/* re-tuning can be used */
 	unsigned int		doing_retune:1;	/* re-tuning in progress */
@@ -435,7 +434,6 @@ struct mmc_host {
 	struct mmc_slot		slot;
 
 	const struct mmc_bus_ops *bus_ops;	/* current bus driver */
-	unsigned int		bus_refs;	/* reference counter */
 
 	unsigned int		sdio_irqs;
 	struct task_struct	*sdio_irq_thread;


