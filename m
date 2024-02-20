Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BDC2DF9F;
	Tue, 20 Feb 2024 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465281; cv=none; b=r98JTc+7CjJ7WQe8OkkOhfAUBfUVgfcs47TMamRQU/ONGXVETJwAC9zwAesbxhTSF0WDMKwU+6jkwlkGmEnRiJ9/xeAkv2vFjmQVjo51A+zfk26qX55nRuDbLLHSYpJld4auFY63I5aBJG9AC9SfH372FscIt/1F+IkTskp/Rxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465281; c=relaxed/simple;
	bh=1g4LJKWg380MFQVmR7uXcSthdALF9l3OsdMGwseqfMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKX1KrHSlCrkmKkiqS+jJGlJqq/km1PSWcYz5KHW1DaysflogeNO9oxGBneH/EEcNKXr5CQ5pzNUaygH/KZOV8wdXf0ghOyEEHH/g7Zsb54lczx7QkRCoIuHCivBEZ2rTKiuNv5Jkfzp6ip8k7z/yfPoh+8WPnXqiocNsLPtu08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MD2C14i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MD2C14i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775DCC433C7;
	Tue, 20 Feb 2024 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465280;
	bh=1g4LJKWg380MFQVmR7uXcSthdALF9l3OsdMGwseqfMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MD2C14ikd3dCOVkz8BnRPntQ61RdEIf2fYCl2G0jOW4FjVEHSH+VKiyEl0Kh1poY
	 O+m/aBTIHL75PCezuLkcCCDfP7Sk3YbN8ZyYyokHJSyyzQ4QroU6d7p7ScP9gC9BFB
	 bbEcdF3zHsTmhu72hNhIAJEfFwmUojglbthJep6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.7 254/309] PCI: dwc: Fix a 64bit bug in dw_pcie_ep_raise_msix_irq()
Date: Tue, 20 Feb 2024 21:56:53 +0100
Message-ID: <20240220205641.113048343@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 #include <linux/bitfield.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -615,7 +616,7 @@ int dw_pcie_ep_raise_msix_irq(struct dw_
 	}
 
 	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
-	msg_addr &= ~aligned_offset;
+	msg_addr = ALIGN_DOWN(msg_addr, epc->mem->window.page_size);
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
 				  epc->mem->window.page_size);
 	if (ret)


