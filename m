Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7908E2FC88B;
	Fri, 21 Nov 2025 13:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733218; cv=none; b=I5R6LR7i5Hve6lwQ5BolQLjIa8YFwazFzVpsZKaOFSpdz5A0Dqa+//8qhW9UsIRT9GZTe9E0H6n8vN9UE8BBelm5IQDJ/TlSoHsVIv32i2DixA8+gTLS0sMObJtjA+iDJJE6KnHB5/M/2WNXdgJNrcJm4jtFabfKWqMqqWgdaQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733218; c=relaxed/simple;
	bh=dukgTRRj81PcQxLp1euul06hDPDrD2eLz0TPl5rDnbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpniCF+zWSB6OC9lC5WVjXxvYp7qJaqSOLAfmhDJ04g35G9ubNbvs7ftzV4nKHNApU58lJZm4mSrd7s3k+i1ZI8IPtIO9uRR8gssfQBU+h5bwR6jh1CJgCiXdl8eNtE2hQu1TFpVYuexSzYxey2CseFAzXG8AKfOQoYOIIAyO78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7o233gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7o233gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F255EC4CEF1;
	Fri, 21 Nov 2025 13:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733218;
	bh=dukgTRRj81PcQxLp1euul06hDPDrD2eLz0TPl5rDnbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7o233gVTgsheE7o8TOyjMX7bf0AQa8tchqJxMb8IRnO264lHFw5OGqAK2nCUH25p
	 5bxXoTnU+zP3ikYqpsBosjmGJN6GU6PDb/0joy23B37DN92iyRjNowTrkSles6ZR1d
	 flr2yBA9vqChIWXwjHcUoqPW+HHmSbGfvi1q0PjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharique Mohammad <sharq0406@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 393/529] ASoC: max98090/91: fixed max98091 ALSA widget powering up/down
Date: Fri, 21 Nov 2025 14:11:32 +0100
Message-ID: <20251121130245.005958907@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



