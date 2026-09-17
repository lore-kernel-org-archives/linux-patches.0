Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08774E0B79;
	Thu, 17 Sep 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668417; cv=none; b=mhCkfM7C2mTokqTvg/dY9TruPe6PyR9Zah6e5Bn40B4T9Iq7vFS1TKtPhhh4iMnBk04d8a2QHT5XS+XydlXWnC9ldZeP/waltUjLSj5BN3rozDh5KdrMs16w2d5cx+emt3zBHhyOFvboX6r9mQscymNE6FiJFXr4KA4n5CmTVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668417; c=relaxed/simple;
	bh=t9ggi4X/Riy14SVN9gBFSvG9481YDu/gu1tLXlR7nVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+0rEeOtzDB89z0+zYyrnDTyu35crqhGodut/IoRb5RBQTHLB5fVMyllPAZIYSe8dT+4wYAapd0PYsIz/YBQJ87rRLT+50QXDkXV2xk3KlV7EgPnML5eZAGXlj4+XV64Pls599A2Z2kiqZKmAc8MUW1d+DMfDESunl9wMtCRhlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewkWpINI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewkWpINI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155A11F000FF;
	Thu, 17 Sep 2026 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668416;
	bh=jGNBVGDtt67Lww+YFcnYExbcIC6UZ3Jzrsm+tsuZ0FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewkWpINIvT6JxBFgj6cpFwc+dcu5Pvw4XjjX/MbBk1fsFHCJvxCQ+xIWDZRUCc1/S
	 GZYsDWRSyTNwCd11/CeQ4pyJW/hWlv5jWAplOWMqDkN1WdiQcxAC8mk4o5j6U1P61q
	 HlQQgD7seCPNt9HOynGq7N4ndtLJGggroqyrc+0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0419/1102] wifi: iwlwifi: pcie: null RX pointers after free
Date: Thu, 17 Sep 2026 16:06:02 +0100
Message-ID: <20260917151550.185949669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 2c79d7a7b583050c9f58041465cb46fe3483ab5d ]

When iwl_pcie_tx_init() fails after RX init, nic init unwinds via
iwl_pcie_rx_free().

The freed RX members stayed non-NULL on the live transport object,
so later teardown or retry could touch stale RX state.
Set rx_pool, global_table, rxq, and alloc_page to NULL after free
to make repeated cleanup and retry paths safe.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.33e8978d8b36.Ibaedd4b0ce01405b940de7b90223b6d2c5136ffd@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index afb88eab8174b..4bd5d2a4cfc8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2024, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1241,11 +1241,16 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 		}
 	}
 	kfree(trans_pcie->rx_pool);
+	trans_pcie->rx_pool = NULL;
 	kfree(trans_pcie->global_table);
+	trans_pcie->global_table = NULL;
 	kfree(trans_pcie->rxq);
+	trans_pcie->rxq = NULL;
 
-	if (trans_pcie->alloc_page)
+	if (trans_pcie->alloc_page) {
 		__free_pages(trans_pcie->alloc_page, trans_pcie->rx_page_order);
+		trans_pcie->alloc_page = NULL;
+	}
 }
 
 static void iwl_pcie_rx_move_to_allocator(struct iwl_rxq *rxq,
-- 
2.53.0



