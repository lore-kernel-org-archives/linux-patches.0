Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA132F83BA;
	Tue, 26 Aug 2025 14:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218198; cv=none; b=mvJ6wzCNOMalxjrSADEtXsE/Rju0x/IqzoymLyqzbZ+9cqC8JFKYnyrw4BVAZ3plWC5+zRKYXeIMSH0Hjh5SYHiqX9Os926J69WEfiKMCLMIQcgxFtRNmHNgOggDRoeg813E8dcgu7+h+P6z2EnAoCsj4fpEcHUVL9HYep9lw9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218198; c=relaxed/simple;
	bh=0jdoZmxgPsPaJiVcqkbLb5Qo1q1KqScL5mI8d0CSQCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7EywpLFgW3ltn72LNbKkrlKaZcKTU24yGldi5aJ7lKqFkYgw2T2wBDOQu10kyhpoTD2W5n8jKW9oG/MKAC3h6QlT8Rdw94Tsub17TeJr/w6Ms3YwVxxBfWRMwo9sFiPhVTQrpD093r8dChSaCs0NtoiHO3J1zeOiTea49ZojbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1o3rVhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1o3rVhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0A8C4CEF1;
	Tue, 26 Aug 2025 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218198;
	bh=0jdoZmxgPsPaJiVcqkbLb5Qo1q1KqScL5mI8d0CSQCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1o3rVhADLIeBrwQIPOoko9+WVdKiOLMVurRj8yNpNXPE3YM0rMMHb0pl+nyUCQB5
	 2j3rDG4D6v7dTB9Yq5d4EXa84MXCM8oHXWZytG/qsX5BmQnnri63rAQgdSWjGtYyML
	 KoJsAprbNG8CxoofBNxkXn4kRUhzTGYk0/G+0BnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/523] net: usbnet: Avoid potential RCU stall on LINK_CHANGE event
Date: Tue, 26 Aug 2025 13:10:40 +0200
Message-ID: <20250826110935.062155899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Ernberg <john.ernberg@actia.se>

[ Upstream commit 0d9cfc9b8cb17dbc29a98792d36ec39a1cf1395f ]

The Gemalto Cinterion PLS83-W modem (cdc_ether) is emitting confusing link
up and down events when the WWAN interface is activated on the modem-side.

Interrupt URBs will in consecutive polls grab:
* Link Connected
* Link Disconnected
* Link Connected

Where the last Connected is then a stable link state.

When the system is under load this may cause the unlink_urbs() work in
__handle_link_change() to not complete before the next usbnet_link_change()
call turns the carrier on again, allowing rx_submit() to queue new SKBs.

In that event the URB queue is filled faster than it can drain, ending up
in a RCU stall:

    rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 0-.... } 33108 jiffies s: 201 root: 0x1/.
    rcu: blocking rcu_node structures (internal RCU debug):
    Sending NMI from CPU 1 to CPUs 0:
    NMI backtrace for cpu 0

    Call trace:
     arch_local_irq_enable+0x4/0x8
     local_bh_enable+0x18/0x20
     __netdev_alloc_skb+0x18c/0x1cc
     rx_submit+0x68/0x1f8 [usbnet]
     rx_alloc_submit+0x4c/0x74 [usbnet]
     usbnet_bh+0x1d8/0x218 [usbnet]
     usbnet_bh_tasklet+0x10/0x18 [usbnet]
     tasklet_action_common+0xa8/0x110
     tasklet_action+0x2c/0x34
     handle_softirqs+0x2cc/0x3a0
     __do_softirq+0x10/0x18
     ____do_softirq+0xc/0x14
     call_on_irq_stack+0x24/0x34
     do_softirq_own_stack+0x18/0x20
     __irq_exit_rcu+0xa8/0xb8
     irq_exit_rcu+0xc/0x30
     el1_interrupt+0x34/0x48
     el1h_64_irq_handler+0x14/0x1c
     el1h_64_irq+0x68/0x6c
     _raw_spin_unlock_irqrestore+0x38/0x48
     xhci_urb_dequeue+0x1ac/0x45c [xhci_hcd]
     unlink1+0xd4/0xdc [usbcore]
     usb_hcd_unlink_urb+0x70/0xb0 [usbcore]
     usb_unlink_urb+0x24/0x44 [usbcore]
     unlink_urbs.constprop.0.isra.0+0x64/0xa8 [usbnet]
     __handle_link_change+0x34/0x70 [usbnet]
     usbnet_deferred_kevent+0x1c0/0x320 [usbnet]
     process_scheduled_works+0x2d0/0x48c
     worker_thread+0x150/0x1dc
     kthread+0xd8/0xe8
     ret_from_fork+0x10/0x20

Get around the problem by delaying the carrier on to the scheduled work.

This needs a new flag to keep track of the necessary action.

The carrier ok check cannot be removed as it remains required for the
LINK_RESET event flow.

Fixes: 4b49f58fff00 ("usbnet: handle link change")
Cc: stable@vger.kernel.org
Signed-off-by: John Ernberg <john.ernberg@actia.se>
Link: https://patch.msgid.link/20250723102526.1305339-1-john.ernberg@actia.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adjust context in header ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c   |   11 ++++++++---
 include/linux/usb/usbnet.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1080,6 +1080,9 @@ static void __handle_link_change(struct
 		 * tx queue is stopped by netcore after link becomes off
 		 */
 	} else {
+		if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
+			netif_carrier_on(dev->net);
+
 		/* submitting URBs for reading packets */
 		tasklet_schedule(&dev->bh);
 	}
@@ -1960,10 +1963,12 @@ EXPORT_SYMBOL(usbnet_manage_power);
 void usbnet_link_change(struct usbnet *dev, bool link, bool need_reset)
 {
 	/* update link after link is reseted */
-	if (link && !need_reset)
-		netif_carrier_on(dev->net);
-	else
+	if (link && !need_reset) {
+		set_bit(EVENT_LINK_CARRIER_ON, &dev->flags);
+	} else {
+		clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags);
 		netif_carrier_off(dev->net);
+	}
 
 	if (need_reset && link)
 		usbnet_defer_kevent(dev, EVENT_LINK_RESET);
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -83,6 +83,7 @@ struct usbnet {
 #		define EVENT_LINK_CHANGE	11
 #		define EVENT_SET_RX_MODE	12
 #		define EVENT_NO_IP_ALIGN	13
+#		define EVENT_LINK_CARRIER_ON	14
 	u32			rx_speed;	/* in bps - NOT Mbps */
 	u32			tx_speed;	/* in bps - NOT Mbps */
 };


