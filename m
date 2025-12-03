Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB4342537;
	Wed,  3 Dec 2025 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777449; cv=none; b=EO0/vBlKOgCDYnGSC5b8PKR9ninAgq30ljUi/K8Da+X+aFODIY8PTI0cLY5A9DriiU37czTaOUSFe8w2QE7KoZ+DjeNWk97wgSuPiimE6Xb5iO+QqhQgsycchxiauvl9TblRZRfs3QC47nuxbx+/Chwpk8HeP06x4g2AnBbVtds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777449; c=relaxed/simple;
	bh=8VijYYln5Nc0fNysQ4T3vKjXR8rmMCQZ4tbwPStzDw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TE47X/GKhR+EZB9scPzG5KGsmOHEQ0erILAzV0PmloQfDlqXKpDlHGLMnUzySdWzcDmtcADP3XXZbrXaSlzWY28+EKiveWJBFONWSuVrZHftm2HyYdWcJko12tLtDtoqt33uFgJ6Zjt9KxMxRl89nSEn7bqaDZxq+YgiZih7uTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XS8a/6uK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XS8a/6uK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C01C4CEF5;
	Wed,  3 Dec 2025 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777448;
	bh=8VijYYln5Nc0fNysQ4T3vKjXR8rmMCQZ4tbwPStzDw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XS8a/6uK1EZTzVh+Q74UKYv6iTt9g6uhtQ/XmhUwVEd9yCO5+Yu7Jjg73ECk8YK8Q
	 MzpjR5UTR+jdVKSl6/aUFNM0H55AA3Oi3UpIQZ1sNVXWa5bF8m50OSTb6tUhIxPW+O
	 HPTy1CS3J0TqvaqsMVnGmZNExwDz8eVIUateFdco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/392] xhci: dbc: poll at different rate depending on data transfer activity
Date: Wed,  3 Dec 2025 16:23:11 +0100
Message-ID: <20251203152415.621696677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,6 +139,7 @@ struct xhci_dbc {
 
 	enum dbc_state			state;
 	struct delayed_work		event_work;
+	unsigned int			poll_interval;	/* ms */
 	unsigned			resume_required:1;
 	struct dbc_ep			eps[2];
 


