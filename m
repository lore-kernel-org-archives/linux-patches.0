Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2C15218A;
	Tue,  2 Jul 2024 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940214; cv=none; b=Egw3ZQEkR80w9Gg4tb1Q7NTDGA49Emp/9pFcbMVGS67IQux4RDYob763tWzg3rT1hEhT/eqQZ0mqmMBS57WaBxcaT5gDTilBqe9LBPG5dRfTDKFCPssSy6VzUZCKC7pX0go2c2zChSrrf3YrnlWCCsYRpOET9dbZS54nmqlFx7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940214; c=relaxed/simple;
	bh=nSMVTIgd9Thr7k3FVRFHkr0ikPJxKLD7IHnspcwI6gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu2mHx+/rOsNBrRRNvzS89YhdfSdMqRswJNEdvKZ16JHKsK/hwzSlrLN9y28ZerCkoMj26TNuO2+jWLcrw4bTaPdd4dWiZw9RxkFdkQqPK4vPg+GSHheRFUfHT3zhMGfaFSBrpTA4UdJ8FbMIYHCzJUAPoE5ZBv5hCUGQ6RH+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBQ7EPF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBQ7EPF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF20FC116B1;
	Tue,  2 Jul 2024 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940214;
	bh=nSMVTIgd9Thr7k3FVRFHkr0ikPJxKLD7IHnspcwI6gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBQ7EPF/CmPMp69X7RnISj3sxzQiJlnz8Bc4r08tqpM8TJJXWvMNbOds1x1W8gaGK
	 IAJFqfw1Ap7xUmePh8VPPKKRwaa797YZ8jc4OsjFUaNexgXSppVlDRJ1xRQsS7fc+W
	 PlwPwkTXz89My9sB7CMElghYYwvi4l2Dx6NiE348=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 045/222] ASoC: mediatek: mt8195: Add platform entry for ETDM1_OUT_BE dai link
Date: Tue,  2 Jul 2024 19:01:23 +0200
Message-ID: <20240702170245.698460082@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 282a4482e198e03781c152c88aac8aa382ef9a55 ]

Commit e70b8dd26711 ("ASoC: mediatek: mt8195: Remove afe-dai component
and rework codec link") removed the codec entry for the ETDM1_OUT_BE
dai link entirely instead of replacing it with COMP_EMPTY(). This worked
by accident as the remaining COMP_EMPTY() platform entry became the codec
entry, and the platform entry became completely empty, effectively the
same as COMP_DUMMY() since snd_soc_fill_dummy_dai() doesn't do anything
for platform entries.

This causes a KASAN out-of-bounds warning in mtk_soundcard_common_probe()
in sound/soc/mediatek/common/mtk-soundcard-driver.c:

	for_each_card_prelinks(card, i, dai_link) {
		if (adsp_node && !strncmp(dai_link->name, "AFE_SOF", strlen("AFE_SOF")))
			dai_link->platforms->of_node = adsp_node;
		else if (!dai_link->platforms->name && !dai_link->platforms->of_node)
			dai_link->platforms->of_node = platform_node;
	}

where the code expects the platforms array to have space for at least one entry.

Add an COMP_EMPTY() entry so that dai_link->platforms has space.

Fixes: e70b8dd26711 ("ASoC: mediatek: mt8195: Remove afe-dai component and rework codec link")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20240624061257.3115467-1-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-mt6359.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359.c b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
index 53fd8a897b9d2..c25a526c90d25 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -939,6 +939,7 @@ SND_SOC_DAILINK_DEFS(ETDM2_IN_BE,
 
 SND_SOC_DAILINK_DEFS(ETDM1_OUT_BE,
 		     DAILINK_COMP_ARRAY(COMP_CPU("ETDM1_OUT")),
+		     DAILINK_COMP_ARRAY(COMP_EMPTY()),
 		     DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
 SND_SOC_DAILINK_DEFS(ETDM2_OUT_BE,
-- 
2.43.0



