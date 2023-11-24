Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA3439FD7;
	Fri, 24 Nov 2023 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKqMqks4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51D6C433C7;
	Fri, 24 Nov 2023 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849292;
	bh=jcNYOc1p/tlL2tK38hNJ6rkjIQtqe0+51Ivgres/Dd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKqMqks4FlslE/9Gwymy7hSwP9eV7sBwbf38wzHcUIvycgIIiGEwsbuDf4Kwuxal8
	 T1kWW0YDHqg6PSgLJoBXLobhpt7PZ92gXTTTRtJnARCUMSXtSzwRmS1NOMaeb2j1/g
	 z+/mp/wwiXm4j38Vosd7aTexPgwmnBmgYTsI3KWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/530] PCI: Use FIELD_GET() to extract Link Width
Date: Fri, 24 Nov 2023 17:44:32 +0000
Message-ID: <20231124172031.350663157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit d1f9b39da4a5347150246871325190018cda8cb3 ]

Use FIELD_GET() to extract PCIe Negotiated and Maximum Link Width fields
instead of custom masking and shifting.

Link: https://lore.kernel.org/r/20230919125648.1920-7-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[bhelgaas: drop duplicate include of <linux/bitfield.h>]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 5 ++---
 drivers/pci/pci.c       | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d9eede2dbc0e1..5a6241044c3c8 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -12,7 +12,7 @@
  * Modeled after usb's driverfs.c
  */
 
-
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/pci.h>
@@ -230,8 +230,7 @@ static ssize_t current_link_width_show(struct device *dev,
 	if (err)
 		return -EINVAL;
 
-	return sysfs_emit(buf, "%u\n",
-		(linkstat & PCI_EXP_LNKSTA_NLW) >> PCI_EXP_LNKSTA_NLW_SHIFT);
+	return sysfs_emit(buf, "%u\n", FIELD_GET(PCI_EXP_LNKSTA_NLW, linkstat));
 }
 static DEVICE_ATTR_RO(current_link_width);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5e51e8bd5c13a..ec43ebfc24a5d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6260,8 +6260,7 @@ u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
 		pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 
 		next_speed = pcie_link_speed[lnksta & PCI_EXP_LNKSTA_CLS];
-		next_width = (lnksta & PCI_EXP_LNKSTA_NLW) >>
-			PCI_EXP_LNKSTA_NLW_SHIFT;
+		next_width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
 
 		next_bw = next_width * PCIE_SPEED2MBS_ENC(next_speed);
 
@@ -6333,7 +6332,7 @@ enum pcie_link_width pcie_get_width_cap(struct pci_dev *dev)
 
 	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
 	if (lnkcap)
-		return (lnkcap & PCI_EXP_LNKCAP_MLW) >> 4;
+		return FIELD_GET(PCI_EXP_LNKCAP_MLW, lnkcap);
 
 	return PCIE_LNK_WIDTH_UNKNOWN;
 }
-- 
2.42.0



