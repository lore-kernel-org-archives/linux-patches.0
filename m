Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4646E30F541;
	Tue, 11 Nov 2025 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823916; cv=none; b=Jtmi56SrBfLDGDzrBEQXF6hjeaQOUL9tp5khZn5jeO0doSdPofKIA8BxS+ZULYxVPDu/VCXINGng/xV93eP7p49gYDrBBKzPw20DG3lbARNuAXj+dd2XiVe2FeEH7A32ScG/n2yCkbD2UQfmDpJvaCHgiZT3d9ChTcFsgYpT9Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823916; c=relaxed/simple;
	bh=QQuYy3RBTJ4aQpmw/KqrkfbO6mYKeDsUsQT/d4U+RW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwjXLJ4Wo91Rjn3bvxiIglKZN4PPyvHHrb6r/nwbVFZIpK53h427XgmN2I98AlhQZ38Qygp9uXO/e5uavhd7CdQ4YoXsWvwup5kDRuSPGPAS5HzLBrVta0d3ucn8kQKV8MzghiN3/vEAH38OPB82Odufj9Ys6Y8fZS3o4jv6mg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGgaOiOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGgaOiOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E8C116D0;
	Tue, 11 Nov 2025 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823915;
	bh=QQuYy3RBTJ4aQpmw/KqrkfbO6mYKeDsUsQT/d4U+RW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGgaOiOnj7QI3nc61hoey+mEDMTqTmzA6a4wzwA7vF6MtSk37anvJ0XKObR80rU+k
	 CrWCQmNJbRHbR/iJUGnZn7AR//PE99IE7sJLnqBuiY6qFx6DmEcBPx05O5xzg1py+W
	 lqyMF7HRmcKs2yGJ5/J9FVJcHQq3kwoq4ArloSHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Sangwook Shin <sw617.shin@samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/565] watchdog: s3c2410_wdt: Fix max_timeout being calculated larger
Date: Tue, 11 Nov 2025 09:43:25 +0900
Message-ID: <20251111004534.723597545@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sangwook Shin <sw617.shin@samsung.com>

[ Upstream commit df3c6e0b6d83450563d6266e1dacc7eaf25511f4 ]

Fix the issue of max_timeout being calculated larger than actual value.
The calculation result of freq / (S3C2410_WTCON_PRESCALE_MAX + 1) /
S3C2410_WTCON_MAXDIV is smaller than the actual value because the remainder
is discarded during the calculation process. This leads to a larger
calculated value for max_timeout compared to the actual settable value.
To resolve this issue, the order of calculations in the computation process
has been adjusted.

Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Sangwook Shin <sw617.shin@samsung.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/s3c2410_wdt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 349d30462c8c0..4b75c0594c872 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <linux/delay.h>
+#include <linux/math64.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -344,9 +345,14 @@ static inline unsigned long s3c2410wdt_get_freq(struct s3c2410_wdt *wdt)
 static inline unsigned int s3c2410wdt_max_timeout(struct s3c2410_wdt *wdt)
 {
 	const unsigned long freq = s3c2410wdt_get_freq(wdt);
+	const u64 n_max = (u64)(S3C2410_WTCON_PRESCALE_MAX + 1) *
+			S3C2410_WTCON_MAXDIV * S3C2410_WTCNT_MAXCNT;
+	u64 t_max = div64_ul(n_max, freq);
 
-	return S3C2410_WTCNT_MAXCNT / (freq / (S3C2410_WTCON_PRESCALE_MAX + 1)
-				       / S3C2410_WTCON_MAXDIV);
+	if (t_max > UINT_MAX)
+		t_max = UINT_MAX;
+
+	return t_max;
 }
 
 static int s3c2410wdt_disable_wdt_reset(struct s3c2410_wdt *wdt, bool mask)
-- 
2.51.0



