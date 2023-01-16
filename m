Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8956646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128CAC433D2;
	Mon, 16 Jan 2023 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886240;
	bh=FW7CGrZV/kvR8I7UMOMeN5n32Ze7WNYky3wgk6AcdBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQ3guInovLLC7MDasSjS8ZmBGXQRe0uOlu0iRwmOoYLW8/5jz2hJ3E8+mnRenNkp2
	 uVvYA228VAMfMoOEST65af4Klb1srG160SQ/kTIv6sXd6IuSApRnS5AfhcbLYWeJH8
	 L5pRnV0I6oQV4wpI7LREM04uHL0Lk+ZqkqsuYKNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 348/658] rtc: pcf85063: Fix reading alarm
Date: Mon, 16 Jan 2023 16:47:16 +0100
Message-Id: <20230116154925.477301463@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 1afa6d9fa9fb..3e7ea5244562 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -159,10 +159,10 @@ static int pcf85063_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
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



