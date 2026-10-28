Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210550;
	b=DDiFqKqBK9ecPTV+E1qk3bfRZFgSJR2tCQGmpkezoDXl50fsm639za3XuiZ3N3KllEB8
	 O36/5iUD23e/JqlH0m8EV/XT8sBIlsCU//WKDLRCIpAKcnSFTODDYs0+8KRtVurf164fh
	 CH6SUSZ4IIJhuGeCC9R4FxrEsusWEnaAJ29vjCFZxbQSazSsHGYrHRf9O/sEic7mmFe6h
	 wBgDnmMgYyrGd946hCHbRsmlJMP8GDhHsacyHOE5H+KOibUVHbL0YaAwujAqvo8ef1Ebq
	 Uc7yoXR+2MLYI7PZyWG+j99xa+uvYtznYSOZIcJMiTD4ZNvDaC59ixN37INJyw4vMfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kR1JUBAf7FLoUlQOTdigYeBCeEMNeRL6IHGMaLacHpU=;
	b=uPNSdZ+X0gH98nfYchkKSzo1E+jK3/i+ytKq2by3DCpTRTB2byNEOQznK9DtO2COLvFb
	 nnwfpk67cqk7lCnHJ2pkpi7UcKgFzMclMbiuLDZmjB3mXIPqFC41qLFOaN0w3bq1MjmoF
	 n952nUWhnXidkJu6fGNB4bEPMxLA78vi+xmZkfvkkTDkTALDHyA3Zi6qVZMZPxBOgo0ZR
	 mwousx0JX9IU1jecnkHanR0WfPLkt5oz1cT+QO3fFfSRuMOhmmfKCk0JOD/uld/yKTM2b
	 tBI1TYLDIrwGYBXK6UGAs+9iUCEEBh+zA0f2ZEQovbso5feCl2FnGjPAro1aDv2Dy9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atFkVSpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD8606A31A;
	Wed, 28 Oct 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atFkVSpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCADB1F01825;
	Wed, 28 Oct 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210549;
	bh=kR1JUBAf7FLoUlQOTdigYeBCeEMNeRL6IHGMaLacHpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atFkVSpQP9aoabuKS7B6p8JyfjylMcQfKYV0Y1Qn5E7KzZpwquWY6dSNZNVl3tgDb
	 a2i9ecDmC8NABaKuLOYBkRTaNPsdYwOoGr8MRgZ5OcS3SnkPElNr+WIETRAuT5m4KO
	 X5H33ite1Uqy9aQSc8n6Me80GOWQD9BcZzmPyEjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/571] i2c: mxs: fix DMA channel leak on probe error
Date: Wed, 28 Oct 2026 17:53:31 +0100
Message-ID: <20261028170009.544724671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 777979e627115734052b323d2721cdb500e81dcf ]

mxs_i2c_probe() requests an exclusive DMA channel before resetting the
controller and registering the I2C adapter. If either later operation
fails, probe returns without releasing the channel because the remove
callback is not invoked after a failed probe.

Use devm_dma_request_chan() so the device core releases the channel on
probe failure and driver detach. Remove the manual release from the
remove callback because the channel is now device-managed.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 62885f59a261 ("MXS: Implement DMA support into mxs-i2c")
Assisted-by: unnamed:claude-opus-4.8 typestate
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: <stable@vger.kernel.org> # v3.7+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260815151720.3757460-1-ruoyuw560@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index b353732f593b1..fa0b4ce5c2f9a 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -824,7 +824,7 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	}
 
 	/* Setup the DMA */
-	i2c->dmach = dma_request_chan(dev, "rx-tx");
+	i2c->dmach = devm_dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
 		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
 				     "Failed to request dma\n");
@@ -862,9 +862,6 @@ static int mxs_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&i2c->adapter);
 
-	if (i2c->dmach)
-		dma_release_channel(i2c->dmach);
-
 	writel(MXS_I2C_CTRL0_SFTRST, i2c->regs + MXS_I2C_CTRL0_SET);
 
 	return 0;
-- 
2.53.0



