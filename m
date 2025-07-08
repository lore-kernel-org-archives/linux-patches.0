Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0B621C190;
	Tue,  8 Jul 2025 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992618; cv=none; b=BHp61i3lP/ExcyV3oAVafdrsO+Yb+DPl0Y+Asr07LBcfbRY6CLvgm3rAsM6hV36aTdiaHt5cek5C/t+Cf2E+ih/67tpR2VGHwUARtjf5vPgILKm9hHDDNNa12xIVGpZhccNO9k+LjzzIeI8rxdYxOln1VhzpkI8U/xBKK1puZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992618; c=relaxed/simple;
	bh=5fZPMcKwqcfhbsadt6y4pPnGT1nW9S/NO07CnjV2xgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my15SCu63eoc0mYHwJZOZv7MnAo1HukcaTCt1ymypxVTLTJNtAADkXaQ251S2UEtTuRbahALlldjaO+B6FSAwBz3P6d64RsKp600kBLDPhF/fswrp4kIfNZ/Ymx+A8LVZLCDYqV275cVohJwLuypHv/FIaXGLNC4j37ZiJJH6l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRkofmJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRkofmJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA0DC4CEED;
	Tue,  8 Jul 2025 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992618;
	bh=5fZPMcKwqcfhbsadt6y4pPnGT1nW9S/NO07CnjV2xgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRkofmJmvr7rmE8P4vfUegs2KwiwhHXazuuwuLr5/xAncrleFoqS/+wCP+WpVn/Qs
	 UwiV7V/D/oi3v0sAW5HdIYbBI1r0CW/jLbyDojWosrCxoD/+2DjWBYQSnI9upUqbQ1
	 ln0GvxV1p8a7a8JPg70YLumPs/JIbPDYVXve1P8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 023/232] mtk-sd: Prevent memory corruption from DMA map failure
Date: Tue,  8 Jul 2025 18:20:19 +0200
Message-ID: <20250708162242.039234370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit f5de469990f19569627ea0dd56536ff5a13beaa3 upstream.

If msdc_prepare_data() fails to map the DMA region, the request is
not prepared for data receiving, but msdc_start_data() proceeds
the DMA with previous setting.
Since this will lead a memory corruption, we have to stop the
request operation soon after the msdc_prepare_data() fails to
prepare it.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: 208489032bdd ("mmc: mediatek: Add Mediatek MMC driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/174972756982.3337526.6755001617701603082.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -783,6 +783,11 @@ static void msdc_prepare_data(struct msd
 	}
 }
 
+static bool msdc_data_prepared(struct mmc_data *data)
+{
+	return data->host_cookie & MSDC_PREPARE_FLAG;
+}
+
 static void msdc_unprepare_data(struct msdc_host *host, struct mmc_data *data)
 {
 	if (data->host_cookie & MSDC_ASYNC_FLAG)
@@ -1346,8 +1351,18 @@ static void msdc_ops_request(struct mmc_
 	WARN_ON(host->mrq);
 	host->mrq = mrq;
 
-	if (mrq->data)
+	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
+		if (!msdc_data_prepared(mrq->data)) {
+			/*
+			 * Failed to prepare DMA area, fail fast before
+			 * starting any commands.
+			 */
+			mrq->cmd->error = -ENOSPC;
+			mmc_request_done(mmc_from_priv(host), mrq);
+			return;
+		}
+	}
 
 	/* if SBC is required, we have HW option and SW option.
 	 * if HW option is enabled, and SBC does not have "special" flags,


