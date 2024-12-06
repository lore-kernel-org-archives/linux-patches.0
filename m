Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116C41514CE;
	Fri,  6 Dec 2024 15:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498420; cv=none; b=JcJytCagcxLr1sAMfrqz+AJYquE/9nHvTDteiAXO9aa2Xhx2WRZUUPMCPKlIy66ZLYDVvzT1RIDCpYEvkayGaQJgNdU+0SlZpU9bxO+QXIcQ4UT8CakAtA29KOUgFRq3COuqvFrTC7mLkBsazjkIlmMHnpF8vECFUjdpgN0s5m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498420; c=relaxed/simple;
	bh=lk0TOXTowgnA98S2R2WSArGStNmHD2T2FD92LSFoYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro++3n7KMeL8Hp72rNIKeb6Tbipd+4dtne+WIVfmMxwgwG0lx3TTPeh6kGewQGTY4vGvqRHvlDKsBizYXdTa87KZuR0S8Xpmn2it1e8CVLkCsLK9WPhx7BB/uAIFQ4gK9CNJZeDe0EDim3IGSUYPNUmNfD4cJhc4cqPgDjNXQgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGyL5W0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGyL5W0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4A0C4CED1;
	Fri,  6 Dec 2024 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498419;
	bh=lk0TOXTowgnA98S2R2WSArGStNmHD2T2FD92LSFoYXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGyL5W0PrR1FW1aaD3TNwelq7yMIXc58RPgPUgoeEaliL63j8mqcQ0LLeE/xkezOZ
	 YTK/ZgJ1TmogdEZQJOfENwfY3AOGFt/BK5R/IX+gA7BeUbLDebyC1ShmOB91Hz1uSn
	 GT10+WIXgkadJijCfwTiU7kXpJgDCa8eADky1GTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 579/676] rtc: ab-eoz9: dont fail temperature reads on undervoltage notification
Date: Fri,  6 Dec 2024 15:36:38 +0100
Message-ID: <20241206143715.978263074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit e0779a0dcf41a6452ac0a169cd96863feb5787c7 ]

The undervoltage flags reported by the RTC are useful to know if the
time and date are reliable after a reboot. Although the threshold VLOW1
indicates that the thermometer has been shutdown and time compensation
is off, it doesn't mean that the temperature readout is currently
impossible.

As the system is running, the RTC voltage is now fully established and
we can read the temperature.

Fixes: 67075b63cce2 ("rtc: add AB-RTCMC-32.768kHz-EOZ9 RTC support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://lore.kernel.org/r/20241122101031.68916-3-maxime.chevallier@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ab-eoz9.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index 04e1b8e93bc1c..79d5ee7b818c5 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -396,13 +396,6 @@ static int abeoz9z3_temp_read(struct device *dev,
 	if (ret < 0)
 		return ret;
 
-	if ((val & ABEOZ9_REG_CTRL_STATUS_V1F) ||
-	    (val & ABEOZ9_REG_CTRL_STATUS_V2F)) {
-		dev_err(dev,
-			"thermometer might be disabled due to low voltage\n");
-		return -EINVAL;
-	}
-
 	switch (attr) {
 	case hwmon_temp_input:
 		ret = regmap_read(regmap, ABEOZ9_REG_REG_TEMP, &val);
-- 
2.43.0



