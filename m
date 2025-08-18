Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496922206AF;
	Mon, 18 Aug 2025 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524364; cv=none; b=ggWpSpD9DODGyuvm19O3o8YtvJo4ufoAwPmsOet6HVedwogQVRwCQoxHawV4QoTiypNT0yo578sQxArO9XirobAINxk+mQGJRx1EN5rPyYkQlkZUwpXmjKTAeAeA4hvZXmXZ9s/+DD//VU0Tdf99ZniACBv2/AnIiLWgAfU7FO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524364; c=relaxed/simple;
	bh=lzIFBCYwgHAJWAkkuCmnj73iRgY44SEDyiuUCa1oprg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBXsEub6oN34HSBQowKPXY3ClmnLq576/d2Yw39yLzvFyCGKZZXhiI2Izi/YOZ1mTpbqZDyraliXqxkjHiRCQlb8EB+FABKEFHVwTRnjSNr/0FW1aIHgWHkNQ+RghGgJ/4j5UIKoQhclRu257w2eR83D6Cx/FBSW02Tc2jxsan8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssQudQBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssQudQBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF1C4CEF1;
	Mon, 18 Aug 2025 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524364;
	bh=lzIFBCYwgHAJWAkkuCmnj73iRgY44SEDyiuUCa1oprg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssQudQBuwPkIXfshJfBEtpWZLR11eIqqdsCLuTMuw3SD4854PygeQ7UZjc/lf+h8+
	 EcEanLNAcwuNjvtoqtugZHONxR9mPssIO/A4F3dMCe0MB2xUBZKhZ1I+IZaHexfo+U
	 86s6uPcE2wp9HSSWFS7M3wbV4CbM9g1SIGsHK7HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 432/515] rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe
Date: Mon, 18 Aug 2025 14:46:58 +0200
Message-ID: <20250818124515.056927774@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meagan Lloyd <meaganlloyd@linux.microsoft.com>

[ Upstream commit 48458654659c9c2e149c211d86637f1592470da5 ]

In using CONFIG_RTC_HCTOSYS, rtc_hctosys() will sync the RTC time to the
kernel time as long as rtc_read_time() succeeds. In some power loss
situations, our supercapacitor-backed DS1342 RTC comes up with either an
unpredictable future time or the default 01/01/00 from the datasheet.
The oscillator stop flag (OSF) is set in these scenarios due to the
power loss and can be used to determine the validity of the RTC data.

Some chip types in the ds1307 driver already have OSF handling to
determine whether .read_time provides valid RTC data or returns -EINVAL.

This change removes the clear of the OSF in .probe as the OSF needs to
be preserved to expand the OSF handling to the ds1341 chip type (note
that DS1341 and DS1342 share a datasheet).

Signed-off-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/1749665656-30108-2-git-send-email-meaganlloyd@linux.microsoft.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index c6d388bb4a19..1960d1bd851c 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1824,10 +1824,8 @@ static int ds1307_probe(struct i2c_client *client)
 		regmap_write(ds1307->regmap, DS1337_REG_CONTROL,
 			     regs[0]);
 
-		/* oscillator fault?  clear flag, and warn */
+		/* oscillator fault? warn */
 		if (regs[1] & DS1337_BIT_OSF) {
-			regmap_write(ds1307->regmap, DS1337_REG_STATUS,
-				     regs[1] & ~DS1337_BIT_OSF);
 			dev_warn(ds1307->dev, "SET TIME!\n");
 		}
 		break;
-- 
2.39.5



