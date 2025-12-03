Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7BF3570DC;
	Wed,  3 Dec 2025 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779742; cv=none; b=sxXCxwMu9QdSs1OwHtkrH62a1qzSeSq1zDYYTaI08N/lYXwsUG1jukC5iqS+Pg2aa9nka6Yh7gR/C69XPu5Eau/lFEt67DgXdF0OAxOvWkP0k8BVCH1FqPLSfeGxn5KKNqcbI7J542fsnJnifCzv/bB3GGycNaPiuiPA71Wut/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779742; c=relaxed/simple;
	bh=YFxltP81R4SABtb9im/Uyl0x7sfHWJLpg/HRbFh1PNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNXN2WlIJwXGykAcJTQLzKo6AwaLly9IHZMca84HbrccL5aFansHhqhnu56IA++2FZWr/yp0KxZ2WK8izwD/f98k4apd760DAoIiZQAQiVmxAM+vVW0q8FqhPd9m4jLu3EyULgm/6I4OGTEFXS/D1IBeaoL4ESf6dbW3uyWS4B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdxDzP0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdxDzP0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEB6C4CEF5;
	Wed,  3 Dec 2025 16:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779742;
	bh=YFxltP81R4SABtb9im/Uyl0x7sfHWJLpg/HRbFh1PNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdxDzP0w7OPaY/ARxLGc+EioMGu7w8oKPrCTo7mkcGwKPkrEOHQGEE30uJfZc9fm/
	 5rEOqmHBCFp2dB1/lfiZnGIlJSThStMzF6O6v/PvDTL/TTVC5YHyocTutmv5oUyJaz
	 /ArdaIJNX5JrWz79Ufhgx0wZatfiwk1elGyiu9h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharique Mohammad <sharq0406@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 346/568] ASoC: max98090/91: fixed max98091 ALSA widget powering up/down
Date: Wed,  3 Dec 2025 16:25:48 +0100
Message-ID: <20251203152453.376699872@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sharique Mohammad <sharq0406@gmail.com>

[ Upstream commit 7a37291ed40a33a5f6c3d370fdde5ee0d8f7d0e4 ]

The widgets DMIC3_ENA and DMIC4_ENA must be defined in the DAPM
suppy widget, just like DMICL_ENA and DMICR_ENA. Whenever they
are turned on or off, the required startup or shutdown sequences
must be taken care by the max98090_shdn_event.

Signed-off-by: Sharique Mohammad <sharq0406@gmail.com>
Link: https://patch.msgid.link/20251015134215.750001-1-sharq0406@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 06ed2a938108e..f5acf84ee20cc 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1235,9 +1235,11 @@ static const struct snd_soc_dapm_widget max98091_dapm_widgets[] = {
 	SND_SOC_DAPM_INPUT("DMIC4"),
 
 	SND_SOC_DAPM_SUPPLY("DMIC3_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
-		 M98090_DIGMIC3_SHIFT, 0, NULL, 0),
+		 M98090_DIGMIC3_SHIFT, 0, max98090_shdn_event,
+			SND_SOC_DAPM_POST_PMU),
 	SND_SOC_DAPM_SUPPLY("DMIC4_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
-		 M98090_DIGMIC4_SHIFT, 0, NULL, 0),
+		 M98090_DIGMIC4_SHIFT, 0, max98090_shdn_event,
+			 SND_SOC_DAPM_POST_PMU),
 };
 
 static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
-- 
2.51.0



