Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2763E83A17;
	Tue, 30 Jul 2024 17:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358857; cv=none; b=GAKfQsCTi9wSbxKFDlQcLFqO04SjQu6Bezst5uOYvu1pQQfSmxLFYg+GaheZCaq6nfdXF3uYiCZPqUGBkUiaatQSkLVSVg1X8oV5wM1+CE6oXrjTe388L1AtRdpI5/dfssofk5TfNRZCV1DvaSrDgPbzfooK1SBQebn4bu+VShk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358857; c=relaxed/simple;
	bh=yUQaxuvkk74X7eVTYa8dZxFfDonvNdBCRXljvnnqNxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw+5WnUnYSwV6Nby2j6yqc2Db8fd1YHeBQLiAevTpwo4oszSKf6wp9bGkXOnBUEikhlYFGARRMwT/W8JO+yLKvNY2GBIVmERVquHarOCjmBfhl5o2qAC8//DHMfiWH65b3sjl296Bmpj0l+a7kfx+aR2Yh16P2bmboVfKZYAyn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Owh3OQKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Owh3OQKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E711C32782;
	Tue, 30 Jul 2024 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358857;
	bh=yUQaxuvkk74X7eVTYa8dZxFfDonvNdBCRXljvnnqNxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Owh3OQKCQV59fZxl3DRPl/q2x6Ggrpj3fsBkRBI5GBQmxVvAAuh2i4NtWW0wBUzPY
	 2qCLg3YvHx/7CB+L8HLDCp4qo9H8AYxmkvdbvH1nvsT9Y4dXKOOOQpnfYegLmiL05s
	 ESv5Wd2XLT0kQcCLkK6LtP3CZTWfOaSbDD6BZ+S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 428/440] nvme-pci: Fix the instructions for disabling power management
Date: Tue, 30 Jul 2024 17:51:01 +0200
Message-ID: <20240730151632.497548512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32e89ea853a47..42ef44cc7a852 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1322,7 +1322,7 @@ static void nvme_warn_reset(struct nvme_dev *dev, u32 csts)
 	dev_warn(dev->ctrl.device,
 		 "Does your device have a faulty power saving mode enabled?\n");
 	dev_warn(dev->ctrl.device,
-		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off\" and report a bug\n");
+		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off\" and report a bug\n");
 }
 
 static enum blk_eh_timer_return nvme_timeout(struct request *req)
-- 
2.43.0



