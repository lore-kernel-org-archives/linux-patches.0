Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317124C077;
	Tue, 29 Apr 2025 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946933; cv=none; b=rAHbgTBmlA7uKlyuNQHrXWP07MPDYwgQgqGO7sbMZE0H839jEyWyQbBRbAtpHdLSKGyQE//XzaAn8/n4V6EIWC0mUJkA7wfVhlXIYnAyT6p/F84ph9oAiTvaSk3LBv732XtRScXew42OwKiF8jGwuqBUqNv6rOwbjNcwVD27qt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946933; c=relaxed/simple;
	bh=jjb1M6W958sigMb7G5XQQSYAx6RLhp6g7EjEO/C+51I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyOwUwTc0wy7N8oYaiQCOU+56k7n7AvwuS6tnVLPfXCz9wTnsg4D/R8C1mI61dluR4ZsTjr+awvsrx5A3JVH7Yfl1GjRmgCqrDU+f08QMEqgOA0uSJCmhNt81y8VZQHxQskcHDJvPy4/0SWARdSavnyDBbqThyj8u3nRmOp1nSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErTFa+2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErTFa+2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F6CC4CEE3;
	Tue, 29 Apr 2025 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946933;
	bh=jjb1M6W958sigMb7G5XQQSYAx6RLhp6g7EjEO/C+51I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErTFa+2UYk+cDzya2MjEPtY8ZpW/RwJKBUYAdhIhdhdCGvIk89LnKzAN4MLV2N/mG
	 EMF265xfAa68QNnL/EKuO4+e2be2FwKEK0GnpOyx07tjvonfFoZIvkr4GF33t3EbYo
	 jvK4csQ6AgY/Df+vzbxIbPzcEolH5tKUOcld+Sok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/286] cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path
Date: Tue, 29 Apr 2025 18:40:20 +0200
Message-ID: <20250429161112.628882814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 00ffb3724ce743578163f5ade2884374554ca021 ]

In the for loop used to allocate the loc_array and bmap for each port, a
memory leak is possible when the allocation for loc_array succeeds,
but the allocation for bmap fails. This is because when the control flow
goes to the label free_eth_finfo, only the allocations starting from
(i-1)th iteration are freed.

Fix that by freeing the loc_array in the bmap allocation error path.

Fixes: d915c299f1da ("cxgb4: add skeleton for ethtool n-tuple filters")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414170649.89156-1-abdun.nihaal@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 7080cb6c83e4a..0f36319eb3115 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2258,6 +2258,7 @@ int cxgb4_init_ethtool_filters(struct adapter *adap)
 						   GFP_KERNEL);
 		if (!eth_filter->port[i].bmap) {
 			ret = -ENOMEM;
+			kvfree(eth_filter->port[i].loc_array);
 			goto free_eth_finfo;
 		}
 	}
-- 
2.39.5



