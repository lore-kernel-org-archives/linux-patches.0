Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3019810A35;
	Mon,  4 Mar 2024 21:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587680; cv=none; b=WsLhGrnWY4el5qNsppsYoOaHiyEk4/HQ0UWD2AIjoodDo9LpYlOE5AdSThSouLGr/BHRccSKeU7MmNqoln51BYb/efssq2AAGLKBq8xt8ZA8uo8msILvnJcyNUT1D7Qdi5dSwnS9VfsPf2o1l6w3JFgL9barKQbMPyVrtkYHKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587680; c=relaxed/simple;
	bh=my7UClLIM/L9rqnVpGEdWJM2N0osWu9a0UUFOL4m7IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkSuYuxf/URkURszbZFFpeBicHBi12h6zZHE8KDLh3TOFftE4tpuB4Eo6C+PepTGhUeqgz+bI8pPzPCP9Rpl+EVafq1ge2LyxdmQgWOBl5Ydhz9orR4ZofcSGlnfnfFlTaJ3vq+25Jo0fNPzhejc7B5kYkhdOSLTI/Ti7IunjWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJuKR6L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJuKR6L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5923C433F1;
	Mon,  4 Mar 2024 21:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587680;
	bh=my7UClLIM/L9rqnVpGEdWJM2N0osWu9a0UUFOL4m7IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJuKR6L2lF1qHgw4mSFZhiHC1qFNSo7+NQ7T4vPsNA3D9vwVXe9/d+6PfvCRFmscp
	 UEgJI2sAXD5UxVZYKjM5vNa+X9jfdAfZrA31Z4lMkbDd3/UwwmwHZxxm0+kBInktHo
	 KZxxzLyf23edD9wvJf3RxM2Lr+oftV1Fb7GWCy8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 049/162] ASoC: qcom: Fix uninitialized pointer dmactl
Date: Mon,  4 Mar 2024 21:21:54 +0000
Message-ID: <20240304211553.422228984@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 1382d8b55129875b2e07c4d2a7ebc790183769ee ]

In the case where __lpass_get_dmactl_handle is called and the driver
id dai_id is invalid the pointer dmactl is not being assigned a value,
and dmactl contains a garbage value since it has not been initialized
and so the null check may not work. Fix this to initialize dmactl to
NULL. One could argue that modern compilers will set this to zero, but
it is useful to keep this initialized as per the same way in functions
__lpass_platform_codec_intf_init and lpass_cdc_dma_daiops_hw_params.

Cleans up clang scan build warning:
sound/soc/qcom/lpass-cdc-dma.c:275:7: warning: Branch condition
evaluates to a garbage value [core.uninitialized.Branch]

Fixes: b81af585ea54 ("ASoC: qcom: Add lpass CPU driver for codec dma control")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://msgid.link/r/20240221134804.3475989-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cdc-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-cdc-dma.c b/sound/soc/qcom/lpass-cdc-dma.c
index 48b03e60e3a3d..8106c586f68a4 100644
--- a/sound/soc/qcom/lpass-cdc-dma.c
+++ b/sound/soc/qcom/lpass-cdc-dma.c
@@ -259,7 +259,7 @@ static int lpass_cdc_dma_daiops_trigger(struct snd_pcm_substream *substream,
 				    int cmd, struct snd_soc_dai *dai)
 {
 	struct snd_soc_pcm_runtime *soc_runtime = snd_soc_substream_to_rtd(substream);
-	struct lpaif_dmactl *dmactl;
+	struct lpaif_dmactl *dmactl = NULL;
 	int ret = 0, id;
 
 	switch (cmd) {
-- 
2.43.0



