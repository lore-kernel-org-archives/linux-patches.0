Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1F171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC85C433D2;
	Mon,  8 May 2023 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545968;
	bh=KPh5Zkjm9LuKwavsUR7yD/4n66vyB1kYOCbXyWL3d8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOePxHFlROoajvdjOgD6KF8DOw9qqOKSoLkhMJBHdEucYM+wF+BXr1LC2DaZNXLIi
	 aq5Oe9LF/Sj6QhS63bjjPckgYOOvHHnbayIx0f9RL8IWHSKtqqoxDb49V/QPDbOYva
	 y9DcEqBpxEjV5Eafp7KAftkborkP2vyZVQaQU5V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/371] wifi: iwlwifi: mvm: initialize seq variable
Date: Mon,  8 May 2023 11:46:54 +0200
Message-Id: <20230508094820.527612752@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

[ Upstream commit 11e94d2bcd88dea5d9ce99555b6b172f5232d3e2 ]

Clang static analysis reports this issue
d3.c:567:22: warning: The left operand of '>' is
  a garbage value
  if (seq.tkip.iv32 > cur_rx_iv32)
      ~~~~~~~~~~~~~ ^

seq is never initialized. Call ieee80211_get_key_rx_seq() to
initialize seq.

Fixes: 0419e5e672d6 ("iwlwifi: mvm: d3: separate TKIP data from key iteration")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230414130637.6dd372f84f93.If1f708c90e6424a935b4eba3917dfb7582e0dd0a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 00ca17f3b263c..6dde3bd8f4416 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -564,6 +564,7 @@ static void iwl_mvm_wowlan_get_tkip_data(struct ieee80211_hw *hw,
 		}
 
 		for (i = 0; i < IWL_NUM_RSC; i++) {
+			ieee80211_get_key_rx_seq(key, i, &seq);
 			/* wrapping isn't allowed, AP must rekey */
 			if (seq.tkip.iv32 > cur_rx_iv32)
 				cur_rx_iv32 = seq.tkip.iv32;
-- 
2.39.2



