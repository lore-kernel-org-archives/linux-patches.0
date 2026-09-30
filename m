Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042A3B8939;
	Wed, 30 Sep 2026 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794811; cv=none; b=tBJOYSZgwUIblH8CrznsIlwWBL69Cvz6ZyFiC82xjUdeEAkzk3uxClaz4fC1DgtdVsB63wIBZbS8g/8+40FANxzEiOlzaQaC9xZY3ji35iS7r9pG35yeJf5UvAW75BoovSebZKsoRoMAm09Nk3dHhc7/IkT4Z8Mr5T+/Yu20TyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794811; c=relaxed/simple;
	bh=oVBWyM8+EJsQPhCkuUa5iDBtVnasRYwDQRvPGLMlQq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvbNIhnQwZ58zX9DCABSGHkQ21PT9JgFKNoYSas1tzsLiEKtUpIylIupoBd0ck4rzULKZSLOiR0VM4l1+dbtSAobgCCL1TEIWN4Sosf7Dh0l8RUazUYcXiUQT1wFn8Vd+tI1oObIH+fyKnZLoW1+S0gLK65m2TJFWZ2/glXwUjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PURvktGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PURvktGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB9F1F000FF;
	Wed, 30 Sep 2026 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794810;
	bh=0IaUsfoc11lGtPmAbB3zRIAgVNuMCbmH4qx5Sd4J9Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PURvktGoPU3uzMns3GSWD+TtRrH8l+Spv/Jw7NqZhzhG6ybwmhBPYr1Q/QwB3c14F
	 wKq8IEVwH5baX+YAeUtqAJc6ESrnefalGIvbhnW+nLNLvHODebVUkzto9UjSmB/40u
	 Ax23/DmJUOCfbXY8WrYjryTklHgCgwJYcCiAllFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Heitbaum <rudi@heitbaum.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0342/1193] ASoC: rt5645: Perform the initial jack detect at probe
Date: Wed, 30 Sep 2026 17:17:06 +0200
Message-ID: <20260930152441.760423223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rudi Heitbaum <rudi@heitbaum.com>

[ Upstream commit 54b279699279411c77c8afbc73b83c70740a7303 ]

The only initial jack detect is the rt5645_irq(0, rt5645) at the end of
rt5645_set_jack_detect(). A card described with simple-audio-card has no
machine driver to call that, so jack state is only ever sampled from an
edge on hp-detect-gpios.

A headphone already in the socket at boot is therefore never noticed, and
the card is silent with every mixer control set correctly.
rt5645_jack_detect() is what force enables the "LDO2" and "Mic Det Power"
supplies that the "HP amp" widget depends on, and what programs
RT5645_CHARGE_PUMP away from its reset value, so without it "HP amp"
cannot power up. Unplugging and replugging the jack is the only way to
recover.

Do the detect at the end of the component probe when the driver owns a
hp-detect GPIO and the codec's own jack detect is unused, which is the
case that has no other trigger. A machine driver calling
rt5645_set_jack_detect() later just repeats it.

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
Link: https://patch.msgid.link/anNU3tOUR7rOReSB@5e001e58230e
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index b69f6afa0ae40..4b35f6284d8c3 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3479,6 +3479,10 @@ static int rt5645_probe(struct snd_soc_component *component)
 	if (!rt5645->eq_param)
 		return -ENOMEM;
 
+	/* no machine driver to call rt5645_set_jack_detect(), so detect here */
+	if (!rt5645->pdata.jd_mode && rt5645->gpiod_hp_det)
+		rt5645_irq(0, rt5645);
+
 	return 0;
 }
 
-- 
2.53.0



