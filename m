Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21032690D5;
	Sat, 30 May 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160577; cv=none; b=pAZFWi0Dwc5g0wEOiqMwdXVv3BtSHolk2b8csWRtQ1J7cxaA7cBdGT/xOtHEGAdGUvPBgaMTGS25cacCXZS8tLH+SeGhVtzlK3NdagTrloV2Cbs/Et0FajiE5Dzt9Hht1dDccN2EMtTavlkci66Od/Cb3jidHDkaGck5QsgzaLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160577; c=relaxed/simple;
	bh=jZU8g06SrduvhJck77PW8eo9N+Dh+dgKK6QjdazcbIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSpujmmX53UxkCRv0lARfLRHSMRn9HaZ2hI9M6anEkQnuyqCDOBBodgSE6R9FKWL/NTzHTYm0VXgXc5TKqym0x6U2ZKV0+JLuTPqxB1PnbM781RUX6UY5Gkj9Eg0BkqjflYZWwD+1lJ4rivZsfxU0Z4tiQ079H966b9pAby3sI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtDS0XnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtDS0XnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B12C1F00893;
	Sat, 30 May 2026 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160576;
	bh=5Fg4KddYc02bXfJFjg0GUjNuMTHb9hvnzKizPLL8mZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtDS0XnLsjE/5OCQajkDQDJ4cJm3zFogK0GphM2djW8em0rMSMNF90CYWEDMDvPNW
	 jXNC9TE5UzTGlwsXnWzqiS+ugzqaoBYtGlCQWLSA6HCQaPkGKox545WmrZZMn6XBum
	 9iR1K6oajBGMjaAJyl27UTCqFqoUGV7pwLzrmi6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 346/969] ASoC: qcom: q6apm-lpass-dai: Fix multiple graph opens
Date: Sat, 30 May 2026 17:57:50 +0200
Message-ID: <20260530160309.918440546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -144,7 +144,7 @@ static int q6apm_lpass_dai_prepare(struc
 	 * It is recommend to load DSP with source graph first and then sink
 	 * graph, so sequence for playback and capture will be different
 	 */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK && dai_data->graph[dai->id] == NULL) {
 		graph = q6apm_graph_open(dai->dev, NULL, dai->dev, graph_id);
 		if (IS_ERR(graph)) {
 			dev_err(dai->dev, "Failed to open graph (%d)\n", graph_id);


