Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2823126ED46;
	Sat, 12 Sep 2026 19:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242545; cv=none; b=UVGEoUvb9B/2qQK71CQtyFe2e03Hzs/FrO0PFyqM8f39BLiLst2fEUM0AOeO6neR1QZ0k49JlVJjPfrKR+QRhb3hD8RJu0r+7+oEx+s42zJaPYkCjfIBANqHVB/R3tQUORqC85QrXuRwp1n6zfTh02HXSN4YLG5eKLeF5uqw92g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242545; c=relaxed/simple;
	bh=WkXmToL+NrPZzVORHoG/Sf/n+uqzbM4grju3301k5Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG5/RRCYrzQJlmPS+KBmHsgwml6aX7RCxV4R4gM/YXEbD15ItSEGvBnHp9mMYxyz/GV36iZjt9C4oPz+bmAHIt2I67Q7sKsg8I0ZhNkfaUykxFRzeEmvuEGeTFsJ6vNVw75kRPX+YNr9GiIvJlw+Tf9IEcefDeALwL6oei5eSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Exbl8YZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Exbl8YZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B311F000FF;
	Sat, 12 Sep 2026 19:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242544;
	bh=QPAPX0t6Jfn4WVGa1Ms6PVyNuX8NLcIC/iyOX4O8JtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Exbl8YZ7Ji65YwGh1iZ6Y+LrEfG1+li6AwL1ACmji3MFXRAwIQLQmi/c9nKBhm8qy
	 ir69pvIRTW0ksRcLw81SmzlzZZy9lTZVbN5rjeHm5cL9yK8+o8SLRpvIJrqW0qH7GN
	 PYrLhH2kMqnv2a/U6o6vDuoRcnGkDio/+63SOla4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 424/798] hwrng: ks-sa - access private data via struct hwrng
Date: Sat, 12 Sep 2026 09:00:52 +0200
Message-ID: <20260912065526.865953321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit b8f836cbe12bccf2beeadd638e1696f4acaa39c3 ]

This driver uses a struct ks_sa_rng for its private data. It contains a
struct hwrng. Call container_of to get from hwrng to ks_sa_rng.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 1c17b601fafb ("hwrng: ks-sa - Fix runtime PM cleanup on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ks-sa-rng.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index 994cfdf346e15..09dcaa35c8009 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -113,8 +113,7 @@ static unsigned int refill_delay_ns(unsigned long clk_rate)
 static int ks_sa_rng_init(struct hwrng *rng)
 {
 	u32 value;
-	struct device *dev = (struct device *)rng->priv;
-	struct ks_sa_rng *ks_sa_rng = dev_get_drvdata(dev);
+	struct ks_sa_rng *ks_sa_rng = container_of(rng, struct ks_sa_rng, rng);
 	unsigned long clk_rate = clk_get_rate(ks_sa_rng->clk);
 
 	/* Enable RNG module */
@@ -153,8 +152,7 @@ static int ks_sa_rng_init(struct hwrng *rng)
 
 static void ks_sa_rng_cleanup(struct hwrng *rng)
 {
-	struct device *dev = (struct device *)rng->priv;
-	struct ks_sa_rng *ks_sa_rng = dev_get_drvdata(dev);
+	struct ks_sa_rng *ks_sa_rng = container_of(rng, struct ks_sa_rng, rng);
 
 	/* Disable RNG */
 	writel(0, &ks_sa_rng->reg_rng->control);
@@ -164,8 +162,7 @@ static void ks_sa_rng_cleanup(struct hwrng *rng)
 
 static int ks_sa_rng_data_read(struct hwrng *rng, u32 *data)
 {
-	struct device *dev = (struct device *)rng->priv;
-	struct ks_sa_rng *ks_sa_rng = dev_get_drvdata(dev);
+	struct ks_sa_rng *ks_sa_rng = container_of(rng, struct ks_sa_rng, rng);
 
 	/* Read random data */
 	data[0] = readl(&ks_sa_rng->reg_rng->output_l);
@@ -179,8 +176,7 @@ static int ks_sa_rng_data_read(struct hwrng *rng, u32 *data)
 
 static int ks_sa_rng_data_present(struct hwrng *rng, int wait)
 {
-	struct device *dev = (struct device *)rng->priv;
-	struct ks_sa_rng *ks_sa_rng = dev_get_drvdata(dev);
+	struct ks_sa_rng *ks_sa_rng = container_of(rng, struct ks_sa_rng, rng);
 	u64 now = ktime_get_ns();
 
 	u32	ready;
@@ -225,7 +221,6 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		.data_present = ks_sa_rng_data_present,
 		.cleanup = ks_sa_rng_cleanup,
 	};
-	ks_sa_rng->rng.priv = (unsigned long)dev;
 
 	ks_sa_rng->reg_rng = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ks_sa_rng->reg_rng))
@@ -253,8 +248,6 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, ks_sa_rng);
-
 	return devm_hwrng_register(&pdev->dev, &ks_sa_rng->rng);
 }
 
-- 
2.53.0



