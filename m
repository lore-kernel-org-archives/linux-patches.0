Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054765;
	b=sRpp2m/YIMXJZPBeBqXublAZlg35wVM5YXBcTxOnOANWTAr0C9KPN3PYX0CmZZeeJdZG
	 uj/0OOYuKEgUca5glvZgDx7dTNleQQhKx8sEGUyLeAYW6AXmPW8EoeOFC0WGDmsHyJDHv
	 3If8tptiA1NkkR8Kzs73JYOVl2H4p/f3raE5PE+mKcpyYFbZLJt6PFyWnF8gOM4uwiIs0
	 F77nYSP1MC5PA5PE5d44pU2sJXwuRundxbcVadgSW8MS4G/iYTsI2wG/4ge/NzRYAb9yq
	 +GU1F42aoS39eatgHeRAdCdvRPqitKNSIxWnN4wXR8dXiRraBnLh2pZu1fLp1Z04NAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdSXiM/EibTb4cIblhFCNVmaOWtVQ6Y57vzjg8FR1LE=;
	b=epPeN8WzMC8WBqFLckbEeM++4joSX8ho04XAb/4gTcQVt4oPv75f+IFrwaP0yxgny8bw
	 wWsZpJOC7ay2sYTqynwAiWvhijiw9DGqMaORIB9HJaVdAbIDjOhCfHn++Icwu3SCCeyOG
	 /NYO3V6pbHh9/IE8EnM3x115lPsnxKeomFvnOhFHUQu7DNSWUobznoETb3sJGh/gSsKvY
	 3MAO7kYLKR0HswgWf9a7bqgC8lrD76YGsZ1mcGng10Ip8n78f0XYajGXKxizjRfGZ3iB0
	 SIR/JxhRo62W8HGn9TrgBGfyN6B9DdWL730sHgJQdbN9KlgspyIvs8gqikZIMxlNxUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuXiowDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC890606A32F;
	Thu, 19 Nov 2026 02:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuXiowDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B304C1F000C4;
	Thu, 19 Nov 2026 02:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054765;
	bh=fdSXiM/EibTb4cIblhFCNVmaOWtVQ6Y57vzjg8FR1LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuXiowDU5xsgUxvI2k5oB5KCfxHMyVkxnpldXX+Tdxpqsuu1Ur2WIzXnw9QBVOq6N
	 iwbVYFuyGxrZKkDGx58lOFC47/8yYLeYE7y6izvWEUnpYKqqMRyD77pYeCadXLrIaK
	 2b1PBs6EjqVE1FSxBcbhZhz9CRLcxr/UFghXwB2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1392/2214] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150107.001749183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 36584d1f0e835..58980e317ca89 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -861,6 +861,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



