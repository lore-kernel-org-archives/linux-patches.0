Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD0280012;
	Tue, 27 May 2025 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364938; cv=none; b=Jx2EJRKWCVqnRJgGOjEXoHvfVqZnLUyHAhKPNWEaDSt0uySyxU8Lvo2ILPNqemqZU7TIo9QT2ZK7pgjM5O7im0R2zIZisJmCR/gWXGbRSbrW8EgHAXEr8RS17B3KIPp+RB+gdHryZDlY/wI8X0+jgqhbuTSw8wFO58VVTr8Jdlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364938; c=relaxed/simple;
	bh=K6gdxiHv/Lrr2yX5U2ldfARHTPcADSdz1iaSML93dnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMGhZgqlGprJDfgjbV+raFbSMHbirWFxSOHXd4Ct9Mmr0kUDk20Xu3E5JOEmLtA9lvp2gA4Z7SDERxgaAYdvdkGukXNdpGyr0nfgtC6J5ebd+VHoZU8Too6rZqN7UkbRKVtduLmodAJ2cGgvg816OdIJJ1W8LFQKDpAZRyVv3Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHJFnzhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHJFnzhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CB1C4CEE9;
	Tue, 27 May 2025 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364938;
	bh=K6gdxiHv/Lrr2yX5U2ldfARHTPcADSdz1iaSML93dnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHJFnzhwcPCV8VUgpRzXakYHaJFMJhghCgV5nZBUCiv0Qtpp5Y4S1q1Jnckpd4MqX
	 5PnNiox0ipKpvhLcWw2Be4DwhmUL88to/uKRna1yCiVLXkjWKHFE6oBaVBAq+jG9xu
	 wZCRyFfULaeBUHxvA9OBinFHd7HWlYckC9o2RI00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/626] wifi: iwlwifi: dont warn when if there is a FW error
Date: Tue, 27 May 2025 18:21:17 +0200
Message-ID: <20250527162452.485196461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b3dcaf33c9d9..311b167ea09ed 100644
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
@@ -419,6 +419,9 @@ IWL_EXPORT_SYMBOL(iwl_trans_tx);
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



