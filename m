Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D926FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EB3C433EF;
	Mon, 16 Jan 2023 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887360;
	bh=OUgQ3YmlL+kC/xj82o2Oh7xprEho4Eb8CVEzeEQBe6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj6Vy7qVvDxhjGpg81V5rusUWIb3bS0URM7Hjm/TSR0DpNcK8Zq+36AZNHiEwx1dQ
	 U1zD+WN6eN/3LK723i8/BAx+vc/wuHp1UTwFyiwgMPNwiaVmSWfMyyIvgT0Efa8Yy5
	 uI4wg/gUT2hYUNvMrtJUSEniELLw0BKHx46XLK/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/521] ASoC: pxa: fix null-pointer dereference in filter()
Date: Mon, 16 Jan 2023 16:46:04 +0100
Message-Id: <20230116154851.820551150@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit ec7bf231aaa1bdbcb69d23bc50c753c80fb22429 ]

kasprintf() would return NULL pointer when kmalloc() fail to allocate.
Need to check the return pointer before calling strcmp().

Fixes: 7a824e214e25 ("ASoC: mmp: add audio dma support")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221114085629.1910435-1-zengheng4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/pxa/mmp-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/pxa/mmp-pcm.c b/sound/soc/pxa/mmp-pcm.c
index d2d4652de32c..5969aa66410d 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -90,7 +90,7 @@ static bool filter(struct dma_chan *chan, void *param)
 
 	devname = kasprintf(GFP_KERNEL, "%s.%d", dma_data->dma_res->name,
 		dma_data->ssp_id);
-	if ((strcmp(dev_name(chan->device->dev), devname) == 0) &&
+	if (devname && (strcmp(dev_name(chan->device->dev), devname) == 0) &&
 		(chan->chan_id == dma_data->dma_res->start)) {
 		found = true;
 	}
-- 
2.35.1



