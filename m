Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403CD1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1F0uAxvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EA3C433C8;
	Wed,  4 Oct 2023 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443829;
	bh=Y3+bGWp6C7eFs5E5dt59qg0uxOCY3dae8BXUPEvF07s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1F0uAxvu6unl28bCZxJSywDLauZOZ07avE4q7FojRTo/aUbs0dYtQyYugwQ+mF2Xw
	 ij5e/kxhJkSuLzqVM7wxQyaRc47cZOBXAaGjc4yqb4AelrK/gPis4J1jJR2OfW2DT8
	 pssMDZqNluZqhqASQLfBxp5ZgE01oaqjeLB2aldM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 035/321] ASoC: rt5640: Enable the IRQ on resume after configuring jack-detect
Date: Wed,  4 Oct 2023 19:53:00 +0200
Message-ID: <20231004175230.789290807@linuxfoundation.org>
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

[ Upstream commit b5e85e535551bf82242aa5896e14a136ed3c156d ]

The jack-detect IRQ should be enabled *after* the jack-detect related
configuration registers have been programmed.

Move the enable_irq() call for this to after the register setup.

Fixes: 5fabcc90e79b ("ASoC: rt5640: Fix Jack work after system suspend")
Cc: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230912113245.320159-5-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index c2c82da36c625..7522a9803d098 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2827,8 +2827,6 @@ static int rt5640_resume(struct snd_soc_component *component)
 	regcache_sync(rt5640->regmap);
 
 	if (rt5640->jack) {
-		enable_irq(rt5640->irq);
-
 		if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER) {
 			snd_soc_component_update_bits(component,
 				RT5640_DUMMY2, 0x1100, 0x1100);
@@ -2855,6 +2853,7 @@ static int rt5640_resume(struct snd_soc_component *component)
 			}
 		}
 
+		enable_irq(rt5640->irq);
 		queue_delayed_work(system_long_wq, &rt5640->jack_work, 0);
 	}
 
-- 
2.40.1



