Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B3C416CFA;
	Sat, 12 Sep 2026 09:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204524; cv=none; b=YHoL34iKBPJiiuDMZ+w3rD8NsmIHKt3WvFOhe6iOKP2ZXvrWkwUQB6Q70ujNPo3TTfavu7MbcDfjVehP5wTd6s6uQcnyONP27TUtH4T4sf2XJ+WiD27MpMGyBQah4Vtlm2uLLdwCC81AWVU41pikh/oAMBeF25NiXuzJrGMA9po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204524; c=relaxed/simple;
	bh=JGWhclwtRjSsI3meNDt/LZH9wuymA/Wv16BXqftBNLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNoyfOi9gCVaqh2+B7R/psNnKCnq/45wxU8jZn3ThA2/BJHp1Rqlvtbs5FDIfNj0iwDg5Kzo//pT3r4KlFl7jxSuyfmgEXsGDgXrw8qHkzXrObR+vSDCMwKYXvmo+9YndU2hKUIF4rSsY9XsrsbJ2DbtO732sxyGCj2OhB0I3kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHJtn8eJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHJtn8eJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0531F000FF;
	Sat, 12 Sep 2026 09:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204522;
	bh=QZ5X4c0cSuymJz+W55S3D2GBFC7GREJmktfkinyuMqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHJtn8eJrb4vNrS6Pmgiw6S4RHiJJyp6BSxHTCX4BEP9yujEwHu1LPVm55ygtjepd
	 jO4yWm4wbD6+i9hdpCrqvGoYKYXDEdXM/ccz2VtDiMgHMcYHSOU2prIpGjT8UU7eab
	 E339ZDRXP7ku45MHppYwfnPd/k9ONRRkJgp8xQn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@riscstar.com>,
	Surendra Singh Chouhan <kr494167@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1629/1815] rtc: spacemit: handle regmap_test_bits() error return
Date: Sat, 12 Sep 2026 08:56:19 +0200
Message-ID: <20260912065727.229972234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surendra Singh Chouhan <kr494167@gmail.com>

[ Upstream commit 092755367e1a5fcf0f5405e9425e86907199dfce ]

p1_rtc_read_time() called if (!regmap_test_bits(regmap, RTC_CTRL, RTC_EN))
to check if the RTC was enabled.

regmap_test_bits() returns 1 if the bit is set, 0 if not set, and a
negative error code (e.g. -EIO) if reading the control register fails.
Using !regmap_test_bits(...) evaluates a negative error code as boolean
false, causing I2C/regmap read failures to be ignored and incorrectly
proceeding to read time registers from a failing device.

Fix this by capturing the return value of regmap_test_bits() and returning
the error code if negative, or -EINVAL if the RTC is disabled.

Fixes: a6de182daa2b ("rtc: spacemit: support the SpacemiT P1 RTC")
Reviewed-by: Alex Elder <elder@riscstar.com>
Signed-off-by: Surendra Singh Chouhan <kr494167@gmail.com>
Link: https://patch.msgid.link/20260724135803.81223-1-kr494167@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-spacemit-p1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-spacemit-p1.c b/drivers/rtc/rtc-spacemit-p1.c
index 43ab62494bb4b..1de7bd995d296 100644
--- a/drivers/rtc/rtc-spacemit-p1.c
+++ b/drivers/rtc/rtc-spacemit-p1.c
@@ -57,8 +57,9 @@ static int p1_rtc_read_time(struct device *dev, struct rtc_time *t)
 	u8 time[6];
 	int ret;
 
-	if (!regmap_test_bits(regmap, RTC_CTRL, RTC_EN))
-		return -EINVAL;		/* RTC is disabled */
+	ret = regmap_test_bits(regmap, RTC_CTRL, RTC_EN);
+	if (ret <= 0)
+		return ret ?: -EINVAL;	/* RTC is disabled or error */
 
 	ret = regmap_bulk_read(regmap, RTC_TIME, time, sizeof(time));
 	if (ret)
-- 
2.53.0



