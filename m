Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D81639C00E;
	Thu, 30 Jul 2026 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425223; cv=none; b=W6C63ZILz/uCXkltqr2C3b7S0Yt+AJIdRzdYfNU/pXizPqP4zaWPVAIHuswDnDy2vMXQ7CE1l+3/6ocscbCTFsQLUR0cJmiQcFQg8tLhmLtzZd5Y4B3OwcoXejT38FUvbBVLwkC0n71FxcbSWc8O15z7EaPzUTdQSXEdmGPNLRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425223; c=relaxed/simple;
	bh=QIozZ1mLVlaL1g8f3+4fwF363nJc0gcJMnRFRmMoDT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j11PWGsHFKetDXhiPr+gIw47txMRyL0TxyDN14CcBs4/FhqqHxGwaRQGNnwyRhFgNqDfL1z8zQrCEglUytw7nfFpsMSsYhb6WQTZ0aIpqA3a19Lgt1sLpkFwXCWzXdj7ya8/ELXzU1WqVpFUzd+Ff3xf7To1CDPbkC4Og+Atp9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bra+gkg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bra+gkg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05BD1F00A3F;
	Thu, 30 Jul 2026 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425222;
	bh=gJYDW3OwxTa2iumhDxkTM7Nkg6DNQwtjscIta1HDUSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bra+gkg1MCwAz4aw5e+LN6lU5sSK35rN5Wn1zHZRvQyORA6fXWhlf2v1w+DwVhJ2U
	 b7Gkt3xv6ueIQ/EwTIDuvDzy3/XaMnx8SXeNBYPMPYb+lyWkA0cIrJInu8to2HNxoV
	 mxUylyguRPUICYHsZ6GnaRaFJI+y7kdWIWDyY+Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 666/675] i3c: mipi-i3c-hci: Fix handling of shared IRQs during early initialization
Date: Thu, 30 Jul 2026 16:16:36 +0200
Message-ID: <20260730141459.311675288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c6396b835a5e599c4df656112140f065bb544a24 ]

Shared interrupts may fire unexpectedly, including during periods when the
controller is not yet fully initialized. Commit b9a15012a1452
("i3c: mipi-i3c-hci: Add optional Runtime PM support") addressed this issue
for the runtime-suspended state, but the same problem can also occur before
the bus is enabled for the first time.

Ensure the IRQ handler ignores interrupts until initialization is complete
by making consistent use of the existing irq_inactive flag.  The flag is
now set to false immediately before enabling the bus.

To guarantee correct ordering with respect to the IRQ handler, protect
all transitions of irq_inactive with the same spinlock used inside the
handler.

Fixes: b8460480f62e1 ("i3c: mipi-i3c-hci: Allow for Multi-Bus Instances")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-14-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c |   13 +++++++++++++
 drivers/i3c/master/mipi-i3c-hci/hci.h  |    1 +
 2 files changed, 14 insertions(+)

--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -147,6 +147,8 @@ static int i3c_hci_bus_init(struct i3c_m
 	if (hci->quirks & HCI_QUIRK_RESP_BUF_THLD)
 		amd_set_resp_buf_thld(hci);
 
+	WRITE_ONCE(hci->irq_inactive, false);
+
 	/* Enable bus with Hot-Join disabled */
 	reg_set(HC_CONTROL, HC_CONTROL_BUS_ENABLE | HC_CONTROL_HOT_JOIN_CTRL);
 	dev_dbg(&hci->master.dev, "HC_CONTROL = %#x", reg_read(HC_CONTROL));
@@ -537,6 +539,15 @@ static irqreturn_t i3c_hci_irq_handler(i
 	irqreturn_t result = IRQ_NONE;
 	u32 val;
 
+	/*
+	 * The IRQ can be shared, so the handler may be called when the IRQ is
+	 * due to a different device. That could happen before the controller
+	 * has been initialized, so exit immediately if IRQs are not expected
+	 * for this device.
+	 */
+	if (READ_ONCE(hci->irq_inactive))
+		return IRQ_NONE;
+
 	val = reg_read(INTR_STATUS);
 	reg_write(INTR_STATUS, val);
 	dev_dbg(&hci->master.dev, "INTR_STATUS %#x", val);
@@ -776,6 +787,8 @@ static int i3c_hci_probe(struct platform
 	if (ret)
 		return ret;
 
+	WRITE_ONCE(hci->irq_inactive, true);
+
 	irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, irq, i3c_hci_irq_handler,
 			       IRQF_SHARED, NULL, hci);
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -46,6 +46,7 @@ struct i3c_hci {
 	void *io_data;
 	const struct hci_cmd_ops *cmd;
 	spinlock_t lock;
+	bool irq_inactive;
 	struct mutex control_mutex;
 	atomic_t next_cmd_tid;
 	u32 caps;


