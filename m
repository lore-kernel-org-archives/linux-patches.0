Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC7D4F96A5;
	Thu, 17 Sep 2026 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664736; cv=none; b=kaQabTxczYXDS+Vwjex7Jz8PxFNlf/1NbqGTbnSGibKod5++SbyBf1DmX6sGlsPbNWws2h7Ikerv8/BbA9wIddeLP942n0MiVoaWRo7QfjFcTOd7yc2NtUF2Mjs/Ew6AcsZ5BGtUwmRfE8GNudkpgxxtMdzG6VPnFIBsEKg6Xhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664736; c=relaxed/simple;
	bh=t1j/GBhSbMr7F3P4O2hEUc7saw8aaDR+wm/QAiBDNjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxbY85BkZOlJ8fJnPc07dFx3lztc1oKXT2ie59/C57QInz2/e6YlMrUSdLoyq9TrhbvRCtWCXTuI7IliQu5uLsyOcjm47SQ99d8yLv/GHfnVQFyLaiLf3Q29OSHWxKN+aLN3Sf6y14I0021PhMRaTCX2tW/kOr0qeMwY0NBE+zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1Ludmz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1Ludmz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D50C1F0089B;
	Thu, 17 Sep 2026 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664734;
	bh=pA0rUEwudXPELaLRGYrEVbxfgNhEP/svWn+b0hIrc4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1Ludmz02qvFl9D41T2bpEbLXLWutjcmJe9+zBvYgQBkUK4GvWwbkkKylCFzSneTY
	 3wGeEyF5O5E5tsPhM674867EUdZn6FjYnV9AHl5bMuhgzN9aA/nc/BMTQAVIgr5fRj
	 RBe9pKlJDPP4VCi6bemBPUs3dmd10jgvyArVf2RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriana Stancu <adriana@arista.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0469/1250] rtc: bq32000: add delay between RTC reads
Date: Thu, 17 Sep 2026 16:04:24 +0100
Message-ID: <20260917151604.686939790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adriana Stancu <adriana@arista.com>

[ Upstream commit d4992b7050a10079bc760bdc5b8688e05a09dfc2 ]

When the RTC is used on systems without a interrupt line, userspace
tools like `hwclock` fall back to a frequent polling loop to synchronize
with the edge of the next second.

On the BQ32000, this aggressive polling can temporarly lock the register
refresh cycle, because the continuous transfers prevent the hardware from
updating the buffer. This results in stale data reads or select() timeouts
in userspace.

This patch introduces a delay before reading the RTC registers in order to
provide a sufficient idle time for the hardware to sync with the register
buffer.

Signed-off-by: Adriana Stancu <adriana@arista.com>
Link: https://patch.msgid.link/20260416142151.3385827-1-adriana@arista.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-bq32k.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index 7ad34539be4d2..245e5e45d6a16 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -16,6 +16,7 @@
 #include <linux/kstrtox.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
+#include <linux/delay.h>
 
 #define BQ32K_SECONDS		0x00	/* Seconds register address */
 #define BQ32K_SECONDS_MASK	0x7F	/* Mask over seconds value */
@@ -89,9 +90,17 @@ static int bq32k_write(struct device *dev, void *data, uint8_t off, uint8_t len)
 
 static int bq32k_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bq32k_regs regs;
 	int error;
 
+	/*
+	 * When the device doesn't have the interrupt connected, prevent
+	 * userpace from polling the RTC registers too frequently.
+	 */
+	if (client->irq <= 0)
+		usleep_range(2000, 2500);
+
 	error = bq32k_read(dev, &regs, 0, sizeof(regs));
 	if (error)
 		return error;
-- 
2.53.0



