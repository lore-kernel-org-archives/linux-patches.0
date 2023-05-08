Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F082168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188A2C433EF;
	Mon,  8 May 2023 10:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540387;
	bh=a5QcUy9ECiqFD21XVRYF04lgFnGRrmOCFXgF5uuq7CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/3wUYy7O4HA1cY2q9bjes248s1ODyoV9/ewz9Zo+nNzOUgKxWBnBp2xl4lLQ3M7h
	 Oz0f9srAfR7fbTLn8Em9Iix1NC7sUw5tTEDl+DZmylQNLRDkCO0lxcCOWmfC3+GGpD
	 M9aRfK6T4Vk3MOgaGVQDjqd+nqDlSHEhqmd592t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 344/611] wifi: iwlwifi: mvm: dont set CHECKSUM_COMPLETE for unsupported protocols
Date: Mon,  8 May 2023 11:43:06 +0200
Message-Id: <20230508094433.591849978@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 217f3c52f00d3419ecdd38a99a7eceecb11679b2 ]

On Bz devices, CHECKSUM_COMPLETE was set for unsupported protocols
which results in a warning. Fix it.

Fixes: b6f5b647f694 ("iwlwifi: mvm: handle RX checksum on Bz devices")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413102635.a2a35286f0ca.I50daa9445a6465514c44f5096c32adef64beba5f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 1aadccd8841fd..091225894037c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -193,8 +193,7 @@ static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * Starting from Bz hardware, it calculates starting directly after
 	 * the MAC header, so that matches mac80211's expectation.
 	 */
-	if (skb->ip_summed == CHECKSUM_COMPLETE &&
-	    mvm->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_BZ) {
+	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		struct {
 			u8 hdr[6];
 			__be16 type;
@@ -209,7 +208,7 @@ static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 			      shdr->type != htons(ETH_P_PAE) &&
 			      shdr->type != htons(ETH_P_TDLS))))
 			skb->ip_summed = CHECKSUM_NONE;
-		else
+		else if (mvm->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_BZ)
 			/* mac80211 assumes full CSUM including SNAP header */
 			skb_postpush_rcsum(skb, shdr, sizeof(*shdr));
 	}
-- 
2.39.2



