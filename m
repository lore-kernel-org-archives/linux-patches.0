Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368933612CA;
	Wed,  3 Dec 2025 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779317; cv=none; b=MYJUIFE5qEi6dyytHZzNDV7QkpCswMnRmMxXrZ98kUDeK9zL1acKHqA92U1vzwFaGWei7BM1GWFg10c9g6crHgJ12sfsCunBRika6AHWKBiA/Z7VjhjWdDQMmz0FnVZJy3VVOIdyY0l2j64jpvUWASV5317SPAoIYuxMBDEZE90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779317; c=relaxed/simple;
	bh=cNbT5QpXv50+zfnh2iJwKmRlbGUNw5zujAdlLsoZjZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwUYhjmiavSLd8qHP/Ij+pdqQdwatBysnTGE6jXLKp9PbES3TuS6/9lbCjKK8KgKulqxW8nxN4SVQiK8zWz4sxiIpDOfteE0P/YWfwvWLiT2mgw/aNhOugjxVKI4IBku0i6eFqJnMaIJyBFSIE9wDbIN0Txx9Ly2E7bfW5HSy1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgrU3jOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgrU3jOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C37EC116B1;
	Wed,  3 Dec 2025 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779316;
	bh=cNbT5QpXv50+zfnh2iJwKmRlbGUNw5zujAdlLsoZjZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgrU3jOCW11GhFgy7lNZHmCsvJTSmYFWhO2nqQBQOf2AjCf9AiNVLjUBe83VuTeDE
	 YOB2ENbwix3KF1qol54NaqFQtUlxl3Kc8mNLhXB3D6myeJWBhenUEx7uM0VCCK9/s5
	 RClOqTNeK8t7aeY3L1pMZrCJ9Dg7jnUgDDkpEbJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Sangwook Shin <sw617.shin@samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/568] watchdog: s3c2410_wdt: Fix max_timeout being calculated larger
Date: Wed,  3 Dec 2025 16:23:44 +0100
Message-ID: <20251203152448.853037047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d3fc8ed886fff..3853be982cd3c 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <linux/delay.h>
+#include <linux/math64.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -303,9 +304,14 @@ static inline unsigned long s3c2410wdt_get_freq(struct s3c2410_wdt *wdt)
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
 
 static inline struct s3c2410_wdt *freq_to_wdt(struct notifier_block *nb)
-- 
2.51.0



