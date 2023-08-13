Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048CF9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2B9C433C7;
	Sun, 13 Aug 2023 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962152;
	bh=cvqnIKndd98t4UYY1pzJ5yw7dW7QKqRSe5BdsRiBZdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAUtksvA9fZ91CKL6fIafO7P+alEa2QKlMbRAShv6tLkeH7WURe7Rz+Dgf3zKvBv+
	 U1O8IhQbcQy+yFh8q+g/jpI59Up0PcXuBWhZshgWzsvTiZHM266GbbNt5kMDE+oZNp
	 HWan8VPI5bkTJroObJWyiyWW+KMBUIpoi7bBxuak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 133/206] PCI: move OF status = "disabled" detection to dev->match_driver
Date: Sun, 13 Aug 2023 23:18:23 +0200
Message-ID: <20230813211728.832515996@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 1a8c251cff2052b60009a070173308322e9600d3 upstream.

The blamed commit has broken probing on
arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi when &enetc_port0
(PCI function 0) has status = "disabled".

Background: pci_scan_slot() has logic to say that if the function 0 of a
device is absent, the entire device is absent and we can skip the other
functions entirely. Traditionally, this has meant that
pci_bus_read_dev_vendor_id() returns an error code for that function.

However, since the blamed commit, there is an extra confounding
condition: function 0 of the device exists and has a valid vendor id,
but it is disabled in the device tree. In that case, pci_scan_slot()
would incorrectly skip the entire device instead of just that function.

In the case of NXP LS1028A, status = "disabled" does not mean that the
PCI function's config space is not available for reading. It is, but the
Ethernet port is just not functionally useful with a particular SerDes
protocol configuration (0x9999) due to pinmuxing constraints of the Soc.
So, pci_scan_slot() skips all other functions on the ENETC ECAM
(enetc_port1, enetc_port2, enetc_mdio_pf3 etc) when just enetc_port0 had
to not be probed.

There is an additional regression introduced by the change, caused by
its fundamental premise. The enetc driver needs to run code for all PCI
functions, regardless of whether they're enabled or not in the device
tree. That is no longer possible if the driver's probe function is no
longer called. But Rob recommends that we move the of_device_is_available()
detection to dev->match_driver, and this makes the PCI fixups still run
on all functions, while just probing drivers for those functions that
are enabled. So, a separate change in the enetc driver will have to move
the workarounds to a PCI fixup.

Fixes: 6fffbc7ae137 ("PCI: Honor firmware's device disabled status")
Link: https://lore.kernel.org/netdev/CAL_JsqLsVYiPLx2kcHkDQ4t=hQVCR7NHziDwi9cCFUFhx48Qow@mail.gmail.com/
Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/bus.c |    4 +++-
 drivers/pci/of.c  |    5 -----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
+#include <linux/of.h>
 #include <linux/proc_fs.h>
 #include <linux/slab.h>
 
@@ -332,6 +333,7 @@ void __weak pcibios_bus_add_device(struc
  */
 void pci_bus_add_device(struct pci_dev *dev)
 {
+	struct device_node *dn = dev->dev.of_node;
 	int retval;
 
 	/*
@@ -344,7 +346,7 @@ void pci_bus_add_device(struct pci_dev *
 	pci_proc_attach_device(dev);
 	pci_bridge_d3_update(dev);
 
-	dev->match_driver = true;
+	dev->match_driver = !dn || of_device_is_available(dn);
 	retval = device_attach(&dev->dev);
 	if (retval < 0 && retval != -EPROBE_DEFER)
 		pci_warn(dev, "device attach failed (%d)\n", retval);
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -34,11 +34,6 @@ int pci_set_of_node(struct pci_dev *dev)
 	if (!node)
 		return 0;
 
-	if (!of_device_is_available(node)) {
-		of_node_put(node);
-		return -ENODEV;
-	}
-
 	dev->dev.of_node = node;
 	dev->dev.fwnode = &node->fwnode;
 	return 0;


