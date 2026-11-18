Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026493;
	b=ukeKftyEijInuMBkkdMqS0vX+P0kFQcaqOgPEedf5C3DEnMP6PMh24/I776VzF2jOilf
	 3lgfblWrcmYa4xk9ANJD+inJXNGOYDUeLkyuZEqdpw97JymZgl8qdF+4/9uQ5YoREZdYN
	 G8+fGE83z3J6KWjlHjdeUu3cIam86KRvHbIfjiF0SMAj1QfMYfTdx9BjRelRTjcEvHdiq
	 YQE7TegOYzISAX2WXYaEgGwUF/93ogXK2pBL37ZNAOPsAjMnUFcA1SKmOfxD1ZexHfgIw
	 IEksUGrYKIuKVX4PBieOPY9VSlm4Ib0jr7CYOKobZQ3kYcdEYz4YtPcNhT5p/0mq1KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MvrojGMp9Y4DOZaULETRMoU4MVPbPyM2q6OjatChwIk=;
	b=4XotWH3haOe1XWsjGKz4dmNeMbfkQMqB8grzkMsrCuA/KqZGa2jhHZVQO4WNQNnFt4Pe
	 r00r88T8ekiu8mi5elYyafM82qYP7CMkOxW6ZkSQghG8lP3SJ33u7++LtpmRBaPWz1q5d
	 RWXyDlfA9fdsFhp+1nGvcNvOY0qbKLnrYSICIChevj23XE4ETod6ZNl61gp6bfGI+YA56
	 dayL04SrbPByivHtGekWMnoo6kFpvngI4zn0zmUb/WXm4JmpwPGZyS8bZj3hSYReLLpS9
	 3WqBv7CfNnQdas/zFWqGY2X0hBR7/0HiLyhV/AlCaWiT4lwPCs828cP5/J3pB6v9oBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKj2PX6L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35DD606A320;
	Wed, 18 Nov 2026 18:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKj2PX6L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E1D1F000C4;
	Wed, 18 Nov 2026 18:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026493;
	bh=MvrojGMp9Y4DOZaULETRMoU4MVPbPyM2q6OjatChwIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKj2PX6L2u+ffofyKbxJiyfIzs1M5/KbuqEo3yr+8jI0jVk8KP6pmCcwDQEg+5USh
	 CRWcXFDorFUJ7uRYd3sCAGnxYQ/F58rO7k+kufll2hncuk5TvWT4JmtWlKEefei1fd
	 lUPorFKvTL6+zoHDOsviQcdWsBYS3kQEnhzWwGc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1454/2151] ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150214.882150069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index edab68ae83665..b269607d2fac1 100644
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



