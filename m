Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1085429CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEF6C34605
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:27:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="EI8TH/jX"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 14 Dec 2021 14:27:26 +0000
Resent-Message-ID: <Ybipzlkxp6w7u8jh@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 06 Dec 2021 22:46:25 +0000
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=2T2R=QX=protonmail.com=povik@kernel.org>)
	id 1muMkY-00AqNU-Mo
	for broonie@sirena.co.uk; Mon, 06 Dec 2021 22:46:25 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 445E3B812A4
	for <broonie@sirena.co.uk>; Mon,  6 Dec 2021 22:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 2FE03C341C9; Mon,  6 Dec 2021 22:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA13DC341C8
	for <broonie@kernel.org>; Mon,  6 Dec 2021 22:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org BA13DC341C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Date: Mon, 06 Dec 2021 22:45:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail2; t=1638830763;
	bh=U6hgS33W3oN42eOQSJvsbmwBlVTgQA45KKfzehh+/LA=;
	h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc;
	b=EI8TH/jXv+u+TR9msZzizapZiSxSbFlZB3hex2So0uidboeLv5n9V6FYGH1HAJdFo
	 gLHjUKQg3mIWyHh3zkLyRm4+gdQkZ2dOUAl1WfL+rB2bmUEde5p8WR6N8VDrfxGEQX
	 C+icUJkVtFbnVf7T6dmot2l32jSZkuFj20us+K0vYCX9ao42P4gdE+a/Cs1Zdf8Ryz
	 zdph6aQ0+X8NQaYJOYrj3isVuLYaMlW4sVlLh75K4g4gO9JQEIhE6ioUCdpe6tJcPL
	 /NqIj7vLyJhjF2U7KOUV1SCTtBriTd5L/XkkKe931m2tK55idJFlgo9GcccYmSsV0V
	 yajU+moGNKjGQ==
To: lgirdwood@gmail.com, broonie@kernel.org
From: =?utf-8?Q?Martin_Povi=C5=A1er?= <povik@protonmail.com>
Cc: alsa-devel@alsa-project.org, dmurphy@ti.com, trivial@kernel.org, =?utf-8?Q?Martin_Povi=C5=A1er?= <povik@protonmail.com>
Reply-To: =?utf-8?Q?Martin_Povi=C5=A1er?= <povik@protonmail.com>
Message-ID: <20211206224529.74656-1-povik@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=2T2R=QX=protonmail.com=povik@kernel.org
Subject: [PATCH] ASoC: tas2770: Fix setting of high sample rates
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: byASKLqCtgiH

Although the codec advertises support for 176.4 and 192 ksps, without
this fix setting those sample rates fails with EINVAL at hw_params time.

Signed-off-by: Martin Povi=C5=A1er <povik@protonmail.com>
---

The bug has been found and the fix tested on an Apple Mac mini (M1, 2020)
which technically does not contain TAS2770 but a TAS5770L part which
appears functionally equivalent.

 sound/soc/codecs/tas2770.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 172e79cbe0da..6549e7fef3e3 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -291,11 +291,11 @@ static int tas2770_set_samplerate(struct tas2770_priv=
 *tas2770, int samplerate)
 =09=09ramp_rate_val =3D TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 =09=09=09=09TAS2770_TDM_CFG_REG0_31_88_2_96KHZ;
 =09=09break;
-=09case 19200:
+=09case 192000:
 =09=09ramp_rate_val =3D TAS2770_TDM_CFG_REG0_SMP_48KHZ |
 =09=09=09=09TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 =09=09break;
-=09case 17640:
+=09case 176400:
 =09=09ramp_rate_val =3D TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 =09=09=09=09TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 =09=09break;
--
2.30.1 (Apple Git-130)


