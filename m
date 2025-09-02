Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAE52EFDB1;
	Tue,  2 Sep 2025 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820311; cv=none; b=fQXDMG0ZnBlVVAvWYfZJl8+7HQGbCd/lImj/EUIZYnl9qx4F9DAUBD1pA8j0JCCkiVEyHRfljEH3gDWb8ouKd2S1kbdVK82OdaeITZ2BIznj1lg23fqIgmqRFbfOMLCguZNm5T9q9o51qzBn7c/ZW9cksqlAMCq8RV0HbltejjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820311; c=relaxed/simple;
	bh=aKr/MuyJgdRlEWf+1iCdOU2EVaOU8UsD9nOWRBfc3TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b64ign184E/mhiQ0M0uPbae53YCjpg7Dcwh1us6COZLfgk6ozJTTFbegVyNS0t9JGGvqOZepjgCom7e1lMfyqQbHe6Hh083zb+lEjCqwCiEId/mqZt85XHMIB7qzvmMhtw0eaM8IBx+m4nx4+0mnr+7ZUnyFk2BnM3SMLqWNrRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkCBeH0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkCBeH0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B300C4CEED;
	Tue,  2 Sep 2025 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820311;
	bh=aKr/MuyJgdRlEWf+1iCdOU2EVaOU8UsD9nOWRBfc3TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkCBeH0GNBvqf/AqL4GfDPfQCqKGvIuvVV+tQpSzg1cqMxz/Mo2PUQaBt2shA5zsv
	 E+waNjTWm+doeVIPS4GB4qGdYiVaXYZYDvn0sdzvkjW+ertXrR+jL0g2oalkHglN4Z
	 sBmiOblGrI4c+TWbbXiVa1CETW6z+BDSFhdX1I4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/75] net/mlx5: Add device cap for supporting hot reset in sync reset flow
Date: Tue,  2 Sep 2025 15:20:49 +0200
Message-ID: <20250902131936.578070943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 9947204cdad97d22d171039019a4aad4d6899cdd ]

New devices with new FW can support sync reset for firmware activate
using hot reset. Add capability for supporting it and add MFRL field to
query from FW which type of PCI reset method to use while handling sync
reset events.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240911201757.1505453-10-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 902a8bc23a24 ("net/mlx5: Fix lockdep assertion on sync reset unload event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9106771bb92f0..4913d364e9774 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1731,7 +1731,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_328[0x2];
 	u8	   relaxed_ordering_read[0x1];
 	u8         log_max_pd[0x5];
-	u8         reserved_at_330[0x6];
+	u8         reserved_at_330[0x5];
+	u8         pcie_reset_using_hotreset_method[0x1];
 	u8         pci_sync_for_fw_update_with_driver_unload[0x1];
 	u8         vnic_env_cnt_steering_fail[0x1];
 	u8         vport_counter_local_loopback[0x1];
@@ -10824,6 +10825,11 @@ struct mlx5_ifc_mcda_reg_bits {
 	u8         data[][0x20];
 };
 
+enum {
+	MLX5_MFRL_REG_PCI_RESET_METHOD_LINK_TOGGLE = 0,
+	MLX5_MFRL_REG_PCI_RESET_METHOD_HOT_RESET = 1,
+};
+
 enum {
 	MLX5_MFRL_REG_RESET_STATE_IDLE = 0,
 	MLX5_MFRL_REG_RESET_STATE_IN_NEGOTIATION = 1,
@@ -10851,7 +10857,8 @@ struct mlx5_ifc_mfrl_reg_bits {
 	u8         pci_sync_for_fw_update_start[0x1];
 	u8         pci_sync_for_fw_update_resp[0x2];
 	u8         rst_type_sel[0x3];
-	u8         reserved_at_28[0x4];
+	u8         pci_reset_req_method[0x3];
+	u8         reserved_at_2b[0x1];
 	u8         reset_state[0x4];
 	u8         reset_type[0x8];
 	u8         reset_level[0x8];
-- 
2.50.1



