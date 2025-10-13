Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFA93064A2;
	Mon, 13 Oct 2025 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369850; cv=none; b=g6mPgQS+MA12wraG8nueu98jehpjkEZSrU8z8A4ehIT786YKulF9uK75Egx/LqiyAi6SXQLy35FBpHeeyw/tgfBXWGrpLaqWfHMoAQGADWsL2AbIeIUsC6qymHFL0pF0oDYofioYZ+A+bizVLXhUYYelWbiqcnnS9K3H6oY6QmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369850; c=relaxed/simple;
	bh=4HEVEEp/iHYmyeaaaMuOHM87QWJKa62HffKJEcUCF1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwn9pBGBvhQkHeuynZdiJ1eKeN6l7JgDuMlewyEq7gC341vFISfH2H+xojjpsJ7UwuTWZElxuqHJwjtIaol2vzRnenK+ILGw7GMx2r41U6Eq8/A1CtsztmKgOeAjauFj8BCqsqM8jjJ4McI5GFBMQWkLbEkEz4WRV3sh5XJTX/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtkxc8EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtkxc8EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D93C4CEE7;
	Mon, 13 Oct 2025 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369850;
	bh=4HEVEEp/iHYmyeaaaMuOHM87QWJKa62HffKJEcUCF1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtkxc8EH655W+JK/9brmZNfDFIXVf5SBGYVLjptXvy4HQAZ2ijqwUqFdVk5op0nbq
	 9CyuenXk7bQ6m4+LHhqRHBPHD+5z+J5f5HdfLWOfBYJCk/mMpwIfQkahnh9rWdVHeC
	 ZZ7A0Cy0kHRBeZIZEu0uqGGtyP6ET5Xoemx8XlXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 391/563] wifi: ath12k: fix overflow warning on num_pwr_levels
Date: Mon, 13 Oct 2025 16:44:12 +0200
Message-ID: <20251013144425.449205273@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit ea2b0af4c9e3f7187b5be4b7fc1511ea239046c0 ]

In ath12k_mac_parse_tx_pwr_env(), for the non-PSD case num_pwr_levels is
limited by ATH12K_NUM_PWR_LEVELS which is 16:

	if (tpc_info->num_pwr_levels > ATH12K_NUM_PWR_LEVELS)
		tpc_info->num_pwr_levels = ATH12K_NUM_PWR_LEVELS;

Then it is used to iterate entries in local_non_psd->power[] and
reg_non_psd->power[]:

	for (i = 0; i < tpc_info->num_pwr_levels; i++) {
		tpc_info->tpe[i] = min(local_non_psd->power[i],
				       reg_non_psd->power[i]) / 2;

Since the two array are of size 5, Smatch warns:

drivers/net/wireless/ath/ath12k/mac.c:9812
ath12k_mac_parse_tx_pwr_env() error: buffer overflow 'local_non_psd->power' 5 <= 15
drivers/net/wireless/ath/ath12k/mac.c:9812
ath12k_mac_parse_tx_pwr_env() error: buffer overflow 'reg_non_psd->power' 5 <= 15

This is a false positive as there is already implicit limitation:

	tpc_info->num_pwr_levels = max(local_non_psd->count,
				       reg_non_psd->count);

meaning it won't exceed 5.

However, to make robot happy, add explicit limit there.

Also add the same to the PSD case, although no warning due to
ATH12K_NUM_PWR_LEVELS equals IEEE80211_TPE_PSD_ENTRIES_320MHZ.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: cccbb9d0dd6a ("wifi: ath12k: add parse of transmit power envelope element")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505180703.Kr9OfQRP-lkp@intel.com/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250804-ath12k-fix-smatch-warning-on-6g-vlp-v1-2-56f1e54152ab@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 93a9c2bc3c596..2644b5d4b0bc8 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11447,8 +11447,10 @@ static void ath12k_mac_parse_tx_pwr_env(struct ath12k *ar,
 
 		tpc_info->num_pwr_levels = max(local_psd->count,
 					       reg_psd->count);
-		if (tpc_info->num_pwr_levels > ATH12K_NUM_PWR_LEVELS)
-			tpc_info->num_pwr_levels = ATH12K_NUM_PWR_LEVELS;
+		tpc_info->num_pwr_levels =
+				min3(tpc_info->num_pwr_levels,
+				     IEEE80211_TPE_PSD_ENTRIES_320MHZ,
+				     ATH12K_NUM_PWR_LEVELS);
 
 		for (i = 0; i < tpc_info->num_pwr_levels; i++) {
 			tpc_info->tpe[i] = min(local_psd->power[i],
@@ -11463,8 +11465,10 @@ static void ath12k_mac_parse_tx_pwr_env(struct ath12k *ar,
 
 		tpc_info->num_pwr_levels = max(local_non_psd->count,
 					       reg_non_psd->count);
-		if (tpc_info->num_pwr_levels > ATH12K_NUM_PWR_LEVELS)
-			tpc_info->num_pwr_levels = ATH12K_NUM_PWR_LEVELS;
+		tpc_info->num_pwr_levels =
+				min3(tpc_info->num_pwr_levels,
+				     IEEE80211_TPE_EIRP_ENTRIES_320MHZ,
+				     ATH12K_NUM_PWR_LEVELS);
 
 		for (i = 0; i < tpc_info->num_pwr_levels; i++) {
 			tpc_info->tpe[i] = min(local_non_psd->power[i],
-- 
2.51.0



