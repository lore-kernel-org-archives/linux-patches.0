Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3458C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7DDC433D2;
	Wed, 28 Dec 2022 15:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242114;
	bh=q4sc++3K2GfvUAKwubTjvcqFLgZ2ewrtLeGPqSmaAzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yvjnua6MfBaRLzXsDUO1XJuT9E/qQ2NFZ+B5Hx829S8xT4jBfu2a94n9nuZoqob2B
	 4ywjksizxZtrNmRPU5+Y/uAPYhIYkAY8x6CaUuvIzp8tlWlagefXghQ6vfZ47wbcd3
	 NIv4RrDBK2Ty4zekav/AwVkJf3bMrhV4wMF/9zMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0362/1073] ASoC: Intel: avs: Lock substream before snd_pcm_stop()
Date: Wed, 28 Dec 2022 15:32:30 +0100
Message-Id: <20221228144337.834349728@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c30c8f9d51ec24b36e2c65a6307a5c8cbc5a0ebc ]

snd_pcm_stop() shall be called with stream lock held to prevent any
races between nonatomic streaming operations.

Fixes: 2f1f570cd730 ("ASoC: Intel: avs: Coredump and recovery flow")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221116115550.1100398-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/ipc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/avs/ipc.c b/sound/soc/intel/avs/ipc.c
index 77da206f7dbb..306f0dc4eaf5 100644
--- a/sound/soc/intel/avs/ipc.c
+++ b/sound/soc/intel/avs/ipc.c
@@ -123,7 +123,10 @@ static void avs_dsp_recovery(struct avs_dev *adev)
 				if (!substream || !substream->runtime)
 					continue;
 
+				/* No need for _irq() as we are in nonatomic context. */
+				snd_pcm_stream_lock(substream);
 				snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+				snd_pcm_stream_unlock(substream);
 			}
 		}
 	}
-- 
2.35.1



