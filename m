Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECCB26CE33;
	Fri, 21 Nov 2025 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732057; cv=none; b=ANXqjJE4EGNiau53686NRnnVXX4s6sRpE3Xk5Z5xMBar8oEs8Rr5pB6qvpjpCXYzCcyx89uu5sg1DViVFp2FHj+/EeKkzu0BOpDe9unWeIt86ceE41bLOvZreeQkztTDy9tkrCrHap9jUZv0E3ICMMdK59nEWuTPhk4yhpSxcQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732057; c=relaxed/simple;
	bh=tJg74wQt86hP6tqdaJQhoSLS8znsLaYF9W/4Pq9MDW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ3gAogdxHrjr8n7uwVEKO8mkLRElH+5ZKIuprz4nWRHhgSig9Iwg/pFVoUUO3qydhWEDiTrIGko4Dm7FvKHHjXhqncOyCCFL0QmhRGn1TTHKIYz6Z5/Qxzs2QJxqaaOldgPDqT/algiRlxKYNWdgYK7h4wY9zDCRJZ9MxHKVt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEZmKsVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEZmKsVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712D4C4CEF1;
	Fri, 21 Nov 2025 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732056;
	bh=tJg74wQt86hP6tqdaJQhoSLS8znsLaYF9W/4Pq9MDW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEZmKsVnHx/JAPe7Icdq69bzaRY87C7ij5JXeCD/s2X6hNNtVWQx45lmrgvAZXYEj
	 8pHMWXYewt47h1hlVAwxtrRmmWo3crizHhWI5OUK3aRgj6Bt6H42nNeaVqyHetugzH
	 WhaaT3Nnax0YrUWL2AV9IZAthMzmWgwgWS9BWIKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>
Subject: [PATCH 6.12 175/185] uio_hv_generic: Set event for all channels on the device
Date: Fri, 21 Nov 2025 14:13:22 +0100
Message-ID: <20251121130150.204542638@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Fixes: 37bd91f22794 ("uio_hv_generic: Let userspace take care of interrupt mask")
Cc: <stable@vger.kernel.org> # 6.12.x
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -65,6 +65,16 @@ struct hv_uio_private_data {
 	char	send_name[32];
 };
 
+static void set_event(struct vmbus_channel *channel, s32 irq_state)
+{
+	channel->inbound.ring_buffer->interrupt_mask = !irq_state;
+	if (!channel->offermsg.monitor_allocated && irq_state) {
+		/* MB is needed for host to see the interrupt mask first */
+		virt_mb();
+		vmbus_set_event(channel);
+	}
+}
+
 /*
  * This is the irqcontrol callback to be registered to uio_info.
  * It can be used to disable/enable interrupt from user space processes.
@@ -79,12 +89,15 @@ hv_uio_irqcontrol(struct uio_info *info,
 {
 	struct hv_uio_private_data *pdata = info->priv;
 	struct hv_device *dev = pdata->device;
+	struct vmbus_channel *primary, *sc;
 
-	dev->channel->inbound.ring_buffer->interrupt_mask = !irq_state;
-	virt_mb();
+	primary = dev->channel;
+	set_event(primary, irq_state);
 
-	if (!dev->channel->offermsg.monitor_allocated && irq_state)
-		vmbus_setevent(dev->channel);
+	mutex_lock(&vmbus_connection.channel_mutex);
+	list_for_each_entry(sc, &primary->sc_list, sc_list)
+		set_event(sc, irq_state);
+	mutex_unlock(&vmbus_connection.channel_mutex);
 
 	return 0;
 }
@@ -95,11 +108,18 @@ hv_uio_irqcontrol(struct uio_info *info,
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
 


