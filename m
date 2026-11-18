Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031719;
	b=3pEntcvEoP5w8sDI0vDdp9lFMTlYN1uwe0Er1DIs8VcQbhOGWigHcNFplX1XUwlcUqp4
	 pNymCoo79Y8cAZVD75Ttc7XlfW5Jgj9SswRW3zQNPLSimXQsjjfixf3dlVYxQsAidM0dD
	 7zkdbJxNc1GHSZIN5L13foGb2gnIkG3CXEjtdPxahqCyjf5/9Gn3GT508ZTPCTSluCgYH
	 bRsRyZ4CibFdwZ64WoOaLHS61qq/0gQciMQkoFwRJBqYm0bzo5ppXj0URCfhpkAYNsn4H
	 gvoJ7uwLo9d5zQkQ8YG/vwN7iFOZf2zbT6+n1Pgtp8uDE+tTwNY9qPOVFcc99SjZxcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qI4F0CIKRNy89HnHVem9Gixalk/NaTh6sD4mBo4dP0Q=;
	b=HeM0Gf/p6y4EunadCGotDb3E02AUIf1rAam33lMmsNVHq+kXMnlvGLLaGvwM5LTcO4nY
	 gyai1Hv2Gwn5w9OzOGgfyVHcIeeIJaecCz/QvAhBoCCMBM08YZE7g04vB2QkYqk2V87Sl
	 CmVVruayoXaOyDYOI2uaVql+ALbo6WPkIX/zrMakFIeuyxf4B6vfpuimHIk0gnv6MatWw
	 a10sr4JhkbLHmfWguUbqSBg/17EZ5SLRGCBygYdffZJXxUT2+uqv93LweFkGBfzR+SOUX
	 xAqbtCD15ySGzqX6Y/ky1RD8uzsyfr95459+l4X36PL8mQvKlalbHAYwM88aY8ruCaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4ePD5hy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BB9606A31C;
	Wed, 18 Nov 2026 19:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4ePD5hy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AE31F000C4;
	Wed, 18 Nov 2026 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031719;
	bh=qI4F0CIKRNy89HnHVem9Gixalk/NaTh6sD4mBo4dP0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4ePD5hyht2h6rJRI8bTh3XyegfyeH/iTaeXqDkvjJtNPTLfXY7S1h/iZo3+KV7sA
	 9GY4pUWLL9qPwRn0k7Hpu/Vp05joxvS/33p+76w8om5ZRLJHAHPEB7ZEABrhrSXXAq
	 ziUQ9MxZddBoixqbnPIqnK0ScPdjf/HBUct5TuaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1158/1756] ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150056.114315510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 85e56c3bbb7e8ea4626f8653afaef0d79d9cb7ba ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from imx_rpmsg_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 3c00eceb2a53 ("ASoC: imx-pcm-rpmsg: Add platform driver for audio base on rpmsg")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-19-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-pcm-rpmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-pcm-rpmsg.c b/sound/soc/fsl/imx-pcm-rpmsg.c
index 1daf0be3d100b..48c11d66f91b0 100644
--- a/sound/soc/fsl/imx-pcm-rpmsg.c
+++ b/sound/soc/fsl/imx-pcm-rpmsg.c
@@ -278,7 +278,7 @@ static int imx_rpmsg_pcm_open(struct snd_soc_component *component,
 	info->stream_timer[substream->stream].substream = substream;
 	timer_setup(&info->stream_timer[substream->stream].timer,
 		    imx_rpmsg_timer_callback, 0);
-	return ret;
+	return 0;
 }
 
 static int imx_rpmsg_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



