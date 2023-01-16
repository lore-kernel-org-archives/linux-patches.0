Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DC16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079E9C433EF;
	Mon, 16 Jan 2023 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887768;
	bh=4hobMpyyOPYzNIsM7DXpq7sbaUu0tHcELctxb41cYYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRFk5e1PUAPLq5wo3U6fT63RmBPfG9j3Jzyt2Yjx+YNPUCCeWAwV9tW7FWBwPV9fX
	 Is6JJTKRGXi6/aHG20YrDFX+cCNrakburyl5CSAxTsQhcbZLoecQDIpI6DwVAua6fM
	 0WADCIT+wNGfnrLsc+b95dnClKB55jaYIXCfM84U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 275/521] rtc: snvs: Allow a time difference on clock register read
Date: Mon, 16 Jan 2023 16:48:57 +0100
Message-Id: <20230116154859.459928263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit 0462681e207ccc44778a77b3297af728b1cf5b9f ]

On an iMX6ULL the following message appears when a wakealarm is set:

echo 0 > /sys/class/rtc/rtc1/wakealarm
rtc rtc1: Timeout trying to get valid LPSRT Counter read

This does not always happen but is reproducible quite often (7 out of 10
times). The problem appears because the iMX6ULL is not able to read the
registers within one 32kHz clock cycle which is the base clock of the
RTC. Therefore, this patch allows a difference of up to 320 cycles
(10ms). 10ms was chosen to be big enough even on systems with less cpu
power (e.g. iMX6ULL). According to the reference manual a difference is
fine:
- If the two consecutive reads are similar, the value is correct.
The values have to be similar, not equal.

Fixes: cd7f3a249dbe ("rtc: snvs: Add timeouts to avoid kernel lockups")
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco@dolcini.it>
Link: https://lore.kernel.org/r/20221106115915.7930-1-francesco@dolcini.it
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-snvs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index 3cf011e12053..b1e13f2877ad 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -32,6 +32,14 @@
 #define SNVS_LPPGDR_INIT	0x41736166
 #define CNTR_TO_SECS_SH		15
 
+/* The maximum RTC clock cycles that are allowed to pass between two
+ * consecutive clock counter register reads. If the values are corrupted a
+ * bigger difference is expected. The RTC frequency is 32kHz. With 320 cycles
+ * we end at 10ms which should be enough for most cases. If it once takes
+ * longer than expected we do a retry.
+ */
+#define MAX_RTC_READ_DIFF_CYCLES	320
+
 struct snvs_rtc_data {
 	struct rtc_device *rtc;
 	struct regmap *regmap;
@@ -56,6 +64,7 @@ static u64 rtc_read_lpsrt(struct snvs_rtc_data *data)
 static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 {
 	u64 read1, read2;
+	s64 diff;
 	unsigned int timeout = 100;
 
 	/* As expected, the registers might update between the read of the LSB
@@ -66,7 +75,8 @@ static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 	do {
 		read2 = read1;
 		read1 = rtc_read_lpsrt(data);
-	} while (read1 != read2 && --timeout);
+		diff = read1 - read2;
+	} while (((diff < 0) || (diff > MAX_RTC_READ_DIFF_CYCLES)) && --timeout);
 	if (!timeout)
 		dev_err(&data->rtc->dev, "Timeout trying to get valid LPSRT Counter read\n");
 
@@ -78,13 +88,15 @@ static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 static int rtc_read_lp_counter_lsb(struct snvs_rtc_data *data, u32 *lsb)
 {
 	u32 count1, count2;
+	s32 diff;
 	unsigned int timeout = 100;
 
 	regmap_read(data->regmap, data->offset + SNVS_LPSRTCLR, &count1);
 	do {
 		count2 = count1;
 		regmap_read(data->regmap, data->offset + SNVS_LPSRTCLR, &count1);
-	} while (count1 != count2 && --timeout);
+		diff = count1 - count2;
+	} while (((diff < 0) || (diff > MAX_RTC_READ_DIFF_CYCLES)) && --timeout);
 	if (!timeout) {
 		dev_err(&data->rtc->dev, "Timeout trying to get valid LPSRT Counter read\n");
 		return -ETIMEDOUT;
-- 
2.35.1



