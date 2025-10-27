Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB21E326D6F;
	Mon, 27 Oct 2025 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592505; cv=none; b=FXXJiBv7CKf/6UMYJI+xhBimY3NGzYGrXFGJddLxgmkAnlbDz4GKs0hqLNo49FuFWd/lMutGhpWN+/TKyqRSYja1LpiHx1dZ42d93rHzpbQQKljLU+Jjddd5knqiWuqLNYoXhz0OJ1bsoCPNeAAKHM0ASpgPdW8WuHQyMn44Ftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592505; c=relaxed/simple;
	bh=RYlyzLF5qjJHe6e68cPrs0Z5rtSCYCrqblwPKO5Nk5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKiMVBC71kr485eMb8g//LVFiKpYaHch3k0la13VfLB58k7O/LB2kGZjmZXOgom/CdTpgR+VDolhU+VE9bUn/H732WwvXTMZKHgrEzcCiM+4rW1ASoyqsX0v4AM4u4SYqg/dks9Ro5BdUfaZwJ7RUdKwNxDcfNHt1l3rkSmlw3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKKapOmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKKapOmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8172EC4CEF1;
	Mon, 27 Oct 2025 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592504;
	bh=RYlyzLF5qjJHe6e68cPrs0Z5rtSCYCrqblwPKO5Nk5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKKapOmuoS5U3hoP0m9juQh83YgViU3sxbKaEwzB9AKzoMFK+aet+ZkQS6nvHXALu
	 iuMmNrV993FctWF/diS2fv0bFIUMobU6otT2XMKyhFI21XIk8pAhy/uYUUBRiyokB0
	 XxMFMZLsks44V9NwvosKCF2c/SZJ4OCq1/sTOZR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Wilczynski <andrzejx.wilczynski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/157] ixgbevf: fix getting link speed data for E610 devices
Date: Mon, 27 Oct 2025 19:36:46 +0100
Message-ID: <20251027183505.174576907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 53f0eb62b4d23d40686f2dd51776b8220f2887bb ]

E610 adapters no longer use the VFLINKS register to read PF's link
speed and linkup state. As a result VF driver cannot get actual link
state and it incorrectly reports 10G which is the default option.
It leads to a situation where even 1G adapters print 10G as actual
link speed. The same happens when PF driver set speed different than 10G.

Add new mailbox operation to let the VF driver request a PF driver
to provide actual link data. Update the mailbox api to v1.6.

Incorporate both ways of getting link status within the legacy
ixgbe_check_mac_link_vf() function.

Fixes: 4c44b450c69b ("ixgbevf: Add support for Intel(R) E610 device")
Co-developed-by: Andrzej Wilczynski <andrzejx.wilczynski@intel.com>
Signed-off-by: Andrzej Wilczynski <andrzejx.wilczynski@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251009-jk-iwl-net-2025-10-01-v3-2-ef32a425b92a@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a7075f501bd3 ("ixgbevf: fix mailbox API compatibility by negotiating supported features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbevf/defines.h      |    1 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    6 
 drivers/net/ethernet/intel/ixgbevf/mbx.h          |    4 
 drivers/net/ethernet/intel/ixgbevf/vf.c           |  137 +++++++++++++++++-----
 4 files changed, 116 insertions(+), 32 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbevf/defines.h
+++ b/drivers/net/ethernet/intel/ixgbevf/defines.h
@@ -28,6 +28,7 @@
 
 /* Link speed */
 typedef u32 ixgbe_link_speed;
+#define IXGBE_LINK_SPEED_UNKNOWN	0
 #define IXGBE_LINK_SPEED_1GB_FULL	0x0020
 #define IXGBE_LINK_SPEED_10GB_FULL	0x0080
 #define IXGBE_LINK_SPEED_100_FULL	0x0008
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2272,6 +2272,7 @@ static void ixgbevf_negotiate_api(struct
 {
 	struct ixgbe_hw *hw = &adapter->hw;
 	static const int api[] = {
+		ixgbe_mbox_api_16,
 		ixgbe_mbox_api_15,
 		ixgbe_mbox_api_14,
 		ixgbe_mbox_api_13,
@@ -2291,7 +2292,8 @@ static void ixgbevf_negotiate_api(struct
 		idx++;
 	}
 
-	if (hw->api_version >= ixgbe_mbox_api_15) {
+	/* Following is not supported by API 1.6, it is specific for 1.5 */
+	if (hw->api_version == ixgbe_mbox_api_15) {
 		hw->mbx.ops.init_params(hw);
 		memcpy(&hw->mbx.ops, &ixgbevf_mbx_ops,
 		       sizeof(struct ixgbe_mbx_operations));
@@ -2648,6 +2650,7 @@ static void ixgbevf_set_num_queues(struc
 		case ixgbe_mbox_api_13:
 		case ixgbe_mbox_api_14:
 		case ixgbe_mbox_api_15:
+		case ixgbe_mbox_api_16:
 			if (adapter->xdp_prog &&
 			    hw->mac.max_tx_queues == rss)
 				rss = rss > 3 ? 2 : 1;
@@ -4641,6 +4644,7 @@ static int ixgbevf_probe(struct pci_dev
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_15:
+	case ixgbe_mbox_api_16:
 		netdev->max_mtu = IXGBE_MAX_JUMBO_FRAME_SIZE -
 				  (ETH_HLEN + ETH_FCS_LEN);
 		break;
--- a/drivers/net/ethernet/intel/ixgbevf/mbx.h
+++ b/drivers/net/ethernet/intel/ixgbevf/mbx.h
@@ -66,6 +66,7 @@ enum ixgbe_pfvf_api_rev {
 	ixgbe_mbox_api_13,	/* API version 1.3, linux/freebsd VF driver */
 	ixgbe_mbox_api_14,	/* API version 1.4, linux/freebsd VF driver */
 	ixgbe_mbox_api_15,	/* API version 1.5, linux/freebsd VF driver */
+	ixgbe_mbox_api_16,      /* API version 1.6, linux/freebsd VF driver */
 	/* This value should always be last */
 	ixgbe_mbox_api_unknown,	/* indicates that API version is not known */
 };
@@ -102,6 +103,9 @@ enum ixgbe_pfvf_api_rev {
 
 #define IXGBE_VF_GET_LINK_STATE 0x10 /* get vf link state */
 
+/* mailbox API, version 1.6 VF requests */
+#define IXGBE_VF_GET_PF_LINK_STATE	0x11 /* request PF to send link info */
+
 /* length of permanent address message returned from PF */
 #define IXGBE_VF_PERMADDR_MSG_LEN	4
 /* word in permanent address message with the current multicast type */
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -313,6 +313,7 @@ int ixgbevf_get_reta_locked(struct ixgbe
 	 * is not supported for this device type.
 	 */
 	switch (hw->api_version) {
+	case ixgbe_mbox_api_16:
 	case ixgbe_mbox_api_15:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
@@ -382,6 +383,7 @@ int ixgbevf_get_rss_key_locked(struct ix
 	 * or if the operation is not supported for this device type.
 	 */
 	switch (hw->api_version) {
+	case ixgbe_mbox_api_16:
 	case ixgbe_mbox_api_15:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
@@ -552,6 +554,7 @@ static s32 ixgbevf_update_xcast_mode(str
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_15:
+	case ixgbe_mbox_api_16:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -625,6 +628,48 @@ static s32 ixgbevf_hv_get_link_state_vf(
 }
 
 /**
+ * ixgbevf_get_pf_link_state - Get PF's link status
+ * @hw: pointer to the HW structure
+ * @speed: link speed
+ * @link_up: indicate if link is up/down
+ *
+ * Ask PF to provide link_up state and speed of the link.
+ *
+ * Return: IXGBE_ERR_MBX in the case of mailbox error,
+ * -EOPNOTSUPP if the op is not supported or 0 on success.
+ */
+static int ixgbevf_get_pf_link_state(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
+				     bool *link_up)
+{
+	u32 msgbuf[3] = {};
+	int err;
+
+	switch (hw->api_version) {
+	case ixgbe_mbox_api_16:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	msgbuf[0] = IXGBE_VF_GET_PF_LINK_STATE;
+
+	err = ixgbevf_write_msg_read_ack(hw, msgbuf, msgbuf,
+					 ARRAY_SIZE(msgbuf));
+	if (err || (msgbuf[0] & IXGBE_VT_MSGTYPE_FAILURE)) {
+		err = IXGBE_ERR_MBX;
+		*speed = IXGBE_LINK_SPEED_UNKNOWN;
+		/* No need to set @link_up to false as it will be done by
+		 * ixgbe_check_mac_link_vf().
+		 */
+	} else {
+		*speed = msgbuf[1];
+		*link_up = msgbuf[2];
+	}
+
+	return err;
+}
+
+/**
  *  ixgbevf_set_vfta_vf - Set/Unset VLAN filter table address
  *  @hw: pointer to the HW structure
  *  @vlan: 12 bit VLAN ID
@@ -659,6 +704,58 @@ mbx_err:
 }
 
 /**
+ * ixgbe_read_vflinks - Read VFLINKS register
+ * @hw: pointer to the HW structure
+ * @speed: link speed
+ * @link_up: indicate if link is up/down
+ *
+ * Get linkup status and link speed from the VFLINKS register.
+ */
+static void ixgbe_read_vflinks(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
+			       bool *link_up)
+{
+	u32 vflinks = IXGBE_READ_REG(hw, IXGBE_VFLINKS);
+
+	/* if link status is down no point in checking to see if PF is up */
+	if (!(vflinks & IXGBE_LINKS_UP)) {
+		*link_up = false;
+		return;
+	}
+
+	/* for SFP+ modules and DA cables on 82599 it can take up to 500usecs
+	 * before the link status is correct
+	 */
+	if (hw->mac.type == ixgbe_mac_82599_vf) {
+		for (int i = 0; i < 5; i++) {
+			udelay(100);
+			vflinks = IXGBE_READ_REG(hw, IXGBE_VFLINKS);
+
+			if (!(vflinks & IXGBE_LINKS_UP)) {
+				*link_up = false;
+				return;
+			}
+		}
+	}
+
+	/* We reached this point so there's link */
+	*link_up = true;
+
+	switch (vflinks & IXGBE_LINKS_SPEED_82599) {
+	case IXGBE_LINKS_SPEED_10G_82599:
+		*speed = IXGBE_LINK_SPEED_10GB_FULL;
+		break;
+	case IXGBE_LINKS_SPEED_1G_82599:
+		*speed = IXGBE_LINK_SPEED_1GB_FULL;
+		break;
+	case IXGBE_LINKS_SPEED_100_82599:
+		*speed = IXGBE_LINK_SPEED_100_FULL;
+		break;
+	default:
+		*speed = IXGBE_LINK_SPEED_UNKNOWN;
+	}
+}
+
+/**
  * ixgbevf_hv_set_vfta_vf - * Hyper-V variant - just a stub.
  * @hw: unused
  * @vlan: unused
@@ -705,7 +802,6 @@ static s32 ixgbevf_check_mac_link_vf(str
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
 	struct ixgbe_mac_info *mac = &hw->mac;
 	s32 ret_val = 0;
-	u32 links_reg;
 	u32 in_msg = 0;
 
 	/* If we were hit with a reset drop the link */
@@ -715,36 +811,14 @@ static s32 ixgbevf_check_mac_link_vf(str
 	if (!mac->get_link_status)
 		goto out;
 
-	/* if link status is down no point in checking to see if pf is up */
-	links_reg = IXGBE_READ_REG(hw, IXGBE_VFLINKS);
-	if (!(links_reg & IXGBE_LINKS_UP))
-		goto out;
-
-	/* for SFP+ modules and DA cables on 82599 it can take up to 500usecs
-	 * before the link status is correct
-	 */
-	if (mac->type == ixgbe_mac_82599_vf) {
-		int i;
-
-		for (i = 0; i < 5; i++) {
-			udelay(100);
-			links_reg = IXGBE_READ_REG(hw, IXGBE_VFLINKS);
-
-			if (!(links_reg & IXGBE_LINKS_UP))
-				goto out;
-		}
-	}
-
-	switch (links_reg & IXGBE_LINKS_SPEED_82599) {
-	case IXGBE_LINKS_SPEED_10G_82599:
-		*speed = IXGBE_LINK_SPEED_10GB_FULL;
-		break;
-	case IXGBE_LINKS_SPEED_1G_82599:
-		*speed = IXGBE_LINK_SPEED_1GB_FULL;
-		break;
-	case IXGBE_LINKS_SPEED_100_82599:
-		*speed = IXGBE_LINK_SPEED_100_FULL;
-		break;
+	if (hw->mac.type == ixgbe_mac_e610_vf) {
+		ret_val = ixgbevf_get_pf_link_state(hw, speed, link_up);
+		if (ret_val)
+			goto out;
+	} else {
+		ixgbe_read_vflinks(hw, speed, link_up);
+		if (*link_up == false)
+			goto out;
 	}
 
 	/* if the read failed it could just be a mailbox collision, best wait
@@ -951,6 +1025,7 @@ int ixgbevf_get_queues(struct ixgbe_hw *
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_15:
+	case ixgbe_mbox_api_16:
 		break;
 	default:
 		return 0;


