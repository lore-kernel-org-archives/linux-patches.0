Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89E217722;
	Tue,  8 Jul 2025 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991957; cv=none; b=VRZlua6IJ/fOVYMOirxTFh/eU8GWdjNMIC6itoz7KSn98U/yk9KDBFKNPHIjal6B3d0HLNDCR5Lv7a1ZJSn+bqcyxYs3jP288UD5PrAJ0B6Ex8ErYa/1GNzZ92g4NVd7xIlUwsK8AcLcrnK+feudrM21ruHCrs/78i1CshyIZ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991957; c=relaxed/simple;
	bh=jOOmqGqqtTenaiVXP6Gtf+y1Rm5wzk2DMd0TOe8z8Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3i2ijMZrsAKZbEP/N2U4XOnlzLh6ZMpkfB0yASL8O19pkrFZ4AJ8SuwROXRcu3r08xt9o6ii6pS3sJ5sqkr7Nvf9IxtaqmTjgnwDcMyD0as/wsMb/JMTPZ9Ohk60wO5H3Xe3S01ituJKQUEN/UV3FFOu6dpzDteBAmzrtQTFyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCHZSn62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCHZSn62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7381BC4CEED;
	Tue,  8 Jul 2025 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991956;
	bh=jOOmqGqqtTenaiVXP6Gtf+y1Rm5wzk2DMd0TOe8z8Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCHZSn62xaXBPSN8Pud3PK8ydc1Vb3fETbmxOpu3yO3nNb0qccfu5lQ5Hz4fuyzCE
	 vYJeW0h1+lJqG3HHizKHID3tugNdpOQAmrA/XZ8sPD9bm4CqXxvt8ODnBmfSfhk4pF
	 kkwQk6p5ltWbah9tRbnXmMM9hIHCHcA4fEnMh/cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 14/81] mtk-sd: reset host->mrq on prepare_data() error
Date: Tue,  8 Jul 2025 18:23:06 +0200
Message-ID: <20250708162225.328150256@linuxfoundation.org>
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
@@ -1331,6 +1331,7 @@ static void msdc_ops_request(struct mmc_
 	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
 		if (!msdc_data_prepared(mrq->data)) {
+			host->mrq = NULL;
 			/*
 			 * Failed to prepare DMA area, fail fast before
 			 * starting any commands.


