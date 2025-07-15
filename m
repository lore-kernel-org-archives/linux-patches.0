Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B227470;
	Tue, 15 Jul 2025 13:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585487; cv=none; b=tGbD8MWVQACcDxxI3iZsnjqRtJPKm420GeBpY4iFsY5w/yij5jVQFzt6mROsO0SKQ4xEyJxYBA/Vd6J1tVrnmhj5B/k9uuidR5SglsY3qfv+BzVaHqkwbsJLIvz/JYDSmwBH3z1xgf1PnCHSnresIwrZlImAbaLHTo8hs+ppHBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585487; c=relaxed/simple;
	bh=Qokx3mFJI/i+LNjYEWR1PgyeKpGMwQiZvD9sK4iVjN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvSWF8QNiDx15apcZLpfNlnxRGAA/ZZF7xQi8yotJ2lNqVZhAKpHaOgtbfv8eLE18eaIFhEbDSvU3QP0V6YnmaFcXR/3IPXnHV4EJe0TxlGq8eBB6wBcJSArFqXxlFjyY+WR/3LB85X+PVQ4VhVcUYek8QB0xh64mw3weJLDw6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6DLx+DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6DLx+DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9F5C4CEE3;
	Tue, 15 Jul 2025 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585486;
	bh=Qokx3mFJI/i+LNjYEWR1PgyeKpGMwQiZvD9sK4iVjN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6DLx+DHo0AfgMqcamQpfgIztkPVhzNUymoO6XWmy/j2wmJWrfO6Y/4zAQoE6/R/z
	 lM8kVKKCWGE2x5Wzk+pRsQ76kIHAdlbZQj2nmquBjQZjcmNUeQYe4TwRVMpb0TGf7+
	 2Lw2RsKl9djepF7WYymxzMD3plx79geCXl0JPxTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Raghavan <arun@asymptotic.io>,
	Pieterjan Camerlynck <p.camerlynck@televic.com>,
	Fabio Estevam <festevam@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 059/163] ASoC: fsl_sai: Force a software reset when starting in consumer mode
Date: Tue, 15 Jul 2025 15:12:07 +0200
Message-ID: <20250715130811.117285875@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Arun Raghavan <arun@asymptotic.io>

commit dc78f7e59169d3f0e6c3c95d23dc8e55e95741e2 upstream.

On an imx8mm platform with an external clock provider, when running the
receiver (arecord) and triggering an xrun with xrun_injection, we see a
channel swap/offset. This happens sometimes when running only the
receiver, but occurs reliably if a transmitter (aplay) is also
concurrently running.

It seems that the SAI loses track of frame sync during the trigger stop
-> trigger start cycle that occurs during an xrun. Doing just a FIFO
reset in this case does not suffice, and only a software reset seems to
get it back on track.

This looks like the same h/w bug that is already handled for the
producer case, so we now do the reset unconditionally on config disable.

Signed-off-by: Arun Raghavan <arun@asymptotic.io>
Reported-by: Pieterjan Camerlynck <p.camerlynck@televic.com>
Fixes: 3e3f8bd56955 ("ASoC: fsl_sai: fix no frame clk in master mode")
Cc: stable@vger.kernel.org
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20250626130858.163825-1-arun@arunraghavan.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -771,13 +771,15 @@ static void fsl_sai_config_disable(struc
 	 * anymore. Add software reset to fix this issue.
 	 * This is a hardware bug, and will be fix in the
 	 * next sai version.
+	 *
+	 * In consumer mode, this can happen even after a
+	 * single open/close, especially if both tx and rx
+	 * are running concurrently.
 	 */
-	if (!sai->is_consumer_mode[tx]) {
-		/* Software Reset */
-		regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR);
-		/* Clear SR bit to finish the reset */
-		regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), 0);
-	}
+	/* Software Reset */
+	regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR);
+	/* Clear SR bit to finish the reset */
+	regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), 0);
 }
 
 static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,


