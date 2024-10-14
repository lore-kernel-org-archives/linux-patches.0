Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDD41B4F14;
	Mon, 14 Oct 2024 14:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917330; cv=none; b=C19ifFNbmgmloMgHDxUByO+p+Upfn5jqpVxvdEEnL5DOWt4Z3jkM//7iNl1gRRB5s94ihaW6OyMuEXh79gPGKYf5dFkIoZDLhtuoABLwilYCN/cnp4nPe1o4Zeyyd7LDzPopHtMgBh4gOKVwXlZDtual9ZIt5TRrla5QayPiE/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917330; c=relaxed/simple;
	bh=e0//OWB6a2v2tmXi9Bi+4QKFR5uMUn426ITt38maviM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXXV9A/jNeOJnvF/U0zYiLmblt2u/UeXH20eJ9d4ZiLX+adpZAaXg3DSXarqcTSuY+4DcLOfy92VRazXLfOmBwSu1yxMUAa/5LMimg4bXFgtIhC+2qJIQXLxAQlNOr+CxL3Xr5JF8ch0wbnQkQYNtCtUmZ6Hoh3vJBHmWs192N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pwt1JLas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pwt1JLas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1592C4CEC3;
	Mon, 14 Oct 2024 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917330;
	bh=e0//OWB6a2v2tmXi9Bi+4QKFR5uMUn426ITt38maviM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pwt1JLas8SHWH3eU33ZgND34MNoBKDD8Fa8vEQG4z+nxlG9/8MTw01L6kQ9DZeTWf
	 GvotT3gf2SKX2VkjIv2KQSKXrQIT42SQcE1dd8xDYBRLvGooymPG9QGFdp1N3NYGBT
	 4jCSh+1JKECFWHMuzocUKVLc5RwFspG2TzXKB3cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Dieter Mummenschanz <dmummenschanz@web.de>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>
Subject: [PATCH 6.6 212/213] e1000e: fix force smbus during suspend flow
Date: Mon, 14 Oct 2024 16:21:58 +0200
Message-ID: <20241014141051.233693731@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

commit 76a0a3f9cc2fbd0e56671706bb74a9a988397898 upstream.

Commit 861e8086029e ("e1000e: move force SMBUS from enable ulp function
to avoid PHY loss issue") resolved a PHY access loss during suspend on
Meteor Lake consumer platforms, but it affected corporate systems
incorrectly.

A better fix, working for both consumer and corporate systems, was
proposed in commit bfd546a552e1 ("e1000e: move force SMBUS near the end
of enable_ulp function"). However, it introduced a regression on older
devices, such as [8086:15B8], [8086:15F9], [8086:15BE].

This patch aims to fix the secondary regression, by limiting the scope of
the changes to Meteor Lake platforms only.

Fixes: bfd546a552e1 ("e1000e: move force SMBUS near the end of enable_ulp function")
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218940
Reported-by: Dieter Mummenschanz <dmummenschanz@web.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218936
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240709203123.2103296-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |   73 ++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 20 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1109,6 +1109,46 @@ static s32 e1000_platform_pm_pch_lpt(str
 }
 
 /**
+ *  e1000e_force_smbus - Force interfaces to transition to SMBUS mode.
+ *  @hw: pointer to the HW structure
+ *
+ *  Force the MAC and the PHY to SMBUS mode. Assumes semaphore already
+ *  acquired.
+ *
+ * Return: 0 on success, negative errno on failure.
+ **/
+static s32 e1000e_force_smbus(struct e1000_hw *hw)
+{
+	u16 smb_ctrl = 0;
+	u32 ctrl_ext;
+	s32 ret_val;
+
+	/* Switching PHY interface always returns MDI error
+	 * so disable retry mechanism to avoid wasting time
+	 */
+	e1000e_disable_phy_retry(hw);
+
+	/* Force SMBus mode in the PHY */
+	ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL, &smb_ctrl);
+	if (ret_val) {
+		e1000e_enable_phy_retry(hw);
+		return ret_val;
+	}
+
+	smb_ctrl |= CV_SMB_CTRL_FORCE_SMBUS;
+	e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, smb_ctrl);
+
+	e1000e_enable_phy_retry(hw);
+
+	/* Force SMBus mode in the MAC */
+	ctrl_ext = er32(CTRL_EXT);
+	ctrl_ext |= E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, ctrl_ext);
+
+	return 0;
+}
+
+/**
  *  e1000_enable_ulp_lpt_lp - configure Ultra Low Power mode for LynxPoint-LP
  *  @hw: pointer to the HW structure
  *  @to_sx: boolean indicating a system power state transition to Sx
@@ -1165,6 +1205,14 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000
 	if (ret_val)
 		goto out;
 
+	if (hw->mac.type != e1000_pch_mtp) {
+		ret_val = e1000e_force_smbus(hw);
+		if (ret_val) {
+			e_dbg("Failed to force SMBUS: %d\n", ret_val);
+			goto release;
+		}
+	}
+
 	/* Si workaround for ULP entry flow on i127/rev6 h/w.  Enable
 	 * LPLU and disable Gig speed when entering ULP
 	 */
@@ -1225,27 +1273,12 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000
 	}
 
 release:
-	/* Switching PHY interface always returns MDI error
-	 * so disable retry mechanism to avoid wasting time
-	 */
-	e1000e_disable_phy_retry(hw);
-
-	/* Force SMBus mode in PHY */
-	ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL, &phy_reg);
-	if (ret_val) {
-		e1000e_enable_phy_retry(hw);
-		hw->phy.ops.release(hw);
-		goto out;
+	if (hw->mac.type == e1000_pch_mtp) {
+		ret_val = e1000e_force_smbus(hw);
+		if (ret_val)
+			e_dbg("Failed to force SMBUS over MTL system: %d\n",
+			      ret_val);
 	}
-	phy_reg |= CV_SMB_CTRL_FORCE_SMBUS;
-	e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, phy_reg);
-
-	e1000e_enable_phy_retry(hw);
-
-	/* Force SMBus mode in MAC */
-	mac_reg = er32(CTRL_EXT);
-	mac_reg |= E1000_CTRL_EXT_FORCE_SMBUS;
-	ew32(CTRL_EXT, mac_reg);
 
 	hw->phy.ops.release(hw);
 out:


