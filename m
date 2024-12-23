Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B71F13BC0C;
	Mon, 23 Dec 2024 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969785; cv=none; b=IdQnYNqaiq1y4IU3yv7mvvQDwX29Q1zsNfForwN/dV1NM3MyeqXaY3jXls0aeVIA8TQHdxJ6dKGDYOaj6vdmclk6+lSCilJXGQh/KgOBtSb3jWG5uHptEKvb6B02Va4xJOREBxaSnN3GtiyWPxO/frmWaalaOsj8xuUMGuvXOkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969785; c=relaxed/simple;
	bh=eE9YQ5gUDdZx5SSXaKIVhZ7YXMDdkJFDoyBoKv8cYow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqqV/Vw7EMIn+dnMZ9gonIEOGU1/xQQhWfbEa4UMWRNs9JYrMDSZNDsowLIOAU5IL/9HMB7fwHmF5O9+q/9AaWgaA89l+cWxaT168UWFMKjHrCh86Ndiclfl3XeU9oFM92awaGgFP3yA3tD8/NW/PdgCUdi9shbrsIOeIsRfgTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rm1pm86y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rm1pm86y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26003C4CED3;
	Mon, 23 Dec 2024 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969784;
	bh=eE9YQ5gUDdZx5SSXaKIVhZ7YXMDdkJFDoyBoKv8cYow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rm1pm86yRSHqx/iLo9mmZbTPB/7uOwFIq8v5la5diUsYXKNShNHU9TJou2/qIOS4c
	 D5InUFzy3X5AAr24Patoc7DiT/GLiHgjj3elbJ9J4g29+2A8kvqBMxPB2oGdmc9Pfg
	 EdnDLQpEhTKiNUWnEQHar2TdHqvF6Ms4rxaUWPs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/160] can: m_can: fix missed interrupts with m_can_pci
Date: Mon, 23 Dec 2024 16:57:46 +0100
Message-ID: <20241223155410.809514219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 743375f8deee360b0e902074bab99b0c9368d42f ]

The interrupt line of PCI devices is interpreted as edge-triggered,
however the interrupt signal of the m_can controller integrated in Intel
Elkhart Lake CPUs appears to be generated level-triggered.

Consider the following sequence of events:

- IR register is read, interrupt X is set
- A new interrupt Y is triggered in the m_can controller
- IR register is written to acknowledge interrupt X. Y remains set in IR

As at no point in this sequence no interrupt flag is set in IR, the
m_can interrupt line will never become deasserted, and no edge will ever
be observed to trigger another run of the ISR. This was observed to
result in the TX queue of the EHL m_can to get stuck under high load,
because frames were queued to the hardware in m_can_start_xmit(), but
m_can_finish_tx() was never run to account for their successful
transmission.

On an Elkhart Lake based board with the two CAN interfaces connected to
each other, the following script can reproduce the issue:

    ip link set can0 up type can bitrate 1000000
    ip link set can1 up type can bitrate 1000000

    cangen can0 -g 2 -I 000 -L 8 &
    cangen can0 -g 2 -I 001 -L 8 &
    cangen can0 -g 2 -I 002 -L 8 &
    cangen can0 -g 2 -I 003 -L 8 &
    cangen can0 -g 2 -I 004 -L 8 &
    cangen can0 -g 2 -I 005 -L 8 &
    cangen can0 -g 2 -I 006 -L 8 &
    cangen can0 -g 2 -I 007 -L 8 &

    cangen can1 -g 2 -I 100 -L 8 &
    cangen can1 -g 2 -I 101 -L 8 &
    cangen can1 -g 2 -I 102 -L 8 &
    cangen can1 -g 2 -I 103 -L 8 &
    cangen can1 -g 2 -I 104 -L 8 &
    cangen can1 -g 2 -I 105 -L 8 &
    cangen can1 -g 2 -I 106 -L 8 &
    cangen can1 -g 2 -I 107 -L 8 &

    stress-ng --matrix 0 &

To fix the issue, repeatedly read and acknowledge interrupts at the
start of the ISR until no interrupt flags are set, so the next incoming
interrupt will also result in an edge on the interrupt line.

While we have received a report that even with this patch, the TX queue
can become stuck under certain (currently unknown) circumstances on the
Elkhart Lake, this patch completely fixes the issue with the above
reproducer, and it is unclear whether the remaining issue has a similar
cause at all.

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/fdf0439c51bcb3a46c21e9fb21c7f1d06363be84.1728288535.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c     | 22 +++++++++++++++++-----
 drivers/net/can/m_can/m_can.h     |  1 +
 drivers/net/can/m_can/m_can_pci.c |  1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 67c404fbe166..97cd8bbf2e32 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1220,20 +1220,32 @@ static void m_can_coalescing_update(struct m_can_classdev *cdev, u32 ir)
 static int m_can_interrupt_handler(struct m_can_classdev *cdev)
 {
 	struct net_device *dev = cdev->net;
-	u32 ir;
+	u32 ir = 0, ir_read;
 	int ret;
 
 	if (pm_runtime_suspended(cdev->dev))
 		return IRQ_NONE;
 
-	ir = m_can_read(cdev, M_CAN_IR);
+	/* The m_can controller signals its interrupt status as a level, but
+	 * depending in the integration the CPU may interpret the signal as
+	 * edge-triggered (for example with m_can_pci). For these
+	 * edge-triggered integrations, we must observe that IR is 0 at least
+	 * once to be sure that the next interrupt will generate an edge.
+	 */
+	while ((ir_read = m_can_read(cdev, M_CAN_IR)) != 0) {
+		ir |= ir_read;
+
+		/* ACK all irqs */
+		m_can_write(cdev, M_CAN_IR, ir);
+
+		if (!cdev->irq_edge_triggered)
+			break;
+	}
+
 	m_can_coalescing_update(cdev, ir);
 	if (!ir)
 		return IRQ_NONE;
 
-	/* ACK all irqs */
-	m_can_write(cdev, M_CAN_IR, ir);
-
 	if (cdev->ops->clear_interrupts)
 		cdev->ops->clear_interrupts(cdev);
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 92b2bd8628e6..ef39e8e527ab 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -99,6 +99,7 @@ struct m_can_classdev {
 	int pm_clock_support;
 	int pm_wake_source;
 	int is_peripheral;
+	bool irq_edge_triggered;
 
 	// Cached M_CAN_IE register content
 	u32 active_interrupts;
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index d72fe771dfc7..9ad7419f88f8 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -127,6 +127,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->pm_clock_support = 1;
 	mcan_class->pm_wake_source = 0;
 	mcan_class->can.clock.freq = id->driver_data;
+	mcan_class->irq_edge_triggered = true;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
-- 
2.39.5



