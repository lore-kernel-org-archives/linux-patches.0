Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5385B363C6F;
	Sat, 12 Sep 2026 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231767; cv=none; b=EqBsWo/PDgoaJ6u0kx3rbAdl+SqjCiAdZsJahnvdgAHencoYf6gHnYTZPG3o/oqq8z+2Jv08lL/nOMXA29vI0AwHgS0FXV7+Fm9YH94pUr3c5EDSYGIgvJSbpUvD71K3fIudhIl8XGwy1OhuBWt3RDu82Z/3vgMv3UBvqb66NFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231767; c=relaxed/simple;
	bh=n3fktjftrCSViT60DC8kyPehvu6prsvm3Doc+PjM8TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyUTdwtI4XkmcFptvgIJ4Jp3hF8loiOmp8+gn+33fi62dMKrSE4uSz3iTc/6JU9KSaY0sXRvGPxLcW4Mih767dd3xGL3GQlbgkJFiX8CQl+fBh1wHUCAhtMfQycQvyXgax2QHsqHtGNYRhEH8fRz3/ZCoZqtqgG4Y4zqVsxosBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0tpEtMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0tpEtMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714761F000FF;
	Sat, 12 Sep 2026 16:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231766;
	bh=Oiwzfg//1cXTALHC73a1dDzxL1jxQg60hNDBzNvjwJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0tpEtMaOFffKsfNGykarFRAgvobYm66H+8+Mqcd8YrBKhr/1dlA2WpAygp8+cPjp
	 yxiG8WaErsFZU7eUsU++1pMKSIMHzwdiIfvxcdvVVyTZ0u0ZXPAjj6NooFoX+Mw3Wy
	 IHa/8lTKqn1J4XLRHh7AbzE3Q4wSKrSEy87qaOU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1067/1191] i3c: mipi-i3c-hci: Refactor PIO register initialization
Date: Sat, 12 Sep 2026 09:03:15 +0200
Message-ID: <20260912065612.139704110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ca4d4682d353bf4e7e5db7b025e9ecd80bc67b27 ]

Move the PIO register setup logic out of hci_pio_init() into a new
helper, __hci_pio_init().  This refactoring prepares for Runtime PM
support by allowing PIO registers to be reinitialized independently
after resume.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-13-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 308ecb824db3 ("i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 45 +++++++++++++++++----------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index 9f0e12d2b906a..da28934a63286 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -136,27 +136,14 @@ struct hci_pio_data {
 	u32 enabled_irqs;
 };
 
-static int hci_pio_init(struct i3c_hci *hci)
+static void __hci_pio_init(struct i3c_hci *hci, u32 *size_val_ptr)
 {
-	struct hci_pio_data *pio;
 	u32 val, size_val, rx_thresh, tx_thresh, ibi_val;
-
-	pio = devm_kzalloc(hci->master.dev.parent, sizeof(*pio), GFP_KERNEL);
-	if (!pio)
-		return -ENOMEM;
-
-	hci->io_data = pio;
-	spin_lock_init(&pio->lock);
+	struct hci_pio_data *pio = hci->io_data;
 
 	size_val = pio_reg_read(QUEUE_SIZE);
-	dev_dbg(&hci->master.dev, "CMD/RESP FIFO = %ld entries\n",
-		FIELD_GET(CR_QUEUE_SIZE, size_val));
-	dev_dbg(&hci->master.dev, "IBI FIFO = %ld bytes\n",
-		4 * FIELD_GET(IBI_STATUS_SIZE, size_val));
-	dev_dbg(&hci->master.dev, "RX data FIFO = %d bytes\n",
-		4 * (2 << FIELD_GET(RX_DATA_BUFFER_SIZE, size_val)));
-	dev_dbg(&hci->master.dev, "TX data FIFO = %d bytes\n",
-		4 * (2 << FIELD_GET(TX_DATA_BUFFER_SIZE, size_val)));
+	if (size_val_ptr)
+		*size_val_ptr = size_val;
 
 	/*
 	 * Let's initialize data thresholds to half of the actual FIFO size.
@@ -202,6 +189,30 @@ static int hci_pio_init(struct i3c_hci *hci)
 
 	/* Always accept error interrupts (will be activated on first xfer) */
 	pio->enabled_irqs = STAT_ALL_ERRORS;
+}
+
+static int hci_pio_init(struct i3c_hci *hci)
+{
+	struct hci_pio_data *pio;
+	u32 size_val;
+
+	pio = devm_kzalloc(hci->master.dev.parent, sizeof(*pio), GFP_KERNEL);
+	if (!pio)
+		return -ENOMEM;
+
+	hci->io_data = pio;
+	spin_lock_init(&pio->lock);
+
+	__hci_pio_init(hci, &size_val);
+
+	dev_dbg(&hci->master.dev, "CMD/RESP FIFO = %ld entries\n",
+		FIELD_GET(CR_QUEUE_SIZE, size_val));
+	dev_dbg(&hci->master.dev, "IBI FIFO = %ld bytes\n",
+		4 * FIELD_GET(IBI_STATUS_SIZE, size_val));
+	dev_dbg(&hci->master.dev, "RX data FIFO = %d bytes\n",
+		4 * (2 << FIELD_GET(RX_DATA_BUFFER_SIZE, size_val)));
+	dev_dbg(&hci->master.dev, "TX data FIFO = %d bytes\n",
+		4 * (2 << FIELD_GET(TX_DATA_BUFFER_SIZE, size_val)));
 
 	return 0;
 }
-- 
2.53.0



