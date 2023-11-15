Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDE2364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTzj1OL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F75C433C8;
	Wed, 15 Nov 2023 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076597;
	bh=Wb/uWYqAAkzq9Sn9ZJYtPj4XLsC1Ei8UjD9vyVMobpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTzj1OL97cIaV4Jm8SDkrnMPSm89KYRi+h6kaMNVI3ggqBkN07uLyNTA19L6pDyiU
	 96oWXbL8FFN2QUSyUsYettjGNO3kKcXgFl18zjJ3l1QQi78KPY7YJ4Hn0xQkGYAYo+
	 w/aHG30eK3NsV730Vx74vW1BnwlpJ7nCYbUGxXHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 307/550] ASoC: cs35l41: Verify PM runtime resume errors in IRQ handler
Date: Wed, 15 Nov 2023 14:14:51 -0500
Message-ID: <20231115191622.098785429@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9f8948db9849d202dee3570507d3a0642f92d632 ]

The interrupt handler invokes pm_runtime_get_sync() without checking the
returned error code.

Add a proper verification and switch to pm_runtime_resume_and_get(), to
avoid the need to call pm_runtime_put_noidle() for decrementing the PM
usage counter before returning from the error condition.

Fixes: f517ba4924ad ("ASoC: cs35l41: Add support for hibernate memory retention mode")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20230907171010.1447274-6-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l41.c b/sound/soc/codecs/cs35l41.c
index c9f033d2782d2..abbe82071c1a4 100644
--- a/sound/soc/codecs/cs35l41.c
+++ b/sound/soc/codecs/cs35l41.c
@@ -386,10 +386,18 @@ static irqreturn_t cs35l41_irq(int irq, void *data)
 	struct cs35l41_private *cs35l41 = data;
 	unsigned int status[4] = { 0, 0, 0, 0 };
 	unsigned int masks[4] = { 0, 0, 0, 0 };
-	int ret = IRQ_NONE;
 	unsigned int i;
+	int ret;
 
-	pm_runtime_get_sync(cs35l41->dev);
+	ret = pm_runtime_resume_and_get(cs35l41->dev);
+	if (ret < 0) {
+		dev_err(cs35l41->dev,
+			"pm_runtime_resume_and_get failed in %s: %d\n",
+			__func__, ret);
+		return IRQ_NONE;
+	}
+
+	ret = IRQ_NONE;
 
 	for (i = 0; i < ARRAY_SIZE(status); i++) {
 		regmap_read(cs35l41->regmap,
-- 
2.42.0



