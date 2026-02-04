Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF641C30D;
	Wed,  4 Feb 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218401; cv=none; b=Tr2nQjcvj3y5FNC7nFvn3UjnB3LGj38JA6khI/BL0zHbRmnyR1+GJM8FwSvVBB1ofSWjm5ZLPUdr98KzRvKkoz0Okz+NJvG2cDNs24+a7EnOxR+MtCLad5OgfOv8kamx13DP+MMZONjYq+TA7rMCLyy2nbagfuvHHRDuixC+U+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218401; c=relaxed/simple;
	bh=oafzXe452xsT2EFFjtmKgCCIy6A9fY1Rhk0zYNAqcpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/FJgEqPoEYZI0OfgnuvKjdbsCbxU+KZ/Lv2QaWi3ladHxjoJP4YpwNc/tQKE5EWrnss+RZNFIAaD2BNzYkbxrO0gmvv5VgXs4vyanGi9GZODUtljw0bwQSwhHK9BCK8R8Uu6Yk3YDQqHfdLiLPwSFW+E/oWtHDucoRfx2hrUJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SzZTQ9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SzZTQ9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317B6C4CEF7;
	Wed,  4 Feb 2026 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218400;
	bh=oafzXe452xsT2EFFjtmKgCCIy6A9fY1Rhk0zYNAqcpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SzZTQ9Y4PCWly15g28jnhafA79qGfmld7NRbT+Dbjo74euX2RzhhJS9HaXxeOkq/
	 kqqA/J+zz8Kc4OHMLiPNvGaXogcJcIqheLEgV7pF5Vzj3hTDGpaBzZkSzvH5yDkZsl
	 wxzN4yi4ciLPK3bo3m7D/cWoqLG6KQvIsnwjXU/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tagir Garaev <tgaraev653@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 20/72] ASoC: Intel: sof_es8336: fix headphone GPIO logic inversion
Date: Wed,  4 Feb 2026 15:40:23 +0100
Message-ID: <20260204143846.355388010@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

From: Tagir Garaev <tgaraev653@gmail.com>

[ Upstream commit 213c4e51267fd825cd21a08a055450cac7e0b7fb ]

The headphone GPIO should be set to the inverse of speaker_en.
When speakers are enabled, headphones should be disabled and vice versa.

Currently both GPIOs are set to the same value (speaker_en), causing
audio to play through both speakers and headphones simultaneously
when headphones are plugged in.

Tested on Huawei Matebook (BOD-WXX9) with ES8336 codec.

Fixes: 6e1ff1459e00 ("ASoC: Intel: sof_es8336: support a separate gpio to control headphone")
Signed-off-by: Tagir Garaev <tgaraev653@gmail.com>
Link: https://patch.msgid.link/20260121152435.101698-1-tgaraev653@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 9904a9e33cccb..c9d9381c76796 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -120,7 +120,7 @@ static void pcm_pop_work_events(struct work_struct *work)
 	gpiod_set_value_cansleep(priv->gpio_speakers, priv->speaker_en);
 
 	if (quirk & SOF_ES8336_HEADPHONE_GPIO)
-		gpiod_set_value_cansleep(priv->gpio_headphone, priv->speaker_en);
+		gpiod_set_value_cansleep(priv->gpio_headphone, !priv->speaker_en);
 
 }
 
-- 
2.51.0



