Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A1221FB1;
	Mon,  2 Jun 2025 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876530; cv=none; b=rOk0JPTtbonMttpQjaqehKPStJVpagDgZVrdRzT7n5hc7nWcnPkYHDUm31aTEDiAyLFIwQ1e4w2VUmwkumVuQ/YE5fykTEt+HtYuvKgofI4yXSOd8LtkwC85DGzd+B4WhXMzsyQhbjQD7UN1qNg5PjeMjaeXRcAuVzFNBXaBpEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876530; c=relaxed/simple;
	bh=nFB28ckDhebrYHe5zt7opi74x5C71k6OL8mScw1/EBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUxnLNhuBt91xMwXFHVQa4RITV9SBjKXeGXyq0dcj9pBAAjp966eqotev1/4z/+HFQUtp68rI03PDghpu1KlxjynnDIePsCDyTDFUVDwhoOr99Zbi+wSIT2HWFrKIMvJMlL4p6rJLAJ4Riyvn6CFsRojH4dGjZSsuJyteoKqDAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9WqH1ER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9WqH1ER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4AAC4CEEB;
	Mon,  2 Jun 2025 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876529;
	bh=nFB28ckDhebrYHe5zt7opi74x5C71k6OL8mScw1/EBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9WqH1ERTKEL6ahALnPMxPV2dBpGR57GQNrWZpJ251DtphNgsHQxVhDQQfueHTWKN
	 pn9aMPOIw0y7m4gblv9IFkgNBWs4RJjAsxfeQc1sYN1K1esX0ce1ftoIWif3DB+1Gw
	 oVdw3iC1knMnZC4o1cP/aR0M9sS4/+FHpx2iPjVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Guterman <amfernusus@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/207] nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro
Date: Mon,  2 Jun 2025 15:49:35 +0200
Message-ID: <20250602134306.734934898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Guterman <amfernusus@gmail.com>

[ Upstream commit e765bf89f42b5c82132a556b630affeb82b2a21f ]

This commit adds the NVME_QUIRK_NO_DEEPEST_PS quirk for device
[126f:2262], which belongs to device SOLIDIGM P44 Pro SSDPFKKW020X7

The device frequently have trouble exiting the deepest power state (5),
resulting in the entire disk being unresponsive.

Verified by setting nvme_core.default_ps_max_latency_us=10000 and
observing the expected behavior.

Signed-off-by: Ilya Guterman <amfernusus@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a3c5af95e8f3e..5f60a6ca247fe 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3448,6 +3448,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x025e, 0xf1ac),   /* SOLIDIGM  P44 pro SSDPFKKW020X7  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
-- 
2.39.5



