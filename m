Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E9359FB0;
	Fri,  9 Jan 2026 12:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960346; cv=none; b=NRD/1q7di15309YHJGpY/eYgLTHP0qq8AP2W5IknaviDwZSGnLG2VT4u/AT5RcPiLQ1SPcYCdK64E12tgFVUcQ59Ro5oeP2UL2ZAtOYNh45xMPMoORbofFXFZ8N3IqljqIpw5TN40KKcJp6W9a4FKo6tC3OMZrtJcvc3tz/HH9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960346; c=relaxed/simple;
	bh=U/hxFRAUYp/xllQp1BYY9Gof5+CVKemf60jz3rAioqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eChScPDGZqysZgKyo2CiwL/6kVZ5ElvfHL4Q6KSZeaYzmskJy9Pd4KNy03q05L40nPvDuDw8M2t+xYBCYuPd1sv+yZoTAyWWcSfQfqpjyXYQaS9AnHATfYA8Rn79HV8Ry6TrMtWGg3fg/CLBP3MhSBf+xl3qPDXO16HESNeRBe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbuXJiy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbuXJiy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C207C4CEF1;
	Fri,  9 Jan 2026 12:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960346;
	bh=U/hxFRAUYp/xllQp1BYY9Gof5+CVKemf60jz3rAioqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbuXJiy0rGmmdYBcmGTaTgLgoYLbSN44b0WJxamQKTPhTj50mumrGn4G3oKka50Pp
	 mcEqFwk+6jxfUs+g/tBzyyxnUdb9F3cpaLosHfeh/r97XfnPvFz4d7bbbHIz5MhnSV
	 LdlKOP8jy93nNmggYhim659K0I9qI+qXt5NjwG8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/737] net/mlx5: Skip HotPlug check on sync reset using hot reset
Date: Fri,  9 Jan 2026 12:38:13 +0100
Message-ID: <20260109112147.312156491@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 48bb52b0bc6693afb17a6024bab925b25fec44a1 ]

Sync reset request is nacked by the driver when PCIe bridge connected to
mlx5 device has HotPlug interrupt enabled. However, when using reset
method of hot reset this check can be skipped as Hotplug is supported on
this reset method.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240911201757.1505453-12-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 367e501f8b09 ("net/mlx5: Serialize firmware reset with devlink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index dc7afc9e7777d..bdcd9e5306331 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -396,7 +396,8 @@ static int mlx5_check_dev_ids(struct mlx5_core_dev *dev, u16 dev_id)
 	return 0;
 }
 
-static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev)
+static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev,
+				      u8 reset_method)
 {
 	u16 dev_id;
 	int err;
@@ -412,9 +413,11 @@ static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev)
 	}
 
 #if IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE)
-	err = mlx5_check_hotplug_interrupt(dev);
-	if (err)
-		return false;
+	if (reset_method != MLX5_MFRL_REG_PCI_RESET_METHOD_HOT_RESET) {
+		err = mlx5_check_hotplug_interrupt(dev);
+		if (err)
+			return false;
+	}
 #endif
 
 	err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
@@ -435,7 +438,7 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 		mlx5_core_warn(dev, "Failed reading MFRL, err %d\n", err);
 
 	if (err || test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags) ||
-	    !mlx5_is_reset_now_capable(dev)) {
+	    !mlx5_is_reset_now_capable(dev, fw_reset->reset_method)) {
 		err = mlx5_fw_reset_set_reset_sync_nack(dev);
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Nack %s",
 			       err ? "Failed" : "Sent");
-- 
2.51.0



