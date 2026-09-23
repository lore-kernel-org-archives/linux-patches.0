Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75E3ADBA7;
	Wed, 23 Sep 2026 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174426; cv=none; b=hpYvj7RhrX21Cj+Y/QaV2vr4R2nmYnpZrNuWg1KaJqIwzErR2E3GnltiJZwuyDmOpxts2otg+Chi3W/QVFzUUJtWvq5G2VpW0BmJNmRlJwVdkm0Sbcgp/KZ8xfBkAHuxDuZbgxQ2WkvPSDZlvq/Dlu8Q77cfIrYjPQoayIVV8JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174426; c=relaxed/simple;
	bh=nZLl6GEKEyJNeQaaUYc3AeeEwAmpiGyTTmiPZJY9FOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+27csPIBS+Ux1fRuNwVx/b293lM3DeHfQd3NljjDWHp9rldYUjONyGketDZktGSGZrtdweE1A5N7dYdN9dzxGD6k/4ZGW0SJ+sgL4PZSDVse/vvRM+tWhGe4yY4ss5uI38xXwNRwuZOoMiacT6qUk1lDjvMMVBWI3fJGhIlQWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYjcbtSQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYjcbtSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43161F000FF;
	Wed, 23 Sep 2026 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174425;
	bh=eq4tsPy2v+vRmTsZ18Lgzt4QR80mJ1RRsQi4qpcl9U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYjcbtSQTcn9v5ElD89WC5A//fQCADgRbgfoZ3eLyPMWxbk8yxM9CIJJ4ZUR3Y30N
	 4dlMSxay0Gu+5cyUDbeoHgFQpuFJZx2qJtlNjrKuKMkJMWrTHVnxPZeuhhnLtmQM8W
	 nqBMyjUKp28ebDysulXq3t3LfvHw0CFUnn8/mmaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/398] ASoC: Add codec_ch_mask to snd_soc_dai_link_ch_map
Date: Wed, 23 Sep 2026 16:03:05 +0200
Message-ID: <20260923140646.319510614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 88b14c0d0bab5c0f3e7c641f274e3c70210c0e36 ]

Add a codec_ch_mask member to snd_soc_dai_link_ch_map.

The CPU and codec channel masks are not necessarily the same, and are
quite likely different. SoundWire and I2S/TDM both support assigning
different sample slots to each codec, so for example channel 0 on each
codec could map to different channels at the CPU.

It is also possible for one TX channel to map to multiple RX channels.
So it isn't _always_ safe to assume that the total number of set bits
in the CPU ch_mask is the same as the total number of enabled channels
on the codec.

For example consider this mapping on a capture stream:

CPU0 CODEC0 cpu_ch_mask = 0x03
CPU1 CODEC0 cpu_ch_mask = 0x03

This could be either four TX channels on the codec split across two
receiving CPUs, or two TX channels on the codec duplicated to two CPUs.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260910114500.1586637-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6b382bdfe26a ("ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 99a8edfd1d7d8..bfe8cd7cc338d 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -683,6 +683,7 @@ struct snd_soc_dai_link_ch_map {
 	unsigned int cpu;
 	unsigned int codec;
 	unsigned int cpu_ch_mask;
+	unsigned int codec_ch_mask;
 };
 
 struct snd_soc_dai_link {
-- 
2.53.0



