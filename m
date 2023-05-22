Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ACD171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15305C433D2;
	Mon, 22 May 2023 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783221;
	bh=UdrF/T5lPmimr9w4SlOiCkw1Xmsl1K72xgZS5Mabj6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChPjXcOC1nOOdb4EPm0wk6yQKRxj89LWCqcBdr2lyXzfIfqHTlKqBI+tYVWVWcyNk
	 mCpYyXJfjSfyd0GaM/zXMo5mqP1Ks7jcPgloSRGnMW3eZe5GIYeR36S2rUC8NdAhEi
	 CqfR3mMO7UFJd/MgyGmyro95n0NWGUcTuMwhL5Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/203] wifi: iwlwifi: mvm: fix cancel_delayed_work_sync() deadlock
Date: Mon, 22 May 2023 20:09:35 +0100
Message-Id: <20230522190359.156272476@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
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

[ Upstream commit c2d8b7f257b2398f2d866205365895e038beca12 ]

Lockdep points out that we can deadlock here by calling
cancel_delayed_work_sync() because that might be already
running and gotten interrupted by the NAPI soft-IRQ.
Even just calling something that can sleep is wrong in
this context though.

Luckily, it doesn't even really matter since the things
we need to do are idempotent, so just drop the _sync().

Fixes: e5d153ec54f0 ("iwlwifi: mvm: fix CSA AP side")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230514120631.b1813c823b4d.I9d20cc06d24fa40b6774d3dd95ea5e2bf8dd015b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index efccdd3f33773..49c28c96fdf28 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1907,7 +1907,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 				RCU_INIT_POINTER(mvm->csa_tx_blocked_vif, NULL);
 				/* Unblock BCAST / MCAST station */
 				iwl_mvm_modify_all_sta_disable_tx(mvm, mvmvif, false);
-				cancel_delayed_work_sync(&mvm->cs_tx_unblock_dwork);
+				cancel_delayed_work(&mvm->cs_tx_unblock_dwork);
 			}
 		}
 
-- 
2.39.2



