Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986D22690F9;
	Tue,  8 Apr 2025 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113454; cv=none; b=Kq1VEA9ZZUJtiNEwJrjE35jQPtMA/3bYoUIfwCVM9GT3a94POku6/fh8pKVJ3+vvIVNKKagUMEFjbevQyLeZm6zVeuMa4iSnNriG5k/aAJABqDdbwSt/yBP+N2WqXWo4wNisTd6nufaCMcmOEYihyqKoS0q012P9iATQz57T5p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113454; c=relaxed/simple;
	bh=qwXK4WDJhrrVqSULeKSLfHW7KP0oUlFPu2H2/5OLzYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmcbQalVjpkZHMB6KxO+Pb7TBAKlIE9GF6m3Ocwba/8DMrwsbEZPGh8N6QOAoPL7SrJa2pSycbp6yXkXuL0rm4RmXl8kFJg7eVfMUzBUDb3AgWKXi+z9wvCRkWaZDMQpVciOHqEzX1pphEh+ykBpggYsHxKniXkb24Z9x2a+IkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eywijUYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eywijUYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28356C4CEE5;
	Tue,  8 Apr 2025 11:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113454;
	bh=qwXK4WDJhrrVqSULeKSLfHW7KP0oUlFPu2H2/5OLzYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eywijUYz0pJPQaPcVxaDkpt7gAGqe99S9+q5SpjtbEivEZNMK8qx2778dJQJOxUu7
	 Gy9luhhjmuM7IytFdKhYfJ8GkfAdkFYj4xgFo5kkN45BuABJk3tNrwDfdo7CbR7UHe
	 vnxvP+BK5n8sFxtMa7itKaNrfK4kR5nExRQOtsnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/268] nvme-pci: skip CMB blocks incompatible with PCI P2P DMA
Date: Tue,  8 Apr 2025 12:49:37 +0200
Message-ID: <20250408104833.029447331@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3cc00d5a10065..5265be835a4ce 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1850,6 +1850,18 @@ static void nvme_map_cmb(struct nvme_dev *dev)
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
@@ -1860,14 +1872,6 @@ static void nvme_map_cmb(struct nvme_dev *dev)
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



