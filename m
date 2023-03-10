Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C47D8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21316C433EF;
	Fri, 10 Mar 2023 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457908;
	bh=2ugTqTugnfclooHvcHshSwj/Ed8qm4Kln7tc39V9KIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1LAfazUAdDiVrnuFnfwxkZ8f/ZLzV1p2iBqF5kAP4Jf/av6sgJNlF823KPBy5koR
	 YfPPD7k0O2ohxy5nuvEu1U0PHX3Hqa25uFhtFnwqYNNhenFi6g1rdehIpUi7HnVcjG
	 4eiED4BKT88s5cYgOK42ubtugEjxoentEbGi0m08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ellero <l.ellero@asem.it>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/252] Input: ads7846 - dont report pressure for ads7845
Date: Fri, 10 Mar 2023 14:37:50 +0100
Message-Id: <20230310133721.842154345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Ellero <l.ellero@asem.it>

[ Upstream commit d50584d783313c8b05b84d0b07a2142f1bde46dd ]

ADS7845 doesn't support pressure.
Avoid the following error reported by libinput-list-devices:
"ADS7845 Touchscreen: kernel bug: device has min == max on ABS_PRESSURE".

Fixes: ffa458c1bd9b ("spi: ads7846 driver")
Signed-off-by: Luca Ellero <l.ellero@asem.it>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230126105227.47648-2-l.ellero@asem.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b536768234b7c..491cc7efecf9e 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1374,8 +1374,9 @@ static int ads7846_probe(struct spi_device *spi)
 			pdata->y_min ? : 0,
 			pdata->y_max ? : MAX_12BIT,
 			0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-			pdata->pressure_min, pdata->pressure_max, 0, 0);
+	if (ts->model != 7845)
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+				pdata->pressure_min, pdata->pressure_max, 0, 0);
 
 	ads7846_setup_spi_msg(ts, pdata);
 
-- 
2.39.2



