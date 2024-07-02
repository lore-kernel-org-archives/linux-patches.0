Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EB71BD51B;
	Tue,  2 Jul 2024 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940089; cv=none; b=SdZDZ3nrRm17g3UvTvHbkhMcbyBQEtBrb4rqLvIs5zulKTHBZ7Ki0qNSDitq8znZbas5GnLWW51jPJqYOecTbxv/WB8hlkMn2hBAJzB+HBuLKEPKoA37e7e3ClSc8on5BHlkBEPbOyuhDRsQAMBkA4dBLjs93wXuPMeaGZQ43Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940089; c=relaxed/simple;
	bh=jiDH+y/ieDXCRx4K5vkx6ODtJvpSfwdFkeIvi5FtqAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvQW1mDtk0obwEeOrGHdzsHATyM+Yn6au1zVoWs7i/umbsPDi4wHVvhzaIB2jH0154RX9A/F+2xWH1U4RgrUCSRkF1I1GFAadLwU+alu0/+5vIYU3Ra9+ZrgLYcmgRevjC0O3Yi1/fCfYutwikqpHfMP4wqY/LO57iIgcKPxnGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0lXqLb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0lXqLb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3202AC116B1;
	Tue,  2 Jul 2024 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940089;
	bh=jiDH+y/ieDXCRx4K5vkx6ODtJvpSfwdFkeIvi5FtqAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0lXqLb5u+4m8eX2F4DH7yhWyMjmG6IdCOvgXlHy365JjPIPa014kHO+1FkgAlH3F
	 CRl+gpSD6eoqz3eWxBxqPPLfXB6s5hf1Ecd9qU05vrFiHHvSejfuw3+avuDCfS9dgm
	 tCwd8aav6k4HJsAbotE7kpHbCScXhgD6pXpm+DPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 018/222] ASoC: atmel: atmel-classd: Re-add dai_link->platform to fix card init
Date: Tue,  2 Jul 2024 19:00:56 +0200
Message-ID: <20240702170244.671408751@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Simion <andrei.simion@microchip.com>

[ Upstream commit 2ed22161b19b11239aa742804549f63edd7c91e3 ]

The removed dai_link->platform component cause a fail which
is exposed at runtime. (ex: when a sound tool is used)
This patch re-adds the dai_link->platform component to have
a full card registered.

Before this patch:
:~$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: CLASSD [CLASSD], device 0: CLASSD PCM snd-soc-dummy-dai-0 []
    Subdevices: 1/1
    Subdevice #0: subdevice #0

:~$ speaker-test -t sine
speaker-test 1.2.6
Playback device is default
Stream parameters are 48000Hz, S16_LE, 1 channels
Sine wave rate is 440.0000Hz
Playback open error: -22,Invalid argument

After this patch which restores the platform component:
:~$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: CLASSD [CLASSD], device 0: CLASSD PCM snd-soc-dummy-dai-0
						[CLASSD PCM snd-soc-dummy-dai-0]
    Subdevices: 1/1
    Subdevice #0: subdevice #0
-> Resolve the playback error.

Fixes: 2f650f87c03c ("ASoC: atmel: remove unnecessary dai_link->platform")
Signed-off-by: Andrei Simion <andrei.simion@microchip.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://msgid.link/r/20240604101030.237792-1-andrei.simion@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-classd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/atmel/atmel-classd.c b/sound/soc/atmel/atmel-classd.c
index 6aed1ee443b44..ba314b2799190 100644
--- a/sound/soc/atmel/atmel-classd.c
+++ b/sound/soc/atmel/atmel-classd.c
@@ -473,19 +473,22 @@ static int atmel_classd_asoc_card_init(struct device *dev,
 	if (!dai_link)
 		return -ENOMEM;
 
-	comp = devm_kzalloc(dev, sizeof(*comp), GFP_KERNEL);
+	comp = devm_kzalloc(dev, 2 * sizeof(*comp), GFP_KERNEL);
 	if (!comp)
 		return -ENOMEM;
 
-	dai_link->cpus		= comp;
+	dai_link->cpus		= &comp[0];
 	dai_link->codecs	= &snd_soc_dummy_dlc;
+	dai_link->platforms	= &comp[1];
 
 	dai_link->num_cpus	= 1;
 	dai_link->num_codecs	= 1;
+	dai_link->num_platforms = 1;
 
 	dai_link->name			= "CLASSD";
 	dai_link->stream_name		= "CLASSD PCM";
 	dai_link->cpus->dai_name	= dev_name(dev);
+	dai_link->platforms->name	= dev_name(dev);
 
 	card->dai_link	= dai_link;
 	card->num_links	= 1;
-- 
2.43.0



