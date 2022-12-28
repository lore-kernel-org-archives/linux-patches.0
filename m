Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985C21875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1875DC433EF;
	Wed, 28 Dec 2022 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243664;
	bh=Jjmn+cly577mIBtdrHbVjmakA1xfXxsj/1hf5RIR99I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1D4W3oRVSipmPZZEaECjhIi/RmqAxrxLjXKC00uhmwbp0Mo9j/CdL4EaAigSyDL5
	 EWypu7isfaHUtxc2baFs0DsoNAYrkKy7YEnyxk0zVpID5HtbQqURnoGAmvaWmKYbJ3
	 AdLp1lcsll/nX7YbdHMo4R3PcOJysOp3OJVGFLzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0530/1146] net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()
Date: Wed, 28 Dec 2022 15:34:29 +0100
Message-Id: <20221228144344.571802075@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 49af7e78b7f5..687f43cd466c 100644
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



