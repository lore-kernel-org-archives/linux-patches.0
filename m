Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF634F93C0;
	Thu, 17 Sep 2026 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664263; cv=none; b=lNk5PsbY4mMZBiPtu4EBSkOgg+rRg0JVzcLXHyhpXXehNb24oyXx2KguhkXbJziajQ3WOU4tf8OS2o8h4o4ylftPbgKnVi3AhiwAXX/Gn+3cJF9dvp+kevLk/gh0U8ymm2GwIZrAuXXsK+Aw2IOlenitnrZpHrM4dBvHW9J/FdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664263; c=relaxed/simple;
	bh=MgoUMykwTHjehur9ahNSsrwdncb/wcE7lebm5wkCpkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXzxg3ZZxafo5izepY3/bbDg2b33p2vXOlme82jvsSFt5mrkbE4tEBDBj0sK7IdN3Sq59U155S3My4kPfrVIkbYQRnQmF5DO5wC+xbCM+jJBJwak7Vh4rXl8Dhl4jU2uPgrPu6oJWBtJDC2uGkVFqcY9T5p8TdwE+nGaEVwM1G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUkY+O2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUkY+O2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF681F000FF;
	Thu, 17 Sep 2026 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664261;
	bh=s9Wgt8slQS3To78CXxAUilc6hcYZuMrACFdQWb7BU00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUkY+O2BlMU9ZndxutTFfeglV7arHewmbhhDPqY7mnuyjk6BZXJFE38F+tDW4rlJI
	 J1PUi90wUveP6dx+h9hAzf64VIxc8aBB20hrse+GAAkXPR34TEuUpcxYprw9Fse4U4
	 Kqq18pGazpb4AebMFSh44M/izg4us7jEp+p/XDxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0313/1250] xhci: Prevent queuing new commands if xhci is inaccessible
Date: Thu, 17 Sep 2026 16:01:48 +0100
Message-ID: <20260917151600.586671190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5624765fb6645..6ce5874fc4b3d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4414,6 +4414,7 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 			 u32 field3, u32 field4, bool command_must_succeed)
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	int ret;
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
@@ -4423,6 +4424,11 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
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
index 72f7da2ed5c47..14eeb16f668b2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1012,6 +1012,10 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
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



