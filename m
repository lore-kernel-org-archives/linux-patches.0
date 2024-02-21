Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88527C094;
	Wed, 21 Feb 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523147; cv=none; b=W57xfRuWZYwKBAyNWG1A8ov3ofpmBq6fRUpDN0IQCJTyfVhgnmb1z1+KGhpvVUGgd0XZLWoEWB8iWdBPChMma5q5V+IRtpnKdp6LVPg9y3X6f42KO8bEqZG4+zD/xVFohtAu0wd0Lfwis5NsFE6+FCJ6YFS2HEU9L+q+xH+wPHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523147; c=relaxed/simple;
	bh=/dwEl0q3LRCPCu2zDV0etoGFJbX9aYCco8jauCgd9ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTG0235I1W7Lr3XAzslwicUPNSGSlTkwXZSN1j8+Yifxh9TrtqyAvHn2rHAmy7Ssgbo1kzAq+aa8C/bn1+6YOE6DBaOOL1Kg4sjzvwrhDCdEuw+yU2ulQVIsbBpkvkib/cAoPNPZ35OB45Sc3xITVl5gKtLSg5/kyKg38bXFMak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXrry3vB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXrry3vB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2034C433F1;
	Wed, 21 Feb 2024 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523147;
	bh=/dwEl0q3LRCPCu2zDV0etoGFJbX9aYCco8jauCgd9ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXrry3vBWfpFS2PW/o4RgeVApWtU/NGFxV9DYqx5CYBdIrLFiGTFJ859kbfmk3PM0
	 Eu1agL0xCL/yJMajq6rMVpZ5yJqY8+DArvxpKQqGTa1+p20m6kP6S/9hoJKSm+atqC
	 +FfAjbSjCVAmq3BLEft2fFGI597RT0FF/3We8dD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 352/476] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Wed, 21 Feb 2024 14:06:43 +0100
Message-ID: <20240221130021.006285821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 6ef5d5b92f7117b324efaac72b3db27ae8bb3082 ]

There is a path in rt5645_jack_detect_work(), where rt5645->jd_mutex
is left locked forever. That may lead to deadlock
when rt5645_jack_detect_work() is called for the second time.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cdba4301adda ("ASoC: rt5650: add mutex to avoid the jack detection failure")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/1707645514-21196-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 2fdfec505192..f903bee194d5 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3288,6 +3288,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_HEADPHONE);
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
+		mutex_unlock(&rt5645->jd_mutex);
 		return;
 	case 4:
 		val = snd_soc_component_read(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
-- 
2.43.0



