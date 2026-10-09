Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB535C6A8;
	Fri,  9 Oct 2026 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555861; cv=none; b=tjtPczZUrZLBj/52P0oW6d6m776p6W0GJfgRmZ301z6c8kQeGqpgkOPfmvC3hoGL8jb/yo99ABisVB+WKiOv9dR5DEZ0TTOKC3DN+2faElBOpJMwW2OD9ziwhOH4EBCANZpsHc7OriY4eiXPdxU5AINi+QtpTLK2LFPG5jlMZ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555861; c=relaxed/simple;
	bh=R0n6cKBiKP2/GW2mrvappSB86BWyxZ269cw2Y3i4YCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AhF19zd/mPechjOyerOFPzkTTHA6rIpvB1xHGEdNAKhlcK+KRiKg8PZzc4d68jfbzDUnoZ1gG14hhBGsrCsoajhymFK5Lb/DxGhIxIxCcGL5SR1yeuj6Y/9vxHrxhmBraQJO9zN/2OfsJcuS6r91t+0vRlWxVpCWozbdfVFWVIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEJ+1OQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEJ+1OQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02B41F000FF;
	Fri,  9 Oct 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555860;
	bh=KUh/BU7zFDAGlMMRa0bPDbsZ5sBaVTyI5SS6w8epaDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEJ+1OQBfPzu2XkQ0N6b+uWyWX7eMa0rxQ8DTMjBjJXuZG3Poiq6QZJofdzcpl1to
	 k7/UWekFG0OSY/5sFSxVoX6ZMMxRUmPrVSMq8frxgyGn77WX2O8aInB0ZvOR6K45IZ
	 W8sfGlXBJVNxIQPnnpWOVm4/pJ1WuurWolKW+vcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 081/428] wifi: ath9k: Clean up device initialisation guards
Date: Fri,  9 Oct 2026 16:06:58 +0200
Message-ID: <20261009140947.952185971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 1af8dc9ca726cf53767f9c0661171396f95c146a ]

The ath9k driver has a couple of guards against the RX path running
until device initialisation has completed. However, they are problematic
for several reasons:

- They use smp_wmb() paired with a data_race() annotation, instead of
  the idiomatic smp_store_release()/smp_load_acquire() pair.

- The guard in ath9k_wmi_event_tasklet() is weirdly late in the
  function.

- There are two of them when there's really no reason the rx init gets
  to run before the whole initialisation is complete.

Consolidate the guards on the single ath9k_htc_priv->initialized
variable and use smp_store_release()/smp_load_acquire() to access it.
Move the store into ath9k_init_device() to make sure it's set in all
paths in the driver.

Fixes: 24355fcb0d4c ("wifi: ath9k: delay all of ath9k_wmi_event_tasklet() until init is complete")
Fixes: b0ec7e55fce6 ("ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20260908170520.112946-1-toke@redhat.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  7 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  8 ++------
 drivers/net/wireless/ath/ath9k/wmi.c          | 12 ++++++------
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6c33e898b3000..4d2b75d0212ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -281,7 +281,6 @@ struct ath9k_htc_rxbuf {
 struct ath9k_htc_rx {
 	struct list_head rxbuf;
 	spinlock_t rxbuflock;
-	bool initialized;
 };
 
 #define ATH9K_HTC_TX_CLEANUP_INTERVAL 50 /* ms */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae857268..911eaa4f776ab 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -910,6 +910,9 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	ath9k_init_leds(priv);
 	ath9k_start_rfkill_poll(priv);
 
+	/* signal completion to ath9k_htc_rxep() and ath9k_wmi_event_tasklet() */
+	smp_store_release(&priv->initialized, true);
+
 	return 0;
 
 err_world:
@@ -966,10 +969,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 
 	htc_handle->drv_priv = priv;
 
-	/* Allow ath9k_wmi_event_tasklet() to operate. */
-	smp_wmb();
-	priv->initialized = true;
-
 	return 0;
 
 err_init:
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0e..95f48c7dca154 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1141,8 +1141,8 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	unsigned long flags;
 
-	/* Check if ath9k_rx_init() completed. */
-	if (!data_race(priv->rx.initialized))
+	/* Check if ath9k_init_device() completed. */
+	if (!smp_load_acquire(&priv->initialized))
 		goto err;
 
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
@@ -1200,10 +1200,6 @@ int ath9k_rx_init(struct ath9k_htc_priv *priv)
 		list_add_tail(&rxbuf->list, &priv->rx.rxbuf);
 	}
 
-	/* Allow ath9k_htc_rxep() to operate. */
-	smp_wmb();
-	priv->rx.initialized = true;
-
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 284e8c13b0430..44e91815a1594 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -146,6 +146,12 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 	unsigned long flags;
 	u16 cmd_id;
 
+	/* Check if ath9k_init_device() completed. */
+	if (!smp_load_acquire(&priv->initialized)) {
+		tasklet_schedule(t);
+		return;
+	}
+
 	do {
 		spin_lock_irqsave(&wmi->wmi_lock, flags);
 		skb = __skb_dequeue(&wmi->wmi_event_queue);
@@ -155,12 +161,6 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 		}
 		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
-		/* Check if ath9k_htc_probe_device() completed. */
-		if (!data_race(priv->initialized)) {
-			kfree_skb(skb);
-			continue;
-		}
-
 		hdr = (struct wmi_cmd_hdr *) skb->data;
 		cmd_id = be16_to_cpu(hdr->command_id);
 		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
-- 
2.53.0



