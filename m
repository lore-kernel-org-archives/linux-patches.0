Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E17A2585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832BDC433D2;
	Mon, 12 Dec 2022 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850802;
	bh=DtBcW4tLmfFdZQNo6uBCQ9zPwq/osweAonFwdx/01vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcZa0EUWwuH3bu0GECT6PjeNwJNhSYMA3N0nnWLz0AmHFKpeIae25b7TKM2H7GYXX
	 dWFT+2jRl0B/p7mZ0KXdMMtALxJEgtizJ/pkFj+CtizgOZ6y5ij+gIzDPK3jjuMUDJ
	 y43AReMP5Am4xYRRILvyp6f9VsJNNpkurrs16qy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Belyshev <belyshev@depni.sinp.msu.ru>,
	Dirk Gouders <dirk@gouders.net>,
	Borislav Petkov <bp@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Len Brown <len.brown@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/106] rtc: mc146818: Dont test for bit 0-5 in Register D
Date: Mon, 12 Dec 2022 14:09:35 +0100
Message-Id: <20221212130926.253163292@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit ebb22a05943666155e6da04407cc6e913974c78c ]

The recent change to validate the RTC turned out to be overly tight.

While it cures the problem on the reporters machine it breaks machines
with Intel chipsets which use bit 0-5 of the D register. So check only
for bit 6 being 0 which is the case on these Intel machines as well.

Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
Reported-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Reported-by: Dirk Gouders <dirk@gouders.net>
Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Dirk Gouders <dirk@gouders.net>
Tested-by: Len Brown <len.brown@intel.com>
Tested-by: Borislav Petkov <bp@suse.de>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/87zh0nbnha.fsf@nanos.tec.linutronix.de
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c         | 4 ++--
 drivers/rtc/rtc-mc146818-lib.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index cce4b62ffdd0..8e8ce40f6440 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -808,8 +808,8 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	spin_lock_irq(&rtc_lock);
 
-	/* Ensure that the RTC is accessible. Bit 0-6 must be 0! */
-	if ((CMOS_READ(RTC_VALID) & 0x7f) != 0) {
+	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
+	if ((CMOS_READ(RTC_VALID) & 0x40) != 0) {
 		spin_unlock_irq(&rtc_lock);
 		dev_warn(dev, "not accessible\n");
 		retval = -ENXIO;
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 7f01dc41271d..6ed2cd5d2bba 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -21,8 +21,8 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 
 again:
 	spin_lock_irqsave(&rtc_lock, flags);
-	/* Ensure that the RTC is accessible. Bit 0-6 must be 0! */
-	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x7f) != 0)) {
+	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
+	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
 		spin_unlock_irqrestore(&rtc_lock, flags);
 		memset(time, 0xff, sizeof(*time));
 		return 0;
-- 
2.35.1



