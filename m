Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201F1DB92A;
	Tue, 12 Aug 2025 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023830; cv=none; b=WGm4AfDJyafI2Cwtan3XYSzASJc616pVTCjmzgxyr9/uAzxiumr4RLtuxb1EM+5qChhIAXtfYpDrzQeqD8vuEuPBeUHoLUjivbh7s56ezK+Qv4zM/oPoKjroKKn8ulKVi5MNG+K6UrFhGYxrZvWEIxSjYOb20T9TTXYDEjXDp1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023830; c=relaxed/simple;
	bh=YiSjxrf0Nb7PpnruA4eGfOWjqQfQSMYKDnrAO6WUxtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUiFMto9cNFWN6ZsdvcCJ2u1/SuL9arcUY8LecdgRVUoL9w9VRvriPX7pR6UbiO0bUdyjM+RakFcj5lR50GHSNSZTva/HXNmwNJTHqzU4+U9KrCxIyOd/y8O3Jlf94sW2yU6F3vSxi8rqkuzHbxTV9kOfSKdQ2c+FTWxSCekOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2agyOjiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2agyOjiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448A9C4CEF0;
	Tue, 12 Aug 2025 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023829;
	bh=YiSjxrf0Nb7PpnruA4eGfOWjqQfQSMYKDnrAO6WUxtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2agyOjiP8ICmDeoOJiTOKeMyyFMqje3iznXSjBtjswH4fKFclEnLZbnvKjB4t/HM9
	 pkRlfEQ4D7zcHOWiVozWpg1oku94tggqzoKM36S+km5BBdKvssdP4Mwequni5VQbdg
	 xspLDCXGT25q7t3Qm08W9So6E9zIVa2nILMpnZmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 194/627] wifi: ath12k: Block radio bring-up in FTM mode
Date: Tue, 12 Aug 2025 19:28:09 +0200
Message-ID: <20250812173426.649019536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 80570587e418f361e7ce3f9200477f728b38c94b ]

Ensure that all radios remain down when the driver operates in Factory
Test Mode (FTM). Reject any userspace attempts to bring up an
interface in this mode.

Currently, the driver allows userspace to bring up the interface even
though it operates in FTM mode, which violates FTM constraints and
leads to FTM command failures.

Hence, block the radio start when the driver is in FTM mode. Also,
remove ath12k_ftm_mode check from ath12k_drain_tx() because FTM mode
check is already handled in the caller function
(ath12k_mac_op_start()).

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 3bc374cbc49e ("wifi: ath12k: add factory test mode support")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250630031502.8902-1-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 0feb800a4921..43464853a01d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8167,14 +8167,9 @@ static int ath12k_mac_start(struct ath12k *ar)
 
 static void ath12k_drain_tx(struct ath12k_hw *ah)
 {
-	struct ath12k *ar = ah->radio;
+	struct ath12k *ar;
 	int i;
 
-	if (ath12k_ftm_mode) {
-		ath12k_err(ar->ab, "fail to start mac operations in ftm mode\n");
-		return;
-	}
-
 	lockdep_assert_wiphy(ah->hw->wiphy);
 
 	for_each_ar(ah, ar, i)
@@ -8187,6 +8182,9 @@ static int ath12k_mac_op_start(struct ieee80211_hw *hw)
 	struct ath12k *ar;
 	int ret, i;
 
+	if (ath12k_ftm_mode)
+		return -EPERM;
+
 	lockdep_assert_wiphy(hw->wiphy);
 
 	ath12k_drain_tx(ah);
-- 
2.39.5



