Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF90934DB64;
	Fri, 21 Nov 2025 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732264; cv=none; b=iMG72fyY1wdfGrv+gHiKNe1k2WMRdroy/7X5IqAOwx6wZnFZfXlcVP11JkV0yf50w+kDcCvIC9+DhCY/SqICZGKO58xyipIduR95UMHg+y6+LQYAxRoNYOWsDgIroq60kF8wDpTZaB4bPqZATeu7QyuYFKPq5dTJxOZFg1iwMyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732264; c=relaxed/simple;
	bh=G3kMQcvZPN9vPREnI/vagQ6Z2H5hBVL/J3hj+JovrPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJvpil4yHj3KdAOCvR5Al3GDC5Sb1hRctRchm5Y60kz27oYCpe0vAlVTImOhjA2Bj8lyaV5rcmT74l+P7nfB/vY0oUq0b4l0TWHw9CFQEehj+W3Pl4R3rduLbjQztJyvIjhPRQ/KUlGg3OdQkwqIW/z2SiAiS0Z11DiuSffnDBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFC4+sxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFC4+sxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460BEC4CEF1;
	Fri, 21 Nov 2025 13:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732264;
	bh=G3kMQcvZPN9vPREnI/vagQ6Z2H5hBVL/J3hj+JovrPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFC4+sxn7CGUhrmAneRLsJ2xhBtbLAZQhmxoIza2JrRzT23p4wfrxvfkUU25IK4Qb
	 SuCmOwX6H7aROb0tSQhagSM9uR7fq3scL/qfoH6+dtQGCuUyawEaxOgq6hllfghr1W
	 6IXeVqVNJWDXmnSmZWsf96X+xRfPAkFRREwSa7C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/529] ASoC: Intel: avs: Unprepare a stream when XRUN occurs
Date: Fri, 21 Nov 2025 14:05:26 +0100
Message-ID: <20251121130231.965695680@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit cfca1637bc2b6b1e4f191d2f0b25f12402fbbb26 ]

The pcm->prepare() function may be called multiple times in a row by the
userspace, as mentioned in the documentation. The driver shall take that
into account and prevent redundancy. However, the exact same function is
called during XRUNs and in such case, the particular stream shall be
reset and setup anew.

Fixes: 9114700b496c ("ASoC: Intel: avs: Generic PCM FE operations")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251023092348.3119313-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 781019685b941..9251c38cf9d12 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -611,6 +611,8 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
+	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
 
-- 
2.51.0



