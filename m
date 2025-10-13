Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCBE3064A2;
	Mon, 13 Oct 2025 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369847; cv=none; b=dfPAmBVrWUNJU4O4ULZ9gFSfurgEPsHI2Ht+3J8kmN5fzthx212DPOJFe9m4B11vmAU5HwcwzC/x0+6yq6OawlBWQXktZ2PSwDe5QniJI9LFnXajbq3oj34Litcx7K5iBodnKKNKDyS57m03SsU6qkUohjp6id2RW6ixbop6ap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369847; c=relaxed/simple;
	bh=6EEvW7xuQob7R7oV8nNI2oShfwdjM0nAyrta/6Zwwyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlS+eMP9CTwuHOrJZyuzyfMvHYC1kgJONPEYFoNV3BkQ3V1um+v4oEkfp2T1spM3bc3af8WSDLCCyBVG1FP0Q7fLWGXOd0N0FRaSKOt0zp4lC+S974lm/aPrIZRtIkCoNDJXxPOF6yzyHhXH6/T0WdjXJiS6wdJPRoAOkq4DXVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M85VtCCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M85VtCCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A3AC4CEE7;
	Mon, 13 Oct 2025 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369847;
	bh=6EEvW7xuQob7R7oV8nNI2oShfwdjM0nAyrta/6Zwwyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M85VtCCWTwOC4fQ3i2uIzWqUmGZIaDMEXuBtoTxAClf4OBuoLMpWjhM5BLchrbF4y
	 rnvgV+d2csnv3wcvTf534lQ7CBclLRxSWSC2O/5RTZa+e9fwz3zW8hAxO5yFidUpNt
	 FsEOM0dz5gbFrZ8JFIMr5TaINcS1zGjfxez/NRmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 390/563] wifi: ath12k: initialize eirp_power before use
Date: Mon, 13 Oct 2025 16:44:11 +0200
Message-ID: <20251013144425.412773484@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit bba2f9faf41ee9607c78fcd669527b7654543cfe ]

Currently, at the end of ath12k_mac_fill_reg_tpc_info(), the
reg_tpc_info struct is populated, including the following:
reg_tpc_info->is_psd_power = is_psd_power;
reg_tpc_info->eirp_power = eirp_power;

Kernel test robot complains on uninitialized symbol:
drivers/net/wireless/ath/ath12k/mac.c:10069
ath12k_mac_fill_reg_tpc_info() error: uninitialized symbol 'eirp_power'

This is because there are some code paths that never set eirp_power, so
the assignment of reg_tpc_info->eirp_power can come from an
uninitialized variable. Functionally this is OK since the eirp_power
only has meaning when is_psd_power is true, and all code paths which set
is_psd_power to true also set eirp_power. However, to keep the robot
happy, always initialize eirp_power before use.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: aeda163bb0c7 ("wifi: ath12k: fill parameters for vdev set TPC power WMI command")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505180927.tbNWr3vE-lkp@intel.com/
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250804-ath12k-fix-smatch-warning-on-6g-vlp-v1-1-56f1e54152ab@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 3a3965b79942d..93a9c2bc3c596 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11240,8 +11240,8 @@ void ath12k_mac_fill_reg_tpc_info(struct ath12k *ar,
 	struct ieee80211_channel *chan, *temp_chan;
 	u8 pwr_lvl_idx, num_pwr_levels, pwr_reduction;
 	bool is_psd_power = false, is_tpe_present = false;
-	s8 max_tx_power[ATH12K_NUM_PWR_LEVELS],
-		psd_power, tx_power, eirp_power;
+	s8 max_tx_power[ATH12K_NUM_PWR_LEVELS], psd_power, tx_power;
+	s8 eirp_power = 0;
 	struct ath12k_vif *ahvif = arvif->ahvif;
 	u16 start_freq, center_freq;
 	u8 reg_6ghz_power_mode;
-- 
2.51.0



