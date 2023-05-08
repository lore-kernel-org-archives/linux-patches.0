Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E2C168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A24BC433EF;
	Mon,  8 May 2023 10:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542405;
	bh=YnOYlFMzKrTTYBMViw1HQnt6n/9Oz/AD8S1PwTe/MW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMDKHQGOQTdibxLXZyoBoiEwe0KHa1lAx1NN/NaYoO2hEVH0LiyCsheppM8OZoscf
	 To38HU3jmVQQ6Kk8M5b0H+acUytDT3H0msABUKAkGZOzeuMYbxDZOwyUuPlb/JN7W0
	 wQCJs7Asic1F4SGXA5mJ4VvWX4cD7yS23+mn4rCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 380/663] wifi: iwlwifi: mvm: initialize seq variable
Date: Mon,  8 May 2023 11:43:26 +0200
Message-Id: <20230508094440.435462277@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index c5ad34b063df6..29f75948ab00c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -563,6 +563,7 @@ static void iwl_mvm_wowlan_get_tkip_data(struct ieee80211_hw *hw,
 		}
 
 		for (i = 0; i < IWL_NUM_RSC; i++) {
+			ieee80211_get_key_rx_seq(key, i, &seq);
 			/* wrapping isn't allowed, AP must rekey */
 			if (seq.tkip.iv32 > cur_rx_iv32)
 				cur_rx_iv32 = seq.tkip.iv32;
-- 
2.39.2



