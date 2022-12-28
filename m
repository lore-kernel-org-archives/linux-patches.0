Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D211868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7963DC433F0;
	Wed, 28 Dec 2022 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242063;
	bh=MbAb0bNy8l/E5IppMg6LDyvbtgW8oiWqlw+mbO+kd0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukC047UA4xS6BD6CT7nlUgVl2147xPmeFJHgzT6f6NyYCLy1ObFZLWDbhKoiwQfnX
	 0EJffcIAtujYed2zGqTF7NYS7eU8KAr7vpqD1Klwse5VukFE5zEcKJ8PQPju9SRdCh
	 n486a//CTZ98UcEXihj0eBMESDRxDSWKVACFLeqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangPeng <zhangpeng362@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0360/1073] pinctrl: k210: call of_node_put()
Date: Wed, 28 Dec 2022 15:32:28 +0100
Message-Id: <20221228144337.780319245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit a8acc11643082a706de86a19f1f824712d971984 ]

Since for_each_available_child_of_node() will increase the refcount of
node, we need to call of_node_put() manually when breaking out of the
iteration.

Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20221122075853.2496680-1-zhangpeng362@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k210.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-k210.c b/drivers/pinctrl/pinctrl-k210.c
index ecab6bf63dc6..ad4db99094a7 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -862,8 +862,10 @@ static int k210_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	for_each_available_child_of_node(np_config, np) {
 		ret = k210_pinctrl_dt_subnode_to_map(pctldev, np, map,
 						     &reserved_maps, num_maps);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(np);
 			goto err;
+		}
 	}
 	return 0;
 
-- 
2.35.1



