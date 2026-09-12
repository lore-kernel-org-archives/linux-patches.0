Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAFC4BEE32;
	Sat, 12 Sep 2026 11:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211776; cv=none; b=k7HO51Ss4r8d15JF3er4nT1zmMKgTZ3/67C2Zvw/YzmS1HLutdA7trK4TzfKl4wiNfVXw2q/ja9xhl6CVTEPA0kgrRk/qjUxt0kIQoroUexwSszhqIo8v/qDtzjB4Wbj1cRCCDZtix1fOqGX/yoeqklkeg3Ijl7o6fEoNXd6tfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211776; c=relaxed/simple;
	bh=STR47tYF1xo3WrvsfQBy864H+ftmT9N2BKT1J3do/fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdTluYGNGp5wmonn8YVWRv+ybQ6hWQ/ZHLDecoyMxWBku48BY3l+jPkfy3H1EscQQaspS5kbqLIfaGiP7BUYm92aUx8JotsgxyUSw0PWBTBc1oD1OCIFjcmZ/eIJgyEJGH8PViWOleSrK5OPP1qEH0SG7I1w143ECfyuIVsazcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNVwXDjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNVwXDjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6931F000FF;
	Sat, 12 Sep 2026 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211774;
	bh=g3KKLdVVtoISsgt1pj5sL9leYFcZVqhWW+c8LZvi2VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNVwXDjzyqQgQ3p5Ezwlp6hq+X4C57YOWcua6lAtKEfSNG0zab0d8J9aL2UaZzCaN
	 Udu+IPPkNMEj2/XB/h0FcoJCOun82e5mH0eYoxUYQWYgO8/ChY7Q7s3JPNakt5BI+r
	 AFUvPPNOp9SWqUwI/jRVBykisU4F3dAadcFcZZAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@riscstar.com>,
	Surendra Singh Chouhan <kr494167@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1301/1518] rtc: spacemit: handle regmap_test_bits() error return
Date: Sat, 12 Sep 2026 08:57:50 +0200
Message-ID: <20260912065652.950075597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



