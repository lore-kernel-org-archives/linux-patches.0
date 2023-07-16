Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8018F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5732EC433C9;
	Sun, 16 Jul 2023 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537627;
	bh=RxvKdJKL3vwD090Wb0vuanC4jKGji81AFXD8hyhfBWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECY4fYgWGNFPZ/k2XwGOht9ttDQ0YyKD9ppJ3o/U8I0K1MV7H8SHBn6+40qfKTZoy
	 q3A8eLgHLGaNNVf5einOm7zWcw+ijbl/AyJ/3PpQoJEisnhqjTglRTdvdOSV1XXdUy
	 4eJHEnsCQ/PQyfWrHJBPu3N2wHs0G6Ne3DalkA2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 146/800] wifi: iwlwifi: mvm: send time sync only if needed
Date: Sun, 16 Jul 2023 21:39:59 +0200
Message-ID: <20230716194952.485800088@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ead65aa2d5155728baec90f6404cd02618ef29d0 ]

If there's no peer configured then there's no point in sending
the command down to the firmware with an invalid peer address.

Fixes: cf85123a210f ("wifi: iwlwifi: mvm: support enabling and disabling HW timestamping")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230531194630.0fb9f81f1852.Idcc41b67d1fbb421e5ed9bac2177b948b7b4d1c9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 205c09bc98634..a6367909d7fe4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1699,9 +1699,11 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 
 	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		iwl_mvm_send_recovery_cmd(mvm, ERROR_RECOVERY_UPDATE_DB);
-		iwl_mvm_time_sync_config(mvm, mvm->time_sync.peer_addr,
-					 IWL_TIME_SYNC_PROTOCOL_TM |
-					 IWL_TIME_SYNC_PROTOCOL_FTM);
+
+		if (mvm->time_sync.active)
+			iwl_mvm_time_sync_config(mvm, mvm->time_sync.peer_addr,
+						 IWL_TIME_SYNC_PROTOCOL_TM |
+						 IWL_TIME_SYNC_PROTOCOL_FTM);
 	}
 
 	if (!mvm->ptp_data.ptp_clock)
-- 
2.39.2



