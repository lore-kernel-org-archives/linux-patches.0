Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED01243964;
	Tue, 29 Apr 2025 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948875; cv=none; b=caiJmc9ZINbWtKCWzaZ/MZdsk73rgRXsynpZILmBR3lUUbMNLX6s5XKeQPwA3MwDDXtheoaZnYNKR54eTk1SAG27oQUIHAmBjNlWu9+NCiy4EPZlyzdLFzJfn7ixjE2eD3h5jZJQkX+YnPhteI1kRtKtVuiOwnpoEth66FMX/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948875; c=relaxed/simple;
	bh=tk40h3pmP2G7h2n6g0phGwqeSl3I3pxFltadkuY+PPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucvAwKbFZiXANR4/SGa2Efae5ty0P9Tqids8bwiueBRBuJf9y2h620U0xYu9voecZjS3fDbwwwJr6/QW3uod3TbRh+KzzYHWM+ppPmRZpww9lRyKQjmGaFvUHq8ie6F5+ajn/RBRu6Xu2xA1hCHtg5qNMjXNQ5hktrHTwnU6yLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOoAtQUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOoAtQUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6445C4CEE3;
	Tue, 29 Apr 2025 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948875;
	bh=tk40h3pmP2G7h2n6g0phGwqeSl3I3pxFltadkuY+PPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOoAtQURnMXaSxjGudHjt88s+7N0L9APUfjcVGSuJVWc1Pc9SVWb5hIh2ssG+UL4H
	 WvSWCwTHlpOKvMRMIYs8wBQxW+6tQhNCVH+vp2jGNpxcf6ncAIXdtBrqh9fwnnX+fD
	 AuluHvGNc8uVScbKCDooelYXarqF3x+tjdHkX9jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/373] cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path
Date: Tue, 29 Apr 2025 18:40:23 +0200
Message-ID: <20250429161129.168788481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 129352bbe1143..f1e09a8dfc5c7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2262,6 +2262,7 @@ int cxgb4_init_ethtool_filters(struct adapter *adap)
 						   GFP_KERNEL);
 		if (!eth_filter->port[i].bmap) {
 			ret = -ENOMEM;
+			kvfree(eth_filter->port[i].loc_array);
 			goto free_eth_finfo;
 		}
 	}
-- 
2.39.5



