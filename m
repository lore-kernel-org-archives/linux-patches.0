Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC1C26A1A7;
	Tue,  8 Apr 2025 12:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116894; cv=none; b=EBj1FSqV1NYVgEKOEuH4MVTQZpRqIDFE2Ms470yDwUPW2tprPr+Coq5hgfKaoQRZKAV1enVTZANGNZIQvMf86pWWafDVYMgj3Hv1LGvJRP2Fcn2NR3i287VbYbd/VVw67Xwc03sWlccY29iklLf1585904Awh9cCBCiyl9kNhCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116894; c=relaxed/simple;
	bh=3UHvLcCWImW5DOlQU1lql1gTwZKTxVQoxS4UtahUO/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz0qHp4PW6wKNt2230Sb7CM74KXNOIwDPrfyrm9OfCeToa20+gu13oAT6aanP5RT6I5uzD/g93dX9kLLqhvjKTpQUPMV8T4I6tcfLjFB/ci9KuO0SA4fiRdBZ7Wc5a0ac78IB+lNau/8K4YcgfANtnziJemb2iCXQkQZ8h4X/LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHNAk/9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHNAk/9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F30C4CEE5;
	Tue,  8 Apr 2025 12:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116894;
	bh=3UHvLcCWImW5DOlQU1lql1gTwZKTxVQoxS4UtahUO/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHNAk/9mskz7QmNrrpt6vpzBiqd5DaR/yI7ecBUzDZG71f6Bs+uyw0ORKs2f0U02Q
	 E4ZDcDqxdkj0zOSDPx6LSpVeINkszSWg2H/YHjS5fGSUIeiuTyZLpYdYCUN8QS86VW
	 A0ZNthQ8rRkrytT6+U7a3igLnF84YfNErRYMFenU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/423] nvme-pci: clean up CMBMSC when registering CMB fails
Date: Tue,  8 Apr 2025 12:49:45 +0200
Message-ID: <20250408104851.777688883@linuxfoundation.org>
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
index 1d3205f08af84..84c0611697a9b 100644
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



