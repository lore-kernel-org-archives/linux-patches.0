Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF5B79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F62C433D2;
	Thu, 12 Jan 2023 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533280;
	bh=Bc1eUI1kKP9fjBGjAy5LJ4KOESeJp26YxdieRxUed4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAgqjPvFCZRed3sENnMtyqBYD7SRkda4YhQoJCvGpLIdI8N8kGpA+LMxWb7pTfwyW
	 zMm8HuHk9rKbDVx+iiCMWjVISoZN5siXDrJgCvlWyP3ObRGDv/ZNVtrJa26NRFiCJj
	 uO7eV01VXpS8kWOhOWXYaexVuYS2I7dGxEjM3IVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/783] rtc: pcf85063: Fix reading alarm
Date: Thu, 12 Jan 2023 14:52:23 +0100
Message-Id: <20230112135544.108224765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit a6ceee26fd5ed9b5bd37322b1ca88e4548cee4a3 ]

If the alarms are disabled the topmost bit (AEN_*) is set in the alarm
registers. This is also interpreted in BCD number leading to this warning:
rtc rtc0: invalid alarm value: 2022-09-21T80:80:80

Fix this by masking alarm enabling and reserved bits.

Fixes: 05cb3a56ee8c ("rtc: pcf85063: add alarm support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220921074141.3903104-1-alexander.stein@ew.tq-group.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index 62684ca3a665..d739b0c965aa 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -167,10 +167,10 @@ static int pcf85063_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret)
 		return ret;
 
-	alrm->time.tm_sec = bcd2bin(buf[0]);
-	alrm->time.tm_min = bcd2bin(buf[1]);
-	alrm->time.tm_hour = bcd2bin(buf[2]);
-	alrm->time.tm_mday = bcd2bin(buf[3]);
+	alrm->time.tm_sec = bcd2bin(buf[0] & 0x7f);
+	alrm->time.tm_min = bcd2bin(buf[1] & 0x7f);
+	alrm->time.tm_hour = bcd2bin(buf[2] & 0x3f);
+	alrm->time.tm_mday = bcd2bin(buf[3] & 0x3f);
 
 	ret = regmap_read(pcf85063->regmap, PCF85063_REG_CTRL2, &val);
 	if (ret)
-- 
2.35.1



