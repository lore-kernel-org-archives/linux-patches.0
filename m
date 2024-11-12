Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF420F5D3;
	Tue, 12 Nov 2024 10:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407642; cv=none; b=faEcQwq+ONOHTv4KYuTIjsf7/FAbhP0jW1DqIrTs+5Q78gmT15+YIzyVFpdztgffybO9gOWd99VuvWsJKfcA5t4WeIRmSIe1NJUsf1xYnJeiOtfNKsBlDuD5PzkcIwQ6XkVz2hhBGLLaSNFHdZhYGW8V5yfoW8J6yoSezv2Q8+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407642; c=relaxed/simple;
	bh=zZ11e16MlqcxHM8n6PfYGUxsG/lqf4PBumE0yplIRW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DT2jfP8yuezAebP1WQ5jQEm9AofTJe2DVVxP5wsfEdSwyd0IK2YtDyU4ide9gp3FEtsvamTU0UA/CIULxXE8KnF2VE92yJArV2kopasmGfWimvFF/+hNfX3LFX58OAtxwPsZwPLV65yNXl5VNrRMGOiSY6O89QJZUk0nw0UBQqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVyC0ZAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVyC0ZAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA2AC4CECD;
	Tue, 12 Nov 2024 10:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407642;
	bh=zZ11e16MlqcxHM8n6PfYGUxsG/lqf4PBumE0yplIRW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVyC0ZAeIH+0X59hFkf0IIWi5bbS2/7G2cWSIFMW92brQ+x8o8y/ihCJX/tS5ZavP
	 86voP70QjJhHJnR+ZwIjaPQGtuiHytKsEj/jVl2YjFAmgdUICZcj6wt1/GNf5UaF8w
	 YxfWj2mXkK2RMAWfnlte6jKe8MrgrJ/+XQ8LWD5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/119] e1000e: Remove Meteor Lake SMBUS workarounds
Date: Tue, 12 Nov 2024 11:20:46 +0100
Message-ID: <20241112101850.169277626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

[ Upstream commit b8473723272e346e22aa487b9046fd324b73a0a5 ]

This is a partial revert to commit 76a0a3f9cc2f ("e1000e: fix force smbus
during suspend flow"). That commit fixed a sporadic PHY access issue but
introduced a regression in runtime suspend flows.
The original issue on Meteor Lake systems was rare in terms of the
reproduction rate and the number of the systems affected.

After the integration of commit 0a6ad4d9e169 ("e1000e: avoid failing the
system during pm_suspend"), PHY access loss can no longer cause a
system-level suspend failure. As it only occurs when the LAN cable is
disconnected, and is recovered during system resume flow. Therefore, its
functional impact is low, and the priority is given to stabilizing
runtime suspend.

Fixes: 76a0a3f9cc2f ("e1000e: fix force smbus during suspend flow")
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index ce227b56cf724..2f9655cf5dd9e 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1205,12 +1205,10 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw *hw, bool to_sx)
 	if (ret_val)
 		goto out;
 
-	if (hw->mac.type != e1000_pch_mtp) {
-		ret_val = e1000e_force_smbus(hw);
-		if (ret_val) {
-			e_dbg("Failed to force SMBUS: %d\n", ret_val);
-			goto release;
-		}
+	ret_val = e1000e_force_smbus(hw);
+	if (ret_val) {
+		e_dbg("Failed to force SMBUS: %d\n", ret_val);
+		goto release;
 	}
 
 	/* Si workaround for ULP entry flow on i127/rev6 h/w.  Enable
@@ -1273,13 +1271,6 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw *hw, bool to_sx)
 	}
 
 release:
-	if (hw->mac.type == e1000_pch_mtp) {
-		ret_val = e1000e_force_smbus(hw);
-		if (ret_val)
-			e_dbg("Failed to force SMBUS over MTL system: %d\n",
-			      ret_val);
-	}
-
 	hw->phy.ops.release(hw);
 out:
 	if (ret_val)
-- 
2.43.0



