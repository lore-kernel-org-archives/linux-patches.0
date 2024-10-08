Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B91DE2AD;
	Tue,  8 Oct 2024 12:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391548; cv=none; b=AF9Q+NPgH+5SdcI6kcDv7pfJrbtS8Y2wAim3JnhK7wu4OTkxsI2fZI1LSWNWS1Y3suQCdhhSiEmBj0HbDyxIAAWBKr1lnjwCu1srZx0KmdXHbCFgO5pP5qOLd6KN/7MyVO/yNPSWkLolYbEdRUDDoGeJh/u2Lh1X50miy1hx3Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391548; c=relaxed/simple;
	bh=3B5Cq3Kh48Du9mhFUpcl0FPTfvr+4p2Ur3sawLJFcMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVMB1Bj3c8TgDDfKBOwWEDHxC/dnUB35mqrioFZ1PHKIdhDdI0pB5Gidfoo1V5Q5Fh3LhgkNKlibzzU44NRSeMuwb019rapxYgrn+oiaBOpyL/gMLOIGXjoO+cyG3nGGLZZ/9MaV5Aslo2zbxIOJcE5GQbACzOex4U1uFQWe4kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1v4DzHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1v4DzHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98415C4CEC7;
	Tue,  8 Oct 2024 12:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391548;
	bh=3B5Cq3Kh48Du9mhFUpcl0FPTfvr+4p2Ur3sawLJFcMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1v4DzHgZDdf+RQBFpSIyveN34XyNvl68lk9IaZbTG/OC34FI8YO2DFIfAzjGZYm8
	 tty3oD8MRNwDd6dcJyTlETCBQIWV6x/0Ggi+ayjLZVmeAyga4Bu7i/2e4g05z7kvHr
	 QaOLRTf8Ua+CmbZoZ0EpdqS5ENvaZbg2N9yHiUk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 149/558] wifi: wilc1000: Do not operate uninitialized hardware during suspend/resume
Date: Tue,  8 Oct 2024 14:02:59 +0200
Message-ID: <20241008115708.227307267@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit b0dc7018477e8fbb7e40c908c29cf663d06b17a7 ]

In case the hardware is not initialized, do not operate it during
suspend/resume cycle, the hardware is already off so there is no
reason to access it.

In fact, wilc_sdio_enable_interrupt() in the resume callback does
interfere with the same call when initializing the hardware after
resume and makes such initialization after resume fail. Fix this
by not operating uninitialized hardware during suspend/resume.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240821183639.163187-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 0043f7a0fdf97..7999aeb76901f 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -977,6 +977,9 @@ static int wilc_sdio_suspend(struct device *dev)
 
 	dev_info(dev, "sdio suspend\n");
 
+	if (!wilc->initialized)
+		return 0;
+
 	if (!IS_ERR(wilc->rtc_clk))
 		clk_disable_unprepare(wilc->rtc_clk);
 
@@ -999,6 +1002,10 @@ static int wilc_sdio_resume(struct device *dev)
 	struct wilc *wilc = sdio_get_drvdata(func);
 
 	dev_info(dev, "sdio resume\n");
+
+	if (!wilc->initialized)
+		return 0;
+
 	wilc_sdio_init(wilc, true);
 	wilc_sdio_enable_interrupt(wilc);
 
-- 
2.43.0



