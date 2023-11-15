Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAC72C870
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJ3/x4tN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D016CC433CB;
	Wed, 15 Nov 2023 19:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076460;
	bh=TQUZSgRDm/1NxYscb6WY6DNRGRRazikOuZXObIWXStA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJ3/x4tNJwZkFM+YRTl1ds2Fz0j93m5t8IeiZe+LiSIMZVg0TW9j6kl6o+mV8/eDf
	 XZwiG0wNaDWlAoCxug0kvv1N/Lyeh/1IUVnMDRCn8R9+2J729i2crN4D6tVAVBWqdy
	 aboYrNKhrBdKw0Ng85+7EXxMVsWx/vNcPA3SZKGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 280/550] soc: qcom: llcc: Handle a second device without data corruption
Date: Wed, 15 Nov 2023 14:14:24 -0500
Message-ID: <20231115191620.185520154@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 67c19ed2219a6..221a1be098d7b 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -945,6 +945,9 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 	u32 version;
 	struct regmap *regmap;
 
+	if (!IS_ERR(drv_data))
+		return -EBUSY;
+
 	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
 	if (!drv_data) {
 		ret = -ENOMEM;
-- 
2.42.0



