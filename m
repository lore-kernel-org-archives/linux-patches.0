Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5D399365;
	Sat, 12 Sep 2026 20:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243317; cv=none; b=V2A1guSGWCl7JKNiLhBWtVFOzuOfIynn3HI6iRLcKSVLp3C/h8AXQRNe5+lU7xSMr4bmqznVodHSpSJc80hFt40NPz0Nzfp5hOHCxy6z1ZQR+6lEHVjHD1FICkW8dFHXhexWRUW9vMHJ8JLSA7QOyLufa+PEI90WpiwAL1k+/vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243317; c=relaxed/simple;
	bh=oiVhqHF7EJ2TNy1uKv1lfP6OTCB60+93Yr6hN+aYIII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epM54qkyDmAXtbVXnaasmX0Awe7d+Xb4fX/J7ceN2jEAtAYMkIYNN5YW2Zi85T/HikONELRn7IXpHYxvy9qvKejQgT1m8Nm1nQk1+W5dnEchfKQHcN4bzw+YA6FmaIZrK4GqTdOe+qJD0dswqg/lQaFwme+J7RuP/fz1yiVd6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZmVY1TY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZmVY1TY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92DF1F000FF;
	Sat, 12 Sep 2026 20:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243316;
	bh=JFxw1yb1qAU8+rDpmdueRXUIF55NSkRqzpOU2Pvh6T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZmVY1TYbbPzeFtOwhcJgg844hZNGmkNF0FyqqPQk+JYzdV8q6KyCNpiwCRwyMwLc
	 CPC/9F4tE2jQQqJ97bxiq7S6AxqklFxVfLC2oHDw6Ob7x9BRiFL7d7MDu+Cjpidtu2
	 ybDfjoy2sxm1ElayFvi5hAYymoqhtCTwxzDdM3T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 696/798] spi: img-spfi: dont disable runtime PM on DMA deferred probe
Date: Sat, 12 Sep 2026 09:05:24 +0200
Message-ID: <20260912065533.047347210@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 923e41ed59511cffe98357c7d58d0294a1c157ee ]

When dma_request_chan() returns -EPROBE_DEFER, the error path jumps to
disable_pm and calls pm_runtime_disable() even though pm_runtime_enable()
was never called, leaving disable_depth unbalanced and the device
permanently PM-disabled.

Route the defer path through free_dma to skip pm_runtime_disable().

Fixes: 6bfbf4d0aa0c ("spi: img-spfi: Use dma_request_chan() instead dma_request_slave_channel()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260808-spfi-v1-1-6bc4345be430@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-img-spfi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 71376b6df89db..5f84c55eee6bb 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -617,7 +617,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->tx_ch);
 		spfi->tx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	spfi->rx_ch = dma_request_chan(spfi->dev, "rx");
@@ -625,7 +625,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(spfi->rx_ch);
 		spfi->rx_ch = NULL;
 		if (ret == -EPROBE_DEFER)
-			goto disable_pm;
+			goto free_dma;
 	}
 
 	if (!spfi->tx_ch || !spfi->rx_ch) {
@@ -653,6 +653,7 @@ static int img_spfi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_disable(spfi->dev);
+free_dma:
 	if (spfi->rx_ch)
 		dma_release_channel(spfi->rx_ch);
 	if (spfi->tx_ch)
-- 
2.53.0



