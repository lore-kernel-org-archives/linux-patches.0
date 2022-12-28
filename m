Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9F61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB9DC433EF;
	Wed, 28 Dec 2022 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241655;
	bh=e8C+FLarz7yHRStBr8a5N2PFhBm2ZxbWJSVqh0GRLVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc2DVDvfiXi0Fvpu8LVkjG/GFwcqiADX45BJTT0TZdclBivxdeAn+cUpkwYpKCFOz
	 HbztDuXu7TtmqbiZLLQRkx5n9VAG9VG9Go0BDgI/hE7K1L+yl5LYdBdsX4gnJEZ6Jh
	 cVhvzaEvztaw7CqfR/9KhqeonFjMF9/HJV48lMJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0312/1073] wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API
Date: Wed, 28 Dec 2022 15:31:40 +0100
Message-Id: <20221228144336.482734951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit bcd68b3dbe78b7b0f7b6b55162cf1eff1e7fff9e ]

Devices with new Tx API have the IV introduced by the HW and it is not
present in the skb at all. Hence we don't need to tell
iwl_mvm_mei_tx_copy_to_csme to jump over 8 bytes to get to the ethernet
header.

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.12dc42133502.Idd744ffeeb84b880eb497963ee02563cbb959a42@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index f9e08b339e0c..6fa8d9e6b186 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1171,9 +1171,15 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	/* From now on, we cannot access info->control */
 	iwl_mvm_skb_prepare_status(skb, dev_cmd);
 
+	/*
+	 * The IV is introduced by the HW for new tx api, and it is not present
+	 * in the skb, hence, don't tell iwl_mvm_mei_tx_copy_to_csme about the
+	 * IV for those devices.
+	 */
 	if (ieee80211_is_data(fc))
 		iwl_mvm_mei_tx_copy_to_csme(mvm, skb,
-					    info->control.hw_key ?
+					    info->control.hw_key &&
+					    !iwl_mvm_has_new_tx_api(mvm) ?
 					    info->control.hw_key->iv_len : 0);
 
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, txq_id))
-- 
2.35.1



