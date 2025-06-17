Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AC32DFF08;
	Tue, 17 Jun 2025 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175927; cv=none; b=r0MyKuZ0qgnmqC6xMVcO++C1FJ8J8K8Y4XJqwUZJTjJiXzVtE1Xn7NLoOU8WYNCj9cqq7qavZ9PJ4SMGziq7Rosd+zC74vmD/B+MYWKEMBBcLj8JUNu2uodUSLQiQZuktwPF85ezzxDFYFwcX3E2Cumxa4xNQvUS8aZKbeyPF5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175927; c=relaxed/simple;
	bh=ht2mKmB+X/ZDhYgBQhXERrsyJgw4Bj5IhrJS5tTRjFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUKY0sNFyjKFwnSs8gV/BlBW5ozNKke/+MA4USf79RDiZz7i9/H5cpEHlQs/0rgRfPTKNIfjIKtcYRuDDumQxGrRksMB2h8eVx2ovYgnB/9pEw4DRFsGXoo0x17Dwqpnd9DlWBY6rRA2mEQLA3qvImF9CyInNQ1CB/gqTkL1xVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfvpKVXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfvpKVXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996ACC4CEE3;
	Tue, 17 Jun 2025 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175927;
	bh=ht2mKmB+X/ZDhYgBQhXERrsyJgw4Bj5IhrJS5tTRjFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfvpKVXacSNaFUv4C+Ppe1mcuFoCTGJXwI/SEreR1YO0W9vQXmH5DPR80PiA3J5J8
	 NVm03IWcyAJymdQ3B2ZSP7HwoSoHetx4IAM/ZvdV5uXcrkLtt7vAsosXXDxJZIY7dT
	 7tsvyxzCXUkc//z3/DDffTKe1j5DzEfFzeD1iDWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/512] wifi: iwlfiwi: mvm: Fix the rate reporting
Date: Tue, 17 Jun 2025 17:22:04 +0200
Message-ID: <20250617152426.016736907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 8f7561209eda7d6998708f06376e8dd2dc52f3b8 ]

The rate validation in mac80211 considers a rate to be valid iff both
the rate index and the count are positive. When the rate scaling is
managed in the driver and not enough traffic passed to set the actual
rate, the driver set the rate to be the optimal rate. However, the rate
count is not set and thus the rate is considered not valid. Fix it by
setting the count to 1.

Fixes: 3e99b4d28219 ("wifi: mac80211: Sanity check tx bitrate if not provided by driver")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250503224232.0d1d1e022d63.I76833c14ba1d66f9bea5c32b25a54d8b36f229ba@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index a8c4e354e2ce7..5f8f245804443 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2,6 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2005 - 2014, 2018 - 2023 Intel Corporation. All rights reserved.
+ * Copyright(c) 2025 Intel Corporation
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *****************************************************************************/
@@ -2709,6 +2710,7 @@ static void rs_drv_get_rate(void *mvm_r, struct ieee80211_sta *sta,
 							  optimal_rate);
 		iwl_mvm_hwrate_to_tx_rate_v1(last_ucode_rate, info->band,
 					     &txrc->reported_rate);
+		txrc->reported_rate.count = 1;
 	}
 	spin_unlock_bh(&lq_sta->pers.lock);
 }
-- 
2.39.5



