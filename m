Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A628E37EFFB;
	Thu, 17 Sep 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667816; cv=none; b=iNEolJSHloxVuR4uOSEPvR8xJTf2PWty/uw2+LJ1HXcbuimOJ/nf6zc4/iwsnaBKN0L9SoRtD4bObQX4fe3Rj06MJZoUi7Ff8nW88QurS52xaq74zLVIbBI7XQmGYZUtqBgrEOfj1V3eoE6DeWRK9IrE5blaDNBcNcK9DslquG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667816; c=relaxed/simple;
	bh=uq/aTSjUH3hsf8NZ2bNORxbIUdIkD9HpAZ3vE5fnPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMsMNzk0796XI4V8upEDNps6np2/6mqhrmC/BGT/zPYR/T7KEA2BskYCOSFao0VjeX05sNXT+HIU3NeBI6u5pJv71mrZlp4Jf30HQ/jinfutzEHToN5ddVKtP82Hto+oTCZpo7t/3AOm8c7yfUOSSVahyuoiSvm7iZr4NgpkX20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY1uGqWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY1uGqWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695931F000FF;
	Thu, 17 Sep 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667814;
	bh=HohVtmlBBDeM4eqgUhS4I2FIVxYQltmAJJUVvX+y25c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tY1uGqWcftLgqUd8cg/h3dcYyMGRHIhFgBKRf6tQySUNZhFJ3Okr05iOhnmXjGZNG
	 YCp/X2h64LjLypZ4YkSMP6zzqy4tQBS47f174xnkUkgFjboKX2JHibEB/S1MDs3MgG
	 TReBXur/j0fWSAAl8MdLoaQI46CdxI6GlR8AdfrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0219/1102] xhci: Prevent queuing new commands if xhci is inaccessible
Date: Thu, 17 Sep 2026 16:02:42 +0100
Message-ID: <20260917151545.076563538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 169c126067e87..22282e0489630 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4402,6 +4402,7 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 			 u32 field3, u32 field4, bool command_must_succeed)
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	int ret;
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
@@ -4411,6 +4412,11 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
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
index a50e813dda13a..b4556ba155d64 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -906,6 +906,10 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
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



