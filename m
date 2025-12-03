Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE7230F929;
	Wed,  3 Dec 2025 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776625; cv=none; b=Ey1/CGJGKgf7mnYIs4laRsrYe4a4EIVVWwj5cv151PD65o4wFXEyXG6M5dRC74CLwgVtIljw1Eki4T2od3qcfJ/0mGH9GO3cAftSMhXaumsd+kQG3elx2u1GBGs/PzOvH4xbRja40b9JPGpaaNBiJoI9lkQ53p9T3hWPWKfP+5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776625; c=relaxed/simple;
	bh=lfE0T+ij7kZFVuSF9+2XFg551vlY6vLN6WfF1UBb4FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+P5mn3xeiw7jesgzJKlOOiLDl4pJJDiW8c6ZVZRMYoBVbVCWc7wap/raqL/Hq5nVoc2ZTxPaa4H8fvJMx1kBDG51Gp43PBrpDqxbLbo9nCPyCK4T6NMYKueNlvswaCkxQtlrDhDasEZprA6ZaVY8MSk0DkjFWQsjxVL3X05Gwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6kNPGOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6kNPGOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7309C4CEF5;
	Wed,  3 Dec 2025 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776624;
	bh=lfE0T+ij7kZFVuSF9+2XFg551vlY6vLN6WfF1UBb4FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6kNPGOkLbC6qFiR3qt3WKkIE6AMzr1Ee4uzapm2SwpWoIw1IYfiw/WX7BIf5Am8/
	 jWmg0OzYHDs26d5cb2xo2ZZzqnKv7TNAO1ROgrMeN+dbC3TZ+Tr2ZtBICiwH7DfTbH
	 H0uymddcsizt8+xvlB9e1lCYgtnrvuYbyQmA8x0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>
Subject: [PATCH 5.10 237/300] uio_hv_generic: Set event for all channels on the device
Date: Wed,  3 Dec 2025 16:27:21 +0100
Message-ID: <20251203152409.405589383@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Long Li <longli@microsoft.com>

commit d062463edf1770427dc2d637df4088df4835aa47 upstream.

Hyper-V may offer a non latency sensitive device with subchannels without
monitor bit enabled. The decision is entirely on the Hyper-V host not
configurable within guest.

When a device has subchannels, also signal events for the subchannel
if its monitor bit is disabled.

This patch also removes the memory barrier when monitor bit is enabled
as it is not necessary. The memory barrier is only needed between
setting up interrupt mask and calling vmbus_set_event() when monitor
bit is disabled.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/1741644721-20389-1-git-send-email-longli@linuxonhyperv.com
Fixes: b15b7d2a1b09 ("uio_hv_generic: Let userspace take care of interrupt mask")
Closes: https://bugs.debian.org/1120602
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -80,9 +80,15 @@ hv_uio_irqcontrol(struct uio_info *info,
 {
 	struct hv_uio_private_data *pdata = info->priv;
 	struct hv_device *dev = pdata->device;
+	struct vmbus_channel *primary, *sc;
 
-	dev->channel->inbound.ring_buffer->interrupt_mask = !irq_state;
-	virt_mb();
+	primary = dev->channel;
+	primary->inbound.ring_buffer->interrupt_mask = !irq_state;
+
+	mutex_lock(&vmbus_connection.channel_mutex);
+	list_for_each_entry(sc, &primary->sc_list, sc_list)
+		sc->inbound.ring_buffer->interrupt_mask = !irq_state;
+	mutex_unlock(&vmbus_connection.channel_mutex);
 
 	return 0;
 }
@@ -93,11 +99,18 @@ hv_uio_irqcontrol(struct uio_info *info,
 static void hv_uio_channel_cb(void *context)
 {
 	struct vmbus_channel *chan = context;
-	struct hv_device *hv_dev = chan->device_obj;
-	struct hv_uio_private_data *pdata = hv_get_drvdata(hv_dev);
+	struct hv_device *hv_dev;
+	struct hv_uio_private_data *pdata;
 
 	virt_mb();
 
+	/*
+	 * The callback may come from a subchannel, in which case look
+	 * for the hv device in the primary channel
+	 */
+	hv_dev = chan->primary_channel ?
+		 chan->primary_channel->device_obj : chan->device_obj;
+	pdata = hv_get_drvdata(hv_dev);
 	uio_event_notify(&pdata->info);
 }
 


