Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEB6210E4
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKVbagOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101EEC433C7;
	Wed,  4 Oct 2023 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444346;
	bh=GE9NsKgEIY8bmWkn0EfsVEl25R83Zj7DdtIxTClD3jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKVbagOuMXyVx7+VKy3cLZq8JP7IUd4Z7YLbeIHoV9PScMegIssP9JP57VouG6aqw
	 MYMDXIBUAL9QewOQ4Va7y1mraqOkytx7FlcBgYnxVLU+VAo9Pjyb+/gOtNqptAR5j+
	 OCc5I9liBhbSmhYx8yqA4CsT717BUt82Y072a2YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 210/321] ASoC: rt5640: Only cancel jack-detect work on suspend if active
Date: Wed,  4 Oct 2023 19:55:55 +0200
Message-ID: <20231004175238.980513162@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8fc7cc507d61fc655172836c74fb7fcc8b7a978b ]

If jack-detection is not used; or has already been disabled then
there is no need to call rt5640_cancel_work().

Move the rt5640_cancel_work() inside the "if (rt5640->jack) {}" block,
grouping it together with the disabling of the IRQ which queues the work
in the first place.

This also makes suspend() symetrical with resume() which re-queues the work
in an "if (rt5640->jack) {}" block.

Cc: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230912113245.320159-7-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index a39d556ad1a10..0a05554da3739 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2802,9 +2802,9 @@ static int rt5640_suspend(struct snd_soc_component *component)
 	if (rt5640->jack) {
 		/* disable jack interrupts during system suspend */
 		disable_irq(rt5640->irq);
+		rt5640_cancel_work(rt5640);
 	}
 
-	rt5640_cancel_work(rt5640);
 	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_OFF);
 	rt5640_reset(component);
 	regcache_cache_only(rt5640->regmap, true);
-- 
2.40.1



