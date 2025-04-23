Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34996280A53;
	Wed, 23 Apr 2025 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420158; cv=none; b=llkotrV5naHSRAq8P/7fu/vGmNemVPAuQZ1EoXhe7whpKUGK236z/nRrxidbPZvrNE4e9KSGXFQAujZd/1kB3/F9xnVyKxxGdwg55krvxwvEjV91ZNiiIy62Cx3+ttymJ0jaVeD3nHG3yMs9JTtSRsJRlSXqZXEYuYXCGGh4y5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420158; c=relaxed/simple;
	bh=2taQ/I/AWxpW1sgB8BsDpbRm+1is2bJyouvm3qQlFnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqkJVNmVYJTEIwvvhot7smcj3Aa32ILFfIAod9gjHc1NB/axbID+5SsbefGUYG0NxB4p5CXwOZQ8v5bKdbKoM4I8BtUAAJ2d6EL1sXInK3iAl9YP1YV+G8dMIGiJMFXULeZKGFSdGhdZ5btSW8D9IDByEkgWOFtGeTW3yr8NJmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxocelUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxocelUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB08DC4CEEB;
	Wed, 23 Apr 2025 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420158;
	bh=2taQ/I/AWxpW1sgB8BsDpbRm+1is2bJyouvm3qQlFnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxocelUtLMPzmF+sy/0hgI+tICtNsLPEcOG0RSgjNl7bOkiLG2jsuFjYlBtABR3g8
	 bmInGAeF4PgaJOewXGuu/6rs/0WV6w5LXKpc3igHgW4LO1OASfoCBW+eLMB7r/9aDc
	 VA7HQ4Do9reiToDfsbgc4ykvU9RazoX1+xicNUXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 064/241] cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path
Date: Wed, 23 Apr 2025 16:42:08 +0200
Message-ID: <20250423142623.218154905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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
index 7f3f5afa864f4..1546c3db08f09 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2270,6 +2270,7 @@ int cxgb4_init_ethtool_filters(struct adapter *adap)
 		eth_filter->port[i].bmap = bitmap_zalloc(nentries, GFP_KERNEL);
 		if (!eth_filter->port[i].bmap) {
 			ret = -ENOMEM;
+			kvfree(eth_filter->port[i].loc_array);
 			goto free_eth_finfo;
 		}
 	}
-- 
2.39.5



