Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52991754B;
	Tue,  8 Jul 2025 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993315; cv=none; b=UKoujCkKR5bYGhUJoVRxtXc8Qf3rb2dQj2peCQn0dSoQHuWnbTw2l694HxYB+y2oGjEAH1F/kAnU2HSE+BGYZnVyWHt4UIHkXApzLAmCxw/ERZ6shhb4P2PSV9+K8d9iQhoCrXC1PqSmAhIvEj3wT5MNdeQ+N6pO6BVzsqzTPpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993315; c=relaxed/simple;
	bh=Gitb/Qofo6qzLRRfbWJxygGr8JI2nzoAu418PKXSEkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4XcvbMUj8dcdFLdDIZ4U+b6Sb4qN/fJtYTelaeY8CbNpjTe/ZJ1DJSBJrCfttmT6UXLWDLTObt6tanhuigsjUy3gzpOQgRsC6IRV+nue607rh9fyqtx7vW1WpCTAYZnP8wOPPmtqY3Xw0s3mf2j5tbTC2nCfbbuQr+6KRDMqPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5LHfYsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5LHfYsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6E3C4CEED;
	Tue,  8 Jul 2025 16:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993314;
	bh=Gitb/Qofo6qzLRRfbWJxygGr8JI2nzoAu418PKXSEkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5LHfYsHw65v5vQhlt9UhFS6jcIA1zGienVnkCErHY2pSBN+BASXUU2S2510wcSle
	 qzMxYZntqy9XZrayzBUaIaCk9aEdCv71CHpDmDxDDGnAdFHfc9I/JdFuam33b8WcvQ
	 YWNKyaXL8SCM5FliB3syfQkDNUcq4nGojK8ONySc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 031/178] mtk-sd: reset host->mrq on prepare_data() error
Date: Tue,  8 Jul 2025 18:21:08 +0200
Message-ID: <20250708162237.360608967@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit ec54c0a20709ed6e56f40a8d59eee725c31a916b upstream.

Do not leave host with dangling ->mrq pointer if we hit
the msdc_prepare_data() error out path.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: f5de469990f1 ("mtk-sd: Prevent memory corruption from DMA map failure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250625052106.584905-1-senozhatsky@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1474,6 +1474,7 @@ static void msdc_ops_request(struct mmc_
 	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
 		if (!msdc_data_prepared(mrq->data)) {
+			host->mrq = NULL;
 			/*
 			 * Failed to prepare DMA area, fail fast before
 			 * starting any commands.


