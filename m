Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFF63BB11C;
	Tue, 12 May 2026 17:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608101; cv=none; b=ID0/XWZ5LSj6V6YMSRJdWccOJLiTqH69lehxY96aNjGwK31yEYTGLRQzte1hEfVA79zx3bLv9XBi7xLba8ufCZeIsXEBfvcTr3MOS9f4OEy+GJSm1buJCOI3yJSKpXewdV3hWfTEn0wo67DPOKDsI0YpAwBiDgjmkMVAp0QjR00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608101; c=relaxed/simple;
	bh=D99teqa9gI/3hn+L/KXz0FPh+Z75G1IZohSPhMNp/s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1toM3RoCZEqNkmfZ/p/RYbOEcRZI/U/7j34CUvX6EEl1MJ6U5mkXGuci2ImIrsKXC4WF/qVUyByyYVtQQBWORTGCvmfLX26RxE84kw8B2FQSkqnkjmm6OgeXNt85+Z8cTbfMgZA3K+WXoT52e0tCRfQC3pIfyO1ssqhTSNCwZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCdBP5Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCdBP5Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED1AC2BCB0;
	Tue, 12 May 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608100;
	bh=D99teqa9gI/3hn+L/KXz0FPh+Z75G1IZohSPhMNp/s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCdBP5Urx78ubbJPDIsZNqwWz1w9MA2vfXtEea0FP1CABlL3QLL95R/kaog5C8zsW
	 zUQaEbZaw0l/gfaSSXGYwp8Ct1Y0Ie7DKFV9wrEeilUsZ+M4Ozl5owV8ZNITxZx/KY
	 w1+0iTignnZv80kkDABW6DIYbB/213hReV8IpRos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 112/206] ASoC: qcom: q6apm-lpass-dai: Fix multiple graph opens
Date: Tue, 12 May 2026 19:39:24 +0200
Message-ID: <20260512173935.226756539@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 69acc488aaf39d0ddf6c3cf0e47c1873d39919a2 upstream.

As prepare can be called mulitple times, this can result in multiple
graph opens for playback path.

This will result in a memory leaks, fix this by adding a check before
opening.

Fixes: be1fae62cf25 ("ASoC: q6apm-lpass-dai: close graph on prepare errors")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -181,7 +181,7 @@ static int q6apm_lpass_dai_prepare(struc
 	 * It is recommend to load DSP with source graph first and then sink
 	 * graph, so sequence for playback and capture will be different
 	 */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK && dai_data->graph[dai->id] == NULL) {
 		graph = q6apm_graph_open(dai->dev, NULL, dai->dev, graph_id);
 		if (IS_ERR(graph)) {
 			dev_err(dai->dev, "Failed to open graph (%d)\n", graph_id);


