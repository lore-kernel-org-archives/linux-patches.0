Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B51C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4BDC433C1;
	Wed, 23 Nov 2022 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194324;
	bh=tykjTPK16xxFVpodumZ6Qwe8q7E9DfTLr7sh3xwQ8iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSey3lI4BJy1wpW91GPacGaLespR6Tp18K40asMESj4Po8cVKOQJ+7veHiG9/e1k9
	 zSzNCak7CV1KmfNOr7M0qt9A347xveoftSBrWIxJmwmYL/EzX6ZibhuldcrPFdN96V
	 3qjFW/v8IQiIcCVMRwwyfvyqTW/W6adciJf+G3ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/114] drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
Date: Wed, 23 Nov 2022 09:50:02 +0100
Message-Id: <20221123084552.465734257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit ce9e57feeed81d17d5e80ed86f516ff0d39c3867 ]

When failed to register irq in xgene_enet_open() for opening device,
napi isn't disabled. When open xgene device next time, it will reports
a invalid opcode issue. Fix it. Only be compiled, not be tested.

Fixes: aeb20b6b3f4e ("drivers: net: xgene: fix: ifconfig up/down crash")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221107043032.357673-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 86811de191ed..f27391abd7da 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1015,8 +1015,10 @@ static int xgene_enet_open(struct net_device *ndev)
 
 	xgene_enet_napi_enable(pdata);
 	ret = xgene_enet_register_irq(ndev);
-	if (ret)
+	if (ret) {
+		xgene_enet_napi_disable(pdata);
 		return ret;
+	}
 
 	if (ndev->phydev) {
 		phy_start(ndev->phydev);
-- 
2.35.1



