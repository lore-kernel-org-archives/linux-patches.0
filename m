Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166E6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B97C433CA;
	Sun, 17 Sep 2023 20:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982708;
	bh=P+lenagLfYl18+RWJZuYW4zW5yMtHMhkXhinYgpEudE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH8/HzeVrF0C4/6PZERB5y89IgIoCGBEkquZgGnnLOCPqZaO1GeY+rbUMk9ftTGwn
	 6aElQI3+vl6oOwQ2PNP6Wv5QF0j/lbASBL1zoPITKxTDZsLOP7N7/dxGImjh/aT+Fk
	 tdgjB3WeG10dATFndwc9ocgravLuXd3CqVg+4yF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.15 329/511] PCI: rockchip: Use 64-bit mask on MSI 64-bit PCI address
Date: Sun, 17 Sep 2023 21:12:36 +0200
Message-ID: <20230917191121.760767714@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Rick Wertenbroek <rick.wertenbroek@gmail.com>

commit cdb50033dd6dfcf02ae3d4ee56bc1a9555be6d36 upstream.

A 32-bit mask was used on the 64-bit PCI address used for mapping MSIs.
This would result in the upper 32 bits being unintentionally zeroed and
MSIs getting mapped to incorrect PCI addresses if the address had any
of the upper bits set.

Replace 32-bit mask by appropriate 64-bit mask.

[kwilczynski: use GENMASK_ULL() over GENMASK() for 32-bit compatibility]
Fixes: dc73ed0f1b8b ("PCI: rockchip: Fix window mapping and address translation for endpoint")
Closes: https://lore.kernel.org/linux-pci/8d19e5b7-8fa0-44a4-90e2-9bb06f5eb694@moroto.mountain
Link: https://lore.kernel.org/linux-pci/20230703085845.2052008-1-rick.wertenbroek@gmail.com
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -159,7 +159,9 @@
 #define PCIE_RC_CONFIG_THP_CAP		(PCIE_RC_CONFIG_BASE + 0x274)
 #define   PCIE_RC_CONFIG_THP_CAP_NEXT_MASK	GENMASK(31, 20)
 
-#define PCIE_ADDR_MASK			0xffffff00
+#define MAX_AXI_IB_ROOTPORT_REGION_NUM		3
+#define MIN_AXI_ADDR_BITS_PASSED		8
+#define PCIE_ADDR_MASK			GENMASK_ULL(63, MIN_AXI_ADDR_BITS_PASSED)
 #define PCIE_CORE_AXI_CONF_BASE		0xc00000
 #define PCIE_CORE_OB_REGION_ADDR0	(PCIE_CORE_AXI_CONF_BASE + 0x0)
 #define   PCIE_CORE_OB_REGION_ADDR0_NUM_BITS	0x3f
@@ -186,8 +188,6 @@
 #define AXI_WRAPPER_TYPE1_CFG			0xb
 #define AXI_WRAPPER_NOR_MSG			0xc
 
-#define MAX_AXI_IB_ROOTPORT_REGION_NUM		3
-#define MIN_AXI_ADDR_BITS_PASSED		8
 #define PCIE_RC_SEND_PME_OFF			0x11960
 #define ROCKCHIP_VENDOR_ID			0x1d87
 #define PCIE_LINK_IS_L2(x) \


