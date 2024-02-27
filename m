Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E70213A26F;
	Tue, 27 Feb 2024 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042978; cv=none; b=d4d7gURU5EHot5SB1qose3xoz2LloEChKct7HLoF7u1CyrUhFx9GOw2HB3Q09Q2Ah6R+pJ6sF+YlLX1E6uBzd66Fe8bjOpe/9Zs+zCUcEtCEP8kPEokH3v1O3SQVjGPJZw0ymbeogD9UZM+J+++C9I2NCS2Sqrpffyxrn8gx7mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042978; c=relaxed/simple;
	bh=aT1VzUXK0RUbe3SKhS8DPwISAS7iT/XYaTSGyu81zPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7oaVYNcP7jHyG37mrxu5603GucbMBs8EKlBye3ATx0Iuer3RmwGLLpr9dVnpPQSP4HDuGBkGbs6A/530EQ4oulbAgB/DQnxzv6teR7otK93+KEymd1U2LRRD1lkYvoEbuWSgYzgRePTrjp+wLeZiKhR4/N5xI6HmOa55U0tjxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcFM61i5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcFM61i5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5A4C433F1;
	Tue, 27 Feb 2024 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042978;
	bh=aT1VzUXK0RUbe3SKhS8DPwISAS7iT/XYaTSGyu81zPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcFM61i5MRRyPOHKCtdaJfjGKetf0/tuZQ39jEUDqPAFDlfiIfOu8W6/q5iBCvcNP
	 3sdpyKBQEmqRIPw3byLbFqOi4Ybc5gwQi+Li+38NF6sZxaI2LoX8qLZglb/npl9zfS
	 67bAG/Ish6pDsbUQsR5BklDZJJsUN1KLIHZzkLGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roee Goldfiner <roee.h.goldfiner@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/245] wifi: iwlwifi: mvm: avoid baid size integer overflow
Date: Tue, 27 Feb 2024 14:26:10 +0100
Message-ID: <20240227131621.123934044@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1a528ab1da324d078ec60283c34c17848580df24 ]

Roee reported various hard-to-debug crashes with pings in
EHT aggregation scenarios. Enabling KASAN showed that we
access the BAID allocation out of bounds, and looking at
the code a bit shows that since the reorder buffer entry
(struct iwl_mvm_reorder_buf_entry) is 128 bytes if debug
such as lockdep is enabled, then staring from an agg size
512 we overflow the size calculation, and allocate a much
smaller structure than we should, causing slab corruption
once we initialize this.

Fix this by simply using u32 instead of u16.

Reported-by: Roee Goldfiner <roee.h.goldfiner@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230620125813.f428c856030d.I2c2bb808e945adb71bc15f5b2bac2d8957ea90eb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 45dfee3ad8c60..2d1755598b475 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2544,7 +2544,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	}
 
 	if (iwl_mvm_has_new_rx_api(mvm) && start) {
-		u16 reorder_buf_size = buf_size * sizeof(baid_data->entries[0]);
+		u32 reorder_buf_size = buf_size * sizeof(baid_data->entries[0]);
 
 		/* sparse doesn't like the __align() so don't check */
 #ifndef __CHECKER__
-- 
2.43.0



