Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF3250B409;
	Thu, 17 Sep 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668721; cv=none; b=L0epeUsE6MeGdOWKca12DXm/B2VhdBT2i+TozGq4iDObNYcX9PWhmILNTo0alRZwWOc/3/ca0luzRzixwjuyJpy/7z7qT/lBOmyTn1KOpW2crbH74Esy2sbQDMza12MCNmtkLJd7IOph/Awbjh6OWNqX1No9i0ifxe1GXwmummg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668721; c=relaxed/simple;
	bh=MG6xXiafnhvkAS5CTa7b39/N2QcwOCU0589PCiSiReg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAh3V/n64w1UuwQb2v1EdRejh468SyUnsbbTeNCDo2GklA33Rp2ScTpyQ4fyxlXnWJcx6in4WGXknpZK/rHfc5qKx3s68U631Oe9tLk5TFZT7szcBpSlrwT2+UBqGW+dm4hSF0T4sSndTlMtCjnfT47hUOipj9/Ij4cN2fBqh6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agf1rhpk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agf1rhpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AFB1F000FF;
	Thu, 17 Sep 2026 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668720;
	bh=RDlbqE/amYAA5Aq0NcMQd5NvuIs85x8vW4JkjrjotHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agf1rhpklsDCxjUcaLcg35iDgaL0EzUW/6PjKvpufYHj96V1W0PBTVlIepibI/QYe
	 thvsn37otmZxUJJxd9xq05KmAyKNq2jyBTyxMVy8DL38k7MHn9NPEJ/ZaG41qif7WG
	 /3vV5yQ0/kzZesr9eWeqLFA5m6KwDrlaMosfPkoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Heitbaum <rudi@heitbaum.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0460/1102] ASoC: rt5645: Perform the initial jack detect at probe
Date: Thu, 17 Sep 2026 16:06:43 +0100
Message-ID: <20260917151551.236726060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 51187b1e0ed2f..a7ac9971ae244 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3495,6 +3495,10 @@ static int rt5645_probe(struct snd_soc_component *component)
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



