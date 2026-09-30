Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64A4F96C5;
	Wed, 30 Sep 2026 15:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782593; cv=none; b=CbjpyUaMnarrdKO5/XGHSAHV+cCz9V/Lx4QjKmCJslEbMqd1VqfUoQiK3nzRmtyk6FYx5qT+83vHYqaN+EJOFd0aw0vRzoU3sfkfoiu77uAPytPU/Rr2G2tx6mHQ71X2v4/SlYLnQ0Ja752YR9fj8Ac85bxbM+A/PG9+/lyFeIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782593; c=relaxed/simple;
	bh=R6kxFUNYwKZY7u3VbkZJ9Eal94bbyDtOuVsHJiHIzU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYSy2OVioe85/I62oNgip09PDhkm8pgZxtin2VxhxWbWX5U5o/+rB3hoaYREfXvZI8cnBKpVOhu1EJY4Fo3yWrXjLz4P7TwsYSJhS0cUvoPZODw1OMsl251sjkCMgYh1elBkSupldmrUt48lXMsj/70xxfHbSxcNMkZyFIYi7H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5/bX1ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5/bX1ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71D21F00898;
	Wed, 30 Sep 2026 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782584;
	bh=OYoooR5LfEDOuBRgOwxIYPnTZFY9+ixUAJGqV1WSeVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5/bX1ldEEsU29+UOFnl9DrSS6k8a5jTetJVIngccxMF8eZRstAzPACWCR8T7Pamz
	 MDuJajxhq/5N+N6FD3tohC21jTM8WoF6QWb7kqj7EKbGGKXU8DtSweuVM3FGydkjtH
	 60gk5R0caYLEQ+BLMV2RtZqNF66nfNtfpSaR21DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/595] xhci: Prevent queuing new commands if xhci is inaccessible
Date: Wed, 30 Sep 2026 17:19:50 +0200
Message-ID: <20260930152349.824831642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 67804954e146a..0e0045a81f92e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4199,6 +4199,7 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 			 u32 field3, u32 field4, bool command_must_succeed)
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	int ret;
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
@@ -4208,6 +4209,11 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
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
index 2cc27dba08e2d..4d33130f1378a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1034,6 +1034,10 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
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



