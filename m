Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A23B19DE;
	Fri,  9 Oct 2026 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556295; cv=none; b=XvHWnBoWv7W+E8SoMVeaOGjXzj310gCDuw96g+dj8lY04EtYxOb/8kJ92uCK6Zm6DLERAEggwRtcHGZ07o/wgUn/3+hlFoA5HZtUcBYbGgTJIRjScBUUCvsdUY1/duCHc4CjJPCovhn2MzphaNImmy/NHRpBw1jqbwrYoa8s2X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556295; c=relaxed/simple;
	bh=nn1kM7mB/E5k6Cwy15GwOFiCBUwBEONdkMBwthyOeQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeVNoJ7DkpklSnSd27EB1ain2FCsYJUBZafcLlBKb0Ld8f7T/D470Kn1ZGcoDtM8OURX7HxrB29bJQeEaxWgNkuCsbMzCnMfID6VDL3GfjuElUJ2gsKyx9tmav2bWHDEGJA6NZQI4kC9J7fiMgVV9zebFAgrzmbjKVLQF4mt9J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN/eJYGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN/eJYGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9D71F000FF;
	Fri,  9 Oct 2026 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556294;
	bh=p1Q4ElZwEA8bkkKa7iNrJ36tFiW6nYpjjY90ydSkxcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pN/eJYGexm0cizuZ4lXochIxbZEM9r5X2A3wEonjPjNaRxUgbpKg7l5nnaxpPedwb
	 atWJplRJonj0tgu+Idoba7zFM0cbr6UMdMPJBvAEchy59j5vopJBV4saA7ywxhCyog
	 t814o/2tRyWjIM/FZ8hJRx3xRYrrAgiiS1lsnfQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zimeng Li <me@lizi.moe>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 211/403] ASoC: qcom: lpass-cpu: use DAI table index for playback constraints
Date: Fri,  9 Oct 2026 16:09:32 +0200
Message-ID: <20261009140957.075560207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Zimeng Li <me@lizi.moe>

commit ca51771c8efde5df05476ac98dd1b2af4e2b149f upstream.

The DAI ID is a hardware port ID and is not necessarily the index of
the corresponding entry in variant->dai_driver.

When configuring a DAI with LPAIF_I2SCTL_MODE_QUAD01, the probe code
currently uses dai_id to index variant->dai_driver. This is incorrect
for platforms where DAI IDs are sparse. For example, the IPQ806x MI2S
DAI has ID 4 while it is the only entry in the DAI driver table. If
that DAI is configured for QUAD01 and probe reaches this branch, the
code writes beyond that single entry via dai_driver[4] instead of
updating the DAI being processed.

Use the loop index i when updating the current DAI's playback channel
constraints, while retaining dai_id for indexing the hardware-port
specific playback SD-line mode array.

This fixes the incorrect DAI table access for platforms where the DAI
ID does not match its position in the driver table.

Fixes: c223f41c1a52 ("ASoC: qcom: Add four speaker support on MI2S secondary")
Cc: stable@vger.kernel.org
Signed-off-by: Zimeng Li <me@lizi.moe>
Assisted-by: LLM-assisted source analysis
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260927010911.51980-1-me@lizi.moe
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1234,8 +1234,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 		}
 		if (drvdata->mi2s_playback_sd_mode[dai_id] ==
 			LPAIF_I2SCTL_MODE_QUAD01) {
-			variant->dai_driver[dai_id].playback.channels_min = 4;
-			variant->dai_driver[dai_id].playback.channels_max = 4;
+			variant->dai_driver[i].playback.channels_min = 4;
+			variant->dai_driver[i].playback.channels_max = 4;
 		}
 	}
 


