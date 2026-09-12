Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A100C37204A;
	Sat, 12 Sep 2026 07:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197292; cv=none; b=HypnLR2/egeJvn9hJ1YfBSiZP0eUnAwXDuJ1I5CPTuSYQFl5LfZfDcCkyr9wq69K8XeuaaDRKeBnsMjPXtyBiFeMCZdBO0gONgTEbXEa7sPO3D/UYVJNVr+EFKrXXMZE1haNOTU5ATOWWMh4OKn8DQ1FUPNN//+L2/TkXDr3auw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197292; c=relaxed/simple;
	bh=pTss0qdCyTuKi0/9Hh6v0vMPakfXJAj7CL43pQ0/nrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyoMb8cEoM9jRF+2i/WjVKVZGM92qgg8zApl6dtARuBVteeVmZcfQt9XWPfBP+/6lSvdsfwSLqg79YjOaGdEAq2IGlSMYaywnh9NPeatjCJaS5Iqu2dIK96nX44YewywaqltEjHmm+maIr530c9TOeX5yOk05t6VGxhiMXrvoXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxCaju8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxCaju8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5BD1F000FF;
	Sat, 12 Sep 2026 07:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197291;
	bh=g112QFxviwK6PmS2FRbHPtZY8wUiiqOKi/88EPFl+Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxCaju8OLg2/KnccvuVJyTY+/Ddxp7A4U3stWKIaiXP9LvS1jfpWNs53uMbnDSlxF
	 RDKRyeFv8K263112Ypwi5nbqiBo45ig+6uEs1CWsLNf9v7iZiaPzhTrjE0jkMjcCK6
	 /dOxeN8C6MU5HkQBxmNDOjRBbcPDrLoyXYw3mHck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0145/1815] ASoC: samsung: i2s: Avoid mixing goto with guard()
Date: Sat, 12 Sep 2026 08:31:35 +0200
Message-ID: <20260912065652.418463029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 02fd694e60a7e2c581c7836f6781c01b9b419c8a ]

cleanup.h recommends not mixing goto-based error handling with cleanup
helpers in the same function.
Remove the goto path and rely on guard(pm_runtime) for automatic cleanup
instead.

Fixes: 3d08517b5c67 ("ASoC: samsung: i2s: Use guard() for spin locks")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260701041310.230725-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/i2s.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index f80f697a5d55d..f80e8d4981565 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -8,6 +8,7 @@
 #include <dt-bindings/sound/samsung-i2s.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/io.h>
@@ -512,7 +513,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 	u32 mod, mask, val = 0;
 	int ret = 0;
 
-	pm_runtime_get_sync(dai->dev);
+	guard(pm_runtime_active)(dai->dev);
 
 	scoped_guard(spinlock_irqsave, &priv->lock)
 		mod = readl(priv->addr + I2SMOD);
@@ -537,8 +538,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 					&& (mod & cdcon_mask))))) {
 			dev_err(&i2s->pdev->dev,
 				"%s:%d Other DAI busy\n", __func__, __LINE__);
-			ret = -EAGAIN;
-			goto err;
+			return -EAGAIN;
 		}
 
 		if (dir == SND_SOC_CLOCK_IN)
@@ -566,7 +566,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 				} else {
 					priv->rclk_srcrate =
 						clk_get_rate(priv->op_clk);
-					goto done;
+					return 0;
 				}
 			}
 
@@ -580,14 +580,14 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 			if (WARN_ON(IS_ERR(priv->op_clk))) {
 				ret = PTR_ERR(priv->op_clk);
 				priv->op_clk = NULL;
-				goto err;
+				return ret;
 			}
 
 			ret = clk_prepare_enable(priv->op_clk);
 			if (ret) {
 				clk_put(priv->op_clk);
 				priv->op_clk = NULL;
-				goto err;
+				return ret;
 			}
 			priv->rclk_srcrate = clk_get_rate(priv->op_clk);
 
@@ -595,11 +595,10 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 				|| (clk_id && !(mod & rsrc_mask))) {
 			dev_err(&i2s->pdev->dev,
 				"%s:%d Other DAI busy\n", __func__, __LINE__);
-			ret = -EAGAIN;
-			goto err;
+			return -EAGAIN;
 		} else {
 			/* Call can't be on the active DAI */
-			goto done;
+			return 0;
 		}
 
 		if (clk_id == 1)
@@ -607,8 +606,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 		break;
 	default:
 		dev_err(&i2s->pdev->dev, "We don't serve that!\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	scoped_guard(spinlock_irqsave, &priv->lock) {
@@ -616,13 +614,8 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id, unsigned int rfs,
 		mod = (mod & ~mask) | val;
 		writel(mod, priv->addr + I2SMOD);
 	}
-done:
-	pm_runtime_put(dai->dev);
 
 	return 0;
-err:
-	pm_runtime_put(dai->dev);
-	return ret;
 }
 
 static int i2s_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
-- 
2.53.0



