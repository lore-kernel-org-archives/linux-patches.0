Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3B2BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D32DC433EF;
	Tue,  7 Mar 2023 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215607;
	bh=oP8ORRjr5X4Rl3p67WgpExTczobI/iUv6ge9a4IZnhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnNA60If/gL3NxCH/+lYznt7px4g9XrJb6R02dzwIyWPEN9ObbOanBmkT60TtB1U/
	 ue7QNQNgtDFPYCtP95J6JCl2ahA6jR+a8sX7PT1LAT1wb+kEqTofWTzb6+XQaTeYGE
	 8pF9mcseMug3XAjOHG4tiafa3Z7lhHrGYWPuXJdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/567] RDMA/cxgb4: add null-ptr-check after ip_dev_find()
Date: Tue,  7 Mar 2023 18:00:52 +0100
Message-Id: <20230307165919.565560916@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit ef42520240aacfc0d46c8d780c051d135a8dc9b7 ]

ip_dev_find() may return NULL and assign it to pdev which is
dereferenced later.
Fix this by checking the return value of ip_dev_find() for NULL
similar to the way it is done with other instances of said function.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230201172103.17261-1-n.zhandarovich@fintech.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 291471d12197f..56f46a16e6575 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4150,6 +4150,10 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	if (neigh->dev->flags & IFF_LOOPBACK) {
 		pdev = ip_dev_find(&init_net, iph->daddr);
+		if (!pdev) {
+			pr_err("%s - failed to find device!\n", __func__);
+			goto free_dst;
+		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
 				    pdev, 0);
 		pi = (struct port_info *)netdev_priv(pdev);
-- 
2.39.2



