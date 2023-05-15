Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C6A1772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B61C433EF;
	Mon, 15 May 2023 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173786;
	bh=rOD/nTUSEHzeWe4Ttb3LoCrlp++gQUsipm7h7uccAvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRgvvxj9nTrqaRmM08nd2A7/zldB+pE+f8peiFm12hOjWrReXtqWbDW8Z5GX5aHy+
	 oOvneBfLcDa8vauWj1/G2B8EvMoHZ90t3ytulRcJnK+hTtPh+wCt1NLJDHi3ywoXxN
	 8uIL0kBeCyLhTSYF4i7NK3gxxzkLOCbd3cScfQKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/282] rtc: meson-vrtc: Use ktime_get_real_ts64() to get the current time
Date: Mon, 15 May 2023 18:29:03 +0200
Message-Id: <20230515161727.156431907@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 0e6255fa3f649170da6bd1a544680589cfae1131 ]

The VRTC alarm register can be programmed with an amount of seconds
after which the SoC will be woken up by the VRTC timer again. We are
already converting the alarm time from meson_vrtc_set_alarm() to
"seconds since 1970". This means we also need to use "seconds since
1970" for the current time.

This fixes a problem where setting the alarm to one minute in the future
results in the firmware (which handles wakeup) to output (on the serial
console) that the system will be woken up in billions of seconds.
ktime_get_raw_ts64() returns the time since boot, not since 1970. Switch
to ktime_get_real_ts64() to fix the calculation of the alarm time and to
make the SoC wake up at the specified date/time. Also the firmware
(which manages suspend) now prints either 59 or 60 seconds until wakeup
(depending on how long it takes for the system to enter suspend).

Fixes: 6ef35398e827 ("rtc: Add Amlogic Virtual Wake RTC")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20230320212142.2355062-1-martin.blumenstingl@googlemail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-meson-vrtc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-meson-vrtc.c b/drivers/rtc/rtc-meson-vrtc.c
index 89e5ba0dae69f..1cf98542578fc 100644
--- a/drivers/rtc/rtc-meson-vrtc.c
+++ b/drivers/rtc/rtc-meson-vrtc.c
@@ -23,7 +23,7 @@ static int meson_vrtc_read_time(struct device *dev, struct rtc_time *tm)
 	struct timespec64 time;
 
 	dev_dbg(dev, "%s\n", __func__);
-	ktime_get_raw_ts64(&time);
+	ktime_get_real_ts64(&time);
 	rtc_time64_to_tm(time.tv_sec, tm);
 
 	return 0;
@@ -101,7 +101,7 @@ static int __maybe_unused meson_vrtc_suspend(struct device *dev)
 		long alarm_secs;
 		struct timespec64 time;
 
-		ktime_get_raw_ts64(&time);
+		ktime_get_real_ts64(&time);
 		local_time = time.tv_sec;
 
 		dev_dbg(dev, "alarm_time = %lus, local_time=%lus\n",
-- 
2.39.2



