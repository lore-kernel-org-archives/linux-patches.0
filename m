Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0FC2686AA;
	Tue,  8 Apr 2025 12:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115850; cv=none; b=ed+Rfl6UCDrl+YbCLyU+aVMj7SDlxxORrr7cnb24OUgf1hgBwex7Tv9bZ37rjwa9v2Nlr55bRjRmGCvDzA4e5rvNTAThBjJ3b2lhGPPsKlOVgroNL2nLxT6tRMhUjBHudCld43MZYSRRNe8gmzt7icXTV5evxWfXECQz3x6pAsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115850; c=relaxed/simple;
	bh=WkP3AOSutE4jsU7YaizltjT3LJJo+IEdfaE5tlr+C4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTzYVX3gNcw61qhsBFW6AHNtrjwlovqHlauZCqbggGaP5BM5DkX+/zS5NIRfzh2bKhg91Vo1IanoPvG1WfUrm83exqGcPBum7SDJ+UJ37HlIAyH8Nz0jGcdmE8um1T7sqLV+pduGYjHZA2sSzKQ9HFefG8uDI7GybjO/Dd8LS3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paIILS5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paIILS5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BA1C4CEE5;
	Tue,  8 Apr 2025 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115850;
	bh=WkP3AOSutE4jsU7YaizltjT3LJJo+IEdfaE5tlr+C4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paIILS5uyV1eNXEfTKdHMbp5c0XSrXEtFD8x+q13T9DHyZiQfpZOW8UUMFI9w+R2z
	 EIpWDq3GZPBPvv9maweNgnPxw7SIFgQFhZ6UBjeUxPnHaSrW4OWeu/n5TZSZ8+eBo+
	 yHC4E1hf6krWT9SlnL0o0WVYU0jwF+18WD3x7iqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/204] nvme-pci: clean up CMBMSC when registering CMB fails
Date: Tue,  8 Apr 2025 12:50:59 +0200
Message-ID: <20250408104824.086663943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 6a3572e10f740acd48e2713ef37e92186a3ce5e8 ]

CMB decoding should get disabled when the CMB block isn't successfully
registered to P2P DMA subsystem.

Clean up the CMBMSC register in this error handling codepath to disable
CMB decoding (and CMBLOC/CMBSZ registers).

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index afcb9668dad98..bfca71f958a06 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1949,6 +1949,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
+		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
 		return;
 	}
 
-- 
2.39.5



