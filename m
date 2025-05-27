Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6B51CEAC2;
	Tue, 27 May 2025 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366963; cv=none; b=YFCivxOWkSpLiQHFq9lD0r+ZL3uf7PKWQMU/SCQ2Wzhi/IYw6UGq7FyMDU0zSYjBo6RQI8RIQsHM20Y1EgE1vN5CyfJGCJulhHwQ/w9aZCyaCH1DCNoF2y44Dw5CSboUm+80HhBGU1bAkf4JWigEk/75rf11viwBYXcHCRjnj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366963; c=relaxed/simple;
	bh=GxT5KQkggRmqs3g79N/7PSimCtIRARyq8PiicUX/+G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egZXBsDWhOMz5EHBBG/97AZg/x47L3MmkwFHZ1x7C2VF4L85pAGXrR9DhdVwLN7TiCFHgIOUwSZFJJktWff0jFYu1KmPcQjpyfqvqE0qFB5MYgzFe4+I6XWHUkthSD/qknpNF9BQGa4c2kYIFAcmL6vxEnUlTWDDoW/L3bwXwX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3/4Pk5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3/4Pk5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4597C4CEE9;
	Tue, 27 May 2025 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366963;
	bh=GxT5KQkggRmqs3g79N/7PSimCtIRARyq8PiicUX/+G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3/4Pk5+QISTSvOxp4AP+xou8dcifJV/cqyIOAK/pBoUk1Z7/vbiNcUZaFitg4f2o
	 TmAZn3EnlUmiOPzTnORY5D39UYaEE3TmkLDnGMVlSgr7O6porldVEWyzGj4dhiioqD
	 XZUiwkks1I0EOAft5MFlIOoDy87Ei87r9lW+ec6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 216/783] wifi: iwlwifi: dont warn when if there is a FW error
Date: Tue, 27 May 2025 18:20:13 +0200
Message-ID: <20250527162521.925169265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c7f50d0433a016d43681592836a3d484817bfb34 ]

iwl_trans_reclaim is warning if it is called when the FW is not alive.
But if it is called when there is a pending restart, i.e. after a FW
error, there is no need to warn, instead - return silently.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.ba3d90b22c25.I9332506af1997faefcf0bdb51d98d5e874051722@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index ced8261c725f8..eb631080c4563 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2019-2021, 2023-2024 Intel Corporation
+ * Copyright (C) 2019-2021, 2023-2025 Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
@@ -655,6 +655,9 @@ IWL_EXPORT_SYMBOL(iwl_trans_tx);
 void iwl_trans_reclaim(struct iwl_trans *trans, int queue, int ssn,
 		       struct sk_buff_head *skbs, bool is_flush)
 {
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return;
+
 	if (WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		      "bad state = %d\n", trans->state))
 		return;
-- 
2.39.5



