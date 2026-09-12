Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3093C8717;
	Sat, 12 Sep 2026 07:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197351; cv=none; b=CiEXKHL/Qw8lKcDsY9Ybkzi+MlqEsC3fvt0dc4VdKorJ6AhqXckhD3cDVCP+qMe6Kv9xtSmwuGeyiL8TYnrD9eT2xpcRHoc3GOSutt2+NrW4Vc+2xcTaeVo/DQSiZVICUaq4O7+WcdSm/BFd1r2bjr78CqX5Ow8tjyiHV3INzlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197351; c=relaxed/simple;
	bh=JMVGRn8eVwLkfYLaKqWv29SikgNyW3dZqmJhU3tzkrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUb8vNifik61q8uq961Vior4GE7YVkWekwt+YHop1SspbyBDiKfKzShy1nrxJ65Cn2oolyaiW0wMMqZGeI2WODmAjCIYLpmqoS2aMiiYJtD91tPFTpuGLrXNbxUm6CFrBPoIXFOOBMxsds7kVCFVbtYaZE6/S8x9rEI9afL6CmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3GR1qR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3GR1qR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B3B1F000FF;
	Sat, 12 Sep 2026 07:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197349;
	bh=Er4rMIuADWOQHowf0rNoFUMF8Uo7sHb/w4FfFJG6Omo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3GR1qR/TQtCCYUwjQ4v/RtLVP9by/TbKda41pa9PRfsyBGg1M8qZO5e8fsrpWAPF
	 U78CQj61izznBT6VVU6aSq61tIyxC+T4iLOIjxbkMCsbbapFvmYPalntRx4R7sDKEe
	 USfNzmdqeyETHRBMPWAP7lpKKMEfFGIjsqUnz7ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0156/1815] leds: lp5860: Fix a potential double-unlock
Date: Sat, 12 Sep 2026 08:31:46 +0200
Message-ID: <20260912065652.673643068@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 10a5a70c02277a1c12999b669a1bd1922558338a ]

In lp5860_device_init(), if lp5860_init_dt() fails, an already unlocked
mutex is unlocked another time.

Slightly rework how the lock is taken/released to avoid this potential
double unlock.

Fixes: f0a66563aa2d ("leds: Add support for TI LP5860 LED driver chip")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/0f4d556e0532bfa881d7d83c1e244572117a89e3.1781970674.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-lp5860-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/leds/rgb/leds-lp5860-core.c b/drivers/leds/rgb/leds-lp5860-core.c
index fd0e2f6e6e0f4..e21d5f2302be0 100644
--- a/drivers/leds/rgb/leds-lp5860-core.c
+++ b/drivers/leds/rgb/leds-lp5860-core.c
@@ -204,9 +204,9 @@ int lp5860_device_init(struct device *dev)
 	mutex_lock(&lp->lock);
 	ret = regmap_update_bits(lp->regmap, LP5860_REG_DEV_INITIAL, LP5860_MODE_MASK,
 				 LP5860_MODE_1 << LP5860_MODE_SHIFT);
+	mutex_unlock(&lp->lock);
 	if (ret)
 		goto err_disable;
-	mutex_unlock(&lp->lock);
 
 	ret = lp5860_init_dt(lp);
 	if (ret)
@@ -215,7 +215,6 @@ int lp5860_device_init(struct device *dev)
 	return 0;
 
 err_disable:
-	mutex_unlock(&lp->lock);
 	lp5860_chip_enable(lp, LP5860_CHIP_DISABLE);
 	return ret;
 }
-- 
2.53.0



