Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4636D1A76A5;
	Tue, 30 Jul 2024 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360713; cv=none; b=AR2Hre1wtB9JywRfYkHvGV45RyGGgk755Hd+CBmZSGqufoi4/WQZysMYHCSPfcKdFX+3WCgv8uyiV5vK8J78F3qkqBQrwWa8m1rrYr4JWj8S80ogIofvODul5xtKwtcS0CAtb/NwLjafm0HwxRuDNgCsBWP6cUXhD4ujDt5IVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360713; c=relaxed/simple;
	bh=qyX+leFfbhUSvHQh85pFzt6Kl3eMQDTxLujDaitYNnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0AbSjIlI908gZvBBprytVHr6zgqVBf7LJXhj3tu+WuQmq+FwH361UtXZ7GZi50W+nnvPsNV34eSoWXOnZSqeuz+jqQcKMaeO1ELAP8YqrbaaM7RGzRnLT5k896XYu2sS6XSpaL5120jDCx+xP8hcQ5knn9UxHoWo/QBO1eTF6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuNebQHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuNebQHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1943C4AF0A;
	Tue, 30 Jul 2024 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360713;
	bh=qyX+leFfbhUSvHQh85pFzt6Kl3eMQDTxLujDaitYNnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuNebQHkBaaITs4NUUY9qg4dP8WIDH5EjArbT8f8d/tSD8SNczPRp4Ya8NfqttFVd
	 ZtTyUeIsjfuDIrtF4r7QyAswzVBT0UyBBjx+kzQIgBVY/uWbGu3rk2N3rCCvicjgII
	 YND+rrPJ8UeG5Spy8z0qCtN3lt0SbQINDLIe/qYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 784/809] nvme-pci: Fix the instructions for disabling power management
Date: Tue, 30 Jul 2024 17:51:00 +0200
Message-ID: <20240730151755.932652339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 92fc2c469eb26060384e9b2cd4cb0cc228aba582 ]

pcie_aspm=off tells the kernel not to modify the ASPM configuration. This
setting does not guarantee that ASPM (Active State Power Management) is
disabled. Hence add pcie_port_pm=off. This disables power management for
all PCIe ports.

This patch has been tested on a workstation with a Samsung SSD 970 EVO Plus
NVMe SSD.

Fixes: 4641a8e6e145 ("nvme-pci: add trouble shooting steps for timeouts")
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 102a9fb0c65ff..9e9b05e79c474 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1274,7 +1274,7 @@ static void nvme_warn_reset(struct nvme_dev *dev, u32 csts)
 	dev_warn(dev->ctrl.device,
 		 "Does your device have a faulty power saving mode enabled?\n");
 	dev_warn(dev->ctrl.device,
-		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off\" and report a bug\n");
+		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off\" and report a bug\n");
 }
 
 static enum blk_eh_timer_return nvme_timeout(struct request *req)
-- 
2.43.0



