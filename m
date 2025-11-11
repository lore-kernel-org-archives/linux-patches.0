Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A621DF258;
	Tue, 11 Nov 2025 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822374; cv=none; b=efoq7o6Yjoqcfzx2MwLTvCHoQmLqlJavZMcOtt3h1SOKoIpbUzmDjqQNXPZitEW3D+XPkhFhJtMdrs0YvdpRtNERBscGjpB5C1r4xltlcbKJS6RgAgf8lw2BNeDtrk/q1EMnc9jPteFgRupPAaiH7CLzgnVPYsADaCqUtfuIWwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822374; c=relaxed/simple;
	bh=+4pNrCigWj+T9qEfeqDydw5oPrCSZC/oyeIHrX6XYBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOnHqFiVw3fb/hG1PltLBk9PBROp7K7KCH1UxnSqDpWh6dWfiaqPbQ4tHd0xfvlec6jsxb0AwvK+a86ZFk900Yd8M0Ua0wXS1fXDOfzt91RBvAAFb/lQjanq2BmAHHOXkes2p2J8dISqCo+Gw5EZqY2O7Lh1dgaYefduCjJIXDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR1Yc5Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR1Yc5Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6104C4AF0B;
	Tue, 11 Nov 2025 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822374;
	bh=+4pNrCigWj+T9qEfeqDydw5oPrCSZC/oyeIHrX6XYBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JR1Yc5IyEvv+pCxd0JehqLZHNO7XHAWaYPjvdFocTi9zZhEXM7i+kSTKFEDZarGN5
	 jFbND6xEfJ5/SyNujb5LGYVvzeh4vbjjWEuYLr282JEd6c4+m11jwcnd6wVw+M7HJF
	 +3h6GVj3iafXZ7F6iSZI2hWPj3bGtpG/AuCJaPyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/565] ASoC: Intel: avs: Disable periods-elapsed work when closing PCM
Date: Tue, 11 Nov 2025 09:38:13 +0900
Message-ID: <20251111004527.726111747@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 845f716dc5f354c719f6fda35048b6c2eca99331 ]

avs_dai_fe_shutdown() handles the shutdown procedure for HOST HDAudio
stream while period-elapsed work services its IRQs. As the former
frees the DAI's private context, these two operations shall be
synchronized to avoid slab-use-after-free or worse errors.

Fixes: 0dbb186c3510 ("ASoC: Intel: avs: Update stream status in a separate thread")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251023092348.3119313-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 3041717632ed0..dee871910d211 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -551,6 +551,7 @@ static void avs_dai_fe_shutdown(struct snd_pcm_substream *substream, struct snd_
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
 
+	disable_work_sync(&data->period_elapsed_work);
 	snd_hdac_ext_stream_release(data->host_stream, HDAC_EXT_STREAM_TYPE_HOST);
 	avs_dai_shutdown(substream, dai);
 }
-- 
2.51.0



