Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913458F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49FBC433D2;
	Mon, 13 Feb 2023 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299989;
	bh=ynkc7p+vQSO7aJs0qHyZwSYXlgXJ4AXGD6bY1HBRZoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D22XOWwj72EhrtbcVpFBRlw4OcgMJe/+dcdc9ncUBeGDcqRs6xOQiA2sXxtpTSv9l
	 UZtEln3peW14aeFru0BUlGLDVbObKYtjXkJbKFDdFBf3H4f439jEg8sxkeV7JPAHOd
	 byc5c/5PlaQq9N1pGRzHd1BM7999FykqR9pUbe9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/114] RDMA/irdma: Fix potential NULL-ptr-dereference
Date: Mon, 13 Feb 2023 15:47:36 +0100
Message-Id: <20230213144743.247946326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

[ Upstream commit 5d9745cead1f121974322b94ceadfb4d1e67960e ]

in_dev_get() can return NULL which will cause a failure once idev is
dereferenced in in_dev_for_each_ifa_rtnl(). This patch adds a
check for NULL value in idev beforehand.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230126185230.62464-1-n.zhandarovich@fintech.ru
Reviewed-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 7b086fe63a245..195aa9ea18b6c 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1722,6 +1722,9 @@ static int irdma_add_mqh_4(struct irdma_device *iwdev,
 			continue;
 
 		idev = in_dev_get(ip_dev);
+		if (!idev)
+			continue;
+
 		in_dev_for_each_ifa_rtnl(ifa, idev) {
 			ibdev_dbg(&iwdev->ibdev,
 				  "CM: Allocating child CM Listener forIP=%pI4, vlan_id=%d, MAC=%pM\n",
-- 
2.39.0



