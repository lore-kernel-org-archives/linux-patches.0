Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4D0357A4A;
	Tue, 17 Mar 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766977; cv=none; b=RDiASqCgi6DQ6kOuSD5S68sPRmUm8jtU5tddnp+/gMtBYUrRACsW3B/Bh5gPr3Tsr7i01zYI90kqYs2Cef2GmBeVHUhYv7TfpEI1Xda2jBcTjVO46XCx0TuBYSCmxlKpQ9g0qBmUyp+0/6jbqQ0TZMaV2Opsk8bxc7HvhiFKFRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766977; c=relaxed/simple;
	bh=ONh3oRUZaPcmvj3AyG1f+RAJ1DhXHJi6U4kJncsGcy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAK2gH+qyOQM+93UcEACDlA+GXQ8LEaF5uuBgQs9r1l90gYxuiF1GLx5kQRoskUIKU+TE0wtgWLECyMJHR4srtvQGGxNL41KD0wXWvE3RW+R9aqBkyvbX70OfvNxUinr0W+iPQApwx0dV8/HeKxLNme0u66KWC5ZLoN5PX+lJDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDfRkJxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDfRkJxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417D9C2BC86;
	Tue, 17 Mar 2026 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766976;
	bh=ONh3oRUZaPcmvj3AyG1f+RAJ1DhXHJi6U4kJncsGcy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDfRkJxkzZn38IF9jN2DoyqxAg1NzbJB37WNX53nrMK2ufdMMVVtTUGjLURuIkhLy
	 /hN9dZB5cTTZLGQOzmb1rWF8OiascjsC5g3zuTAGX16njvwlAPRsVpKjXtH1J+TEwB
	 Wv5qBLb/iG8gWhU+2BWu/kSIf+JGKNVxNZgVuxHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.19 365/378] i3c: mipi-i3c-hci: Factor out DMA mapping from queuing path
Date: Tue, 17 Mar 2026 17:35:22 +0100
Message-ID: <20260317163020.407483460@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit f3bcbfe1b8b0b836b772927f75f8cb6e759eb00a upstream.

Prepare for fixing a race in the DMA ring enqueue path when handling
parallel transfers.  Move all DMA mapping out of hci_dma_queue_xfer()
and into a new helper that performs the mapping up front.

This refactoring allows the upcoming fix to extend the spinlock coverage
around the enqueue operation without performing DMA mapping under the
spinlock.

No functional change is intended in this patch.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c |   49 ++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 16 deletions(-)

--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -375,6 +375,33 @@ static void hci_dma_unmap_xfer(struct i3
 	}
 }
 
+static struct i3c_dma *hci_dma_map_xfer(struct device *dev, struct hci_xfer *xfer)
+{
+	enum dma_data_direction dir = xfer->rnw ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	bool need_bounce = device_iommu_mapped(dev) && xfer->rnw && (xfer->data_len & 3);
+
+	return i3c_master_dma_map_single(dev, xfer->data, xfer->data_len, need_bounce, dir);
+}
+
+static int hci_dma_map_xfer_list(struct i3c_hci *hci, struct device *dev,
+				 struct hci_xfer *xfer_list, int n)
+{
+	for (int i = 0; i < n; i++) {
+		struct hci_xfer *xfer = xfer_list + i;
+
+		if (!xfer->data)
+			continue;
+
+		xfer->dma = hci_dma_map_xfer(dev, xfer);
+		if (!xfer->dma) {
+			hci_dma_unmap_xfer(hci, xfer_list, i);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
 static int hci_dma_queue_xfer(struct i3c_hci *hci,
 			      struct hci_xfer *xfer_list, int n)
 {
@@ -382,6 +409,11 @@ static int hci_dma_queue_xfer(struct i3c
 	struct hci_rh_data *rh;
 	unsigned int i, ring, enqueue_ptr;
 	u32 op1_val, op2_val;
+	int ret;
+
+	ret = hci_dma_map_xfer_list(hci, rings->sysdev, xfer_list, n);
+	if (ret)
+		return ret;
 
 	/* For now we only use ring 0 */
 	ring = 0;
@@ -392,9 +424,6 @@ static int hci_dma_queue_xfer(struct i3c
 	for (i = 0; i < n; i++) {
 		struct hci_xfer *xfer = xfer_list + i;
 		u32 *ring_data = rh->xfer + rh->xfer_struct_sz * enqueue_ptr;
-		enum dma_data_direction dir = xfer->rnw ? DMA_FROM_DEVICE :
-							  DMA_TO_DEVICE;
-		bool need_bounce;
 
 		/* store cmd descriptor */
 		*ring_data++ = xfer->cmd_desc[0];
@@ -413,18 +442,6 @@ static int hci_dma_queue_xfer(struct i3c
 
 		/* 2nd and 3rd words of Data Buffer Descriptor Structure */
 		if (xfer->data) {
-			need_bounce = device_iommu_mapped(rings->sysdev) &&
-				      xfer->rnw &&
-				      xfer->data_len != ALIGN(xfer->data_len, 4);
-			xfer->dma = i3c_master_dma_map_single(rings->sysdev,
-							      xfer->data,
-							      xfer->data_len,
-							      need_bounce,
-							      dir);
-			if (!xfer->dma) {
-				hci_dma_unmap_xfer(hci, xfer_list, i);
-				return -ENOMEM;
-			}
 			*ring_data++ = lower_32_bits(xfer->dma->addr);
 			*ring_data++ = upper_32_bits(xfer->dma->addr);
 		} else {
@@ -447,7 +464,7 @@ static int hci_dma_queue_xfer(struct i3c
 		op2_val = rh_reg_read(RING_OPERATION2);
 		if (enqueue_ptr == FIELD_GET(RING_OP2_CR_DEQ_PTR, op2_val)) {
 			/* the ring is full */
-			hci_dma_unmap_xfer(hci, xfer_list, i + 1);
+			hci_dma_unmap_xfer(hci, xfer_list, n);
 			return -EBUSY;
 		}
 	}


