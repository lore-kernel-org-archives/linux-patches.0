Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5026FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90019C433C8;
	Sun, 17 Sep 2023 20:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981641;
	bh=dXaDsgpMPvbqsu8mBBUjXVnKhWtL8IZA6oq494jqK9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r317037czc4T3jfS1BmONvBPhDjZufjgrP5uEC3D05kjkoA/UypU8654zC2YbHIyo
	 d7tC4UWn08Z9z3kA3AXikeRFQ9T+XD2Bm9DW2/AMeD8Zd1LvqvcS0cZQ2ALu/OdTO8
	 rVp/rUlLz8GWDzmIXcVuONTs+Hktk4Prg2BMz+M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/511] hwrng: nomadik - keep clock enabled while hwrng is registered
Date: Sun, 17 Sep 2023 21:08:29 +0200
Message-ID: <20230917191115.851791400@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 039980de89dc9dd757418d6f296e4126cc3f86c3 ]

The nomadik driver uses devres to register itself with the hwrng core,
the driver will be unregistered from hwrng when its device goes out of
scope. This happens after the driver's remove function is called.

However, nomadik's clock is disabled in the remove function. There's a
short timeframe where nomadik is still registered with the hwrng core
although its clock is disabled. I suppose the clock must be active to
access the hardware and serve requests from the hwrng core.

Switch to devm_clk_get_enabled and let devres disable the clock and
unregister the hwrng. This avoids the race condition.

Fixes: 3e75241be808 ("hwrng: drivers - Use device-managed registration API")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/nomadik-rng.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index e8f9621e79541..3774adf903a83 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -13,8 +13,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 
-static struct clk *rng_clk;
-
 static int nmk_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	void __iomem *base = (void __iomem *)rng->priv;
@@ -36,21 +34,20 @@ static struct hwrng nmk_rng = {
 
 static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 {
+	struct clk *rng_clk;
 	void __iomem *base;
 	int ret;
 
-	rng_clk = devm_clk_get(&dev->dev, NULL);
+	rng_clk = devm_clk_get_enabled(&dev->dev, NULL);
 	if (IS_ERR(rng_clk)) {
 		dev_err(&dev->dev, "could not get rng clock\n");
 		ret = PTR_ERR(rng_clk);
 		return ret;
 	}
 
-	clk_prepare_enable(rng_clk);
-
 	ret = amba_request_regions(dev, dev->dev.init_name);
 	if (ret)
-		goto out_clk;
+		return ret;
 	ret = -ENOMEM;
 	base = devm_ioremap(&dev->dev, dev->res.start,
 			    resource_size(&dev->res));
@@ -64,15 +61,12 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 
 out_release:
 	amba_release_regions(dev);
-out_clk:
-	clk_disable_unprepare(rng_clk);
 	return ret;
 }
 
 static void nmk_rng_remove(struct amba_device *dev)
 {
 	amba_release_regions(dev);
-	clk_disable_unprepare(rng_clk);
 }
 
 static const struct amba_id nmk_rng_ids[] = {
-- 
2.40.1



