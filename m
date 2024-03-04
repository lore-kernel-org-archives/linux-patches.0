Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7B8F58;
	Mon,  4 Mar 2024 21:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588328; cv=none; b=Dau0OzzAruCpqAwsh0hScC37Kdj4XHRNxrsqdwgCBhwx4m/hg9dVzKsfp0DigM6ZmHkSlm7AOrZECIbW0CsPFyABauIxl3L5FlowyY1g720VQElSaYqmrq0JdBhYtazGliuVeAzrtUVug4I+RmY9yBkp4u2r989wVUjyEqlVI5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588328; c=relaxed/simple;
	bh=Vp7gcFD/QwvEvV2IQCDyDVhqQA27yZyQg0mbAIigctc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHVv2Rza0SOGzsGaH/4oJPVie7q9wxnpcrSKlrbF34MLNEifkWviZQuqXf9PaxnWD+m/uiRUTSHFN2Lqo5oLqUAoCJghZkz1q6ItwFr3PB18MY9IFsm/nFV8AErum9XLBM8al6oCbQ1geXvN9ZuJz/FUpifXX9/RFh4PIaOvkN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8Esdm4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8Esdm4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67FCC433C7;
	Mon,  4 Mar 2024 21:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588328;
	bh=Vp7gcFD/QwvEvV2IQCDyDVhqQA27yZyQg0mbAIigctc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8Esdm4DgOecRRd+xYZOwuko/7uJWVRBhsIq+a8JRW2c8lvp6uGTqry7kfrWXIBnY
	 eO+OaEavx1GDQBg/fCJpqYqcPyUNr+ziUX4qZUirV4BTgVy1zE0yMQ7EFSGemlrZjb
	 eQ1MrhdT2h6jnW3qXVE+TlTL3ASte08u4s+PXV9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/143] ASoC: qcom: Fix uninitialized pointer dmactl
Date: Mon,  4 Mar 2024 21:22:48 +0000
Message-ID: <20240304211551.465374028@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8221e2cbe35c1..4d5d147b47db0 100644
--- a/sound/soc/qcom/lpass-cdc-dma.c
+++ b/sound/soc/qcom/lpass-cdc-dma.c
@@ -258,7 +258,7 @@ static int lpass_cdc_dma_daiops_trigger(struct snd_pcm_substream *substream,
 				    int cmd, struct snd_soc_dai *dai)
 {
 	struct snd_soc_pcm_runtime *soc_runtime = snd_soc_substream_to_rtd(substream);
-	struct lpaif_dmactl *dmactl;
+	struct lpaif_dmactl *dmactl = NULL;
 	int ret = 0, id;
 
 	switch (cmd) {
-- 
2.43.0



