Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC87197A8B;
	Thu,  6 Jun 2024 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682929; cv=none; b=CIuqiaJ/BB6zX9pkIDCvQX9XF9inJu5tviFIaprnm5IVdhOZTHJiHLyvRga0IyMdKNnFB9TwVJvcbcyCn9ALux/54SxXlBYihJp4PX/0t5qkxTwbDGwxTjuuQ42Pd+YcLVajOvjlLA79PVDePC1wKJHvliO3uu++t3ymqniZstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682929; c=relaxed/simple;
	bh=f/6sbasxOjPy6L7AItsv0sZfTJsNZJO/0pg26Cm7NT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSgt+aOCxFnpcRWJIFgXRJLB+FjXCZvsLzjhr1VuZjaB7kMfR2jCFKOQtlchfBM8VaFhri40KrFW7FDHjkPl2NvwERjMi0eFClOaN4oni8YoqGXyrWTRmWJmC96io/B7nOUVilskt6jPgBf9Stidm3KBS9+UFUKDiA43v+AETp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okXZx+3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okXZx+3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8591C4AF0B;
	Thu,  6 Jun 2024 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682928;
	bh=f/6sbasxOjPy6L7AItsv0sZfTJsNZJO/0pg26Cm7NT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okXZx+3IgUMOmtuzZeWFS6jcjWnOp0Vr2DLG/lx3GKEwIz2W/EqFroBz7rAMLSVci
	 o2Z5DpKtSjGkhVi82xcgJ9Zj1+ebPzo4zm3VCckzQG0h0cYo0mTJskJ4XHwNuE5JKX
	 Vl+2GDbwEdKKMBfHL2VkJshy+1+0OmbYPKYoX5dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 074/374] VMCI: Fix an error handling path in vmci_guest_probe_device()
Date: Thu,  6 Jun 2024 16:00:53 +0200
Message-ID: <20240606131654.343837903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



