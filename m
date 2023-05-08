Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA6168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F7FC433D2;
	Mon,  8 May 2023 10:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540424;
	bh=LBqd+C7Zpt3DsMKRx75hNx6Kkn4pYk+ZCGpR24kff2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9p5LwGLoUs+p6a7Z3m8FLQHe2DqiHR+KlOwKz45NovMkFhECseRMrBuxGyL5MHUn
	 v5AAtLYioRkKzZC9vW8d7QQCTVixZoAj5FwhIoLpQuwpevTgNVGTX1W1Odvx96fjXS
	 FR7+3CVymwD0Kj0SJoVIOXVnMn/U1uRWRLqDUNFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Lorenzo Zolfanelli <lorenzo@zolfa.nl>
Subject: [PATCH 6.1 360/611] wifi: iwlwifi: make the loop for card preparation effective
Date: Mon,  8 May 2023 11:43:22 +0200
Message-Id: <20230508094434.100646929@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 28965ec0b5d9112585f725660e2ff13218505ace ]

Since we didn't reset t to 0, only the first iteration of the loop
did checked the ready bit several times.
>From the second iteration and on, we just tested the bit once and
continued to the next iteration.

Reported-and-tested-by: Lorenzo Zolfanelli <lorenzo@zolfa.nl>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216452
Fixes: 289e5501c314 ("iwlwifi: fix the preparation of the card")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230416154301.615b683ab9c8.Ic52c3229d3345b0064fa34263293db095d88daf8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 1690d7a4bd9c0..54f11f60f11c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -599,7 +599,6 @@ static int iwl_pcie_set_hw_ready(struct iwl_trans *trans)
 int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
-	int t = 0;
 	int iter;
 
 	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
@@ -616,6 +615,8 @@ int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 	usleep_range(1000, 2000);
 
 	for (iter = 0; iter < 10; iter++) {
+		int t = 0;
+
 		/* If HW is not ready, prepare the conditions to check again */
 		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_PREPARE);
-- 
2.39.2



