Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7868D1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B43C433F0;
	Wed, 28 Dec 2022 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246199;
	bh=Ygy8EgtQzNxXOzgVAk1VZO+lRG4woIA8vzcJPJNiZvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reVMpLSvQO/hsObyecbqqqlM52fxJM06YQVZg1KJPXjF27I4AxTDE3Y58dAidKSoA
	 gdhuvrySLTliM9uJLPct6VJfT/wsASS9JZ1V1grHlf4LBLuGiPMmb+EeArKdtsxQL8
	 MauUbr9VIfis3Hf9lwX45pjHqcF1G/APx0zz3jvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0997/1073] ASoC: sof_es8336: fix possible use-after-free in sof_es8336_remove()
Date: Wed, 28 Dec 2022 15:43:05 +0100
Message-Id: <20221228144355.210858386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1b41beaa7a58467505ec3023af8aad74f878b888 ]

sof_es8336_remove() calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This
means that the callback function may still be running after
the driver's remove function has finished, which would result
in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Fixes: 89cdb224f2ab ("ASoC: sof_es8336: reduce pop noise on speaker")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221205143721.3988988-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 5c218a39ca20..57adcefce043 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -782,7 +782,7 @@ static int sof_es8336_remove(struct platform_device *pdev)
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 	struct sof_es8336_private *priv = snd_soc_card_get_drvdata(card);
 
-	cancel_delayed_work(&priv->pcm_pop_work);
+	cancel_delayed_work_sync(&priv->pcm_pop_work);
 	gpiod_put(priv->gpio_speakers);
 	device_remove_software_node(priv->codec_dev);
 	put_device(priv->codec_dev);
-- 
2.35.1



