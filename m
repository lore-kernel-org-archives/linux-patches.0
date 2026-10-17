Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BE5377A97;
	Sat, 17 Oct 2026 16:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253883; cv=none; b=mh+jL0zvBFwQ6fS5h+jS73z5aZvFvO9Sia/J1DOwxKMx0Ip+KzV10XqomphSuS2aIL42hghJuBPBGLp0a429AjNFLtvlvPm1WLX+Kcuxo6197m9YvuU9AROnsm1iUM/Eka6Pfcipb5P8LYB2tJy1TjdiFJairnd20QzjSgJiKlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253883; c=relaxed/simple;
	bh=2pYY9r0yHoJRd45AEK/m3TBEAhRwiNcL74A8qWDOW8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL3+LgPUxM3hDCUd4Fe7SbZ6B1FllNzKjbXiELTgwEqQtrLfDZta+nMSfH/Yr6JcM5hNJnhs86bq1YqLVGWKcaQ6Ni1Jr9Kr6TYfzG0wKA3fCyfnr/yMIxtGEVZDVOTx7e4ftmAH0tR1c4D1olIyd8V92vrjLpjuMEcrzBX6ALI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPjiMz0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPjiMz0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D0C1F000C4;
	Sat, 17 Oct 2026 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253882;
	bh=Bv8NlGVR6ICT+2OR/s2T3TFs3j8Xw/Jbn+2D+wpUQy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPjiMz0cYOZt+itNMfL6xgVVyZIFznFE20E95W/MUAQ8gvjcYpuUzHCQjKdTW9Ry7
	 rqQqvjDmGLKPyQnmRa/DIUe1Tsgg9lsASAxX/zGpN67f2OI8Pw6g/w3NniIcuZcADQ
	 abr1S9Ii0nY6San8RWSZymwgno/W3jrNAu8lOLmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/869] i3c: mipi-i3c-hci: Fix race in DMA ring dequeue
Date: Sat, 17 Oct 2026 17:51:45 +0200
Message-ID: <20261017160043.831643893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1dca8aee80eea76d2aae21265de5dd64f6ba0f09 ]

The HCI DMA dequeue path (hci_dma_dequeue_xfer()) may be invoked for
multiple transfers that timeout around the same time.  However, the
function is not serialized and can race with itself.

When a timeout occurs, hci_dma_dequeue_xfer() stops the ring, processes
incomplete transfers, and then restarts the ring.  If another timeout
triggers a parallel call into the same function, the two instances may
interfere with each other - stopping or restarting the ring at unexpected
times.

Add a mutex so that hci_dma_dequeue_xfer() is serialized with respect to
itself.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 1 +
 drivers/i3c/master/mipi-i3c-hci/dma.c  | 2 ++
 drivers/i3c/master/mipi-i3c-hci/hci.h  | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 51780354be3b3..73a620144c7e1 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -804,6 +804,7 @@ static int i3c_hci_probe(struct platform_device *pdev)
 	hci = devm_kzalloc(&pdev->dev, sizeof(*hci), GFP_KERNEL);
 	if (!hci)
 		return -ENOMEM;
+	mutex_init(&hci->control_mutex);
 	hci->base_regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(hci->base_regs))
 		return PTR_ERR(hci->base_regs);
diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 8788eefcbb5be..845feecc0211f 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -459,6 +459,8 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	bool did_unqueue = false;
 	u32 ring_status;
 
+	guard(mutex)(&hci->control_mutex);
+
 	ring_status = rh_reg_read(RING_STATUS);
 	if (ring_status & RING_STATUS_RUNNING) {
 		/* stop the ring */
diff --git a/drivers/i3c/master/mipi-i3c-hci/hci.h b/drivers/i3c/master/mipi-i3c-hci/hci.h
index aaa47ac473814..24e6dd22cf0e4 100644
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -48,6 +48,7 @@ struct i3c_hci {
 	const struct hci_io_ops *io;
 	void *io_data;
 	const struct hci_cmd_ops *cmd;
+	struct mutex control_mutex;
 	atomic_t next_cmd_tid;
 	u32 caps;
 	unsigned int quirks;
-- 
2.53.0



