Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C193AE1BD;
	Wed, 30 Sep 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791353; cv=none; b=eju4mSBoFj/ZM/UVmHaNgdy/Xjxrk1Ao7PRmGEkiVeMVb6KeMSVRcU8ZB4vTdbgbO+KOuQJwvXmV4fSEYae8X2qNIo6fYMiIXboNG1wdG+gy1N16x4VW+ybj6WahrBsuZhYv+f8iUNevy5vr7q4vAwLchYHxOU+OGOthxfESusc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791353; c=relaxed/simple;
	bh=gBVpVTPNgLdELRov8S21NCaWwVSZBBYfIVwcM0uLHxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro5IEr+Da6lRZdzySC0o88r8Qe3tAnnEPmPQHzrhn3LEqvZXSYrpAtiD+/drAYI0w+F1/DO+30se74YpR+dlUWTt4X92pzrRRlJy7XKYavJETbMoqrSwWn25kvBXzUnr1DxxORH0cqkgJ9m47ONAb+M4M82Qj1Ynfbua273AQgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wi+cQ8wN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wi+cQ8wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7C51F000FF;
	Wed, 30 Sep 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791352;
	bh=8HK5ho9NUZIKT4s1Z9iqLeLdzWQpnBTWWAr2vj/pPig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wi+cQ8wNm5IP8dMgAFYUGt/trAhysqmagCRml8UdzXOTK5BYcq40+T86SbsPx1Unv
	 yJPF56B/cd8OfVFP70tlQjzsmr1Y60aYE9oEzrNyqikFvT4BmcDpf0j2yM9uZARyWV
	 uW+zPU6VsdQtHHn+RAfjrSzWpLiSUmsZ6sLRXowk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Heitbaum <rudi@heitbaum.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/752] ASoC: rt5645: Perform the initial jack detect at probe
Date: Wed, 30 Sep 2026 17:21:37 +0200
Message-ID: <20260930152403.171236092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a44f5201515b..1862a10c0acbf 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3453,6 +3453,10 @@ static int rt5645_probe(struct snd_soc_component *component)
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



