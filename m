Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062163;
	b=OZthPHtGT268aoWiaJ8y4A9ToT/L6Y2HIp4YJrwfA6895DeZ5bNa7YNfduT79Z6hI/XX
	 S5wXa2JKKShU4L9r86xx91iVekJiDxzB8mFeU7RUrqLXWRPHB0bBDHKQblytSSZSoRafu
	 t7Pi8S4jCo3mQ6GzlZAYzjrU7m/WIPdkYumWbFkAKW17fH+rnIQeWCrIdiyHe1GmISK/N
	 KeiUHyDKo+0D7k1sDGwQsV1y/iT2CjKbkyvKAg09iBgRawcbYFe/VBcLhSS8L+e63VmZH
	 PYY9bms7emnjN4/eYm0S2yB/hxdMoyrg9CqXleWQ1dABF+Z4rjGJEK/wwjNufAFCTjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PCxdpI7oJv5fKRKuJ9YCxuNNsf5n4QbT96qTtnEh2/I=;
	b=c2tr6wlx3GmejZ8P3DK3mI+f9brMLhKTME6fvl0dfzQKAtDnfioony5vWkhOoc+8QI9I
	 PDx+P6yRxF6qmVEqbIz5vsSsJe9bvAtamN6Q60llTwa0ZQ53o11Qfmm6ds5Sv5WFA6SqM
	 siLVaMUPc7+8BgqzjLYm4ZxJLFekBBmg/sZByHMP5oF5l10iSiTrve+PR0qeKm+pWiDlb
	 xabym56yUNqrmRDzgDDOnWjVivSv1Mm02qEePUpR6VlSKBGU83EdJxTSeOBxxIyJ2Tj0k
	 G0fk61lq2QwxTwQ0e814q2s6x7KxwjOeNLAbVx5LXjYqehkrEMfYjkEXy0Co572ss7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y797wilm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BD606A320;
	Thu, 19 Nov 2026 04:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y797wilm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13311F000C4;
	Thu, 19 Nov 2026 04:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062163;
	bh=PCxdpI7oJv5fKRKuJ9YCxuNNsf5n4QbT96qTtnEh2/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y797wilmoFJAJChy85Luy6pWItthw81q7BuRRSGwMTg3Uiyu4JZQAmhCMeGPungNu
	 rC37eIZR2ebbgr+upwxr6liIhdf7KQLEkm7hcT1ftFbxP2oGsJMlHAqU4JP/V881s6
	 r8YQATHfsh6HFxJEJJtFThWKojOZSLxgtJPZDp7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Probst <markus.probst@posteo.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1811/1848] rtc: s35390a: Fix alarm not disabling
Date: Wed, 18 Nov 2026 16:04:09 +0100
Message-ID: <20261118150035.215931610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5447f116cc910..2268599568a09 100644
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



