Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90E26156E;
	Tue,  8 Apr 2025 12:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114979; cv=none; b=uvMrSBV+rKyG/eI5UmaT9PKGeZoAtz6SWwcWF060NASm2IOemfQlbdgeL+QG0RFGzjeZyC8Y7KkSJ+k8Z3N2tcz6kwuPrgd0qgyDhdE2CHl50kT1LgDUPbKE1mEAc8CdJrG74wjpUdbgKyWCUR2ky6Vb7TGMDJWJFXxc7FHD/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114979; c=relaxed/simple;
	bh=ixpwpvAlvnq0baYpz2XmzRzw1iu/pjhm4uE38NHd8fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9FRr+mI5Bi3KhsPRs5go+xzZ55IENl3XaQ0wtp+KpHCOnA/OFWWEO6LnRdC/tPQTqzDRR8dDdUhcUnSgbDFwMsiHt8poQERWzeizlG6a4kdmSKvd5MVB80mhQVaCfaoV6BID16/GM6n4zSppSC4/imXLY/GXupw1bJyL56w0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQQSg+1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQQSg+1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB9CC4CEE5;
	Tue,  8 Apr 2025 12:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114979;
	bh=ixpwpvAlvnq0baYpz2XmzRzw1iu/pjhm4uE38NHd8fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQQSg+1cMLghumxaHT+UUMr/Si+iGBp7HPhFs7Mvmx4Hlkeh1+hFX2O5PBMCVd2vY
	 KyzSqNuo0XzUzAhI4kHJqDXhGW3u65XHV1Bvf17Vg2odhi1JUkGOfpYnm/nTFAgEBc
	 /nZT/qFrfW6XafthEMfQ/9vmJduMXatbeeVYsSG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 306/499] nvme-pci: clean up CMBMSC when registering CMB fails
Date: Tue,  8 Apr 2025 12:48:38 +0200
Message-ID: <20250408104858.847979963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0b4ca8e8f9b46..5dae150991fdd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2005,6 +2005,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
+		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
 		return;
 	}
 
-- 
2.39.5



