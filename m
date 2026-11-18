Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056958;
	b=KdBEEQTT0S8AqAk+mGR7ZulBiFcOUqbBjQ2rgkmRa2JyPQIgVTYHfqUUz4WOUAj8d9GE
	 Y12yD4VAVUowdKIQTLSW3+LUOojgJbSpo+49lGS3q7dHUjgBSdZrE93pv+2p5cr/fgWBC
	 Fg9jPrZuvbiXJXeilVRQ1sgzL79fJbBObeXgbzcnrTgL0mOpnxlHLH7/7LwygAd9vs15y
	 TrVa2272UK3Hlv6brcuO0X+8XUircp+FhUMw0UFrzC81Kmdz2GAQ5JCN5xisMYLYUKMRz
	 p8jRnMi+r8ZEEtaMbk3BfKlP91hQFZBwWgl4ZdDEYC/V14w8n856Yv7XM1Z8vXqot1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrwM5cWFZ4B3AWGX/esKdA/2S0HmdDZJif/q9oqdYSI=;
	b=TgmhygRJh5dMFGh3r7pbeBH4vywW7RZdmzfCdMSlXevvszUa3UpETSWmKAS5TvyThRLl
	 Sq9B+GtVCG5YZuqsWcJW9yqADXbsV0IhBszNfZIJ7QBc94VfyIIg0DKIYiutoMZJ69hCW
	 sudQjQAHlXnWD/fhydJWLK1NiGeSh2IKBWaEH/jpDEZM0tzdED1V81ahKMi48nFvhNNmg
	 EqzDn6chGTSbunnStIccFbwE7hwQjgvIehzOUjIhrkORJQ+v9fsdpce41OrlB4KzkPKRJ
	 EXEruk+OxRnSlflIBozTjG5ewZ3kj901rXj8tsZe+49KudCYJR8AfXiFDdu9JzmjAUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRD1VZka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B840606A320;
	Thu, 19 Nov 2026 02:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRD1VZka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8D21F000C4;
	Thu, 19 Nov 2026 02:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056957;
	bh=vrwM5cWFZ4B3AWGX/esKdA/2S0HmdDZJif/q9oqdYSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRD1VZkaCTrb89zNi8fJJAe5a294iCwm+2f41uKv2TYoDsJ+pMIQQmEz1Rb81kyQY
	 kzrq2pUOf/DMBDR7L5njUpm1H9i2i/m0JGZVmp/aPZd1xp5T5EbbLJA+ChCMxyTP4x
	 RghUQW6IYIcUv7pV5+6sN6sS2axGS4jbLRcnZIkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2166/2214] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:04:02 +0100
Message-ID: <20261118150137.073058519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e669b75b408a..2da889e94dac8 100644
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
@@ -416,11 +434,12 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
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
 
 static int s35390a_probe(struct i2c_client *client,
-- 
2.53.0



