Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925981863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BB7C433D2;
	Wed, 28 Dec 2022 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241671;
	bh=CqQRcsSQq058uT3OMgNYfTs9DiLJtY+KpGVWtVw1EFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AafOt+nWhvRmd7VfDaH8ROJlpx+KfwtWuQ6o2h6MsUaHhWsIWDN8yxn0W3vi5RI+Z
	 4/MooIQX+uW2GLd45Tht+k4rj+7gKMTrkOdsXESA1Zaz1hG+9KOPYx/T8R1pW4bsSr
	 sHVo/O0WhKsRf2BMOoL1rFE2KQmQnccAmD9r8XsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0314/1073] wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone
Date: Wed, 28 Dec 2022 15:31:42 +0100
Message-Id: <20221228144336.535597562@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d3df49dda431f7ae4132a9a0ac25a5134c04e812 ]

If cloning the SKB fails, don't try to use it, but rather return
as if we should pass it.

Coverity CID: 1503456

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.0ce03ba99601.I87960b7cb0a3d16b9fd8d9144027e7e2587f5a58@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/net.c b/drivers/net/wireless/intel/iwlwifi/mei/net.c
index 3472167c8370..eac46d1a397a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/net.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/net.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2021 Intel Corporation
+ * Copyright (C) 2021-2022 Intel Corporation
  */
 
 #include <uapi/linux/if_ether.h>
@@ -337,10 +337,14 @@ rx_handler_result_t iwl_mei_rx_filter(struct sk_buff *orig_skb,
 	if (!*pass_to_csme)
 		return RX_HANDLER_PASS;
 
-	if (ret == RX_HANDLER_PASS)
+	if (ret == RX_HANDLER_PASS) {
 		skb = skb_copy(orig_skb, GFP_ATOMIC);
-	else
+
+		if (!skb)
+			return RX_HANDLER_PASS;
+	} else {
 		skb = orig_skb;
+	}
 
 	/* CSME wants the MAC header as well, push it back */
 	skb_push(skb, skb->data - skb_mac_header(skb));
-- 
2.35.1



