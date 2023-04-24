Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B206A7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F3C433D2;
	Mon, 24 Apr 2023 13:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343027;
	bh=7Z6bMx4oCwqkksV1dpSf/lzDQSmNYW3uK/vGMR70Z0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1qn6iah1JINYoo6bBNReYxWX3zmEboZTkB/YeA7nAHTwNW1u8gDHYUBwQM6yBLa+
	 1wXe7s0FMnFDtJdRJ6SWzMq6rQfv6iGJb2y6P3apW+maPVxYxrPcSVGhrWnAt1QiOv
	 7IHdi6oTvNgPVnGu2E6FRdniZuvcnlL+NEZQa+sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lanzhe <u202212060@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 032/110] spi: spi-rockchip: Fix missing unwind goto in rockchip_sfc_probe()
Date: Mon, 24 Apr 2023 15:16:54 +0200
Message-Id: <20230424131137.343997955@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Lanzhe <u202212060@hust.edu.cn>

[ Upstream commit 359f5b0d4e26b7a7bcc574d6148b31a17cefe47d ]

If devm_request_irq() fails, then we are directly return 'ret' without
clk_disable_unprepare(sfc->clk) and clk_disable_unprepare(sfc->hclk).

Fix this by changing direct return to a goto 'err_irq'.

Fixes: 0b89fc0a367e ("spi: rockchip-sfc: add rockchip serial flash controller")
Signed-off-by: Li Lanzhe <u202212060@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230419115030.6029-1-u202212060@hust.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index bd87d3c92dd33..69347b6bf60cd 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -632,7 +632,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "Failed to request irq\n");
 
-		return ret;
+		goto err_irq;
 	}
 
 	ret = rockchip_sfc_init(sfc);
-- 
2.39.2



