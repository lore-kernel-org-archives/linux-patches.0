Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80BDD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FD8C433EF;
	Mon, 12 Jun 2023 10:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567058;
	bh=FziwGmdtAE1CFjguqzvd7nHuHzA04oK5v5d2YF1oH1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXxJQiOG5omusnhkoTSjjGKIA92L5JxuT6zO2blkqlAL4ajO8obrTQ8dZc89O8eE6
	 Q2dxETUGswYIxDHz5BhKgcYngQlypRooaBg2AfWllZfFsk6AsZdqrcshs9gVpg8fMY
	 V/Kzq/4l0gtm/vc+jI9IbEheoTF5cEAclZfg8U7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 134/160] ASoC: simple-card-utils: fix PCM constraint error check
Date: Mon, 12 Jun 2023 12:27:46 +0200
Message-ID: <20230612101721.192901205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 635071f5fee31550e921644b2becc42b3ff1036c ]

The code in asoc_simple_startup was treating any non-zero return from
snd_pcm_hw_constraint_minmax as an error, when this can return 1 in some
normal cases and only negative values indicate an error.

When this happened, it caused asoc_simple_startup to disable the clocks
it just enabled and return 1, which was not treated as an error by the
calling code which only checks for negative return values. Then when the
PCM is eventually shut down, it causes the clock framework to complain
about disabling clocks that were not enabled.

Fix the check for snd_pcm_hw_constraint_minmax return value to only
treat negative values as an error.

Fixes: 5ca2ab459817 ("ASoC: simple-card-utils: Add new system-clock-fixed flag")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20230602011936.231931-1-robert.hancock@calian.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 56552a616f21f..1f24344846ae9 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -314,7 +314,7 @@ int asoc_simple_startup(struct snd_pcm_substream *substream)
 		}
 		ret = snd_pcm_hw_constraint_minmax(substream->runtime, SNDRV_PCM_HW_PARAM_RATE,
 			fixed_rate, fixed_rate);
-		if (ret)
+		if (ret < 0)
 			goto codec_err;
 	}
 
-- 
2.39.2



