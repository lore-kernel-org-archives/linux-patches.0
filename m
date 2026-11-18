Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055779;
	b=rhYE+kaa9mc0tv/57hMV4FubU4BDfGI8CGnE3nqJLl5au01iHz2HuExs/uTb2q59ILPw
	 qPxaMFkEHzmMoUynUQC6RddaqMgv33iQhbouMiv/DdVwQUC+u35Buxc2tz8di9cPQ7dlc
	 RWaiBCXROegQ0vAwlTb+Y/BgGgb56PHrrCJZW5DfZHPBKmFwZELqYO5purrMCYtjHWOhM
	 SkvSBxvzEDqoEFybbz6k5PSx9sWXKlgCBTKrB7Ikpv/Si8j8s3hOPOWZcYdyhog3k6nGg
	 qbOh39tX6Tfatq0OyV/pgaAxOE7UPAVyWZaLbEnPIElvy8xHRzJpAiP7CClUKTlukUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTMb1m5a1h1xwUItJl4C1kQ8visYbNkGbLbdoyBnFPo=;
	b=vqxOuMbbySNvBYydDzxl3aM+fS+voFcEnFiClhudoKIZSlxky1uzBjm518Qg++JxoCy2
	 M3zURwwQqGLKtt0mnRUq0p8iUpM4iA/qsrvMAKZfKi0SddOekU/RM/go+QQ08xZaucKfp
	 ahegitg5Q5ByXzv4s7PxeFP2n8a2wTo0fwSpnMrstVNWAcPWvEuhgyBS/TPh/HZFdJpw0
	 sMCuOrd+0Eq6zWvwry8yNHkWUB6O0u+jZgkj7YzCnTNeCJOVS1XRACUAGDjTqol3FlZFr
	 pvBH+opbS9uED9JO/mceCRicnD0UoGG0CiwFsvRucZ26Gbeyj4JiD/CtmTYB8gslcFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tl7eNhh5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BFD606A320;
	Thu, 19 Nov 2026 02:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tl7eNhh5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683331F000C4;
	Thu, 19 Nov 2026 02:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055778;
	bh=RTMb1m5a1h1xwUItJl4C1kQ8visYbNkGbLbdoyBnFPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tl7eNhh5U3HRAoHOM3oZcZVTBzFnyQY7A37uKw65wHXbETPGmZ6BJkayO4YxREwRG
	 09FA7Pfjv2TAOg7FuUXqqh2vXoPD0akmwOBTIGP4rPnRMSntZ2czP7HjB3oEiw9MWf
	 LTZtLe8Ic8q0ARaG4AwJF50qITZsaTz1z+aeLivE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1753/2214] dmaengine: ste_dma40: Fix failed start cleanup
Date: Wed, 18 Nov 2026 15:57:09 +0100
Message-ID: <20261118150121.701841819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 8175ead5727173d4b96d1e830e696765d75ade71 ]

If d40_start() fails after a queued descriptor has been moved to the
active list, d40_queue_start() currently returns NULL without unwinding
the transfer state or clearing the channel busy flag.

Fix this pre-existing error path by completing the descriptor through the
normal tasklet path, clearing the busy flag, balancing the runtime PM
reference and returning an error pointer to distinguish the failure from
the no-work case. Do not free the descriptor directly, since it has
already been submitted and has a DMA cookie.

When starting the next queued transfer from the completion handler, put
the completed descriptor on the done list first. This preserves FIFO
completion order if the new transfer fails to start and prevents the
completed cookie from moving backwards.

Use done-list membership rather than the cyclic flag to identify terminal
descriptors in the tasklet. A cyclic descriptor that failed to start is
then completed and removed instead of remaining permanently at the head
of the done list.

Fixes: 7d83a854a1a4 ("dma40: remove "hardware link with previous jobs" code")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Assisted-by: LLM
Link: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-4-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c9097dc6748a7..52f455262857d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1510,8 +1510,15 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 		/* Start dma job */
 		err = d40_start(d40c);
 
-		if (err)
-			return NULL;
+		if (err) {
+			d40_desc_remove(d40d);
+			d40_desc_done(d40c, d40d);
+			d40c->pending_tx++;
+			d40c->busy = false;
+			pm_runtime_put_autosuspend(d40c->base->dev);
+			tasklet_schedule(&d40c->tasklet);
+			return ERR_PTR(err);
+		}
 	}
 
 	return d40d;
@@ -1555,15 +1562,15 @@ static void dma_tc_handle(struct d40_chan *d40c)
 			return;
 		}
 
+		d40_desc_remove(d40d);
+		d40_desc_done(d40c, d40d);
+
 		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
 
 			pm_runtime_mark_last_busy(d40c->base->dev);
 			pm_runtime_put_autosuspend(d40c->base->dev);
 		}
-
-		d40_desc_remove(d40d);
-		d40_desc_done(d40c, d40d);
 	}
 
 	d40c->pending_tx++;
@@ -1577,20 +1584,22 @@ static void dma_tasklet(struct tasklet_struct *t)
 	struct d40_desc *d40d;
 	unsigned long flags;
 	bool callback_active;
+	bool from_done;
 	struct dmaengine_desc_callback cb;
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	/* Get first entry from the done list */
 	d40d = d40_first_done(d40c);
-	if (d40d == NULL) {
+	from_done = !!d40d;
+	if (!from_done) {
 		/* Check if we have reached here for cyclic job */
 		d40d = d40_first_active_get(d40c);
 		if (d40d == NULL || !d40d->cyclic)
 			goto check_pending_tx;
 	}
 
-	if (!d40d->cyclic)
+	if (from_done)
 		dma_cookie_complete(&d40d->txd);
 
 	/*
@@ -1606,7 +1615,7 @@ static void dma_tasklet(struct tasklet_struct *t)
 	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	dmaengine_desc_get_callback(&d40d->txd, &cb);
 
-	if (!d40d->cyclic) {
+	if (from_done) {
 		if (async_tx_test_ack(&d40d->txd)) {
 			d40_desc_remove(d40d);
 			d40_desc_free(d40c, d40d);
-- 
2.53.0



