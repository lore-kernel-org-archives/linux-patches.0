Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A9211706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7405C433C7;
	Mon, 11 Sep 2023 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444583;
	bh=U/9f/Cj+XMj/K5tM5YSrdtO7C+Xb2u5hCtFBue192eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEX4iTYkcOKAfhNQwj0qFv7Ct/gVd26G0N5cnBtxIn9iNKMe8h1Sl+hyA7N34h20e
	 BDiJvdqqn6c8Vcxt2gWxx+yP5ge/Ep3e4WSW0dBRFMYZYfRFzIln7JVWNCr51+6b9I
	 gMIPIl821u0bd1QKtJor5CQokTGNtFE/FIpaVIDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/600] ata: pata_arasan_cf: Use dev_err_probe() instead dev_err() in data_xfer()
Date: Mon, 11 Sep 2023 15:41:16 +0200
Message-ID: <20230911134634.869133962@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Minjie Du <duminjie@vivo.com>

[ Upstream commit 4139f992c49356391fb086c0c8ce51f66c26d623 ]

It is possible for dma_request_chan() to return EPROBE_DEFER, which
means acdev->host->dev is not ready yet. At this point dev_err() will
have no output. Use dev_err_probe() instead.

Signed-off-by: Minjie Du <duminjie@vivo.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_arasan_cf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index e89617ed9175b..46588fc829432 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -529,7 +529,8 @@ static void data_xfer(struct work_struct *work)
 	/* dma_request_channel may sleep, so calling from process context */
 	acdev->dma_chan = dma_request_chan(acdev->host->dev, "data");
 	if (IS_ERR(acdev->dma_chan)) {
-		dev_err(acdev->host->dev, "Unable to get dma_chan\n");
+		dev_err_probe(acdev->host->dev, PTR_ERR(acdev->dma_chan),
+			      "Unable to get dma_chan\n");
 		acdev->dma_chan = NULL;
 		goto chan_request_fail;
 	}
-- 
2.40.1



