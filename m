Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF6D258CE1;
	Thu, 17 Apr 2025 18:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914614; cv=none; b=gOato4D5SR97c3kHV4o7CJQzKXZomixBOrqrMZZMWOYDqnX2MNT/ck8yXkA6Kpqkb0anBBEI2W5IJNfIuIbubL7Zy+m48sFY+RpWG2krkPOnjIndn0tD3OFcNt+ZLdI8d8sv+mzBSvUhwdnIAXnuniqu36pjVipamAX9e0Dvagw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914614; c=relaxed/simple;
	bh=DSRbpl9yKy1V7dtlV43MLCrWX5gmVcEHiRyY3/rAUZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ilo2Hctrme1yp1P/PCWR+eUDl8vmZdWNC049G4xv1v+4YxbH9iT6uOONGjOvBfNfOp5xWSz4ggBpm9VIYKuosqoBkA5fs/DsYlrjJaOsFo1ppNEHtf+2v/3nKJ82CcDJyYfFDoZL5gDS9huYOvUETIkk7Rwzd1rKt1CUW6d88VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQ+rUdlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQ+rUdlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C9C4CEE4;
	Thu, 17 Apr 2025 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914614;
	bh=DSRbpl9yKy1V7dtlV43MLCrWX5gmVcEHiRyY3/rAUZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQ+rUdlLKfcd1PCQcvx07XXyH+bcRe550udLce6aS3/aCA0dwborH0T+b4oe3oRVF
	 LULffH0J1wLLS4cuRQ6eCi28jDqiqtIqxeffXoyE2AFvjHxtOg5yeIkevezGpZBqVc
	 V2t5M3HngQu9G972G5sGHGDsxC6zCu2CuCac6iyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 272/414] ASoC: qdsp6: q6asm-dai: fix q6asm_dai_compr_set_params error path
Date: Thu, 17 Apr 2025 19:50:30 +0200
Message-ID: <20250417175122.369683378@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

commit 7eccc86e90f04a0d758d16c08627a620ac59604d upstream.

In case of attempts to compress playback something, for instance,
when audio routing is not set up correctly, the audio DSP is left in
inconsistent state because we are not doing the correct things in
the error path of q6asm_dai_compr_set_params().

So, when routing is not set up and compress playback is attempted
the following errors are present (simplified log):

q6routing routing: Routing not setup for MultiMedia-1 Session
q6asm-dai dais: Stream reg failed ret:-22
q6asm-dai dais: ASoC error (-22): at snd_soc_component_compr_set_params()
on 17300000.remoteproc:glink-edge:apr:service@7:dais

After setting the correct routing the compress playback will always fail:

q6asm-dai dais: cmd = 0x10db3 returned error = 0x9
q6asm-dai dais: DSP returned error[9]
q6asm-dai dais: q6asm_open_write failed
q6asm-dai dais: ASoC error (-22): at snd_soc_component_compr_set_params()
on 17300000.remoteproc:glink-edge:apr:service@7:dais

0x9 here means "Operation is already processed". The CMD_OPEN here was
sent the second time hence DSP responds that it was already done.

Turns out the CMD_CLOSE should be sent after the q6asm_open_write()
succeeded but something failed after that, for instance, routing
setup.

Fix this by slightly reworking the error path in
q6asm_dai_compr_set_params().

Tested on QRB5165 RB5 and SDM845 RB3 boards.

Cc: stable@vger.kernel.org
Fixes: 5b39363e54cc ("ASoC: q6asm-dai: prepare set params to accept profile change")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://patch.msgid.link/20250327154650.337404-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -892,9 +892,7 @@ static int q6asm_dai_compr_set_params(st
 
 		if (ret < 0) {
 			dev_err(dev, "q6asm_open_write failed\n");
-			q6asm_audio_client_free(prtd->audio_client);
-			prtd->audio_client = NULL;
-			return ret;
+			goto open_err;
 		}
 	}
 
@@ -903,7 +901,7 @@ static int q6asm_dai_compr_set_params(st
 			      prtd->session_id, dir);
 	if (ret) {
 		dev_err(dev, "Stream reg failed ret:%d\n", ret);
-		return ret;
+		goto q6_err;
 	}
 
 	ret = __q6asm_dai_compr_set_codec_params(component, stream,
@@ -911,7 +909,7 @@ static int q6asm_dai_compr_set_params(st
 						 prtd->stream_id);
 	if (ret) {
 		dev_err(dev, "codec param setup failed ret:%d\n", ret);
-		return ret;
+		goto q6_err;
 	}
 
 	ret = q6asm_map_memory_regions(dir, prtd->audio_client, prtd->phys,
@@ -920,12 +918,21 @@ static int q6asm_dai_compr_set_params(st
 
 	if (ret < 0) {
 		dev_err(dev, "Buffer Mapping failed ret:%d\n", ret);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto q6_err;
 	}
 
 	prtd->state = Q6ASM_STREAM_RUNNING;
 
 	return 0;
+
+q6_err:
+	q6asm_cmd(prtd->audio_client, prtd->stream_id, CMD_CLOSE);
+
+open_err:
+	q6asm_audio_client_free(prtd->audio_client);
+	prtd->audio_client = NULL;
+	return ret;
 }
 
 static int q6asm_dai_compr_set_metadata(struct snd_soc_component *component,


