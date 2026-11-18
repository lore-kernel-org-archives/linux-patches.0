Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057019;
	b=IX5VMnWrzZHaseSOUTVzNii0idTscxAC2EXBXJrsVK3V9u5sRb4asDdHkI2zuTSOVYce
	 MG3ujncK5fYabl+pucoe7IfQQTedGF+OfJnXB8Rr7Eih9XqxwIPbYeeIcVP2EqHtRdISY
	 iEHaJgDyB4k7yX//BduPN0QlE2qeShfM7x3HpxOsKfQ36qrrBG6CA7zKee3bKcdL+RVqf
	 l7rPVPVOnG2GSQijnF4tawjFoUZkzjxdNK6Ef0ETkt0tPERLfrHgoJCpjUNjEznMg4enX
	 co2Tssittj/ccVPeAPEALY3pe1ICiZhG6zNY0m4XodNdeczqbmj2oF3xvXDLMnHWiNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXtS+Yje+yo/Lm2qPzQ19TEntKINiET5AMPyhfYpBbM=;
	b=FqAwGTQKrhvDbjEVHyR1vxNbAZSq6n0NBEyjp2306E5I3y9h6FGiMtwwNOPvTI2Mso9W
	 BfilJvFwA6Z73XhC2XVI+iCpiyWS1DocF9DSLOYvDN8uHfGhSHo8ElITMp0XcYLKkJjY0
	 4HKHy18sO4TlWxSmxE+s/E3ncs92kiatbBhIiFAhfEMh2VRHSRFcGl7kTgDR/ut5MBVP9
	 i+3D6xW+Stkwvcym19fFnIS6LpdgvKbUioJR+mqdv6UEpGIb4KDAucNCgLRVvXELmk4AJ
	 V0XUhI324xSt+qN0W2vRAYrZBZ7XDH3oXByYDxg4Qusyap7cU9RR+Mh4ZvFOWQN22mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnODqhu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EF7606A337;
	Thu, 19 Nov 2026 02:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnODqhu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13411F000C6;
	Thu, 19 Nov 2026 02:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057019;
	bh=WXtS+Yje+yo/Lm2qPzQ19TEntKINiET5AMPyhfYpBbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnODqhu7K2o1IBth+oa1/yiNAXC2k/AG/jur5E+AChcOc9JKOR8B7I41KlTyAqyzk
	 fF20MRdXzeaw6bhOt7jnG6gcRz++XUVxLPKZAHLqGXyqrhIWxVfbnH6UxlfKHdHGcG
	 Ui5qK9RKQxbK17dOcvX4EESFuhdstj4zQmSENd3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2168/2214] rtc: s35390a: let the core handle the alarm resolution
Date: Wed, 18 Nov 2026 16:04:04 +0100
Message-ID: <20261118150137.144927258@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 654815eff130a42e861241b848dfea2c50d6c7b1 ]

Tell the RTC core UIE are not supported because the resolution of the alarm
is a minute.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211107225458.111068-2-alexandre.belloni@bootlin.com
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 2da889e94dac8..ced6c0497ed6e 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -303,9 +303,6 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 		alm->time.tm_min, alm->time.tm_hour, alm->time.tm_mday,
 		alm->time.tm_mon, alm->time.tm_year, alm->time.tm_wday);
 
-	if (alm->time.tm_sec != 0)
-		dev_warn(&client->dev, "Alarms are only supported on a per minute basis!\n");
-
 	/* disable interrupt (which deasserts the irq line) */
 	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
 	if (err < 0)
@@ -510,8 +507,8 @@ static int s35390a_probe(struct i2c_client *client,
 	s35390a->rtc->range_min = RTC_TIMESTAMP_BEGIN_2000;
 	s35390a->rtc->range_max = RTC_TIMESTAMP_END_2099;
 
-	/* supports per-minute alarms only, therefore set uie_unsupported */
-	s35390a->rtc->uie_unsupported = 1;
+	set_bit(RTC_FEATURE_ALARM_RES_MINUTE, s35390a->rtc->features);
+	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, s35390a->rtc->features );
 
 	if (status1 & S35390A_FLAG_INT2)
 		rtc_update_irq(s35390a->rtc, 1, RTC_AF);
-- 
2.53.0



