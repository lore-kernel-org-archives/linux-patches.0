Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371AF2F8BD9;
	Tue, 26 Aug 2025 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208085; cv=none; b=lMfUnciXq+aqbnVyAL10KrrjulZ58AjOWyLNkqngAKVUF5BP8QEMAPDv5OjaY4OpTPSRQFbP4b8cOr/5mjQkQGwKUdsH9huagiAHlEgJZCcnk1yQEda6HSz8KNYpsVVMQwT32Y1pCOcHyJdTp8pAU00agZ3raXUZ7Q/JfDCTn8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208085; c=relaxed/simple;
	bh=Vv63Z1ySRQypRrjWbRFawFmnRjapJMyYVwXOeOKMS4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne55mNALlS4OR8u3UZsamA3qcmhdEFCT+7lGys0T/E3AVK97VebcdjzvXozta+FiJQoMKjKlUlOh5e1aapsKKk562omoU4MCoWjrwZ0/UgRYpiNv0ejDXPIo6xg/HCXj4MX4JYp9je4EkeikAlw3eLdBbmFAwG1GioQa1RV9C/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNKt50M2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNKt50M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61830C4CEF1;
	Tue, 26 Aug 2025 11:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208084;
	bh=Vv63Z1ySRQypRrjWbRFawFmnRjapJMyYVwXOeOKMS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNKt50M2tMK2Z1G82AD0hUBMHykXS+9wiJHAWUKR1d1sgNsfcs0/tWkKmtyAXpi1z
	 AZPPm9Sqi63le+bYSNwCh5CE/X9BG/AFlzUILTQi65TC+AMV8vY/5nt+SEENdGma9A
	 oiZCaUQWwCBz691zXir6aQrTci1hD54dpkFXqU/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ValdikSS <iam@valdikss.org.ru>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 432/457] igc: fix disabling L1.2 PCI-E link substate on I226 on init
Date: Tue, 26 Aug 2025 13:11:56 +0200
Message-ID: <20250826110947.965320214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ValdikSS <iam@valdikss.org.ru>

[ Upstream commit 1468c1f97cf32418e34dbb40b784ed9333b9e123 ]

Device ID comparison in igc_is_device_id_i226 is performed before
the ID is set, resulting in always failing check on init.

Before the patch:
* L1.2 is not disabled on init
* L1.2 is properly disabled after suspend-resume cycle

With the patch:
* L1.2 is properly disabled both on init and after suspend-resume

How to test:
Connect to the 1G link with 300+ mbit/s Internet speed, and run
the download speed test, such as:

    curl -o /dev/null http://speedtest.selectel.ru/1GB

Without L1.2 disabled, the speed would be no more than ~200 mbit/s.
With L1.2 disabled, the speed would reach 1 gbit/s.
Note: it's required that the latency between your host and the remote
be around 3-5 ms, the test inside LAN (<1 ms latency) won't trigger the
issue.

Link: https://lore.kernel.org/intel-wired-lan/15248b4f-3271-42dd-8e35-02bfc92b25e1@intel.com
Fixes: 0325143b59c6 ("igc: disable L1.2 PCI-E link substate to avoid performance issue")
Signed-off-by: ValdikSS <iam@valdikss.org.ru>
Reviewed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20250819222000.3504873-6-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 031c332f66c4..1b4465d6b2b7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7115,6 +7115,13 @@ static int igc_probe(struct pci_dev *pdev,
 	adapter->port_num = hw->bus.func;
 	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
+	/* PCI config space info */
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	hw->revision_id = pdev->revision;
+	hw->subsystem_vendor_id = pdev->subsystem_vendor;
+	hw->subsystem_device_id = pdev->subsystem_device;
+
 	/* Disable ASPM L1.2 on I226 devices to avoid packet loss */
 	if (igc_is_device_id_i226(hw))
 		pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
@@ -7141,13 +7148,6 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->mem_start = pci_resource_start(pdev, 0);
 	netdev->mem_end = pci_resource_end(pdev, 0);
 
-	/* PCI config space info */
-	hw->vendor_id = pdev->vendor;
-	hw->device_id = pdev->device;
-	hw->revision_id = pdev->revision;
-	hw->subsystem_vendor_id = pdev->subsystem_vendor;
-	hw->subsystem_device_id = pdev->subsystem_device;
-
 	/* Copy the default MAC and PHY function pointers */
 	memcpy(&hw->mac.ops, ei->mac_ops, sizeof(hw->mac.ops));
 	memcpy(&hw->phy.ops, ei->phy_ops, sizeof(hw->phy.ops));
-- 
2.50.1



