Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA6D1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60D8C433D2;
	Wed, 28 Dec 2022 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245015;
	bh=H+NjqY+eCG8tBT/cRDyQh1pMzSYauxs9/AH0P+pMNbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfBZG92fyqeOm5xw9wUFavm/7D+47VJehvINbT0pxAnLePbL/kqMHEdqNF5kgvrP6
	 rK7/AGmz/slsm5h8mqMNSTw3vP71M/kBfiY8zZd2c6nQnKtufBt81g4Phja2Cml7LT
	 77I9lNAVKVaoaMdS1JMmyHkfdulJQfc3dg7cIX+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Chris Morgan <macromorgan@hotmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0778/1146] power: supply: Fix refcount leak in rk817_charger_probe
Date: Wed, 28 Dec 2022 15:38:37 +0100
Message-Id: <20221228144351.279188279@linuxfoundation.org>
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

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 54c03bfd094fb74f9533a9c28250219afe182382 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 11cb8da0189b ("power: supply: Add charger driver for Rockchip RK817")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Reviewed-by: Chris Morgan <macromorgan@hotmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rk817_charger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/rk817_charger.c b/drivers/power/supply/rk817_charger.c
index f20a6ac584cc..4f9c1c417916 100644
--- a/drivers/power/supply/rk817_charger.c
+++ b/drivers/power/supply/rk817_charger.c
@@ -1060,8 +1060,10 @@ static int rk817_charger_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	charger = devm_kzalloc(&pdev->dev, sizeof(*charger), GFP_KERNEL);
-	if (!charger)
+	if (!charger) {
+		of_node_put(node);
 		return -ENOMEM;
+	}
 
 	charger->rk808 = rk808;
 
-- 
2.35.1



