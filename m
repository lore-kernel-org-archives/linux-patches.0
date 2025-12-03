Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584D83074B3;
	Wed,  3 Dec 2025 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778081; cv=none; b=J40qHh3v4qwSTZWX8p7wChUu7TBOJqDbXYsBKJDnOxfQUIVlBtn6viYM+oaLx/W+miDLf9J+hdMbMjn/CIaAkj8CyVe2POSOk+Tal0qVgk9mQv7M5je/PqdlU+fO2cfted9d5Mg9fVHS9JHG1EtZbk5jY9t1T1PyCND39L7xOQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778081; c=relaxed/simple;
	bh=B20TrMiavSEz3ksT4zDC4l2ubPKoZhKtdwEOK9I2e3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGs6kKs+Qi5nSwtowKpQvFKtSpZ00cJpUcp2OmtY16yFkA1bOEtJfkQZCJO//uz+Eh3rAotEijsjLTAMSjoo1RDtJVZAAv1Sz1vTzCQEdrAhekbx/J2p9i5bz4zhMRLLPdwyUXp1lhRJ81Qm+E451Sy3IQNO00trk9S8S0ww4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFZ7sv7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFZ7sv7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BB7C4CEF5;
	Wed,  3 Dec 2025 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778081;
	bh=B20TrMiavSEz3ksT4zDC4l2ubPKoZhKtdwEOK9I2e3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFZ7sv7/PWCseGosp067Z+bifRt51c2NRgmufsndyQomiJZtRFyMflxsORCpMVPVd
	 MtlgRJqZEExJ7I17qMJ7HB2RfGsmxvUK+0Rlu70j+0516q6qNED1fTitKGzRKMhohP
	 gblE9x0VrJceMAh4JfBRYJU0/axbSyD5kFGjWjo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharique Mohammad <sharq0406@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/392] ASoC: max98090/91: fixed max98091 ALSA widget powering up/down
Date: Wed,  3 Dec 2025 16:26:26 +0100
Message-ID: <20251203152422.863083141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index 5513acd360b8f..3cf41870978da 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1233,9 +1233,11 @@ static const struct snd_soc_dapm_widget max98091_dapm_widgets[] = {
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



