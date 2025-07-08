Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A32367CE;
	Tue,  8 Jul 2025 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991981; cv=none; b=Qdl8mmFzZGVfZp1UlpDZetuT1fkGXjuoR4GaZWxAIjwC4BF4NW4ZYLBYL6ordOKGGAZK1cOlKLOS7qy5MMZ/q/zJqA20vOqzkoLoVFRhxlGDSOSa91WcxIr1SLqQ/agi8BM1sIyRziTCiBEsXxVpbJVEfvvz9n++YW1NA6VCd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991981; c=relaxed/simple;
	bh=FtwfQtTPq/KA3CoNM+0G2mKP6Vvb/uKBiC4HsDLUyMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WE6ONmsDoE2yyz7llCtCjCB4gTRthfBqwhARDWQz8OQVA1Gxz85aeqHJV16XHURl+PBXrRMQpj+PR0zE3BL/08fteOJsbptNenyY4xwCMtTOM5PjXxIxiPQ0vLgJiW9VbpaZrgEoLlKSeYuK09r/f06aJQIo8EUUviNFosIlxAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HROXAwng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HROXAwng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4DCC4CEED;
	Tue,  8 Jul 2025 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991981;
	bh=FtwfQtTPq/KA3CoNM+0G2mKP6Vvb/uKBiC4HsDLUyMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HROXAwng9o4DmfDE3PJGgGmIWKFm4x8MJuzEYvjOuQS0u1k3aLW3pDaIbjuptBj7V
	 ic5b4WEWaZh+Aur37k4LP5ZNnJsUzn+P16Dt3JqSP/Pz1ck/itBHMLjq625N8iIf5O
	 hPl6n4gie2OVhstxXfFIpOGgsIIyd3j80tt+ENV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 13/81] mtk-sd: Prevent memory corruption from DMA map failure
Date: Tue,  8 Jul 2025 18:23:05 +0200
Message-ID: <20250708162225.282448215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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
@@ -763,6 +763,11 @@ static void msdc_prepare_data(struct msd
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
@@ -1323,8 +1328,18 @@ static void msdc_ops_request(struct mmc_
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


