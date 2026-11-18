Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033138;
	b=3Iukr+Y+Nm7lIx7D9PLTAM7v7huJ33NmVj0QxyJI7VQW5ffcaM4RTGNULGQMqhq4WCr1
	 9YWVvnfry/lXkRGlqLS5i62BAtOS8m5aTOLWp4JzuK3qzdMfTK4eOC5JruWV6pquWWRJf
	 qiQVJmoz+En7iDhE6vuneiKfiNNW+u84oIlBx8dbBaLrNotXzuwW77ztlwqL6FVhOvBk9
	 CLDwvgemRB8BYS35q+f1FM4pUoCUsy8se+4ft8vLZ6MYe5pQndei+b97w0m+JXEfARH3Z
	 UfeR9GCAor736bYV39jEhKpdavOmbUzdh4VKgOKjhAtRlMF121mjf1RQ5Gpaq0a1kmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IaJ1VTXi3lPzEhHPHnXyOegSzrK/SKuM0kvTToTJG6k=;
	b=wXlb/5i3LF5W4I/HnZqMV9MTIpCmBWF9leoLD4rn1EbPCFn4jWxXCiBMlHj04qvsBYNV
	 cZHuPdp2nfoaL7d1fHD392EAikkx28Ixkk8EWkBu4SEsuD/7ThbrPGv23QqiyYWX2hyhk
	 hGj8CsE6ku0RKn8OREJTTV1x0l3D0i/522SI5fWJKNTOy6X5eOcPj//GaSzujhBl9BRjJ
	 fMEu+gpfDP14stLPZqAs2nQ2JY05l6APH+iHnHwmQurnlelc1zmyCZDwaT+aM9BfhUfJE
	 s1QIyTHEZC5D4+IbRCLM+W5H9drFefUvFUaY3h7pH9SMk28351QfKBwSU6RKQtNIdkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlOZExV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57605606A336;
	Wed, 18 Nov 2026 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlOZExV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4DB1F000C4;
	Wed, 18 Nov 2026 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033138;
	bh=IaJ1VTXi3lPzEhHPHnXyOegSzrK/SKuM0kvTToTJG6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlOZExV2A7OUZQoSCXecDuX+cmlaJdrl9tlt5iQO8CriNUcb2J4Cdf2Qqjdj0EQwS
	 MFOxUrP0ltvurV0tdaa4E/KWHkrKbwKuDayT1lkJmLXlCabTt1QHAEwecqBE8KRwIQ
	 tdnx4jWy24mKPvX21I5Rd9/K8JZnT/ra1qTHS76Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1662/1756] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:03:09 +0100
Message-ID: <20261118150115.875031821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a680d2c354261..d7e6c4ada3628 100644
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
 
 static int s35390a_probe(struct i2c_client *client)
-- 
2.53.0



