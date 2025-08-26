Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9AC342CA7;
	Tue, 26 Aug 2025 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217899; cv=none; b=MJ3JjFHrCYSsxf3FjYUuvgbUTfeDb5ilo21mFc5TubaX7VrNYH1RIega94hriNaTZxhRqP4i5G3st+s0zcLvTReVVlN72WRuxO5/fusWuKnkQrSPidfMlvcnwzzq2CEkyms44NOAXBcMd2X93H8aWWzH/kvEDfB+6aPC20mhKCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217899; c=relaxed/simple;
	bh=Giz9tc7fBxqv4HwHWY3PlP43FiLwKxAsGtPky+S8uCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jep6WsbKgorqcT5R//TGksT7XkMaxw/XsVNhi9QZMy26Xrzaj7ecv/xRKecVVQnJTt3aYh3HnQabDmtzK68PD94zIRXOL3tjlAFRl+PQec5xOyrEEuKGnx6fWFYtt/Py5x05mtTLQ7n9DkVz4xQbCocDJxi0kmjnpC6OtEht9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myerU3lA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myerU3lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E90C113CF;
	Tue, 26 Aug 2025 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217897;
	bh=Giz9tc7fBxqv4HwHWY3PlP43FiLwKxAsGtPky+S8uCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myerU3lACBNRKiNgXAtcWjY1YCzC/8DS5YuqJlCZSR4ngFG0eCj8ER9auov4DAocO
	 03YCwp1uxHlvZ7MOO1cmTW2V2ePbx5q2ZEmj7UCRdlpj3cLc40jfe/Za9/KljJsy68
	 nGQKFSsZoqNjp4bL+zqoKXVztlH3JevLPGR4f1hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/523] rtc: ds1307: handle oscillator stop flag (OSF) for ds1341
Date: Tue, 26 Aug 2025 13:08:47 +0200
Message-ID: <20250826110932.283831687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meagan Lloyd <meaganlloyd@linux.microsoft.com>

[ Upstream commit 523923cfd5d622b8f4ba893fdaf29fa6adeb8c3e ]

In using CONFIG_RTC_HCTOSYS, rtc_hctosys() will sync the RTC time to the
kernel time as long as rtc_read_time() succeeds. In some power loss
situations, our supercapacitor-backed DS1342 RTC comes up with either an
unpredictable future time or the default 01/01/00 from the datasheet.
The oscillator stop flag (OSF) is set in these scenarios due to the
power loss and can be used to determine the validity of the RTC data.

This change expands the oscillator stop flag (OSF) handling that has
already been implemented for some chips to the ds1341 chip (DS1341 and
DS1342 share a datasheet). This handling manages the validity of the RTC
data in .read_time and .set_time based on the OSF.

Signed-off-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/1749665656-30108-3-git-send-email-meaganlloyd@linux.microsoft.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index ba420201505c..a60362c69d87 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -275,6 +275,13 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 		if (tmp & DS1340_BIT_OSF)
 			return -EINVAL;
 		break;
+	case ds_1341:
+		ret = regmap_read(ds1307->regmap, DS1337_REG_STATUS, &tmp);
+		if (ret)
+			return ret;
+		if (tmp & DS1337_BIT_OSF)
+			return -EINVAL;
+		break;
 	case ds_1388:
 		ret = regmap_read(ds1307->regmap, DS1388_REG_FLAG, &tmp);
 		if (ret)
@@ -373,6 +380,10 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
 				   DS1340_BIT_OSF, 0);
 		break;
+	case ds_1341:
+		regmap_update_bits(ds1307->regmap, DS1337_REG_STATUS,
+				   DS1337_BIT_OSF, 0);
+		break;
 	case ds_1388:
 		regmap_update_bits(ds1307->regmap, DS1388_REG_FLAG,
 				   DS1388_BIT_OSF, 0);
-- 
2.39.5



