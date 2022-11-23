Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA71C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9046C433C1;
	Wed, 23 Nov 2022 09:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195231;
	bh=6xSy77Aw6z0fpoypOrp9uPxk6VC+ci3iUBhretptsqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dg4pNU3PNUB+tBBypJCAwAE3ZCfa7pxd0WrTTBgw1qUI/M9gfiOfbJbT29VxchJF2
	 Alk7pY+SDy+TuOgVSDB1fwd+0HfzXa9zP6SbwrotfdB+hK3cjOzY5SJ7VPPymK8pNM
	 k1KWZU1KY87NYGATeECzqcx5q3qI683+gzLHnelQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/149] ASoC: mt6660: Keep the pm_runtime enables before component stuff in mt6660_i2c_probe
Date: Wed, 23 Nov 2022 09:49:47 +0100
Message-Id: <20221123084558.125414426@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit c4ab29b0f3a6f1e167c5a627f7cd036c1d2b7d65 ]

It would be better to keep the pm_runtime enables before the
IRQ and component stuff. Both of those could start triggering
PM runtime events.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221008140522.134912-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6660.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index e18a58868273..3cee2ea4b85d 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -504,14 +504,14 @@ static int mt6660_i2c_probe(struct i2c_client *client,
 		dev_err(chip->dev, "read chip revision fail\n");
 		goto probe_fail;
 	}
+	pm_runtime_set_active(chip->dev);
+	pm_runtime_enable(chip->dev);
 
 	ret = devm_snd_soc_register_component(chip->dev,
 					       &mt6660_component_driver,
 					       &mt6660_codec_dai, 1);
-	if (!ret) {
-		pm_runtime_set_active(chip->dev);
-		pm_runtime_enable(chip->dev);
-	}
+	if (ret)
+		pm_runtime_disable(chip->dev);
 
 	return ret;
 
-- 
2.35.1



