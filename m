Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D9B8825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB52C433D2;
	Fri, 10 Mar 2023 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460192;
	bh=AIIVqu2N5Ht/vwSzmhL714X2QfHfG+2igVdoJxiaMxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nU4KiS45A6OPJ1tUGzKSIKKH04kw7L29hVIuoqET6Aar4cy5kHs35jFUj5i4aYSzh
	 FAoD/LO0LGvBKOvrMtm5yynd7IqxjrXpmfQODGKZ5W6ZifxGAUpaIp0Rr+B+kJqqmL
	 81OvrI4hzoWmgY0tz5zWfDNrs4dTLpwno3z6DpYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ellero <l.ellero@asem.it>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/529] Input: ads7846 - dont check penirq immediately for 7845
Date: Fri, 10 Mar 2023 14:36:29 +0100
Message-Id: <20230310133816.359562306@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit fa9f4275b20ec7b2a8fb05c66362d10b36f9efec ]

To discard false readings, one should use "ti,penirq-recheck-delay-usecs".
Checking get_pendown_state() at the beginning, most of the time fails
causing malfunctioning.

Fixes: ffa458c1bd9b ("spi: ads7846 driver")
Signed-off-by: Luca Ellero <l.ellero@asem.it>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230126105227.47648-4-l.ellero@asem.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 9f5cc42a567a5..1753288cedde7 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -852,14 +852,8 @@ static void ads7846_report_state(struct ads7846 *ts)
 	if (x == MAX_12BIT)
 		x = 0;
 
-	if (ts->model == 7843) {
+	if (ts->model == 7843 || ts->model == 7845) {
 		Rt = ts->pressure_max / 2;
-	} else if (ts->model == 7845) {
-		if (get_pendown_state(ts))
-			Rt = ts->pressure_max / 2;
-		else
-			Rt = 0;
-		dev_vdbg(&ts->spi->dev, "x/y: %d/%d, PD %d\n", x, y, Rt);
 	} else if (likely(x && z1)) {
 		/* compute touch pressure resistance using equation #2 */
 		Rt = z2;
-- 
2.39.2



