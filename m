Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079CB1D61BB;
	Mon, 18 Aug 2025 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526136; cv=none; b=fn6XLxAgKcjgbNAuTWrCH8PCbN+7cFH7bUO1doWMuOKmdbG3Urb1MC+0ntcAp1/XIWoyE7Zp4t4zDe6HaXYypmUPYlxnCZPlZCwfck0Rh1Aas2goGxf0yH/2yAvx99MtRDcWpwKE59iWhQb2WRXY0mlFoBXVke8AyAtiNqtxMG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526136; c=relaxed/simple;
	bh=UYofjXticcb/N1J8MTxSEvLBZrewNDCShqlphaoK/RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NccQ5g5K126O7Sx3WCFCOafxWYrsGm2bneYgOFhMPdL7+1Pr1eX0b6+4ThKFHZNhhlUd+nnESK9rXJEztenmzieCNJoGABbdNvLdstGVXcvDA4g05ijsZgZG9cSnqQY+dXtAwbBHO35k1Fyx8ncuOk5Yctx9tOPNwSkZFcTJqrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kd4fC2tN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kd4fC2tN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CC3C4CEEB;
	Mon, 18 Aug 2025 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526135;
	bh=UYofjXticcb/N1J8MTxSEvLBZrewNDCShqlphaoK/RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kd4fC2tNdL9/30gwhUAXy0pdTqr7Nye47ZCQaEfoI9ZnNHvbDuGzUWN6uMsueO990
	 uvdhckKx/9Oc7W/v7EBGEvp47P841MtOmGJDNJX0D34mWTGJk74rkYvpF7JSrpXTIl
	 devojGGCrlMv8sKnc7chq6k2aBC8q7TY7nLBnW20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 468/570] rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe
Date: Mon, 18 Aug 2025 14:47:35 +0200
Message-ID: <20250818124523.905426519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



