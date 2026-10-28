Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208779;
	b=Xi/ry3gvGL5Z5PQzJ8Ak3wRanyfR/l3LsTxNlyCnwj/Y4sYN6ARflbdudwRRTPzImaLN
	 ILvdYRMYX0F1c4dFsvoG82iJz/G1eBwK19BJaM68nNm2ZudUI+QyOwaa9LhGiJT/pvfCu
	 rmuzx0q2EN8+O+pA9ZLbJ3sfbFumMG6ogUf3ro/g8NoUZ9p3bNJeoHWmGN/Obu2ki0XUY
	 ST0mwDbvjhE95hhXUMwizueYarUqKmSFIQygrBaz0iB2bk4yn10+lmPmAnEB7UP8dYVXs
	 JOdoponGmtc/Wypnu1BPllJ4ZjBgSjzz1J7gUzvL66+1ECMokwTRU0mwFhymmpj9bFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tR3CmW3V/eM95ZyD8G4/DHChUGWJ+D6v+eEbOBwus6w=;
	b=n7cyHFv8ZaeR1GgXWqK9A0vQ17GfqBnnfzHH8hUM6jXXXUiCpTDRUjFbgh7Dm4S2W//4
	 k7qB6RXGoiY20d9fT2ErkmZwzryhcx6b8IM16xe8BuyS6vkEyjNy366f/B1ybFJvP7MQm
	 bwPusUdwT8Rmn7A/LzLuccEC7kV34//ICHAsp7kf7eiVjSs98qi0FHCNPLPtB/FyUi4hM
	 z8jBRW0IgEEpch0W+0vKUx9qIpRTY0DkyjdVRUWYSFSKBXc7Evl81lJtRgxdgr2t/Y58y
	 p6dheemo8M70Fl6QOLVfZxCCqgLxkVVWdx+1dKldjqQEbCmF7MYw+eG459BG2ZuLKXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGVBUUFI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6616606A31A;
	Wed, 28 Oct 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGVBUUFI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322801F01825;
	Wed, 28 Oct 2026 17:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208778;
	bh=tR3CmW3V/eM95ZyD8G4/DHChUGWJ+D6v+eEbOBwus6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGVBUUFIUt7nWYFqofHqUCZvdc2uftD+zpq38yolQubpTFQWzojicvaze+MdzDaC2
	 s4cimJjiRoheM56ReRaoqcuaoumOag3k6GIEUYP9lyiJD4bxG8+HfklwlWVcrNvCQn
	 EsCM9Ci5C4yLjTGYZmUvRqSeqAXOdnKfldmKZohI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5.10 195/516] usb: gadget: aspeed-vhub: cancel wake work on device removal
Date: Wed, 28 Oct 2026 17:55:47 +0100
Message-ID: <20261028170008.121424127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 20388c8d1d74c203fec8194c45cd31afdfab934e upstream.

wake_work is armed from the gadget .wakeup callback to resume suspended
downstream ports, and it is never cancelled in ast_vhub_remove(), so a
work item queued before or during removal can run after devm has freed
vhub and its ports, a use-after-free.

Cancelling the work alone is not sufficient: usb_gadget_wakeup() takes
no lock and the unbind path never clears wakeup_en, so a remote-wakeup
request in flight on another CPU can re-arm the work after the cancel
and before vhub is freed.

ast_vhub_del_dev() already clears d->registered under vhub->lock before
unregistering the gadget. Refuse the wakeup in ast_vhub_udc_wakeup()
once d->registered is clear: the check and the schedule_work() are then
atomic against the unbind, so a wakeup that passed before the flag was
cleared is drained by the cancel_work_sync() after the del_dev loop,
and one that arrives later returns without arming. Also move INIT_WORK()
to the top of ast_vhub_probe(), since the probe error path reuses
ast_vhub_remove() and would otherwise cancel a never-initialized work
item.

This issue was found by an in-house static analysis tool.

Fixes: 7ecca2a4080c ("usb/gadget: Add driver for Aspeed SoC virtual hub")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: https://patch.msgid.link/20260908041740.613713-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/core.c |    4 ++++
 drivers/usb/gadget/udc/aspeed-vhub/dev.c  |    2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c  |    5 +++--
 drivers/usb/gadget/udc/aspeed-vhub/vhub.h |    1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/aspeed-vhub/core.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/core.c
@@ -272,6 +272,9 @@ static int ast_vhub_remove(struct platfo
 	for (i = 0; i < vhub->max_ports; i++)
 		ast_vhub_del_dev(&vhub->ports[i].dev);
 
+	/* Final drain; the worker takes vhub->lock, so stay outside of it */
+	cancel_work_sync(&vhub->wake_work);
+
 	spin_lock_irqsave(&vhub->lock, flags);
 
 	/* Mask & ack all interrupts  */
@@ -332,6 +335,7 @@ static int ast_vhub_probe(struct platfor
 		return -ENOMEM;
 
 	spin_lock_init(&vhub->lock);
+	INIT_WORK(&vhub->wake_work, ast_vhub_wake_work);
 	vhub->pdev = pdev;
 	vhub->port_irq_mask = GENMASK(VHUB_IRQ_DEV1_BIT + vhub->max_ports - 1,
 				      VHUB_IRQ_DEV1_BIT);
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -275,7 +275,7 @@ static int ast_vhub_udc_wakeup(struct us
 	int rc = -EINVAL;
 
 	spin_lock_irqsave(&d->vhub->lock, flags);
-	if (!d->wakeup_en)
+	if (!d->wakeup_en || !d->registered)
 		goto err;
 
 	DDBG(d, "Device initiated wakeup\n");
--- a/drivers/usb/gadget/udc/aspeed-vhub/hub.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/hub.c
@@ -532,7 +532,7 @@ void ast_vhub_device_connect(struct ast_
 		ast_vhub_send_host_wakeup(vhub);
 }
 
-static void ast_vhub_wake_work(struct work_struct *work)
+void ast_vhub_wake_work(struct work_struct *work)
 {
 	struct ast_vhub *vhub = container_of(work,
 					     struct ast_vhub,
@@ -562,6 +562,8 @@ static void ast_vhub_wake_work(struct wo
 
 void ast_vhub_hub_wake_all(struct ast_vhub *vhub)
 {
+	lockdep_assert_held(&vhub->lock);
+
 	/*
 	 * A device is trying to wake the world, because this
 	 * can recurse into the device, we break the call chain
@@ -1046,7 +1048,6 @@ static int ast_vhub_init_desc(struct ast
 int ast_vhub_init_hub(struct ast_vhub *vhub)
 {
 	vhub->speed = USB_SPEED_UNKNOWN;
-	INIT_WORK(&vhub->wake_work, ast_vhub_wake_work);
 
 	return ast_vhub_init_desc(vhub);
 }
--- a/drivers/usb/gadget/udc/aspeed-vhub/vhub.h
+++ b/drivers/usb/gadget/udc/aspeed-vhub/vhub.h
@@ -545,6 +545,7 @@ void ast_vhub_hub_suspend(struct ast_vhu
 void ast_vhub_hub_resume(struct ast_vhub *vhub);
 void ast_vhub_hub_reset(struct ast_vhub *vhub);
 void ast_vhub_hub_wake_all(struct ast_vhub *vhub);
+void ast_vhub_wake_work(struct work_struct *work);
 
 /* dev.c */
 int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx);


