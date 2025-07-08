Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D01754B;
	Tue,  8 Jul 2025 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993312; cv=none; b=ZgZPwPgTWVfC8KViPlBUoTNYcDtouBgYvtWYYmY8V0lqZrLS0lbMsI0VU/vPJzA/JW3s/mc3UWyemLmof8LJ5CNtdmNQA4eLKJgRNslXfwllU71A/z4ZOIywKgV5qansvQsfeEGJe4RVyTMYrpUwKYnF70RYcwbgHiXvoa38vCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993312; c=relaxed/simple;
	bh=1Y0E2UJQ47HDIswoxHXjz15N9OjtpX4mTU4/d3BLHFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTCpv8WUL85c4tqVERwUtaIjJA6CsqU2Hl+4Vk1/K/uD+pSGb8O2mWyXx0fDLAEap8wgI26MVoJC+pZimzIb4tgFrce0pXdWNDj3d2zGKxiQvxcdCVMJoS1W/b1PiI5bjXmVR6rll4YcCtxzSFh0N4VwvfZkLIG7lECnMfRTuik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXjj9RTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXjj9RTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8D3C4CEED;
	Tue,  8 Jul 2025 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993311;
	bh=1Y0E2UJQ47HDIswoxHXjz15N9OjtpX4mTU4/d3BLHFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXjj9RTLUWKOtKR/yTRN4Ws8TYy/lSCnohlY0pTRi6lxjnZehuYGy/NAOP+3pMSwn
	 53EeJSL4AxvYbrlw36RHwwxPzVCFVA8jMHxed14aPBVTmYet5SO5iY9JtBkGrlMWwN
	 MX2a4xTl3/AU6G6N429rVZU0YFobQnsNiVTJo1vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 030/178] mtk-sd: Prevent memory corruption from DMA map failure
Date: Tue,  8 Jul 2025 18:21:07 +0200
Message-ID: <20250708162237.335112414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -834,6 +834,11 @@ static void msdc_prepare_data(struct msd
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
@@ -1466,8 +1471,18 @@ static void msdc_ops_request(struct mmc_
 	WARN_ON(!host->hsq_en && host->mrq);
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


