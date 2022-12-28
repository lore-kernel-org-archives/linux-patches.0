Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A871875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E41C433D2;
	Wed, 28 Dec 2022 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243201;
	bh=F/SzWPdVnhRsksvZ9j1OOAWMBR2NQrYAmrU8kfUHv9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWeqmo0v9ZMHMwlyz1Gipo23sfTA2Ye7+QzvyfrvYTHaxy+O7Z35p1WN4z7SuVeni
	 cuc6lFrtFhX+vw9/ZagY5b+FKrNvoxiso8jBXGELXFLXEQNRFPLIKX5eyXodlCcKkB
	 tmYI4L5F7MgBaTThHRpfu83kYxbDrNEcReyoUPBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jingjin <wangjingjin1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 694/731] ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()
Date: Wed, 28 Dec 2022 15:43:21 +0100
Message-Id: <20221228144316.579627533@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Jingjin <wangjingjin1@huawei.com>

[ Upstream commit 6d94d0090527b1763872275a7ccd44df7219b31e ]

rk_spdif_runtime_resume() may have called clk_prepare_enable() before return
from failed branches, add missing clk_disable_unprepare() in this case.

Fixes: f874b80e1571 ("ASoC: rockchip: Add rockchip SPDIF transceiver driver")
Signed-off-by: Wang Jingjin <wangjingjin1@huawei.com>
Link: https://lore.kernel.org/r/20221208063900.4180790-1-wangjingjin1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_spdif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index d027ca4b1796..09a25d84fee6 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -88,6 +88,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(spdif->hclk);
 	if (ret) {
+		clk_disable_unprepare(spdif->mclk);
 		dev_err(spdif->dev, "hclk clock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



