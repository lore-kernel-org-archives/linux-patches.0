Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95551E9916;
	Wed, 15 Jan 2025 10:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938569; cv=none; b=bR6ZJptUEyb5Z3UDt4PF51ttl/hZT7VZ6jiopQza1TlWKjXuWWJ9A/DbjOAdQZ2jUzfeN0PJQqpE6wASvteQpfKkq/DQ2F8tKRa0rePACxUsN619dlYXTrdRSlQIlac+zWwi9Vru6QQaG5ulnc/CbhUl4AXu4ba5eTnRyRkWlT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938569; c=relaxed/simple;
	bh=/yiuqolGkxcxaYzKOln4PV4NLneLGdwZWukgtBG/5nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9DXoIwnkGGSLGBYEGq0SGzAafLGB/FZHC5RuP7ZvketYtZAuoKyk6kFid+Tutbxm6gxqe1Yd0S7bjLmS2u595H8WDaeXzaQGMaQhfxnInHaY/HHPAKIZjmZiCSapgMlaEIGZz3SPejpfdbmaqQ4VzQhrYnYEwb71RmhELwYmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvtdhntZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvtdhntZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AF0C4CEE1;
	Wed, 15 Jan 2025 10:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938569;
	bh=/yiuqolGkxcxaYzKOln4PV4NLneLGdwZWukgtBG/5nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvtdhntZkO++qhZ5vlzb8bU2NQCy9bAHfC5vIies/DsH2rZWeVxaPo1APgQqjsq3L
	 jel9YnlTFbm0fggDpETbSAcjGn6le+nh2DZN6ttdvTLazcT9UvA9q+adllnddGhp+x
	 WLLmxc8dIVIVRinOhNa4E2tHkId+0QJMKcUD9as4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	En-Wei Wu <en-wei.wu@canonical.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/129] igc: return early when failing to read EECD register
Date: Wed, 15 Jan 2025 11:36:45 +0100
Message-ID: <20250115103555.581002736@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: En-Wei Wu <en-wei.wu@canonical.com>

[ Upstream commit bd2776e39c2a82ef4681d02678bb77b3d41e79be ]

When booting with a dock connected, the igc driver may get stuck for ~40
seconds if PCIe link is lost during initialization.

This happens because the driver access device after EECD register reads
return all F's, indicating failed reads. Consequently, hw->hw_addr is set
to NULL, which impacts subsequent rd32() reads. This leads to the driver
hanging in igc_get_hw_semaphore_i225(), as the invalid hw->hw_addr
prevents retrieving the expected value.

To address this, a validation check and a corresponding return value
catch is added for the EECD register read result. If all F's are
returned, indicating PCIe link loss, the driver will return -ENXIO
immediately. This avoids the 40-second hang and significantly improves
boot time when using a dock with an igc NIC.

Log before the patch:
[    0.911913] igc 0000:70:00.0: enabling device (0000 -> 0002)
[    0.912386] igc 0000:70:00.0: PTM enabled, 4ns granularity
[    1.571098] igc 0000:70:00.0 (unnamed net_device) (uninitialized): PCIe link lost, device now detached
[   43.449095] igc_get_hw_semaphore_i225: igc 0000:70:00.0 (unnamed net_device) (uninitialized): Driver can't access device - SMBI bit is set.
[   43.449186] igc 0000:70:00.0: probe with driver igc failed with error -13
[   46.345701] igc 0000:70:00.0: enabling device (0000 -> 0002)
[   46.345777] igc 0000:70:00.0: PTM enabled, 4ns granularity

Log after the patch:
[    1.031000] igc 0000:70:00.0: enabling device (0000 -> 0002)
[    1.032097] igc 0000:70:00.0: PTM enabled, 4ns granularity
[    1.642291] igc 0000:70:00.0 (unnamed net_device) (uninitialized): PCIe link lost, device now detached
[    5.480490] igc 0000:70:00.0: enabling device (0000 -> 0002)
[    5.480516] igc 0000:70:00.0: PTM enabled, 4ns granularity

Fixes: ab4056126813 ("igc: Add NVM support")
Cc: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Signed-off-by: En-Wei Wu <en-wei.wu@canonical.com>
Reviewed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 9fae8bdec2a7..1613b562d17c 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -68,6 +68,10 @@ static s32 igc_init_nvm_params_base(struct igc_hw *hw)
 	u32 eecd = rd32(IGC_EECD);
 	u16 size;
 
+	/* failed to read reg and got all F's */
+	if (!(~eecd))
+		return -ENXIO;
+
 	size = FIELD_GET(IGC_EECD_SIZE_EX_MASK, eecd);
 
 	/* Added to a constant, "size" becomes the left-shift value
@@ -221,6 +225,8 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 
 	/* NVM initialization */
 	ret_val = igc_init_nvm_params_base(hw);
+	if (ret_val)
+		goto out;
 	switch (hw->mac.type) {
 	case igc_i225:
 		ret_val = igc_init_nvm_params_i225(hw);
-- 
2.39.5



