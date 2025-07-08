Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDB11E492;
	Tue,  8 Jul 2025 17:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994115; cv=none; b=nZj39P69SX1FDT5BOZucnENx6DtzgcliuVm5op/AypNwdq/FdnThC6sfqJ+ybuRWPRfgfUYbgqkJ1P2CQAwnFypgCpK6xzxULc5wrXj9AVtTPCaGHQ0PNdysI499Axv93Cp2ROf1JmFcUyu0FEio+bxALQ8PniB+mZWPXiOlN30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994115; c=relaxed/simple;
	bh=S28OdX/9KooApUJu/gqEACFGL8Hcmd0R6uKa42W2zyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxJTPFuIOrOlZb/I2L6Qj9T3uxOK0Khf7ZjV/7V6B1y/qD3X0M7p2EzdhEtBKAqReDUsf10EKy1soH3Bwvrpl+4V4ONAPRamcduB0R0yXLAQylrNHsRrwo6jeOBk2mZNpae8ro1K1N+6EtaOUl8OF/kPuHDaz2+fmqNjMnpjxMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sgtbv0Ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sgtbv0Ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27822C4CEED;
	Tue,  8 Jul 2025 17:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994115;
	bh=S28OdX/9KooApUJu/gqEACFGL8Hcmd0R6uKa42W2zyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sgtbv0UaAe9P8a7ZzxpJnd7VEBNqlBKbuamrJAf86FldtrU+rJDSWrh2AxjXuJFqS
	 4UUL/Dtgx3j7SvSoJVbFMBWlaFNR9Jh1C/I+CdrG0MIFOU3Vuz6qGY4WouL3T8Eg1G
	 gttpunnZupkIqJSKJqHEiKgwhOiUxmCp3F3QIvsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 103/160] mtk-sd: Prevent memory corruption from DMA map failure
Date: Tue,  8 Jul 2025 18:22:20 +0200
Message-ID: <20250708162234.343494213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
@@ -734,6 +734,11 @@ static void msdc_prepare_data(struct msd
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
@@ -1306,8 +1311,18 @@ static void msdc_ops_request(struct mmc_
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


