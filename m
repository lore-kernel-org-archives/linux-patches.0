Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70651BE258;
	Thu,  6 Jun 2024 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683535; cv=none; b=KTcrzjU2fd2wV/2mSWQO0yLe0QEtSsR4IQKAoa4f/BKW+/40sOXTl+S3bHtfiIlkeaVoNO7FKl5ceybakKS2VjG82kSW0nuF273gvei+HfhN+BvAvBUl0oMcWl0HkSCiGWN5h6dQqOakD90qfRMJBkkTiEAyixEn6Iipg72yPWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683535; c=relaxed/simple;
	bh=qJXexJr/MIjvEZYnAvSjI32v/cvHJYGi0tP9N7PML78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSz14rulEJVBpRBOCI/w2E+QsXgPMRufcMtfNZE6PRfPoAPwQ19LECYyaxYRRXCVDoRFiSqD7d8bKcFJBIgqFM77Be0yoySEd3WZhcTpPbcjoJQXc7uqL5/PbChLGFOYms0aUGGfW0jSxHCCxWdPFDCeIJJIQn0Iy5pgWjZO+uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F83qtKXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F83qtKXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886AAC32781;
	Thu,  6 Jun 2024 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683535;
	bh=qJXexJr/MIjvEZYnAvSjI32v/cvHJYGi0tP9N7PML78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F83qtKXsy101aKLWn7rO6936Ehlo+kg3jxWyVEnAqXHrV5AArbJY5pDDgRuBcVdt9
	 u8TakHee51rVglLMSuzq8DVp52USCO0GKmZ0nvG24DKVVBHRXH2s5/iXs49AbTcrrk
	 PI52lK31O+/7RIESrt7WN+wwfOgB1tcQ5daHuSyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 475/744] VMCI: Fix an error handling path in vmci_guest_probe_device()
Date: Thu,  6 Jun 2024 16:02:27 +0200
Message-ID: <20240606131747.688193293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 73df3d6f2e9533e93a5039a33c40dd7216b81801 ]

After a successful pci_iomap_range() call, pci_iounmap() should be called
in the error handling path, as already done in the remove function.

Add the missing call.

The corresponding call was added in the remove function in commit
5ee109828e73 ("VMCI: dma dg: allocate send and receive buffers for DMA
datagrams")

Fixes: e283a0e8b7ea ("VMCI: dma dg: add MMIO access to registers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Vishnu Dasa <vishnu.dasa@broadcom.com>
Link: https://lore.kernel.org/r/a35bbc3876ae1da70e49dafde4435750e1477be3.1713961553.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_guest.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index 4f8d962bb5b2a..1300ccab3d21b 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -625,7 +625,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	if (!vmci_dev) {
 		dev_err(&pdev->dev,
 			"Can't allocate memory for VMCI device\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_unmap_mmio_base;
 	}
 
 	vmci_dev->dev = &pdev->dev;
@@ -642,7 +643,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 		if (!vmci_dev->tx_buffer) {
 			dev_err(&pdev->dev,
 				"Can't allocate memory for datagram tx buffer\n");
-			return -ENOMEM;
+			error = -ENOMEM;
+			goto err_unmap_mmio_base;
 		}
 
 		vmci_dev->data_buffer = dma_alloc_coherent(&pdev->dev, VMCI_DMA_DG_BUFFER_SIZE,
@@ -893,6 +895,10 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 err_free_data_buffers:
 	vmci_free_dg_buffers(vmci_dev);
 
+err_unmap_mmio_base:
+	if (mmio_base != NULL)
+		pci_iounmap(pdev, mmio_base);
+
 	/* The rest are managed resources and will be freed by PCI core */
 	return error;
 }
-- 
2.43.0



