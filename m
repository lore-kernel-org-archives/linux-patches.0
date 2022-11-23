Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471E11C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAACC433D7;
	Wed, 23 Nov 2022 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195992;
	bh=XfMfgMe8lbKu34voISkyYmbekNIIsZxoeYhUhW5IZ+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXd9yahAXTrmzHHQE6VtbgIflLAqV0GgtLscJKXzUsZHGOILmGbFmlHXQFsyZwBCI
	 tOFFgfh3oZ1GcIsq6oiLOCO2nr9PAMnPOXvOSzIViscLEqDJ8siXGpZf+2Cr5wecik
	 n5F9JTq0koG+ZspjLV7gLJXDDD/DSmMJiVAW7CMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/181] net: mhi: Fix memory leak in mhi_net_dellink()
Date: Wed, 23 Nov 2022 09:50:52 +0100
Message-Id: <20221123084606.176445831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f7c125bd79f50ec6094761090be81d02726ec6f4 ]

MHI driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch calls free_netdev() to fix it since netdev_priv
is used after unregister.

Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mhi_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index aaa628f859fd..f84554aa02af 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -343,6 +343,8 @@ static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
 
 	kfree_skb(mhi_netdev->skbagg_head);
 
+	free_netdev(ndev);
+
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-- 
2.35.1



