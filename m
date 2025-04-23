Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291CD29DB9D;
	Wed, 23 Apr 2025 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422079; cv=none; b=i89s1e8cYZ15X4Ju6nBUZFSTp4DKpxieW9FXCmhTqx6nYMkpqvdbmi5czUOTjyP1mCyDB25Af8qxrp7ElZFNVMeFfGoKONtFRzsHTtVws6VzA0gOZSFDtbvW9RwmbKUAVbZ4KJo/DCtohhqRLnxMeGYy7QIgK/KewjpZmafSOGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422079; c=relaxed/simple;
	bh=X+xTr1K14pnexeOaRPs7gESKXMKjERmbV2ZWYAPezIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5JhbpZohKo+qFWOkotKPuPVeR7olQVv7pN+6+ht7F7KKiekWMzfvanoLnmN1Wrcq//H3RiQrYSHpqB8TG3oSfKfY+Uwbw5xLSmKerLOLBMjkoY+34eUiItN0J6H/wZ6WVvP9+MCoiQCcp+BGHnuauTV+kXpU9VwNqphQngYCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2/2BdGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2/2BdGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B00C4CEE2;
	Wed, 23 Apr 2025 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422078;
	bh=X+xTr1K14pnexeOaRPs7gESKXMKjERmbV2ZWYAPezIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2/2BdGyTkC3Qerfl4jrdUq4j7CLDfqim4km0PfWXizIRW3Op9woqZdJJQUNw+Nmy
	 U/LjaajugeNNlM+E6oQVeKAirDV2qE/Dr4i23drTlnWIVOq8CJsfgZ00rQwOAVzS1Z
	 AtCHzuYYJmG4iCs1AuFZLweX90xt4GhzIqY8zaKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/393] cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path
Date: Wed, 23 Apr 2025 16:42:50 +0200
Message-ID: <20250423142654.672125801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8477a93cee6bd..b77897aa06c4f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2273,6 +2273,7 @@ int cxgb4_init_ethtool_filters(struct adapter *adap)
 		eth_filter->port[i].bmap = bitmap_zalloc(nentries, GFP_KERNEL);
 		if (!eth_filter->port[i].bmap) {
 			ret = -ENOMEM;
+			kvfree(eth_filter->port[i].loc_array);
 			goto free_eth_finfo;
 		}
 	}
-- 
2.39.5



