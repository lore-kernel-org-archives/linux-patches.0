Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1B183CD5;
	Tue, 30 Jul 2024 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357750; cv=none; b=QLnvsipmaaHFqZSbQnFkqADdpt97UDlUcpsfKsvC+saHEPJKpvN3qHaTKy7RUICh5jp0fX0NwWL5wpM0tGCMOKZbXpjffUA2n0ZpOQyXCsY4/ed9gh+GvQ1NhFOd8R72fOeVuhu0i0jn1PtP6i/QG6ttZHKSOU5lz8ywuvE0Y/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357750; c=relaxed/simple;
	bh=0hiLsT0tC9EoUu9m2toFTFbqYBzwRo8DiKtHRaiwWW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVIr3gx3Cru5JBmNxluVHmXb8ypfK+3vmj2NV/zAoYGBKNPOYfNkMgXAFHzPRH1oC5/pNbCtZ91dE4xZzBkc1MBHER2B2bCw9z3OW5JOD1vcDYm3OpVusJoT9rtykS2xdzb8rDR9//7P7TeNRGiw+xdLl6QdKWBCgPzWwNT99Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyFhFSaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyFhFSaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167E9C32782;
	Tue, 30 Jul 2024 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357750;
	bh=0hiLsT0tC9EoUu9m2toFTFbqYBzwRo8DiKtHRaiwWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyFhFSaL7iiH3/ZEFbyz7HTbrOzFGSyyIK+Bk2eOy9f0UCIvrntLq+4GMZxfJM4DH
	 oi0w22Y3b/mPGlxRRNgE9UUvvS5+kThir650yrE/5GePn7rwHrKEDVv5R8ET4lkow1
	 SsFs/10l5KP11hpQfbvhm05c7S44UZ8SxymWznXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 323/440] PCI: dw-rockchip: Fix initial PERST# GPIO value
Date: Tue, 30 Jul 2024 17:49:16 +0200
Message-ID: <20240730151628.435038197@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 28b8d7793b8573563b3d45321376f36168d77b1e upstream.

PERST# is active low according to the PCIe specification.

However, the existing pcie-dw-rockchip.c driver does:

  gpiod_set_value(..., 0); msleep(100); gpiod_set_value(..., 1);

when asserting + deasserting PERST#.

This is of course wrong, but because all the device trees for this
compatible string have also incorrectly marked this GPIO as ACTIVE_HIGH:

  $ git grep -B 10 reset-gpios arch/arm64/boot/dts/rockchip/rk3568*
  $ git grep -B 10 reset-gpios arch/arm64/boot/dts/rockchip/rk3588*

The actual toggling of PERST# is correct, and we cannot change it anyway,
since that would break device tree compatibility.

However, this driver does request the GPIO to be initialized as
GPIOD_OUT_HIGH, which does cause a silly sequence where PERST# gets
toggled back and forth for no good reason.

Fix this by requesting the GPIO to be initialized as GPIOD_OUT_LOW (which
for this driver means PERST# asserted).

This will avoid an unnecessary signal change where PERST# gets deasserted
(by devm_gpiod_get_optional()) and then gets asserted (by
rockchip_pcie_start_link()) just a few instructions later.

Before patch, debug prints on EP side, when booting RC:

  [  845.606810] pci: PERST# asserted by host!
  [  852.483985] pci: PERST# de-asserted by host!
  [  852.503041] pci: PERST# asserted by host!
  [  852.610318] pci: PERST# de-asserted by host!

After patch, debug prints on EP side, when booting RC:

  [  125.107921] pci: PERST# asserted by host!
  [  132.111429] pci: PERST# de-asserted by host!

This extra, very short, PERST# assertion + deassertion has been reported to
cause issues with certain WLAN controllers, e.g. RTL8822CE.

Fixes: 0e898eb8df4e ("PCI: rockchip-dwc: Add Rockchip RK356X host controller driver")
Link: https://lore.kernel.org/linux-pci/20240417164227.398901-1-cassel@kernel.org
Tested-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Jianfeng Liu <liujianfeng1994@gmail.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org	# v5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -240,7 +240,7 @@ static int rockchip_pcie_resource_get(st
 		return PTR_ERR(rockchip->apb_base);
 
 	rockchip->rst_gpio = devm_gpiod_get_optional(&pdev->dev, "reset",
-						     GPIOD_OUT_HIGH);
+						     GPIOD_OUT_LOW);
 	if (IS_ERR(rockchip->rst_gpio))
 		return PTR_ERR(rockchip->rst_gpio);
 


