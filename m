Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E1214389C;
	Wed, 19 Jun 2024 13:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802777; cv=none; b=obODEe8jehLwXHwd/WJ+aCdbc5/HlVh4ys+iuEk0B5RrGMXI7F7OYsHuBFZaWU/lmTsI8LynwvYgurXsc5YnHOMAhZresdoGOzm+FoRsC9/s4oyLi6XQdBvaplhtl7fMrtNvYk4Y7xBQgh2cxAdumopZuUyjO+Qynd6VBtwnX6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802777; c=relaxed/simple;
	bh=baJXZVx6TpqK6BYFiDnCuzlR53PmqdK9HFUKORRT2oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsJsPkTSB2uHbpK6CRSqQsF18PnycOjgV5YrUa1RmB8FxdEWpTQV5iNaI5mVS+hF2x4iOpgI4wdNArlACRZOJOok/aje65fKF6273GHCHn0LDPSYcR6UCKRmVhJB5kt+l+6VlGvuegoRzGpPrk+AXsp7yxkkmXNMGmqIf63ai2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5DWsw9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5DWsw9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277A1C2BBFC;
	Wed, 19 Jun 2024 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802777;
	bh=baJXZVx6TpqK6BYFiDnCuzlR53PmqdK9HFUKORRT2oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5DWsw9pW4Q4edzhETMCgBLxES3isnzXTwzX9H/SKH+dawndbkDRJTUC73s4LqHjT
	 m3qpfDfb0cUglPSJYNSYjs1KTuctWhD942dIWwBHiOlLj+Np1V31IxAs0sX4i/cIY6
	 NcueR4g1sSkVaewZpfgBO5DKy4y6iWOSySTWrOcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 012/281] wifi: iwlwifi: mvm: dont initialize csa_work twice
Date: Wed, 19 Jun 2024 14:52:51 +0200
Message-ID: <20240619125610.318899239@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 92158790ce4391ce4c35d8dfbce759195e4724cb ]

The initialization of this worker moved to iwl_mvm_mac_init_mvmvif
but we removed only from the pre-MLD version of the add_interface
callback. Remove it also from the MLD version.

Fixes: 0bcc2155983e ("wifi: iwlwifi: mvm: init vif works only once")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240512152312.4f15b41604f0.Iec912158e5a706175531d3736d77d25adf02fba4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index df183a79db4c8..43f3002ede464 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -75,8 +75,6 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_free_bf;
 
 	iwl_mvm_tcm_add_vif(mvm, vif);
-	INIT_DELAYED_WORK(&mvmvif->csa_work,
-			  iwl_mvm_channel_switch_disconnect_wk);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvm->monitor_on = true;
-- 
2.43.0



