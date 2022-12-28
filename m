Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482871863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C130DC433EF;
	Wed, 28 Dec 2022 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240216;
	bh=l9AOlS29MLEVOvw/Jr0qb7P4Cmzp6IpF/g+zdJHvoBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eR4eVWxv7aHkziUp4gzMZ1lyZjwxF59DLUx5EVcVLnkZWot8wgyoSLCvM5IZ8Xh3z
	 aY7UYrhyQSbSB1DrKLuw62Sro2A1SUc7KzmWNdwPCFB2yEDpbLSOQGVoy8a4qwa3AD
	 PnMv4UzZwg7KIaorhvJA9Eu2qNNT2OEsc6x2gPzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/731] net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()
Date: Wed, 28 Dec 2022 15:37:11 +0100
Message-Id: <20221228144305.964885957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit f150b63f3fa5fdd81e0dd6151e8850268e29438c ]

The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
some error handling case, which will lead to a memory leak. Fix this up
by adding kfree_skb() to release skb.

Compile tested only.

Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index dd5c4ef92ef3..ea7200b7b647 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1654,12 +1654,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
 	}
 
 	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
-	if (ret)
+	if (ret) {
+		kfree_skb(skb);
 		goto cleanup;
+	}
 
 	ret = dev_set_promiscuity(priv->dev, 1);
-	if (ret)
+	if (ret) {
+		kfree_skb(skb);
 		goto cleanup;
+	}
 
 	ret = dev_direct_xmit(skb, 0);
 	if (ret)
-- 
2.35.1



