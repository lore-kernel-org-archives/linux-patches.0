Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A522DEA7E;
	Fri, 21 Nov 2025 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731636; cv=none; b=IR4czSmdVv+KqWPcGPeDQy0/XpYnG2rbqxyIOHQy59LhEeaPkxa14eLoFBDYrealw8BqWpbr1aAs+TyyMayewx+Pzr022D35bXSShMuAV5jO48GI2Y9OCrbayeZ8tK8RdKASYMtzJm7hptfwyyefpAWyueVwsD4eW9Dew1Am7qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731636; c=relaxed/simple;
	bh=PyHAB49KbcVRMr72lAxR3TbRrTFabSc3cD0zlIZ52x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q206W4Fjp7MXSo8OENXQ1XML6zNZQgLFehtwEkziqhKrhPF+MIp+HHNh8pQEwDPSepB5/b+HeOVf0sxQtP6BHDer9fBrKUzkOpSwpIrrAmdGvZLJvGjHRsPNbyUlCfKWhzq39ux5Z2e32YoenKSESWTE2tRBFVHxzJ+ZREMzXsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXPyltJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXPyltJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3185C4CEF1;
	Fri, 21 Nov 2025 13:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731636;
	bh=PyHAB49KbcVRMr72lAxR3TbRrTFabSc3cD0zlIZ52x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXPyltJJg+oqZIZokZKt/ggluQijwuZkt7uywRsb7Vf3OJO8BjtBEGeg9l7ImEHNZ
	 D+HRuRmw4Jwv9Tpc6Ep+g9MTEBj576xTLjCBeHM2BHCq8sEIcafjuUA9IIW0kId2Pa
	 mLQfjxfKnrEPG/bz5qosoE7l7qFdi2g1yynXivEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharique Mohammad <sharq0406@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/185] ASoC: max98090/91: fixed max98091 ALSA widget powering up/down
Date: Fri, 21 Nov 2025 14:10:56 +0100
Message-ID: <20251121130144.926510824@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index 2adf744c65263..4023b88e7bc13 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1234,9 +1234,11 @@ static const struct snd_soc_dapm_widget max98091_dapm_widgets[] = {
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



