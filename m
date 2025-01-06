Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A78770812;
	Mon,  6 Jan 2025 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177769; cv=none; b=fhyz39WS07qcdglwuYYQrYdrhlTxh+MD0kUPul2IVPCJhra9o0MgXzF/DmvgR6xNZCP2xiZOKa5za+SEJ9+qkQVFb17Qr97dWiiQ7UvzqOp+5D/tgiSf9UiXqwwIakH9F9Ga0cB3SLjbzy+qUdJFcSKVqNzyj9MOGoQdhCScfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177769; c=relaxed/simple;
	bh=VAvxdR2ZRokiSExS2+EKdF0Qj5LYj2PGewqzKqO7S6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hBTpkQjBTWOc/IBDVm2qH4Ojr5DIlylAXT3XpTKwnpojfIvCGMBRvxkTaBw9EckMDZUzkKRIHxAMlTZ7rEbfoUuf8igIx6s+biF61FywXMPsiDfSoI0OJ8Xk/Gr+XBOOMU5x4TntfnkynvwUNQ1dzU+dwvwoTV9DSD8fKcR0kRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oROzQmeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oROzQmeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860E3C4CED2;
	Mon,  6 Jan 2025 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177768;
	bh=VAvxdR2ZRokiSExS2+EKdF0Qj5LYj2PGewqzKqO7S6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oROzQmeY0ZMFO/IzkngVtwH89jmBqKrTJWKnsbeJ0oPqtqWqHRseKPycRJCFbgPgM
	 nCCF8QaJokGk8dDEg4JdgzvG0k8+rHW/rY5z/VeKn9+/k5aWDPBkyn0LM+63xX12eF
	 OJV+DhTVw3/GHKH6SJEy5xIcLJKDHsHjj/GtwBmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pawe=C5=82=20Anikiel?= <panikiel@google.com>,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/156] nvme-pci: 512 byte aligned dma pool segment quirk
Date: Mon,  6 Jan 2025 16:15:05 +0100
Message-ID: <20250106151142.466970740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Beckett <bob.beckett@collabora.com>

[ Upstream commit ebefac5647968679f6ef5803e5d35a71997d20fa ]

We initially introduced a quick fix limiting the queue depth to 1 as
experimentation showed that it fixed data corruption on 64GB steamdecks.

Further experimentation revealed corruption only happens when the last
PRP data element aligns to the end of the page boundary. The device
appears to treat this as a PRP chain to a new list instead of the data
element that it actually is. This implementation is in violation of the
spec. Encountering this errata with the Linux driver requires the host
request a 128k transfer and coincidently be handed the last small pool
dma buffer within a page.

The QD1 quirk effectly works around this because the last data PRP
always was at a 248 byte offset from the page start, so it never
appeared at the end of the page, but comes at the expense of throttling
IO and wasting the remainder of the PRP page beyond 256 bytes. Also to
note, the MDTS on these devices is small enough that the "large" prp
pool can hold enough PRP elements to never reach the end, so that pool
is not a problem either.

Introduce a new quirk to ensure the small pool is always aligned such
that the last PRP element can't appear a the end of the page. This comes
at the expense of wasting 256 bytes per small pool page allocated.

Link: https://lore.kernel.org/linux-nvme/20241113043151.GA20077@lst.de/T/#u
Fixes: 83bdfcbdbe5d ("nvme-pci: qdepth 1 quirk")
Cc: Paweł Anikiel <panikiel@google.com>
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h | 5 +++++
 drivers/nvme/host/pci.c  | 9 +++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 093cb423f536..61bba5513de0 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -173,6 +173,11 @@ enum nvme_quirks {
 	 * MSI (but not MSI-X) interrupts are broken and never fire.
 	 */
 	NVME_QUIRK_BROKEN_MSI			= (1 << 21),
+
+	/*
+	 * Align dma pool segment size to 512 bytes
+	 */
+	NVME_QUIRK_DMAPOOL_ALIGN_512		= (1 << 22),
 };
 
 /*
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 55af3dfbc260..76b3f7b396c8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2690,15 +2690,20 @@ static int nvme_disable_prepare_reset(struct nvme_dev *dev, bool shutdown)
 
 static int nvme_setup_prp_pools(struct nvme_dev *dev)
 {
+	size_t small_align = 256;
+
 	dev->prp_page_pool = dma_pool_create("prp list page", dev->dev,
 						NVME_CTRL_PAGE_SIZE,
 						NVME_CTRL_PAGE_SIZE, 0);
 	if (!dev->prp_page_pool)
 		return -ENOMEM;
 
+	if (dev->ctrl.quirks & NVME_QUIRK_DMAPOOL_ALIGN_512)
+		small_align = 512;
+
 	/* Optimisation for I/Os between 4k and 128k */
 	dev->prp_small_pool = dma_pool_create("prp list 256", dev->dev,
-						256, 256, 0);
+						256, small_align, 0);
 	if (!dev->prp_small_pool) {
 		dma_pool_destroy(dev->prp_page_pool);
 		return -ENOMEM;
@@ -3446,7 +3451,7 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1217, 0x8760), /* O2 Micro 64GB Steam Deck */
-		.driver_data = NVME_QUIRK_QDEPTH_ONE },
+		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
 	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_BOGUS_NID, },
-- 
2.39.5



