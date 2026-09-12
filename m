Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F4D2BCF4C;
	Sat, 12 Sep 2026 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238351; cv=none; b=dp5UyIQfF/ZmHDGMvlV4UVGZYUY0A3Y+ZrA20oBzKKFcJ4ov3oLZ5ubh6j6aJQFWBh6todfWo0cApcUX9d6+nwqxuULl0ndbzNJXFLngKjJiiwPyKlV6t2DXu1c40Me+mgD/D9HJvKPBPoLEXlkNJ4T5KEen4BuuhSVyQXtasfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238351; c=relaxed/simple;
	bh=PTcJsgoJeU1Jeis84Y1bMWoF6OHvYxvrg2W0Pk+08hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5Kzj/PkxDeuAcGonldvenYPsLEdMwQkyfy3UISiKGuMl6yDSW/ZK4CzodyT+cGoSHk95sR/WZ1SgjTOYIouWRnuHC/QB2IByGW9245z69l0kXRy9cDwSzlHXaM9czDn6K8ED81P7KxiHjzsIhIFNpZ5HxMmJsnfx6Q+QpWBfPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTYW/8b/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTYW/8b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44CE1F000FF;
	Sat, 12 Sep 2026 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238350;
	bh=ibkBeTSL0odKm+80dm9BgVnbx+tYz/Yep3bTzXSOCkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTYW/8b/8hDkUxZGR3Sx08QstrKkialWqfzXGYYdi7xVI0IIrrQZrGZcrO1GFpAuc
	 L60trudo367qJeit4EGIuc8TXAmDFgFqnVDHF7HYiS9FXBECCBCM9OtcvFcMIDRVlU
	 DND0Yd1Sq8Ssn+zs1ICrbrMQjUvIot3K9qjilZ/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/935] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 08:57:52 +0200
Message-ID: <20260912065536.968647347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d03f980a25853f6a380895119a572a3bb1194e8d ]

sa_ul_probe() calls sa_init_mem() to create the DMA pool used for
security context buffers, but ignores its return value. If pool creation
fails, probe still continues with DMA setup, algorithm registration and
child population even though later request setup depends on that pool.

Stop probing when sa_init_mem() fails, and route that failure to the PM
cleanup path without attempting to destroy an uncreated DMA pool.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 1cd81918580b0..0fe6b97f67de4 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2416,7 +2416,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sa_init_mem(dev_data);
+	ret = sa_init_mem(dev_data);
+	if (ret)
+		goto disable_pm;
+
 	ret = sa_dma_init(dev_data);
 	if (ret)
 		goto destroy_dma_pool;
@@ -2451,6 +2454,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.53.0



