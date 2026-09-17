Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716263C872B;
	Thu, 17 Sep 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665142; cv=none; b=dWg0hIiBK6RN65//9LNzREqaYHjH0WsM4il2YxLM7GSOfF6nkMin+uJvRN9v9DERcH1pgeJPPIdZnoKF8HL9gGDxBGj0bub4YT+99TQxaES4n3TOyB6eGqdxsd9ViCVRZZ3T0w12zQl5nF/NY0/+m4P29veBbEZkJge/gwBQYYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665142; c=relaxed/simple;
	bh=nsFCxoMbPGoANAnwSyHFUAMPxDeqe4AS26AdO18bSz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i29usAPWYahZKSgihevoFjEnZcdGscmBtOUsy0Jbp8WwwtIZdhVIxZ0ly9mxlVWfm7m4jEr0xhwsg7oKzfO37LESzpi/+7KmlxtVrodWjzz07F+GkGPJ/OKQlgA1ADH8Jvmc+WIhyCq8+HpoRCiUk/gUn7Qr2XnVF4B332i8Uv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ali/4lyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ali/4lyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF581F00893;
	Thu, 17 Sep 2026 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665141;
	bh=LBPC953+qfrJnSne5SP3dtJmMHr5YDYSVjkjgA+pm5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ali/4lyBBdP6DnW/JiQ2EgZsFC2t+aciLbE3tOQD0KH5qec1zqb5Uf3mdl67PsuhN
	 6RdUEyvBYZL0hNmrWkgKOqYtgMjs5oHCfC5QHRxKH7faeZR7Ror2dX0ahVA3PhBDwE
	 M1Vqw35frVbrbvStvCF++iwVCwX06JbrV6koXphY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Heitbaum <rudi@heitbaum.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0563/1250] ASoC: rt5645: Perform the initial jack detect at probe
Date: Thu, 17 Sep 2026 16:05:58 +0100
Message-ID: <20260917151607.185129754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 29a403526cd9e..428cc6850dc5e 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3497,6 +3497,10 @@ static int rt5645_probe(struct snd_soc_component *component)
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



