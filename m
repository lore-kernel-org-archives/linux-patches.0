Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050678;
	b=jJlEqrAVYhaLXp2Dj/hGEBGJRJggGuvmVZic96hMys2VCL73oArU3nIzZBpfKr/6AsWM
	 PLEg5hLZ9HAh55JrEk/yw5qX8TLW9zdbY4xiVcfX/DvwR/4HgbvUVCmBnQqWXbXbuHoLz
	 ZWPtMkXSISuB7yHOd8yNQ6xhMTVV6xgz7YWyEPV7kR22/m5p90/9nLBiwFspFpIN975K6
	 guIBKHePNjR2w6okIyoXM1ctLwjTntK1S+Q9xFNTJYkoakaiaSovt8MamPfWH04Y5Z6bM
	 h/lLDoG6X0vyK6YzvdoW6AbiuKaypqYtYRA9JZIyHhg5GzufVDUqb36JeaUHMOqpwoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tewg7IE65hNrQt8w/SLgglqC692X/FTPY/gCBw7WbK0=;
	b=hHAOSLSgDZmyNwHw3dIiFYXv8vKpsuPIcEwm4JaaI7AfTW2f02OmbkFUW2NqnFSnqk25
	 j3ieIm4czq03kWxSQUSWHFW6pC9IkymdsmnN/5DeGcVWLaNvbXBZhGraVoVgWpE+J5CT3
	 6/2TkRYz8AAVATcfelSpVZYHPc6fqghOj22tF2ydwTEPWE1NrxZY1v9tbbrlmcKz+E86r
	 v8vYqlWzLQMVuM1f/OnC/uBdicy6mM7E4vb4lkMMgcx1q01r+ePnG1zYQnTtDfXH9wqRp
	 QwsaPFAgbek9PmrbPJi8rntsuoeOZ+SfgDGGVrPZ2Y3qD/+RwOJdtPjuZ6o1E8qL6/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odkgGqxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F274A606A325;
	Thu, 19 Nov 2026 01:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odkgGqxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB09F1F000CA;
	Thu, 19 Nov 2026 01:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050677;
	bh=Tewg7IE65hNrQt8w/SLgglqC692X/FTPY/gCBw7WbK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odkgGqxNeFk33WollCFr9ja4igkVYti5K9tbFNzmyJqCiL+wwWpHgaP36avXtsMmt
	 Y1qmxRxW4lUS9qRjrOL3zR+JN9oKya6z0D3vOzXrDoDWOGNMpOTGybUXQz6sX5JNZo
	 m+F5qKCecg51luMhETjNn+NSVGvkQs019Dt8BHsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2792/2857] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:03:46 +0100
Message-ID: <20261118150342.127161730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Probst <markus.probst@posteo.de>

[ Upstream commit d93f29e41089bbb14637289fe77bdd72b71e9ac5 ]

Implement alarm_irq_enable callback.

Fixes: 542dd33a4925 ("drivers/rtc/rtc-s35390a.c: add wakealarm support for rtc-s35390A rtc chip")
Signed-off-by: Markus Probst <markus.probst@posteo.de>
Link: https://patch.msgid.link/20260930-rtc_s35390a_int1-v10-3-e7b1cbc50a7b@posteo.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 2509beac5009d..c10765959d101 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -273,6 +273,24 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
+static int s35390a_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct s35390a *s35390a = dev_get_drvdata(dev);
+	u8 sts;
+	int err;
+
+	if (enabled)
+		sts = S35390A_INT2_MODE_ALARM;
+	else
+		sts = S35390A_INT2_MODE_NOINTR;
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -413,11 +431,12 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
 }
 
 static const struct rtc_class_ops s35390a_rtc_ops = {
-	.read_time	= s35390a_rtc_read_time,
-	.set_time	= s35390a_rtc_set_time,
-	.set_alarm	= s35390a_rtc_set_alarm,
-	.read_alarm	= s35390a_rtc_read_alarm,
-	.ioctl          = s35390a_rtc_ioctl,
+	.read_time		= s35390a_rtc_read_time,
+	.set_time		= s35390a_rtc_set_time,
+	.set_alarm		= s35390a_rtc_set_alarm,
+	.read_alarm		= s35390a_rtc_read_alarm,
+	.alarm_irq_enable	= s35390a_rtc_alarm_irq_enable,
+	.ioctl			= s35390a_rtc_ioctl,
 };
 
 static int s35390a_probe(struct i2c_client *client)
-- 
2.53.0



