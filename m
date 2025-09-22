Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A992820D1;
	Mon, 22 Sep 2025 19:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569957; cv=none; b=JgD2cK3kp42HZq341/jhkNLHi78ioL8JYwrp+wRjH3hZitKD+4uqsiCXZjywMgBEDW1BUOOw8SQ/9WML2mxd538gRiVo6gCShGdpAkbMG4T1Pz0Zt/5XQidE3v4QgaTeRT9sYwzu6QqgqorbWWyfjSBJ51DMR+J10w7VqFnP7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569957; c=relaxed/simple;
	bh=LvDJAFHF0ZX8OJoUbq0YgQ/3KfXmHJZLK2pMP99Grs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR/AYJ9j6jpwFstqMsl4R0CRNK8uRMpk6beu/ZIiCtvVN9DVLpYbDkJk6lZYWImw2ZReheskBm1nNlFsdR73RVOoO9x8SkJpSQpXMbG3XUfwgXwRtVhaGIm9P56Uy3eXd1TlR8ugC60BP171USDxbrdOPrCtiRdHkQo9Qe6aS3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHgjz0iD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHgjz0iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE2BC113D0;
	Mon, 22 Sep 2025 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569956;
	bh=LvDJAFHF0ZX8OJoUbq0YgQ/3KfXmHJZLK2pMP99Grs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHgjz0iDddLZjqAOE/btOYBWkLZoA8MI0brf3ZTRcwhuhhQtsr7dCiQ6H8GURdoqw
	 sByq+J6QLr+1lLPJTK5kSpwpJFlhcamuFMBgAxul3xykLoKhldqkenrsSy4NH8rP5z
	 827v6S48MD70xR98oMJ5SqJPgVcHeU6Q8t+lJmnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 055/105] ASoC: qcom: q6apm-lpass-dais: Fix NULL pointer dereference if source graph failed
Date: Mon, 22 Sep 2025 21:29:38 +0200
Message-ID: <20250922192410.357178384@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 68f27f7c7708183e7873c585ded2f1b057ac5b97 upstream.

If earlier opening of source graph fails (e.g. ADSP rejects due to
incorrect audioreach topology), the graph is closed and
"dai_data->graph[dai->id]" is assigned NULL.  Preparing the DAI for sink
graph continues though and next call to q6apm_lpass_dai_prepare()
receives dai_data->graph[dai->id]=NULL leading to NULL pointer
exception:

  qcom-apm gprsvc:service:2:1: Error (1) Processing 0x01001002 cmd
  qcom-apm gprsvc:service:2:1: DSP returned error[1001002] 1
  q6apm-lpass-dais 30000000.remoteproc:glink-edge:gpr:service@1:bedais: fail to start APM port 78
  q6apm-lpass-dais 30000000.remoteproc:glink-edge:gpr:service@1:bedais: ASoC: error at snd_soc_pcm_dai_prepare on TX_CODEC_DMA_TX_3: -22
  Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a8
  ...
  Call trace:
   q6apm_graph_media_format_pcm+0x48/0x120 (P)
   q6apm_lpass_dai_prepare+0x110/0x1b4
   snd_soc_pcm_dai_prepare+0x74/0x108
   __soc_pcm_prepare+0x44/0x160
   dpcm_be_dai_prepare+0x124/0x1c0

Fixes: 30ad723b93ad ("ASoC: qdsp6: audioreach: add q6apm lpass dai support")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Message-ID: <20250904101849.121503-2-krzysztof.kozlowski@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -213,8 +213,10 @@ static int q6apm_lpass_dai_prepare(struc
 
 	return 0;
 err:
-	q6apm_graph_close(dai_data->graph[dai->id]);
-	dai_data->graph[dai->id] = NULL;
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		q6apm_graph_close(dai_data->graph[dai->id]);
+		dai_data->graph[dai->id] = NULL;
+	}
 	return rc;
 }
 


