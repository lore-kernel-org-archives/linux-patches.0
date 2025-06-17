Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD3D1BD9D3;
	Tue, 17 Jun 2025 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177029; cv=none; b=VnhnokHTVx1Iky//gi7FtTvHhFf1b23FRm2+XCRlMRX0mVyhSO0YVagFBvRfcftWz2NzS/7eF/j1bAUQgp4Pj2SJV6UBsrfW148ssoWmCUTAT59rbEiCv3pbffoyyzAxSd3JgMBRmzMIV9EuN0fxU3I0qytnJ0EGnWTqf+/S3DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177029; c=relaxed/simple;
	bh=WFyK3zAndATWEZPdNyWZRCMkVOYGcPPXVZv4AUCx9Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYOS/jUSi7z1+lK5hMEc1gH8GObj9ONrkf20wVoLoyFYvzZ0K0yAJ+oYK8REW2enPybJXqnF2Q6mud4Ri0UtPXf+2rqHR1M048C4HX5mqGgV8H4g6c97XzCJ/pGCo+qW3Gc4X3RQymgOk43vDCl63GFU2IRuWvhKZsrpydERK5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/QRVly4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/QRVly4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140CEC4CEE3;
	Tue, 17 Jun 2025 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177029;
	bh=WFyK3zAndATWEZPdNyWZRCMkVOYGcPPXVZv4AUCx9Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/QRVly4nOUTvvIyTiWKc/Z9sTSUFucMLWcVYsVjm0DgZiqZnTSSVZ0STtlacxn9J
	 RwBLcGQk3nrxC94nKf/sddGQOSAL5pLe5QAj1byZwQI2D2hOICQeFUqpcISk8If9Am
	 DZLUe4qRm/VqCUAMzXJM3bRV8sxHRlkGAWC9bGF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 250/780] wifi: iwlfiwi: mvm: Fix the rate reporting
Date: Tue, 17 Jun 2025 17:19:18 +0200
Message-ID: <20250617152501.633759099@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 068c58e9c1eb4..c2729dab8e79e 100644
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



