Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917734B410;
	Tue, 12 May 2026 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609378; cv=none; b=sgdfWPpy3Kf3vLBPAS2QNTGOyNEsXsVGdsVaIsEF2F1sYwf81LaL9S8q+kMaDClx+XBddg3OGa9yZiKRIGw090DbzBYeGyCRQdtHaEpogUcB02flPh5xqGpFKl2yr+8F6/wd7Hsj2PdC8CjpnrT5XaEMg1YHuwWNMaqgJ340esU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609378; c=relaxed/simple;
	bh=ky0MeBNSlDZpT084uLhYPNXa0cMkQEr8yZflwCatrmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6Hx2NLA8dbnHOu5b8Lby9wpcggrU/OPy5WQsXiBvjApxR2uytFwaD84lLtGz94xT2sgQluNdq98VDVQG63UTPb8QIsMy4GSw6gUeRpGcOS1k4LEimkZTW1ujO1fxr730D9C1t+65u6tZBQ/1TrIuuLahRVJHVyKk+VGC4Q+RYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LF/uR3eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LF/uR3eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41B3C2BCB0;
	Tue, 12 May 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609378;
	bh=ky0MeBNSlDZpT084uLhYPNXa0cMkQEr8yZflwCatrmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF/uR3eQYW41bfF+UjmAMO9zxfFMZRG+XQicrf9IbWYgH7H0tNFfqqfireswav1iD
	 snKTle6E/6pqcd+lz65F79x2l2Z3h7nZ6thJj1RWx6c3MNVJ1whn8FuwzNWUuNSlfk
	 z6mtTtyowjMmY5i286kEJ6ES1SzGOlg2JnvEu3w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 173/307] ASoC: qcom: q6apm-lpass-dai: Fix multiple graph opens
Date: Tue, 12 May 2026 19:39:28 +0200
Message-ID: <20260512173943.769531749@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


