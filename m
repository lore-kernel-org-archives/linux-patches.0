Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0323A8486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C098C433D6;
	Thu, 27 Oct 2022 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889938;
	bh=JtpIYIMkexgB07OMO+X3Sg3lhexb866ZbWLaBgvsPt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3JuVOqfUuxKA+arLIIj9b3X7yG99nOVgWzEKUSoFiEIe2bKHYjqXyf75GP1KiCts
	 9RLsXNJ9pbJ08ekqZU02YEGUulx6IclI5UhnOY0/9pj5Hng3C/MN8L4XX8/B+2louM
	 KXdnHniLxvSmu63dq/67PMLEAK/c2mEj3vels9Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 54/94] net: ethernet: mtk_eth_wed: add missing of_node_put()
Date: Thu, 27 Oct 2022 18:54:56 +0200
Message-Id: <20221027165059.356238195@linuxfoundation.org>
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

[ Upstream commit e0bb4659e235770e6f53b3692e958591f49448f5 ]

The device_node pointer returned by of_parse_phandle() with refcount
incremented, when finish using it, the refcount need be decreased.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index fff2b745587e..614147ad6116 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -808,7 +808,7 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	pdev = of_find_device_by_node(np);
 	if (!pdev)
-		return;
+		goto err_of_node_put;
 
 	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
@@ -861,6 +861,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	mutex_unlock(&hw_lock);
 err_put_device:
 	put_device(&pdev->dev);
+err_of_node_put:
+	of_node_put(np);
 }
 
 void mtk_wed_exit(void)
@@ -881,6 +883,7 @@ void mtk_wed_exit(void)
 		hw_list[i] = NULL;
 		debugfs_remove(hw->debugfs_dir);
 		put_device(hw->dev);
+		of_node_put(hw->node);
 		kfree(hw);
 	}
 }
-- 
2.35.1



