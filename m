Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022182;
	b=rN2xt8mdXfhNyJGxTBcoqUDffuhOOq4c5FFZ6HRVZCc7pgPn+oXoAn74bdSnUAY1ZAG0
	 p8RCyL6dvy5Y28SgUk+0kHT2GGY/kJ0baUN+6OQc613pV9Mn1EZCOdsCAj4ojCcW2lMj6
	 VM6vyxOuzE40iOxZWHjYrglEzUqxIJvwsL3Vgn/xjwOU1U6ulO2uprDo9Ul3Ct7OJmEtY
	 8IzIeX0G3hrlppZxpIxdBNT4q9kotqir7SuL7/1w914WqrtR2jeG/CQzRYiKE+xywCdX5
	 y7E4hV1O0e6oFIv+VD6uxQ1np8/zzewlAX7jrGt781cMIZd09ae23KkPfbo7OnHNYwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uvj/R0q2vDE0NT5RbRrDY56B0KHwnJAZQqA9PocEWmY=;
	b=20Mt8q2qnZblEV/rQfEdtQ6ex7YF2Osxdz5Y2GKCR2k7x0UtNqfRS9YYvnSEkigLJTyn
	 w+MFj8EVDylGfJ/d7ujvCt+AD1Alk9EpIAO6OsknA2j9uEHpF1dwIU+qqTr/aR3SuXzB+
	 Yq46eN7v+LtMPpIEi2nMuYnAk9qkMay/3TjrvZ5v8FPasVi7wKzMK39V8zSloiUgyswrt
	 v/QBgonf/0GhT4Lh2NKul6o8tCm7VvQuPZAfJdhkgD+oFs8c2+YynypMo7cYQyiHLaVFW
	 +GP4e93ZgjE8aWY0292Ex/AqZI7AxJu7prYa+xUuBeMQBH+7oxrot1A1OOCekXm30tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ae7afufw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982A0606A325;
	Wed, 18 Nov 2026 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ae7afufw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45721F000C4;
	Wed, 18 Nov 2026 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022182;
	bh=uvj/R0q2vDE0NT5RbRrDY56B0KHwnJAZQqA9PocEWmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ae7afufwAtumEqYsHj+UVan0GdxrtQMuekpOppA3BkNHlT0cLkPJ0U8Pg28wkS5Ny
	 ZUYpYuqOdAj4qj/lNGN39aq6UkGvsDah901mbOluTlz//bpMb7C1ukWRyLi8XP6HWJ
	 a8rocMMw2heU3NU2dfZT919w80roXbGZ9bKZ4KJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2570/2651] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150416.910143423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4cfe7034c5165..575bb256eb258 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -270,6 +270,24 @@ static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
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
@@ -410,11 +428,12 @@ static int s35390a_rtc_ioctl(struct device *dev, unsigned int cmd,
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
 
 static int s35390a_nvmem_read(void *priv, unsigned int offset, void *val,
-- 
2.53.0



