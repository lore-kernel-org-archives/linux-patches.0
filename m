Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042724;
	b=kQHBBV0yz3OwhMhK8rZsHzC/5CPZMbmXiQo/WdcLTs6W7ljJvaDDCX7FlzWue8SUamaL
	 wRhbiThu/H4CsNsxOBlrUVwc8vj9PDrK69X7QXkc9jknd9bmhHjRQ5RSXkcSTy3kg/h2S
	 dflE+ZFp98DacwLYSjGixDtvsZeN2QWAp2tGDa5rGI2H84ZmQdkf8WHUY0sxU4ucOKvFB
	 DfSuX40RMZlxdEhXh8isKe2xV38EB8I0Nny543DUhxYNWkvrVxLoWs7pOVathhm1/3CoK
	 U3ieGS7l8OLcKjzkVZMsIYdgTI6vJuEUSiNay78CwtSjoRlGnHbfflygu7qDJ5ByaLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rnv8+nphfO2iPQmzxyJGdkH62Dp37Q60Yfvwml+1FdM=;
	b=H5N0Urt/MuT/GGSO0zjD/mqJwEtTAZheKkhX5pIguV/8yDBo8LB2s12NEcDTdVwZ9d8B
	 iklbvTBj/W2byB7VDptXiY7/IV+rC3ZFz4ikBinQ1hOqD1rxi14hy2SfruK6cGxCCHmyV
	 FLU7p7K4ZjtYY7UAtEQtMSOEV+qrjFKXo1BqkQ3fC1AWROHxRYR2hyXw0Keso7ElMQsgV
	 BusML3a43XWLd/igteAOzfMU1P3rizpxdSvVyRL96HREl/ZxBit0mRhp8PdvrRLzDhE98
	 oSilWKzI2QYDd2oFX5TdYQ/RZZQbiVwRMehJ1a3YpYyiBtac7VduMntZlca0DIz5Mug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WhZ8DkDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC32606A325;
	Wed, 18 Nov 2026 22:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WhZ8DkDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED651F000C4;
	Wed, 18 Nov 2026 22:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042724;
	bh=rnv8+nphfO2iPQmzxyJGdkH62Dp37Q60Yfvwml+1FdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhZ8DkDE+CgqGExOhkiibsTauMTZi0zdv9EcMccwzhJy8aANHKXV6hyKWsDUM9qQC
	 K0A/Y+Wa/OO+H8vs+e7tvL9PbUNydnvLBwVzvm7Ep2bpmmyAenxWIRXNRtVYy2exSu
	 9kjDVUrdA2fUr+e4aDc8La4GD4Cpfp22Wsa1/DMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3245/3318] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:04:27 +0100
Message-ID: <20261118150457.013792010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea4eaa675e236..0c45993764a45 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -271,6 +271,24 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
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
@@ -411,11 +429,12 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
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



