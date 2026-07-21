Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27244347BC6;
	Tue, 21 Jul 2026 22:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673947; cv=none; b=uLt1PGufwav50v18hCqKj92tgEdVDAtp/E8b2Mb0zL+TjmP2bmUdwCV79pb1n/KMjUtUik4W8Iymne98nsXbvRwp2r321LBlTHSG6fV6c3LPCU9Ql6uz8GnL11XUstnEYNh8akIQoDrOvFB7v8RQtTzvcmbjxvqou5oUGuVhO44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673947; c=relaxed/simple;
	bh=m/zkTFfwwz4tmG9tn3YzXMUWLIOCqupoYuHgwwWDDZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgx4iiAh3ojb8EUBuEB3XECohRVYm/ueVXIGLr/gccetG/4m40Za+1X1xkth64V3sMx0juN1fhAgzGozqpMA6cmoGChZj1LnATVqn9EkMNrztlRRyO9t75mKnEZKFMx7xeNivNdqj5fglltEo7Rulqw+yDYTvHPpBYPX8RJzs88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqOxMQa2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqOxMQa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A371F000E9;
	Tue, 21 Jul 2026 22:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673946;
	bh=NZr/c7cQBdVtOAE9fUlQQ3eOK91smf2E6Z2dOZRDTAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqOxMQa2oIkgCakCjAcDbuO0J3mVr2g5OTpBMrUK/699bzljqClVG9/tlf0Mp9vIS
	 voFjRDFJePjiF3sm3br2bOE8Unupvo+iAFFF3XE+G/TQfyMR7Hz3vbeHEgN+dF4FEO
	 PtCRBOGqEnTAICnPIPxfpPscdi+MDbfEk16E5ACw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronan Dalton <ronan.dalton@alliedtelesis.co.nz>,
	linux-rtc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Tyler Hicks <code@tyhicks.com>,
	Sasha Levin <sashal@kernel.org>,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 5.10 353/699] rtc: ds1307: handle oscillator stop flag for ds1337/ds1339/ds3231
Date: Tue, 21 Jul 2026 17:21:52 +0200
Message-ID: <20260721152403.656599907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronan Dalton <ronan.dalton@alliedtelesis.co.nz>

[ Upstream commit a091e1ba3b68cabc9caedafc6f81d9fe9b3b2200 ]

Prior to commit 48458654659c ("rtc: ds1307: remove clear of oscillator
stop flag (OSF) in probe"), the oscillator stop flag (OSF) bit was
checked during device probe for the ds1337, ds1339, ds1341, and ds3231
chips; if it was set, it would be cleared and a warning would be logged
saying "SET TIME!". Since that commit, the OSF bit is no longer cleared,
but the warning is still printed.

Directly following that commit, there was no way to get rid of this
warning because nothing cleared the OSF bit on these chips.

The commit associated with the previous commit, 523923cfd5d6 ("rtc:
ds1307: handle oscillator stop flag (OSF) for ds1341"), made proper use
of the OSF when getting and setting the time in the RTC. However, the
other RTC variants ds1337, ds1339 and ds3231 didn't have a corresponding
change made.

Given that the OSF bit is no longer cleared at probe time when it is
set, the remaining three chips should have the same handling as the
ds1341 chip has for the OSF bit.

Fix the issue on the ds1337, ds1339 and ds3231 chips by applying the
same logic as the ds1341 has to these chips.

Note that any devices brought up between the first referenced commit and
this one may begin mistrusting the time reported by the RTC until it is
set again, if the bit was never explicitly cleared.

Note that only the ds1339 was tested with this change, but the
datasheets for the other chips contain essentially identical
descriptions of the OSF bit so the same change should work.

Signed-off-by: Ronan Dalton <ronan.dalton@alliedtelesis.co.nz>
Cc: linux-rtc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Tyler Hicks <code@tyhicks.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Fixes: 48458654659c ("rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe")
Reviewed-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Link: https://patch.msgid.link/20260508032518.3696705-2-ronan.dalton@alliedtelesis.co.nz
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index ecfd6c27ba542c..27073898c9c3d7 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -265,6 +265,16 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 		if (tmp & DS1338_BIT_OSF)
 			return -EINVAL;
 		break;
+	case ds_1337:
+	case ds_1339:
+	case ds_1341:
+	case ds_3231:
+		ret = regmap_read(ds1307->regmap, DS1337_REG_STATUS, &tmp);
+		if (ret)
+			return ret;
+		if (tmp & DS1337_BIT_OSF)
+			return -EINVAL;
+		break;
 	case ds_1340:
 		if (tmp & DS1340_BIT_nEOSC)
 			return -EINVAL;
@@ -275,13 +285,6 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 		if (tmp & DS1340_BIT_OSF)
 			return -EINVAL;
 		break;
-	case ds_1341:
-		ret = regmap_read(ds1307->regmap, DS1337_REG_STATUS, &tmp);
-		if (ret)
-			return ret;
-		if (tmp & DS1337_BIT_OSF)
-			return -EINVAL;
-		break;
 	case ds_1388:
 		ret = regmap_read(ds1307->regmap, DS1388_REG_FLAG, &tmp);
 		if (ret)
@@ -376,14 +379,17 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 		regmap_update_bits(ds1307->regmap, DS1307_REG_CONTROL,
 				   DS1338_BIT_OSF, 0);
 		break;
-	case ds_1340:
-		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
-				   DS1340_BIT_OSF, 0);
-		break;
+	case ds_1337:
+	case ds_1339:
 	case ds_1341:
+	case ds_3231:
 		regmap_update_bits(ds1307->regmap, DS1337_REG_STATUS,
 				   DS1337_BIT_OSF, 0);
 		break;
+	case ds_1340:
+		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
+				   DS1340_BIT_OSF, 0);
+		break;
 	case ds_1388:
 		regmap_update_bits(ds1307->regmap, DS1388_REG_FLAG,
 				   DS1388_BIT_OSF, 0);
-- 
2.53.0



