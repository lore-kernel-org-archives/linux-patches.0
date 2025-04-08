Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E993D20CCD8;
	Tue,  8 Apr 2025 11:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113452; cv=none; b=BMdB/OllKtwbj3VuUkIzjmAMxJerExwEA610+NYcwlx+SSN2CFIcndVqPiABq3L9W/x2egP2qOTLKD0FVB0TCWBABn7mIni5HyKxqTrKAYyYdO6tYoG0OFOGc4ah80Ka4Eh3zR5GFOHSZsa33yxh1oRiAJz4D9G6vJxX+dW8RHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113452; c=relaxed/simple;
	bh=47/Pe+QopSXPyoTaqzQefiDVHLStEz837C6eSgcIzQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vtq38fRmkAZLJoy4/LF+zN+fwGRIG6Y9Uw5UOVpsQn5Wj5dEMKoUsStYrzC3ApnHKkKOk9xPRNBZBxGt+5edf+w1ccVk8ompel42fR1FEodhBuoLTgH/daKjsso8klnbBv1eBaA9XMOR8nWWPRaKTl6PGTCksf4ir69fEgP+rvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgRzlrOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgRzlrOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC6FC4CEE5;
	Tue,  8 Apr 2025 11:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113451;
	bh=47/Pe+QopSXPyoTaqzQefiDVHLStEz837C6eSgcIzQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgRzlrOphA3XPOKZ8XeNOq4mrxDmtjOqeT0k1B1IX/pWejkZ2uDlZEivyheDLpswg
	 LDNM5Vz731oq+EWWyq7wN84R4Po09JEw6gsWE48esYCDC9gpU++Y9qhuHUD3q2QVi0
	 p3QZCLW8WEI58TpukNs7aPEf3ht6WYXrc3gj1WtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/268] nvme-pci: clean up CMBMSC when registering CMB fails
Date: Tue,  8 Apr 2025 12:49:36 +0200
Message-ID: <20250408104833.001381061@linuxfoundation.org>
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
index a36ec6df6624b..3cc00d5a10065 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1871,6 +1871,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
+		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
 		return;
 	}
 
-- 
2.39.5



