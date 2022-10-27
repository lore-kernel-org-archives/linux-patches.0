Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658868486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2FCC433C1;
	Thu, 27 Oct 2022 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889936;
	bh=hDG4OaXLMBwx144O6iq3c/ifd2pyrJggYNLmL9GKX/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdZf5563r5ZHQesvFhHU1rV51YxE5+1BGDCrzZzUjjTFPICA6dcWw8zspnYE9AOtv
	 bMngIythSCDYqW6GXvftm5m2rOqM3PjnbyO3WsKvhYWJQcA6Q8Rdr94p5qljBm9o3G
	 1lL1PjIjp+BXntEKvRNytHVMSrNgB5SZPeVu5FVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 53/94] net: ethernet: mtk_eth_wed: add missing put_device() in mtk_wed_add_hw()
Date: Thu, 27 Oct 2022 18:54:55 +0200
Message-Id: <20221027165059.323049926@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9d4f20a476ca57e4c9246eb1fa2a61bea2354720 ]

After calling get_device() in mtk_wed_add_hw(), in error path, put_device()
needs be called.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 29be2fcafea3..fff2b745587e 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -813,11 +813,11 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return;
+		goto err_put_device;
 
 	regs = syscon_regmap_lookup_by_phandle(np, NULL);
 	if (IS_ERR(regs))
-		return;
+		goto err_put_device;
 
 	rcu_assign_pointer(mtk_soc_wed_ops, &wed_ops);
 
@@ -853,8 +853,14 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	hw_list[index] = hw;
 
+	mutex_unlock(&hw_lock);
+
+	return;
+
 unlock:
 	mutex_unlock(&hw_lock);
+err_put_device:
+	put_device(&pdev->dev);
 }
 
 void mtk_wed_exit(void)
-- 
2.35.1



