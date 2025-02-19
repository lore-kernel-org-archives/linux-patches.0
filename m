Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE81DE89B;
	Wed, 19 Feb 2025 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954063; cv=none; b=lnrJwmRi7Osz6s4V4dmxMX49KOWL4iSAWrP27FasP8VuijaOWRTo5/u8qldeZx9R5CAkXrGw5XDK1OKvN/N3QRNUlHnXdnCNiZZm9HVpLbw4hhVSixzcO1Cmvqod4GFqbOosYtMm+3xHXXQ81F24fctZFqYKrMd+jJiiuxHkhy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954063; c=relaxed/simple;
	bh=UzLr0BHJUNTqaUBaPbe/CdS8W+lZqBtsuRbvgYcUAn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJxvceaU/bsaWyxe+Tz62EdIZ23dFD4QutGYJYxXvWZJt10KeSYnspyQoe/qNzM9/hWdrgenGn5RzQ9W0u3OJVwttt3J1+Id/4X9kIDcClDFw0+dSd4hYj6UwpGLmgcjEdq2x6YKU8oVykJrrOke4vKhNBkkOkC4QF8UK4QvC6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvwoHmD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvwoHmD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBFDC4CED1;
	Wed, 19 Feb 2025 08:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954063;
	bh=UzLr0BHJUNTqaUBaPbe/CdS8W+lZqBtsuRbvgYcUAn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvwoHmD8ALQsLcwly+ZY/ZAqnYDROhKfiiY99EJOPAcf2Rh1BgoFg2wyKNsEOSktj
	 VKIDri0BshouHvVuj8cl2EsPQ/vcq47XhNeJQGJbs1vCKqVWuROFcoX72obs6wEe7g
	 wcaePQ8nZcT9aBbA+ueRkiQlCz+Z5ZaKMLab3FO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Starks <jostarks@microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/274] Drivers: hv: vmbus: Wait for boot-time offers during boot and resume
Date: Wed, 19 Feb 2025 09:25:39 +0100
Message-ID: <20250219082612.949436698@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

[ Upstream commit 113386ca981c3997db6b83272c7ecf47456aeddb ]

Channel offers are requested during VMBus initialization and resume from
hibernation. Add support to wait for all boot-time channel offers to
be delivered and processed before returning from vmbus_request_offers.

This is in analogy to a PCI bus not returning from probe until it has
scanned all devices on the bus.

Without this, user mode can race with VMBus initialization and miss
channel offers. User mode has no way to work around this other than
sleeping for a while, since there is no way to know when VMBus has
finished processing boot-time offers.

With this added functionality, remove earlier logic which keeps track
of count of offered channels post resume from hibernation. Once all
offers delivered message is received, no further boot-time offers are
going to be received. Consequently, logic to prevent suspend from
happening after previous resume had missing offers, is also removed.

Co-developed-by: John Starks <jostarks@microsoft.com>
Signed-off-by: John Starks <jostarks@microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20250102130712.1661-2-namjain@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250102130712.1661-2-namjain@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 61 +++++++++++++++++++++++++++++----------
 drivers/hv/connection.c   |  4 +--
 drivers/hv/hyperv_vmbus.h | 14 ++-------
 drivers/hv/vmbus_drv.c    | 16 ----------
 4 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 3c6011a48dabe..6e084c2074141 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -944,16 +944,6 @@ void vmbus_initiate_unload(bool crash)
 		vmbus_wait_for_unload();
 }
 
-static void check_ready_for_resume_event(void)
-{
-	/*
-	 * If all the old primary channels have been fixed up, then it's safe
-	 * to resume.
-	 */
-	if (atomic_dec_and_test(&vmbus_connection.nr_chan_fixup_on_resume))
-		complete(&vmbus_connection.ready_for_resume_event);
-}
-
 static void vmbus_setup_channel_state(struct vmbus_channel *channel,
 				      struct vmbus_channel_offer_channel *offer)
 {
@@ -1109,8 +1099,6 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
 		/* Add the channel back to the array of channels. */
 		vmbus_channel_map_relid(oldchannel);
-		check_ready_for_resume_event();
-
 		mutex_unlock(&vmbus_connection.channel_mutex);
 		return;
 	}
@@ -1296,13 +1284,28 @@ EXPORT_SYMBOL_GPL(vmbus_hvsock_device_unregister);
 
 /*
  * vmbus_onoffers_delivered -
- * This is invoked when all offers have been delivered.
+ * The CHANNELMSG_ALLOFFERS_DELIVERED message arrives after all
+ * boot-time offers are delivered. A boot-time offer is for the primary
+ * channel for any virtual hardware configured in the VM at the time it boots.
+ * Boot-time offers include offers for physical devices assigned to the VM
+ * via Hyper-V's Discrete Device Assignment (DDA) functionality that are
+ * handled as virtual PCI devices in Linux (e.g., NVMe devices and GPUs).
+ * Boot-time offers do not include offers for VMBus sub-channels. Because
+ * devices can be hot-added to the VM after it is booted, additional channel
+ * offers that aren't boot-time offers can be received at any time after the
+ * all-offers-delivered message.
  *
- * Nothing to do here.
+ * SR-IOV NIC Virtual Functions (VFs) assigned to a VM are not considered
+ * to be assigned to the VM at boot-time, and offers for VFs may occur after
+ * the all-offers-delivered message. VFs are optional accelerators to the
+ * synthetic VMBus NIC and are effectively hot-added only after the VMBus
+ * NIC channel is opened (once it knows the guest can support it, via the
+ * sriov bit in the netvsc protocol).
  */
 static void vmbus_onoffers_delivered(
 			struct vmbus_channel_message_header *hdr)
 {
+	complete(&vmbus_connection.all_offers_delivered_event);
 }
 
 /*
@@ -1578,7 +1581,8 @@ void vmbus_onmessage(struct vmbus_channel_message_header *hdr)
 }
 
 /*
- * vmbus_request_offers - Send a request to get all our pending offers.
+ * vmbus_request_offers - Send a request to get all our pending offers
+ * and wait for all boot-time offers to arrive.
  */
 int vmbus_request_offers(void)
 {
@@ -1596,6 +1600,10 @@ int vmbus_request_offers(void)
 
 	msg->msgtype = CHANNELMSG_REQUESTOFFERS;
 
+	/*
+	 * This REQUESTOFFERS message will result in the host sending an all
+	 * offers delivered message after all the boot-time offers are sent.
+	 */
 	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_message_header),
 			     true);
 
@@ -1607,6 +1615,29 @@ int vmbus_request_offers(void)
 		goto cleanup;
 	}
 
+	/*
+	 * Wait for the host to send all boot-time offers.
+	 * Keeping it as a best-effort mechanism, where a warning is
+	 * printed if a timeout occurs, and execution is resumed.
+	 */
+	if (!wait_for_completion_timeout(&vmbus_connection.all_offers_delivered_event,
+					 secs_to_jiffies(60))) {
+		pr_warn("timed out waiting for all boot-time offers to be delivered.\n");
+	}
+
+	/*
+	 * Flush handling of offer messages (which may initiate work on
+	 * other work queues).
+	 */
+	flush_workqueue(vmbus_connection.work_queue);
+
+	/*
+	 * Flush workqueue for processing the incoming offers. Subchannel
+	 * offers and their processing can happen later, so there is no need to
+	 * flush that workqueue here.
+	 */
+	flush_workqueue(vmbus_connection.handle_primary_chan_wq);
+
 cleanup:
 	kfree(msginfo);
 
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index f001ae880e1db..8351360bba161 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -34,8 +34,8 @@ struct vmbus_connection vmbus_connection = {
 
 	.ready_for_suspend_event = COMPLETION_INITIALIZER(
 				  vmbus_connection.ready_for_suspend_event),
-	.ready_for_resume_event	= COMPLETION_INITIALIZER(
-				  vmbus_connection.ready_for_resume_event),
+	.all_offers_delivered_event = COMPLETION_INITIALIZER(
+				  vmbus_connection.all_offers_delivered_event),
 };
 EXPORT_SYMBOL_GPL(vmbus_connection);
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 52cb744b4d7fd..e4058af987316 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -287,18 +287,10 @@ struct vmbus_connection {
 	struct completion ready_for_suspend_event;
 
 	/*
-	 * The number of primary channels that should be "fixed up"
-	 * upon resume: these channels are re-offered upon resume, and some
-	 * fields of the channel offers (i.e. child_relid and connection_id)
-	 * can change, so the old offermsg must be fixed up, before the resume
-	 * callbacks of the VSC drivers start to further touch the channels.
+	 * Completed once the host has offered all boot-time channels.
+	 * Note that some channels may still be under process on a workqueue.
 	 */
-	atomic_t nr_chan_fixup_on_resume;
-	/*
-	 * vmbus_bus_resume() waits for "nr_chan_fixup_on_resume" to
-	 * drop to zero.
-	 */
-	struct completion ready_for_resume_event;
+	struct completion all_offers_delivered_event;
 };
 
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 2892b8da20a5e..bf5608a740561 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2427,11 +2427,6 @@ static int vmbus_bus_suspend(struct device *dev)
 	if (atomic_read(&vmbus_connection.nr_chan_close_on_suspend) > 0)
 		wait_for_completion(&vmbus_connection.ready_for_suspend_event);
 
-	if (atomic_read(&vmbus_connection.nr_chan_fixup_on_resume) != 0) {
-		pr_err("Can not suspend due to a previous failed resuming\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&vmbus_connection.channel_mutex);
 
 	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
@@ -2456,17 +2451,12 @@ static int vmbus_bus_suspend(struct device *dev)
 			pr_err("Sub-channel not deleted!\n");
 			WARN_ON_ONCE(1);
 		}
-
-		atomic_inc(&vmbus_connection.nr_chan_fixup_on_resume);
 	}
 
 	mutex_unlock(&vmbus_connection.channel_mutex);
 
 	vmbus_initiate_unload(false);
 
-	/* Reset the event for the next resume. */
-	reinit_completion(&vmbus_connection.ready_for_resume_event);
-
 	return 0;
 }
 
@@ -2502,14 +2492,8 @@ static int vmbus_bus_resume(struct device *dev)
 	if (ret != 0)
 		return ret;
 
-	WARN_ON(atomic_read(&vmbus_connection.nr_chan_fixup_on_resume) == 0);
-
 	vmbus_request_offers();
 
-	if (wait_for_completion_timeout(
-		&vmbus_connection.ready_for_resume_event, secs_to_jiffies(10)) == 0)
-		pr_err("Some vmbus device is missing after suspending?\n");
-
 	/* Reset the event for the next suspend. */
 	reinit_completion(&vmbus_connection.ready_for_suspend_event);
 
-- 
2.39.5



