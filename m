Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206ED394470;
	Sat, 17 Oct 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260364; cv=none; b=ImciDwfRb/nITH3HmOep25iKDZ1PqqDJ9cUMbjYHMqaqn1Tvx68dPGG/kZycFk7trMABDloEWSLLh+ddyPJLPE3j8XWxFscik5o+HzAakN2XDuLtfllvwVxDCLvZgM3G2TUlVQ18+7RVoDMyrypEfklsyvVUeUgbT70YxjS7e3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260364; c=relaxed/simple;
	bh=DTFJ7x3bsZIgy5q31QpcOqy0+ge6Ie1y3yODldnyTMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLs4tgdX12YH5B1uF1mkiafAYDkKKEX7/4SRXDALR4cMDDfiLHxhWQh74cxMlMWpRKOxEDLEwZLlUOJAcgYl0gkMCipKtbiApwIaAdaHqDp2N6OSGXC45wfhh7+CLWf0l26XLtxp33YetKxHOJvuzNwy2oqt+tVV91C25sE+6K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdygzAlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdygzAlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5660C1F000C4;
	Sat, 17 Oct 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260362;
	bh=5UCwqSG+Q8m6eD/dPsFlyhDRKEFd7YaCdFiChsSfNYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdygzAlHTz2W09ocp/xqNAxBJvno64bgG/+mKvlheM37o0XRQnUF0zqFrvltZcTvF
	 N4E2R/kyB5VuoPnwupbqsQl6Z7a0SVCin2HjcirvlFPooZYIEv7rDzf36h8HVA1SZe
	 SFy5rkBqbkQh/51G3RA4dNZ7ObBs48JZHPHXMYy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1520/1674] wifi: iwlwifi: pcie: null RX pointers after free
Date: Sat, 17 Oct 2026 18:03:12 +0200
Message-ID: <20261017160510.135940949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be9b5a19e2a7c..618d8eac37d64 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2023 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2023, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1236,11 +1236,16 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
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



