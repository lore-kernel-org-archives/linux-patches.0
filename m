Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1AE13AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9287C433C8;
	Mon, 26 Jun 2023 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804192;
	bh=do/DmtMPxwbRjIVCRT56rhDV2UK89+MaXz+b2J15bqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khtByKeiQqQAQRJxxAMibnJ+v8VKUICjw1FwYO7mMnDaufwSQyh4o8mttSqUaQ7XM
	 Ee+S1M6QsjjeP6whnD/6xOGbxBMurEQCWPATvr2yaawJAu1/l94Qu6vb7EmHJxPIFn
	 PyVxSuqzy0M2EwnmZwOz/RvZ7z7T8G57brRuI/6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/170] spi: spi-geni-qcom: correctly handle -EPROBE_DEFER from dma_request_chan()
Date: Mon, 26 Jun 2023 20:10:41 +0200
Message-ID: <20230626180803.872331047@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 9d7054fb3ac2e8d252aae1268f20623f244e644f ]

Now spi_geni_grab_gpi_chan() errors are correctly reported, the
-EPROBE_DEFER error should be returned from probe in case the
GPI dma driver is built as module and/or not probed yet.

Fixes: b59c122484ec ("spi: spi-geni-qcom: Add support for GPI dma")
Fixes: 6532582c353f ("spi: spi-geni-qcom: fix error handling in spi_geni_grab_gpi_chan()")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230615-topic-sm8550-upstream-fix-spi-geni-qcom-probe-v2-1-670c3d9e8c9c@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 4e83cc5b445d8..dd1581893fe72 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -595,6 +595,8 @@ static int spi_geni_init(struct spi_geni_master *mas)
 			geni_se_select_mode(se, GENI_GPI_DMA);
 			dev_dbg(mas->dev, "Using GPI DMA mode for SPI\n");
 			break;
+		} else if (ret == -EPROBE_DEFER) {
+			goto out_pm;
 		}
 		/*
 		 * in case of failure to get dma channel, we can still do the
-- 
2.39.2



