Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567F628135C;
	Tue,  8 Apr 2025 12:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116783; cv=none; b=YRH7PivEiGQFK0s32Cf2RenlmJXiolXVipV6hxlSoQvl8f+W95KYKTB14aAUK+3spwaYik7eFxvaUEw1HaN6+obrIEOcQllCDRtL9Wnal1WgXxTMGKlryXBqVF4rLWtOUybuC8Y060Dfi5Xfp7UnGSCGDQG015LXtD4Art25dsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116783; c=relaxed/simple;
	bh=dXqMpQIoQZE538p5J1QfHGwBXOD99KUG+QRH0x7LYHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/m00VDPO2SkggHWMl6E4nTOZe+ChgjD3/qsR68n9qP4pbp5nvuPTX2uqNdWJqekkOLCnzLZbJoVH9p8hAQjKzJvrSg6bH8GOcYZNpkV7UsTGQFqpwo3dxqgTcKf/12CGwYEp/tCW95MN9DyOIfurVUphbmfb3zreErO91Y0Qe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5r5HtbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5r5HtbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94DAC4CEE5;
	Tue,  8 Apr 2025 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116783;
	bh=dXqMpQIoQZE538p5J1QfHGwBXOD99KUG+QRH0x7LYHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5r5HtbHcH+FJZ/tu1bF5X/rck8CRzTJKahQhRfqpQtVvsIcESXMBwXyZdlfo2gLI
	 0pC5FaNq8s8h7yR9GrDQfp3CYveLX8013xXTk1qf9E65bxGwNEOe33Wf+XD1RM7dYC
	 /6YfVK8etFq5pq2wrZspjY6a15zYvrtT1bIXNTSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/423] nvme-pci: skip CMB blocks incompatible with PCI P2P DMA
Date: Tue,  8 Apr 2025 12:49:46 +0200
Message-ID: <20250408104851.802831154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 56cf7ef0d490b28fad8f8629fc135c5ab7c9f54e ]

The PCI P2PDMA code will register the CMB block to the memory
hot-plugging subsystem, which have an alignment requirement. Memory
blocks that do not satisfy this alignment requirement (usually 2MB) will
lead to a WARNING from memory hotplugging.

Verify the CMB block's address and size against the alignment and only
try to send CMB blocks compatible with it to prevent this warning.

Tested on Intel DC D4502 SSD, which has a 512K CMB block that is too
small for memory hotplugging (thus PCI P2PDMA).

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 84c0611697a9b..833a67b79e13c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1984,6 +1984,18 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (offset > bar_size)
 		return;
 
+	/*
+	 * Controllers may support a CMB size larger than their BAR, for
+	 * example, due to being behind a bridge. Reduce the CMB to the
+	 * reported size of the BAR
+	 */
+	size = min(size, bar_size - offset);
+
+	if (!IS_ALIGNED(size, memremap_compat_align()) ||
+	    !IS_ALIGNED(pci_resource_start(pdev, bar),
+			memremap_compat_align()))
+		return;
+
 	/*
 	 * Tell the controller about the host side address mapping the CMB,
 	 * and enable CMB decoding for the NVMe 1.4+ scheme:
@@ -1994,14 +2006,6 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 			     dev->bar + NVME_REG_CMBMSC);
 	}
 
-	/*
-	 * Controllers may support a CMB size larger than their BAR,
-	 * for example, due to being behind a bridge. Reduce the CMB to
-	 * the reported size of the BAR
-	 */
-	if (size > bar_size - offset)
-		size = bar_size - offset;
-
 	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
-- 
2.39.5



