Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026468;
	b=3jkSmfP9mgOmi+9EqP5yNqaTK1+BtbTIZmbFhdxbDtxUge9EVvxj/hpOI6zxFNZmGaHg
	 xXJ7sWVRjLE2pZBx4+6249eVx/ySvpBaDLmJyzrXLUZ/YyLQIth1vUKeSPt4L6VNTpJz5
	 3tgL6tHyudz25EwQiwLCj7jSZA7dm3ejkFO27rmAhy0k0tXS1i+kQpeb2ehqYSLqZ1VPH
	 vDiJB9zFY5sGN39pziLNWyB70lmZmDTPol4acwNCCyaWrhPx6M5P1wa2bRKPwN8maIhB8
	 3Xnv3u53nlOHQ9iyVfABBrwlDRb12f8GSHCnF6d4Q7Svic57cCh7sqOQS+WwYL28glQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nVYMbaFHSQBtwiRzreS+L44udAU924apXxOmOLEPyA0=;
	b=Wq/k1012f1PmpAaHCbxCL8YCSSjTuJ9+SZ2iVHw5zZUDUvw/9g0kwOu2cPrOyQoykcmj
	 05Ze/kSCYS+Dp6Q5BRleISCtmXf380WUBdvy+PF+K8lNZUaI40b7Z40hPHJz33XhPEZ84
	 bIJ3Q4lkIYSwGi51OPiKvfD0JNvGDDp1Yg/6zxVpAFMQiYS7/mJjZjm8yw4Xjolq+e+MQ
	 3Inf9lut+xYCkEiH/gjTt0nbOKLzd1/97eKoDwP6wAZGOSdgXVl4gReZm9SiB0v8Np2r0
	 K2TuSGiLBtyPMov7Ro94YlcU6YKv9+MzZJj9m/njjOQwganQWxhelXV2Aqtl/CAYMpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPzOh7wL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C02A606A325;
	Wed, 18 Nov 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPzOh7wL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07A71F000C4;
	Wed, 18 Nov 2026 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026468;
	bh=nVYMbaFHSQBtwiRzreS+L44udAU924apXxOmOLEPyA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPzOh7wLW70Gsftm+VsBS4L12+ik5k/sDMAuIC7LQLE/RxcREV0VowkAtHSuLsOaN
	 kv2yNcSYZraFQhWXukACMRXUb/+v3qJZ8kDBOheTK84K0uXobogchRZry+OgW/OgC6
	 pNbxKwMmFk6vB76JUjMZeg+jMn/iqAaAkcFjPuCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1446/2151] ASoC: amd: acp: Fix .close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:01 +0100
Message-ID: <20261118150214.601520839@linuxfoundation.org>
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

[ Upstream commit 2c3400aa9f397da48a6760f5e84438973e01a00c ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_dma_open(). ASoC only marks the component as opened when
.open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 623621a9f9e1 ("ASoC: amd: Add common framework to support I2S on ACP SOC")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index b25ac5612808c..861411c4a75c5 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -248,7 +248,7 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 	list_add_tail(&stream->list, &chip->stream_list);
 	spin_unlock_irq(&chip->acp_lock);
 
-	return ret;
+	return 0;
 }
 
 static int acp_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



