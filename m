Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E691FB24
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237C1C433C8;
	Tue,  1 Aug 2023 09:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882281;
	bh=t7rHmNfJi8Xzf8k1L0tqxO6xhIyurqe/8uqRDwpI+zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRjdXJCNj+MaQtWYakXP0DjMvc7vw0NPm8+CthHl2Ajvn7MozcvdmvDygMoz4cz+B
	 J+spHScBi9BpMVfJWrDNpqMLa9lw/IxJEJUMhk3o6fGyoImgpc9ruhGqkE60fe8I0g
	 bMxbg3u9JrMRKcjDNjVZYj7iBaJZMLSPP77QhJvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/228] i2c: nomadik: Remove unnecessary goto label
Date: Tue,  1 Aug 2023 11:18:00 +0200
Message-ID: <20230801091923.662033496@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andi Shyti <andi.shyti@kernel.org>

[ Upstream commit 1c5d33fff0d375e4ab7c4261dc62a286babbb4c6 ]

The err_no_mem goto label doesn't do anything. Remove it.

Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 05f933d5f731 ("i2c: nomadik: Remove a useless call in the remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-nomadik.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 5004b9dd98563..8b9577318388e 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -971,10 +971,9 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	u32 max_fifo_threshold = (vendor->fifodepth / 2) - 1;
 
 	dev = devm_kzalloc(&adev->dev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		ret = -ENOMEM;
-		goto err_no_mem;
-	}
+	if (!dev)
+		return -ENOMEM;
+
 	dev->vendor = vendor;
 	dev->adev = adev;
 	nmk_i2c_of_probe(np, dev);
@@ -995,30 +994,27 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 
 	dev->virtbase = devm_ioremap(&adev->dev, adev->res.start,
 				resource_size(&adev->res));
-	if (!dev->virtbase) {
-		ret = -ENOMEM;
-		goto err_no_mem;
-	}
+	if (!dev->virtbase)
+		return -ENOMEM;
 
 	dev->irq = adev->irq[0];
 	ret = devm_request_irq(&adev->dev, dev->irq, i2c_irq_handler, 0,
 				DRIVER_NAME, dev);
 	if (ret) {
 		dev_err(&adev->dev, "cannot claim the irq %d\n", dev->irq);
-		goto err_no_mem;
+		return ret;
 	}
 
 	dev->clk = devm_clk_get(&adev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
 		dev_err(&adev->dev, "could not get i2c clock\n");
-		ret = PTR_ERR(dev->clk);
-		goto err_no_mem;
+		return PTR_ERR(dev->clk);
 	}
 
 	ret = clk_prepare_enable(dev->clk);
 	if (ret) {
 		dev_err(&adev->dev, "can't prepare_enable clock\n");
-		goto err_no_mem;
+		return ret;
 	}
 
 	init_hw(dev);
@@ -1049,7 +1045,6 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 
  err_no_adap:
 	clk_disable_unprepare(dev->clk);
- err_no_mem:
 
 	return ret;
 }
-- 
2.39.2



