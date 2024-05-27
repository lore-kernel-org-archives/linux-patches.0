Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49B17727;
	Mon, 27 May 2024 19:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838382; cv=none; b=KI/wJagvVcLZR5q9Ycto1mWLtQTrF3U5g4JIWB0kbIfNF3vFWBhuwXsmkaVQpx+NmywaANa6ScKAIcKnoMaGiBm92r29pC0u/mjORtraz0UboaMk2LAzvSd6Bd+M5ayGsGADGcUZ4LqstZsWirJyxi7FcNl6iR66fkAXsSLAfuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838382; c=relaxed/simple;
	bh=QDwSFyelHK8hZGlNhwWNHQRuS6sN88SqSJdm4vLVDew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMkrEmODJYPwv5rV0LlW1Hn7vWhlUpqDEmckGxYvsJDZwwbRQPo6CsAcIMqa8BxggiOqdw+GkM+zHDygbBbpk5zWjo9ckGxYgXFdePTJlNG2k5LPrcyoogZ+x3yN9lYoUFA5fPODSa8eGVXDos2IeMcauheuV43x04sXorLqqZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/t5dE7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/t5dE7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09094C2BBFC;
	Mon, 27 May 2024 19:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838382;
	bh=QDwSFyelHK8hZGlNhwWNHQRuS6sN88SqSJdm4vLVDew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/t5dE7Isb2jyN4+xuf6oNyXqpR+e/ivDF7TU6a4/hlnNzCPGO5flfns0/eep7iFj
	 ubBqR6NYDkmlSB854CTUgONTZAm4+YaFqmGIDlAB4Z7qWrx8USut0OecSAbqpmDsiz
	 W5pjgSMTCfA0fTOnCUEhavnk8xe9uEcJduV6jtYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 371/493] ASoC: kirkwood: Fix potential NULL dereference
Date: Mon, 27 May 2024 20:56:13 +0200
Message-ID: <20240527185642.406280458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit ea60ab95723f5738e7737b56dda95e6feefa5b50 ]

In kirkwood_dma_hw_params() mv_mbus_dram_info() returns NULL if
CONFIG_PLAT_ORION macro is not defined.
Fix this bug by adding NULL check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bb6a40fc5a83 ("ASoC: kirkwood: Fix reference to PCM buffer address")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://msgid.link/r/20240328173337.21406-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index dd2f806526c10..ef00792e1d49a 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -182,6 +182,9 @@ static int kirkwood_dma_hw_params(struct snd_soc_component *component,
 	const struct mbus_dram_target_info *dram = mv_mbus_dram_info();
 	unsigned long addr = substream->runtime->dma_addr;
 
+	if (!dram)
+		return 0;
+
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		kirkwood_dma_conf_mbus_windows(priv->io,
 			KIRKWOOD_PLAYBACK_WIN, addr, dram);
-- 
2.43.0



