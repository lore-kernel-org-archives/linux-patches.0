Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE7822579E;
	Fri, 31 Oct 2025 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919387; cv=none; b=TsTV5XIPbPYmeRCdgNaQOyW9QuhmV/jTv+Ah1oA0SW94okDxILnuBw0vuxM60Mn2SIMOO2rGkVJq06Vunb9A172gaRUthOKagns7J+ogknaE4ClESusXk+nC9aSHlUBqto2Ou5JIsXtVMb51z+JcCE/PC9E7TX2XkEUxgHo9K54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919387; c=relaxed/simple;
	bh=46FFnr9WLF9i9H0srZJRWF7kyywIMd+cnzId3IhG+1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq31Ftb/dc6FvNW7q8lFbOUr4gFh44XFOlrStJdA6WO8vvHZcHfFyOMECNk6DdLZ56WPD/aRQanV7TjuRLewO6RtxD4qSC76+NgjL7yxN96wUIYewQkfnTmBvKkTps4ZS9Nh7/W3HZBl1uI7snGpj4ePCeL2EnA29u8oAmQAHMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyJAKxRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyJAKxRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF1AC4CEE7;
	Fri, 31 Oct 2025 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919386;
	bh=46FFnr9WLF9i9H0srZJRWF7kyywIMd+cnzId3IhG+1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyJAKxRcMDF7KxI7KS5alVN5JxeZT30QHsoL0+MZQyZnLUvZ2Ul8BHDWbyFERWn5w
	 /UExs/wr2aFNbDU2pNzyQu7AbCz/FvK2BXMHEgzvOYbpbM21XbaCXqvFeTuPvnCMd7
	 DZy3VrIhxro7xcG4M8gwe5I8VxCv2850bmLxSdts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/32] xhci: dbc: poll at different rate depending on data transfer activity
Date: Fri, 31 Oct 2025 15:01:17 +0100
Message-ID: <20251031140043.003030045@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit fb18e5bb96603cc79d97f03e4c05f3992cf28624 ]

DbC driver starts polling for events immediately when DbC is enabled.
The current polling interval is 1ms, which keeps the CPU busy, impacting
power management even when there are no active data transfers.

Solve this by polling at a slower rate, with a 64ms interval as default
until a transfer request is queued, or if there are still are pending
unhandled transfers at event completion.

Tested-by: Uday M Bhat <uday.m.bhat@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240229141438.619372-9-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f3d12ec847b9 ("xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |   13 +++++++++++--
 drivers/usb/host/xhci-dbgcap.h |    2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -665,7 +665,8 @@ static int xhci_dbc_start(struct xhci_db
 		return ret;
 	}
 
-	return mod_delayed_work(system_wq, &dbc->event_work, 1);
+	return mod_delayed_work(system_wq, &dbc->event_work,
+				msecs_to_jiffies(dbc->poll_interval));
 }
 
 static void xhci_dbc_stop(struct xhci_dbc *dbc)
@@ -964,8 +965,10 @@ static void xhci_dbc_handle_events(struc
 	enum evtreturn		evtr;
 	struct xhci_dbc		*dbc;
 	unsigned long		flags;
+	unsigned int		poll_interval;
 
 	dbc = container_of(to_delayed_work(work), struct xhci_dbc, event_work);
+	poll_interval = dbc->poll_interval;
 
 	spin_lock_irqsave(&dbc->lock, flags);
 	evtr = xhci_dbc_do_handle_events(dbc);
@@ -981,13 +984,18 @@ static void xhci_dbc_handle_events(struc
 			dbc->driver->disconnect(dbc);
 		break;
 	case EVT_DONE:
+		/* set fast poll rate if there are pending data transfers */
+		if (!list_empty(&dbc->eps[BULK_OUT].list_pending) ||
+		    !list_empty(&dbc->eps[BULK_IN].list_pending))
+			poll_interval = 1;
 		break;
 	default:
 		dev_info(dbc->dev, "stop handling dbc events\n");
 		return;
 	}
 
-	mod_delayed_work(system_wq, &dbc->event_work, 1);
+	mod_delayed_work(system_wq, &dbc->event_work,
+			 msecs_to_jiffies(poll_interval));
 }
 
 static ssize_t dbc_show(struct device *dev,
@@ -1242,6 +1250,7 @@ xhci_alloc_dbc(struct device *dev, void
 	dbc->idVendor = DBC_VENDOR_ID;
 	dbc->bcdDevice = DBC_DEVICE_REV;
 	dbc->bInterfaceProtocol = DBC_PROTOCOL;
+	dbc->poll_interval = DBC_POLL_INTERVAL_DEFAULT;
 
 	if (readl(&dbc->regs->control) & DBC_CTRL_DBC_ENABLE)
 		goto err;
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -93,6 +93,7 @@ struct dbc_ep {
 
 #define DBC_QUEUE_SIZE			16
 #define DBC_WRITE_BUF_SIZE		8192
+#define DBC_POLL_INTERVAL_DEFAULT	64	/* milliseconds */
 
 /*
  * Private structure for DbC hardware state:
@@ -139,6 +140,7 @@ struct xhci_dbc {
 
 	enum dbc_state			state;
 	struct delayed_work		event_work;
+	unsigned int			poll_interval;	/* ms */
 	unsigned			resume_required:1;
 	struct dbc_ep			eps[2];
 


