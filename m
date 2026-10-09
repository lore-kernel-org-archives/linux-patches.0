Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0A84EFFAE;
	Fri,  9 Oct 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556935; cv=none; b=tvcPft2m7HvjCAKFN5a/CvkL05EelFGaAY00ms+B8y0+jGxTT+PoH2Eu1nzpCq19mI3KD1unSFIbjsp+TDDSwWJ9QXoOhk5MnRhf56rrAQJpZhYgRAIzNEJyDY2XXXxK7Ye30nkW+cbzp1ydqmId9mvWCVVgha4hi/PZJkiTSoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556935; c=relaxed/simple;
	bh=iLI1hEJVJlNKf0Qwr5xQPCMUY9uov0iVAjKpp41DR0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lL+RmT8bkYj8Dwk/c8sNlohnsMLHrYMdet51B9l1dfKqMJz7SECo8SU7cR2V5E4ZXx3Uu5r7PYFaZSPghRyYlOEJ+jXYLf8U0KYTXJy9J/+FFObq11tgGcrlrZCZ587rEXa+LrcPxQoYhpqSaGmSntHraVQTRc+E/GMXtzaqk4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUwoNMck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUwoNMck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB21F000FF;
	Fri,  9 Oct 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556933;
	bh=Q/nD7h24b/0nvcTpjOGXxthjGYv2AihBb+Ftl7911ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUwoNMck9dtB+xTBmXZNPe24QOcQQ8SI/gbEsXDaSWV+bEHifZQwXOAtjl+ShPOrj
	 9J5aOYbAYj0hEVe7X61bEdUtex8i6I7tCGQOSUchnaQbZ8xX225tQnvSEXzTiqPstw
	 alBQ4f7xOTH+EEYcdOSDZoY/8fmo70SCtzeMnfpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zimeng Li <me@lizi.moe>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 266/428] ASoC: qcom: lpass-cpu: use DAI table index for playback constraints
Date: Fri,  9 Oct 2026 16:10:03 +0200
Message-ID: <20261009140951.939733949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


