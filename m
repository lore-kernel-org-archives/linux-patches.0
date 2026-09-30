Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C504FE2E6;
	Wed, 30 Sep 2026 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784425; cv=none; b=LPZsDBKUerCQi/wfWvbRkNjUwlOxtjCX9+/19k6TQ2EjNmEOSP7+Ltepy3iIP4A12OCWWhSIMgQFiqvElfTynu0SUnq7Oo+uIh2QwU66/TmazXaPBo33y7od9vYHbBxKtk9424vgoYQr8U06IdFDs1a2VTqpEVXYEQQHiyTD6Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784425; c=relaxed/simple;
	bh=SD+4/0BUu2NrUKQUTdyJNkPTMXvAovy47rYwGvbt9PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtdBbUW/fuXsOxjwM9TQLSXN6r/BkEWOmyALHfSo9/ABtF0/R7ym8UF1JRasgBv40pYc8Fc7wYrepC6UCfDF8jZZh8fE+dgkg2gRFnXGpw5/ZxNHOMg3aac8oa3/1K05pNl7tz7IOUkPB+5tuY5IY/C6PU8f747vjHOzHCaJSH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kh/RZUUV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kh/RZUUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB21F000FF;
	Wed, 30 Sep 2026 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784420;
	bh=4/V0FLAUga9V3Yb2AewrWxsFP3sMyIttim3kqk8TbnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kh/RZUUVNgwUQz9i56Y5NKv1myCmkkz0+FCo/PTh1OIx1lk6kJIbELA4pZWzXH9c5
	 FDS/10U+55Q3Lm9TaOtQd1IKGPvCuMh8fZjsfdIz/ScdOSe4b9ttKBjhGtxAXpMyvl
	 IRNHoqwLQBHXOJcdt0T/1mXWeGo24K0qVkzCjcJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/982] xhci: Prevent queuing new commands if xhci is inaccessible
Date: Wed, 30 Sep 2026 17:14:44 +0200
Message-ID: <20260930152419.995297733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 82b70c799281cc24506085be978b829149ba0ca4 ]

Refuse to queue a new command on the command ring if xHC is marked
inaccessible with the HCD_FLAG_HW_ACCESSIBLE.

HCD_FLAG_HW_ACCESSIBLE is set and cleared in suspend and resume.

Also print a warning if xhci is being suspended with commands
still pending on the command ring.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260603091132.1110849-13-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 6 ++++++
 drivers/usb/host/xhci.c      | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index b0da53e9037ed..3f34aa004bc98 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4429,6 +4429,7 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 			 u32 field3, u32 field4, bool command_must_succeed)
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	int ret;
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
@@ -4438,6 +4439,11 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 		return -ESHUTDOWN;
 	}
 
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		xhci_warn(xhci, "Can't queue command, xHC not accessible\n");
+		return -ESHUTDOWN;
+	}
+
 	if (!command_must_succeed)
 		reserved_trbs++;
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 37fb2491d88f2..104ee26b27aa4 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1062,6 +1062,10 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 	/* step 1: stop endpoint */
 	/* skipped assuming that port suspend has done */
 
+	/* Check if command ring is empty */
+	if (!list_empty(&xhci->cmd_list))
+		xhci_warn(xhci, "Suspending and stopping xHC with pending command!\n");
+
 	/* step 2: clear Run/Stop bit */
 	command = readl(&xhci->op_regs->command);
 	command &= ~CMD_RUN;
-- 
2.53.0



