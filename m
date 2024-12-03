Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CD31E3DF9;
	Tue,  3 Dec 2024 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242344; cv=none; b=oy0+n2/KOvzMJF1zzG7+VJIJLooF5BN4vW5DBkrm5JQGB20+0zyRpsuYfKm6Zv3lPQma8c4YbzlMiwafUFoENG5GfGOKpA4WSHSLnyGW0bhj2mQV0BMj0lhcoY9HlaDIyfZONaM92B1vgg5mLYt5/cGoPAjFUHeKTh5XvFpZzAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242344; c=relaxed/simple;
	bh=JoCh0g+u6T4wFMS+mCi+ey0uloxgeXS9JjQ02e8tJE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiLjhyNQLx6pufkLtsFhC2S30x20xMNmhJYTrHTw1l+IYzQGF+6vJo+JcJv1indp/rY+M6xJhYn77Rh6bcUUX4qiUanj+ofFXUgWvNKkiRZTIzzdvmcCg7p7/vfQaovqkj3tV7kI9UNTpHhbK2NDFvO+SPPIRnigyrOiMSthMvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbhgjBpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbhgjBpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A310DC4CECF;
	Tue,  3 Dec 2024 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242344;
	bh=JoCh0g+u6T4wFMS+mCi+ey0uloxgeXS9JjQ02e8tJE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbhgjBpRwstQqiZMr6scfyECHKth2PyjgR6BNztY2ptMJJPzTvIudHiZEc2jJlaNB
	 Uy66Jn4wbFWRqwNDDm2UYQsdLn2ZLsWE/SXwJvrHtqqnEdiZUE9kMgPIjfOCRMVjzo
	 2Y/qDT6qyw0PKKTf6npaDfYffyTVPvvvnFG5xD1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 677/826] usb: xhci: Limit Stop Endpoint retries
Date: Tue,  3 Dec 2024 15:46:44 +0100
Message-ID: <20241203144810.163125261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michal Pecio <michal.pecio@gmail.com>

commit 42b7581376015c1bbcbe5831f043cd0ac119d028 upstream.

Some host controllers fail to atomically transition an endpoint to the
Running state on a doorbell ring and enter a hidden "Restarting" state,
which looks very much like Stopped, with the important difference that
it will spontaneously transition to Running anytime soon.

A Stop Endpoint command queued in the Restarting state typically fails
with Context State Error and the completion handler sees the Endpoint
Context State as either still Stopped or already Running. Even a case
of Halted was observed, when an error occurred right after the restart.

The Halted state is already recovered from by resetting the endpoint.
The Running state is handled by retrying Stop Endpoint.

The Stopped state was recognized as a problem on NEC controllers and
worked around also by retrying, because the endpoint soon restarts and
then stops for good. But there is a risk: the command may fail if the
endpoint is "stopped for good" already, and retries will fail forever.

The possibility of this was not realized at the time, but a number of
cases were discovered later and reproduced. Some proved difficult to
deal with, and it is outright impossible to predict if an endpoint may
fail to ever start at all due to a hardware bug. One such bug (albeit
on ASM3142, not on NEC) was found to be reliably triggered simply by
toggling an AX88179 NIC up/down in a tight loop for a few seconds.

An endless retries storm is quite nasty. Besides putting needless load
on the xHC and CPU, it causes URBs never to be given back, paralyzing
the device and connection/disconnection logic for the whole bus if the
device is unplugged. User processes waiting for URBs become unkillable,
drivers and kworker threads lock up and xhci_hcd cannot be reloaded.

For peace of mind, impose a timeout on Stop Endpoint retries in this
case. If they don't succeed in 100ms, consider the endpoint stopped
permanently for some reason and just give back the unlinked URBs. This
failure case is rare already and work is under way to make it rarer.

Start this work today by also handling one simple case of race with
Reset Endpoint, because it costs just two lines to implement.

Fixes: fd9d55d190c0 ("xhci: retry Stop Endpoint on buggy NEC controllers")
CC: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-32-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   28 ++++++++++++++++++++++++----
 drivers/usb/host/xhci.c      |    2 ++
 drivers/usb/host/xhci.h      |    1 +
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -52,6 +52,7 @@
  *   endpoint rings; it generates events on the event ring for these.
  */
 
+#include <linux/jiffies.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
@@ -1151,16 +1152,35 @@ static void xhci_handle_cmd_stop_ep(stru
 			return;
 		case EP_STATE_STOPPED:
 			/*
-			 * NEC uPD720200 sometimes sets this state and fails with
-			 * Context Error while continuing to process TRBs.
-			 * Be conservative and trust EP_CTX_STATE on other chips.
+			 * Per xHCI 4.6.9, Stop Endpoint command on a Stopped
+			 * EP is a Context State Error, and EP stays Stopped.
+			 *
+			 * But maybe it failed on Halted, and somebody ran Reset
+			 * Endpoint later. EP state is now Stopped and EP_HALTED
+			 * still set because Reset EP handler will run after us.
+			 */
+			if (ep->ep_state & EP_HALTED)
+				break;
+			/*
+			 * On some HCs EP state remains Stopped for some tens of
+			 * us to a few ms or more after a doorbell ring, and any
+			 * new Stop Endpoint fails without aborting the restart.
+			 * This handler may run quickly enough to still see this
+			 * Stopped state, but it will soon change to Running.
+			 *
+			 * Assume this bug on unexpected Stop Endpoint failures.
+			 * Keep retrying until the EP starts and stops again, on
+			 * chips where this is known to help. Wait for 100ms.
 			 */
 			if (!(xhci->quirks & XHCI_NEC_HOST))
 				break;
+			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
+				break;
 			fallthrough;
 		case EP_STATE_RUNNING:
 			/* Race, HW handled stop ep cmd before ep was running */
-			xhci_dbg(xhci, "Stop ep completion ctx error, ep is running\n");
+			xhci_dbg(xhci, "Stop ep completion ctx error, ctx_state %d\n",
+					GET_EP_CTX_STATE(ep_ctx));
 
 			command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
 			if (!command) {
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -8,6 +8,7 @@
  * Some code borrowed from the Linux EHCI driver.
  */
 
+#include <linux/jiffies.h>
 #include <linux/pci.h>
 #include <linux/iommu.h>
 #include <linux/iopoll.h>
@@ -1777,6 +1778,7 @@ static int xhci_urb_dequeue(struct usb_h
 			ret = -ENOMEM;
 			goto done;
 		}
+		ep->stop_time = jiffies;
 		ep->ep_state |= EP_STOP_CMD_PENDING;
 		xhci_queue_stop_endpoint(xhci, command, urb->dev->slot_id,
 					 ep_index, 0);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -690,6 +690,7 @@ struct xhci_virt_ep {
 	/* Bandwidth checking storage */
 	struct xhci_bw_info	bw_info;
 	struct list_head	bw_endpoint_list;
+	unsigned long		stop_time;
 	/* Isoch Frame ID checking storage */
 	int			next_frame_id;
 	/* Use new Isoch TRB layout needed for extended TBC support */


