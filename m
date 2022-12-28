Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23671863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A84C433D2;
	Wed, 28 Dec 2022 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242485;
	bh=q4sc++3K2GfvUAKwubTjvcqFLgZ2ewrtLeGPqSmaAzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzJzgudxDlJK9lhXIxsCHDVSpIjWye5TJOkP9dQyCnCWK7sn6gmZm6lkWW4nZiHSF
	 dJshOhiw5/47vm8Efp4DEZsQ5qZbCijDIuInCwKPtxoEMTA/7czASU0mgzUrgbOmbw
	 u/YOBke+IQkgOwvV8IVAdbumiSMaR4BkkfDH/5Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0375/1146] ASoC: Intel: avs: Lock substream before snd_pcm_stop()
Date: Wed, 28 Dec 2022 15:31:54 +0100
Message-Id: <20221228144340.349340657@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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



