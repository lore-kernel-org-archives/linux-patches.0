Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975FC8E6;
	Mon, 22 Sep 2025 19:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569621; cv=none; b=kMcVWXaCrHxJdk5qLlsK3haxLfsRJS7kHYQz/mJ4qvGTFK3vywYrnHZxu5pU+gEzUc2FM+lJp7TdwLm9fvpMtztOGgPXcbZ4CJg28Y7PGugrCU+fF/op1wFaJAYU6OwFOqdWF2LE+Evo39U39MEdoQTER+6Ehi32fFivE+39w+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569621; c=relaxed/simple;
	bh=gstpobnaU9uYt/GVWO2hSRTHIQgRpmRRsOyUmBJvODc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buEjXwIaWJnI6svyi6GI61TH1Bfmt+HnIyOxj/ukAKDG7JPPkUR3pWR1lRnFbiOgWPuBhFOrqxhotjtqCK3nirZFRK0xX5xEojHL8KoJjbs2xDan9lrvzd9N57ALTCeteeXDohzzSmHitEgfdEcZEvXJ1iSbpCfdIRoM7GOhijc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDIxKvLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDIxKvLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD09C4CEF0;
	Mon, 22 Sep 2025 19:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569621;
	bh=gstpobnaU9uYt/GVWO2hSRTHIQgRpmRRsOyUmBJvODc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDIxKvLmoNIO6G++547C2h59pdswSfMsKqMKU/iEZmZXMGEsXLsaWy20ubi1Qd8h6
	 hRsktIsrjb5n8LiiqSh1ebQJbBU5Nr3CNrwwOovM/vbr+DDnOoaJwMvYsff0NXBGxO
	 L2Q07DxsN5rbN0/Qp2j2hJH047Bd7v3ny2XUKbSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/61] ASoC: qcom: q6apm-lpass-dai: close graphs before opening a new one
Date: Mon, 22 Sep 2025 21:29:50 +0200
Message-ID: <20250922192405.202314697@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit c52615e494f17f44b076ac8ae5a53cfc0041a0dd ]

On multiple prepare calls, its possible that the playback graphs are
not unloaded from the DSP, which can have some wierd side-effects,
one of them is that the data not consumed without any errors.

Fixes: c2ac3aec474d("ASoC: qcom: q6apm-lpass-dai: unprepare stream if its already prepared")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230323164403.6654-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 68f27f7c7708 ("ASoC: qcom: q6apm-lpass-dais: Fix NULL pointer dereference if source graph failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -130,6 +130,9 @@ static int q6apm_lpass_dai_prepare(struc
 	if (dai_data->is_port_started[dai->id]) {
 		q6apm_graph_stop(dai_data->graph[dai->id]);
 		dai_data->is_port_started[dai->id] = false;
+
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			q6apm_graph_close(dai_data->graph[dai->id]);
 	}
 
 	/**


