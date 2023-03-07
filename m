Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6CBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D82C433EF;
	Tue,  7 Mar 2023 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213282;
	bh=AF769B30T8DbAb9bQNz2IbMFDjrXhdFLVYPbCj+khD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTKRBqxIu87STyf6JZNhZZ4VC5q7fmDTYoyg3yXCAs4MuymoyIlZjwriHxygZ5CUR
	 +JWcqNoJRolfx19KyaRnUV43X+6cYnpVYKFDtsOmsa46RaN7FerMje50ij3IVBtsHi
	 Muxi/EfrxSHpDmRcVLqaLKKir3IaES1CzbH7nHfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 457/885] PCI: mt7621: Delay phy ports initialization
Date: Tue,  7 Mar 2023 17:56:31 +0100
Message-Id: <20230307170022.360211959@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 0cb2a8f3456ff1cc51d571e287a48e8fddc98ec2 ]

Some devices like ZBT WE1326 and ZBT WF3526-P and some Netgear models need
to delay phy port initialization after calling the mt7621_pcie_init_port()
driver function to get into reliable boots for both warm and hard resets.

The delay required to detect the ports seems to be in the range [75-100]
milliseconds.

If the ports are not detected the controller is not functional.

There is no datasheet or something similar to really understand why this
extra delay is needed only for these devices and it is not for most of
the boards that are built on mt7621 SoC.

This issue has been reported by openWRT community and the complete
discussion is in [0]. The 100 milliseconds delay has been tested in all
devices to validate it.

Add the extra 100 milliseconds delay to fix the issue.

[0]: https://github.com/openwrt/openwrt/pull/11220

Link: https://lore.kernel.org/r/20221231074041.264738-1-sergio.paracuellos@gmail.com
Fixes: 2bdd5238e756 ("PCI: mt7621: Add MediaTek MT7621 PCIe host controller driver")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mt7621.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-mt7621.c b/drivers/pci/controller/pcie-mt7621.c
index ee7aad09d6277..63a5f4463a9f6 100644
--- a/drivers/pci/controller/pcie-mt7621.c
+++ b/drivers/pci/controller/pcie-mt7621.c
@@ -60,6 +60,7 @@
 #define PCIE_PORT_LINKUP		BIT(0)
 #define PCIE_PORT_CNT			3
 
+#define INIT_PORTS_DELAY_MS		100
 #define PERST_DELAY_MS			100
 
 /**
@@ -369,6 +370,7 @@ static int mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 		}
 	}
 
+	msleep(INIT_PORTS_DELAY_MS);
 	mt7621_pcie_reset_ep_deassert(pcie);
 
 	tmp = NULL;
-- 
2.39.2



