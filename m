Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E846D2C1;
	Tue, 21 Jul 2026 19:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661059; cv=none; b=KSdx91hs6j0uLMAcZ8bDmsOKGu8rxv8mWhY+ylfPhFY182MzcHXWkMx7b+qd7z6qipC5b9sgNTxVbQOenVmEm46UfG/FtvXfHojEJXaIk1QuiRLce0S6zfMVPQb8R+yS+rhyumCtpCcZgIRBxY5SSXPhlecsUqfXgzpdKbsgOMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661059; c=relaxed/simple;
	bh=mlE9pUcm9omthWClEVUGTmRFDhOWVQUynYAPn0eOHjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YumQULwRRzquqUlvoS5KJQXSSR1BJuQigMm8xXF2mvJ6uzk7cQlOzEnXXG99y7QpdCnnVp2bHTyfHSzVrSOl3jYmP5zF/k21fLyZRjXofMYIFte/wKEHBfjxyQ2h00ql6/REwwFS+chBrEXHDyGW0l+5gNvfyqL53GaJLZSXTq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdYYxXdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdYYxXdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6909B1F000E9;
	Tue, 21 Jul 2026 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661057;
	bh=TG1jmZ8bIz/eg0hfQsJFzfXwCbZLP2WlRzr2bHAGQ2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdYYxXdABL011wbY8lMBCkGCx10sS3lzYDBhUyku4smBoifzK4kUG8ZUY3GMJ72D6
	 TaSnGt7IHk12gNt1fAYE2G76kQA1g528LJuCBT+0pNZ8PGQG0/GnUvOUAHHeIur7ri
	 2zvTE2oUzubqgqNwTQDLtXIVziliC2qhc/znoDIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Moriya Kadosh <moriyax.kadosh@intel.com>,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1215/2077] e1000e: Reconfigure PLL clock gate timeout and re-enable K1 on Meteor Lake
Date: Tue, 21 Jul 2026 17:14:48 +0200
Message-ID: <20260721152621.472653461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dima Ruinskiy <dima.ruinskiy@intel.com>

[ Upstream commit 578294b8b60d2c630991f221838f9ec61ae89df0 ]

Commit 3c7bf5af21960 ("e1000e: Introduce private flag to disable K1")
disabled K1 by default on Meteor Lake and newer systems due to packet
loss observed on various platforms. However, disabling K1 caused an
increase in power consumption.

To mitigate this, reconfigure the PLL clock gate value so that K1 can
remain enabled without incurring the additional power consumption.
Re-enable K1 by default, but keep the private flag to support disabling
it via ethtool. Additionally, introduce a DMI quirk table, so that K1 may
be disabled by default on known problematic systems. Currently, this
includes the Dell Pro 16 Plus, where the issue has been reported to persist
despite the changes to the PLL lock timeout.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220954
Link: https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20250623/048860.html
Link: https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20260330/054059.html
Signed-off-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Co-developed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Fixes: 3c7bf5af21960 ("e1000e: Introduce private flag to disable K1")
Tested-by: Moriya Kadosh <moriyax.kadosh@intel.com>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  3 +++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index dea208db1be5bf..aa90e0ce8acaf8 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1594,6 +1594,9 @@ static s32 e1000_check_for_copper_link_ich8lan(struct e1000_hw *hw)
 			phy_reg &= ~I217_PLL_CLOCK_GATE_MASK;
 			if (speed == SPEED_100 || speed == SPEED_10)
 				phy_reg |= 0x3E8;
+			else if (hw->mac.type == e1000_pch_mtp ||
+				 hw->mac.type == e1000_pch_ptp)
+				phy_reg |= 0x1D5;
 			else
 				phy_reg |= 0xFA;
 			e1e_wphy_locked(hw, I217_PLL_CLOCK_GATE_REG, phy_reg);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 7ce0cc8ab8f4c7..7612ddd066fe54 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -25,6 +25,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/prefetch.h>
 #include <linux/suspend.h>
+#include <linux/dmi.h>
 
 #include "e1000.h"
 #define CREATE_TRACE_POINTS
@@ -58,6 +59,17 @@ static const struct e1000_info *e1000_info_tbl[] = {
 	[board_pch_ptp]		= &e1000_pch_ptp_info,
 };
 
+static const struct dmi_system_id disable_k1_list[] = {
+	{
+		.ident = "Dell Pro 16 Plus PB16250",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro 16 Plus PB16250"),
+		},
+	},
+	{}
+};
+
 struct e1000_reg_info {
 	u32 ofs;
 	char *name;
@@ -7670,7 +7682,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* init PTP hardware clock */
 	e1000e_ptp_init(adapter);
 
-	if (hw->mac.type >= e1000_pch_mtp)
+	/* disable K1 by default on known problematic systems */
+	if (hw->mac.type >= e1000_pch_mtp && dmi_check_system(disable_k1_list))
 		adapter->flags2 |= FLAG2_DISABLE_K1;
 
 	/* reset the hardware with the new settings */
-- 
2.53.0



