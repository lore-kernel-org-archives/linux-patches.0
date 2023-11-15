Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A1045BF1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5PDXbsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E52C433C7;
	Wed, 15 Nov 2023 22:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085776;
	bh=PCewESNMSe6KZqLZ5t4XXt7BYlFw6GvTkz74ce1IcT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5PDXbsVQTGVt9ya3XGCtd8txxFDSwfc4TNHfH1aP9zLjVV4dqCSmznvX618Vh5Ho
	 vGQxlTIr/OQdwn+skiQFs7QilYSjFU1f3k9gFDiMQrv/GN/8z49ZLCLqhSzOdrI7As
	 bh6Nthbu4Ssmj0JNW9FR3kS624f8yW5TQMFuwUy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/119] soc: qcom: llcc: Handle a second device without data corruption
Date: Wed, 15 Nov 2023 17:00:37 -0500
Message-ID: <20231115220134.094018747@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit f1a1bc8775b26345aba2be278118999e7f661d3d ]

Usually there is only one llcc device. But if there were a second, even
a failed probe call would modify the global drv_data pointer. So check
if drv_data is valid before overwriting it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
Link: https://lore.kernel.org/r/20230926083229.2073890-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 19039f19af971..431b214975c85 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -356,6 +356,9 @@ static int qcom_llcc_probe(struct platform_device *pdev,
 	int ret, i;
 	struct platform_device *llcc_edac;
 
+	if (!IS_ERR(drv_data))
+		return -EBUSY;
+
 	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
 	if (!drv_data) {
 		ret = -ENOMEM;
-- 
2.42.0



