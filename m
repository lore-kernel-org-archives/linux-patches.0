Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C0D2139C9;
	Tue, 26 Aug 2025 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215608; cv=none; b=GeT9pMtVt1cSDkve3xjW/HJtiL/Wk5fQnMO2IIiiUFhPh9uFlpCFdBUe27EOM+3ZGA4YGxFFwHeL4tA4XyjQ9z7Nbc9CVuyHnaJYihPQ5mNQehD0CBKzjOSJy31CfPb3QrDij6DBQJxosdBSPLUX7V4Q0RdUy8Ov7SBwcq2C/p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215608; c=relaxed/simple;
	bh=yah+XGO/Xl4hCpTzn7tR7cMRoFXbXHIo344tSz3YJOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxCYsljwV3VqrCcNJvJ0cChmzTtsp6U7IpB7cnk67xwccD/OB/OE9wnkMDztpd320cGVdX8wxqAiPtI8YiQ2HTp3k7iGklnQRgKae9Bvk6vyUa5mALNWHy0N2b6Ze7UMr8LCzfVDOrnt1I8Chd2kTTgI8Lo+GG+p1lKGvt8bto8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSoQTV3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSoQTV3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFCAC4CEF1;
	Tue, 26 Aug 2025 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215608;
	bh=yah+XGO/Xl4hCpTzn7tR7cMRoFXbXHIo344tSz3YJOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSoQTV3T/ns4vKaNjpZNiuO25A0R4NpS6QWxQhOBunhICYM/xTfKJZKFxQ01XeeVG
	 ybJeaXsA3seE040s6c8LIqcHvG/nZ9VvVNT3h3+rX6f/keOBavw1tDBMfxo9Ts9zFP
	 6q8KtCUs5QEQ3jYMUIlIdk6QhPrdQgNoPqCPO2to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Raghavan <arun@asymptotic.io>,
	Pieterjan Camerlynck <p.camerlynck@televic.com>,
	Fabio Estevam <festevam@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 067/644] ASoC: fsl_sai: Force a software reset when starting in consumer mode
Date: Tue, 26 Aug 2025 13:02:38 +0200
Message-ID: <20250826110948.159006090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -580,13 +580,15 @@ static void fsl_sai_config_disable(struc
 	 * anymore. Add software reset to fix this issue.
 	 * This is a hardware bug, and will be fix in the
 	 * next sai version.
+	 *
+	 * In consumer mode, this can happen even after a
+	 * single open/close, especially if both tx and rx
+	 * are running concurrently.
 	 */
-	if (!sai->is_consumer_mode) {
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


