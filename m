Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6101B16423;
	Tue, 27 Feb 2024 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042539; cv=none; b=nCbVSx65SY4bvkd6mTnnCZ4/+wCnV2IOqK++M7g+J2BsT+Siba1Y+pL7cK3Egr8g1VNzeR4ZTIyFxEjLGIrUekM5u/squ+PeAwST+QiTt/IqJG0/B3NkOFq9PoNaYFQcQoqkakluR/r7jY2HWk7hEXPcsglwdpMPUI43caaeMZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042539; c=relaxed/simple;
	bh=+p2dWreX4u/wMS9QMeEJlXWRrPafAAtmuR/BA/nHwME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OkMMx5v1AgjxrR7jkL3S69lb+xuUSaKrZ19mC5vpI2PSkXJphCzxuNjwIcnP8jNiO00ty39gg6Q/S/+Bv2zKnyniVArYojzVaPX8Wtd9087Uo5qAagv/e7FrLM2AdjejEhIss9xotG1jfnmwiKnQZw7lLoztsTtWag0xVoH9RTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMY8aqA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMY8aqA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53B1C433F1;
	Tue, 27 Feb 2024 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042539;
	bh=+p2dWreX4u/wMS9QMeEJlXWRrPafAAtmuR/BA/nHwME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMY8aqA14QAIHYg6VkEALkvMY8hl33fBGfAVMFLgakTxGQsIhQJy3Cu6MIw/q5cg3
	 YS78i/VffDTdbOHRyyDryLQVRxbJkTW0+hdpOM/vIoEbqfG7WK2JehoiDuoHjs41nT
	 4YWbCwO9yoYfrBivK8bHaY2LpAj0+YS5ETWW3pOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 008/245] PCI: dwc: Fix a 64bit bug in dw_pcie_ep_raise_msix_irq()
Date: Tue, 27 Feb 2024 14:23:16 +0100
Message-ID: <20240227131615.379734819@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit b5d1b4b46f856da1473c7ba9a5cdfcb55c9b2478 upstream.

The "msg_addr" variable is u64.  However, the "aligned_offset" is an
unsigned int.  This means that when the code does:

  msg_addr &= ~aligned_offset;

it will unintentionally zero out the high 32 bits.  Use ALIGN_DOWN() to do
the alignment instead.

Fixes: 2217fffcd63f ("PCI: dwc: endpoint: Fix dw_pcie_ep_raise_msix_irq() alignment support")
Link: https://lore.kernel.org/r/af59c7ad-ab93-40f7-ad4a-7ac0b14d37f5@moroto.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -6,6 +6,7 @@
  * Author: Kishon Vijay Abraham I <kishon@ti.com>
  */
 
+#include <linux/align.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
@@ -589,7 +590,7 @@ int dw_pcie_ep_raise_msix_irq(struct dw_
 	}
 
 	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
-	msg_addr &= ~aligned_offset;
+	msg_addr = ALIGN_DOWN(msg_addr, epc->mem->window.page_size);
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
 				  epc->mem->window.page_size);
 	if (ret)


