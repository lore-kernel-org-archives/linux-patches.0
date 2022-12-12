Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C4028ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833A6C433D2;
	Mon, 12 Dec 2022 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852773;
	bh=8vkCQ9vi5s0z7pCyVGfQ2EjNW4tbn7Udw9CYLYhlQf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgTdoAabB/xv5lcKVZrqXoSrlVf58/triK7kYF3nnaSWVhWxgsqt2HhEbsJqXA9oj
	 i9wlnu0IrWBL8c8kUET1RhGBG/hqajhYqZpeXIBYkf17h/P9mZlRy4bkvGFw5RPHIv
	 XX4CURQ9HM/gfvRJYQy7uGoRjYh0mM9GKNb7828U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 121/157] octeontx2-pf: Fix potential memory leak in otx2_init_tc()
Date: Mon, 12 Dec 2022 14:17:49 +0100
Message-Id: <20221212130939.718742009@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit fbf33f5ac76f2cdb47ad9763f620026d5cfa57ce ]

In otx2_init_tc(), if rhashtable_init() failed, it does not free
tc->tc_entries_bitmap which is allocated in otx2_tc_alloc_ent_bitmap().

Fixes: 2e2a8126ffac ("octeontx2-pf: Unify flow management variables")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index e64318c110fd..6a01ab1a6e6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1134,7 +1134,12 @@ int otx2_init_tc(struct otx2_nic *nic)
 		return err;
 
 	tc->flow_ht_params = tc_flow_ht_params;
-	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	if (err) {
+		kfree(tc->tc_entries_bitmap);
+		tc->tc_entries_bitmap = NULL;
+	}
+	return err;
 }
 EXPORT_SYMBOL(otx2_init_tc);
 
-- 
2.35.1



