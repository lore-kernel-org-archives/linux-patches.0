Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACBC3EDE62;
	Tue, 12 May 2026 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608611; cv=none; b=hh7cOE6rWcSC3dPXduBE2bGCwjBisVHhW1p7gOSGZ9ZwiV8rhcmHgseQx+9ho4kRJ91iVu43KDAQooxDMT9jhJ+Fra6scFYTcbYBT5ljVEEhuZ/RKCHh5x/aIhJ+RqiDqJL3XQ/FYnpPM2K13wXUPId6k2wi6xxxb4Few8EjW0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608611; c=relaxed/simple;
	bh=1aiBBCx4OnZjXU64nGJCs+QDIAY4d9fTDabB+Ko45X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhQlNGphjPm/tKsfd13ysyF+409Za4a8hUaj0TvJLvNGldJSpB91a8Fm8Oq+s0pvWgbgBOz7L6w3+49Xf5Fd3CHYkwjNR0qh9Sf//K2uk8I+wUjZoKdOjpssrCs0HxFT9Gk2rVvsntuvPZ7KghBsm1bAKzbWnArAw1IvAjVpbIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0A+ARRot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0A+ARRot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E8BC2BCF6;
	Tue, 12 May 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608611;
	bh=1aiBBCx4OnZjXU64nGJCs+QDIAY4d9fTDabB+Ko45X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0A+ARRotmgLhlEScU868otf2i9sGGtocY3LYyPjzib8TU5vyrTutbFtAmwwjLMWex
	 EE4dvqpgJkHl1Z2BUnFjGA26b0wV3N/vRZh3LGMCUHAiE3Els/ceJscGC9NzA3jj6i
	 BTYy3L9mMdn2ZzDQxzCMXR3G0dZ3xiBW/0jRJfeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 146/270] ASoC: qcom: q6apm-lpass-dai: Fix multiple graph opens
Date: Tue, 12 May 2026 19:39:07 +0200
Message-ID: <20260512173941.522708106@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


