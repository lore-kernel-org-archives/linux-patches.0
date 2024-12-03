Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8441F8933;
	Tue,  3 Dec 2024 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242823; cv=none; b=kOsUzFYFjceP4KAFeUgcxWuBWFVAQjdWVsIXfUzrJ1A4L2rskfSBY1QFYkJXSLRh4ILmETTluXMqsULzlBGAZOg1w/g5yixmzJruuIokShe/jmvkwYVP9vrkw2N6YC9uOZsKIUlETluhlBUYeTLCi9YQwy9UyRBBEQCiOfWPoiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242823; c=relaxed/simple;
	bh=rWGMRo4PyywWCnO2sjBR8M6vEAQeuLDFVucKKHcKbtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po+Tzts0CREDsfqZ7+aRuWqxpe6Lk2uj9Af2PW0PKu/JRV7KUvP1ipYDuBbSkbj4+AQmOdckde0jyyMFlRCo+LutSCrfAr8Lu6xZX/+RvnHrMyE+lLvZcJKgq7S+Bv9mGrFl9x09lWuGkL/uDCOLilfw4WJsbYkdWVTvmpM4HTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bi+VZtoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bi+VZtoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AD4C4CED6;
	Tue,  3 Dec 2024 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242823;
	bh=rWGMRo4PyywWCnO2sjBR8M6vEAQeuLDFVucKKHcKbtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bi+VZtoy5PtkO9Jd2rzq05S5vHBoOh1iGvYxdIHdQGxBfI/H3D4TmW/TkzzIPoZYb
	 wB0MpnJfvuZ88ShLosc4y/NCwIWIpeZul5BY4c/ls5l8VVFXnzsOqg7qWq4H9EClUB
	 CCO4Xr3SHShm87ls1KAi1hC7zBPLkf0D593Jyky8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 789/826] rtc: rzn1: fix BCD to rtc_time conversion errors
Date: Tue,  3 Dec 2024 15:48:36 +0100
Message-ID: <20241203144814.539744855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 55727188dfa3572aecd946e58fab9e4a64f06894 ]

tm_mon describes months from 0 to 11, but the register contains BCD from
1 to 12. tm_year contains years since 1900, but the BCD contains 20XX.
Apply the offsets when converting these numbers.

Fixes: deeb4b5393e1 ("rtc: rzn1: Add new RTC driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20241113113032.27409-1-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rzn1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-rzn1.c b/drivers/rtc/rtc-rzn1.c
index 56ebbd4d04814..8570c8e63d70c 100644
--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -111,8 +111,8 @@ static int rzn1_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_hour = bcd2bin(tm->tm_hour);
 	tm->tm_wday = bcd2bin(tm->tm_wday);
 	tm->tm_mday = bcd2bin(tm->tm_mday);
-	tm->tm_mon = bcd2bin(tm->tm_mon);
-	tm->tm_year = bcd2bin(tm->tm_year);
+	tm->tm_mon = bcd2bin(tm->tm_mon) - 1;
+	tm->tm_year = bcd2bin(tm->tm_year) + 100;
 
 	return 0;
 }
@@ -128,8 +128,8 @@ static int rzn1_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_hour = bin2bcd(tm->tm_hour);
 	tm->tm_wday = bin2bcd(rzn1_rtc_tm_to_wday(tm));
 	tm->tm_mday = bin2bcd(tm->tm_mday);
-	tm->tm_mon = bin2bcd(tm->tm_mon);
-	tm->tm_year = bin2bcd(tm->tm_year);
+	tm->tm_mon = bin2bcd(tm->tm_mon + 1);
+	tm->tm_year = bin2bcd(tm->tm_year - 100);
 
 	val = readl(rtc->base + RZN1_RTC_CTL2);
 	if (!(val & RZN1_RTC_CTL2_STOPPED)) {
-- 
2.43.0



