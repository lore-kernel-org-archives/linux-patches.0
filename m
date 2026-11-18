Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041472;
	b=EX9EVp9zM+Q/MZiUeL9ypsA5hemWE0/MhNu4nl7FtOXz26+xhJUWSCTKFnSRK7w9EYuY
	 KJGaqaI+CqDoewiQcinQ2UnCYH0X/EgLLEX92exPZMFeV2RGiYqOqT0294dVEW4a+uaaS
	 dkgeySDEmNBeStVv/8s/0xuTI3uAGMio2PGfNfezLErV3RugNycxSl0ef+wN6NhghEaUx
	 DoaXgP3G4EqN25ASTcyaqsPoBzasD+QW+K6Nc1o6N/5UPdUi1Z+34xKfNBT4N/N9QB3gD
	 MWr0dgx6jId/3du/ctJYRNEXsxBPzUCftNcUOaDBa8lM8WseOXHaY9cPkMA/ENAA40g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBQAGYuNbN49uv82TZvxuUlGfayOPdsXlIBNlCgnon8=;
	b=wyD8xkEshT+GCF8SYq2AwUyowYLEbePeZbiaNojp9bVWmXYq0NdOE2NwiHT5A/CSRATg
	 UQ1u43ekZu4nyaGh75HJtXEcL27N9qv7sXfTVxLsqW2SolMLs/hdJD6nxUcPV6wh6oO+e
	 WfehyPm47gjVPIzYQciGflR4k3itZ9eTb3mFdBzICLWmiiAwWRjFQnJPKhcF1LxgEbelG
	 76uEvDixoAH9gJkEhVt0dmNoST2VXsatX0qJppTUtX/TiH6JpSDrk74sHZxiO+WlJkW0b
	 MyBmDIvVj42VdoYn9ldXx98Kt+w4F8Af5P7vNl9tmbUiH6W2leuBvQOO1W514LIMISA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIuy+1wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1706C60A3839;
	Wed, 18 Nov 2026 22:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OIuy+1wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4531F000C9;
	Wed, 18 Nov 2026 22:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041471;
	bh=sBQAGYuNbN49uv82TZvxuUlGfayOPdsXlIBNlCgnon8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIuy+1wrUCLIKWkEObjC79Axa+u5wDXXAytyYTdrGm0p2wKKhWN+VwPZCAxQU5yKK
	 kJYCTHZyEWwH2txLDxN+TMHFDxijF4Ij5Rq+H0ck2rWfpgiJkGwGpFf47M/ytTrrXV
	 ALvIlbBbSh1C9z2DJjPMStO9M0NKgrb0GvNYT+ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2826/3318] ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150445.417249369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb736d45c9e04..7e3f85f5fc19d 100644
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



