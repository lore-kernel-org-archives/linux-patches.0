Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28709346E6D;
	Fri, 21 Nov 2025 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732737; cv=none; b=Xs34Hdrj5f4p0JnT6NLZvQ99t9VMwLupVlgLz8qCYsRBPY33y5X7jeuKArerYxWsZPYn4tRXUCr1ondJKGNq1dq7x6lMhDXc1khczulE0iX8/Ka3dn0QzhQXovy9w1RoKEA45Ia4JGr4EeZojY6y5YUA0G8pUJXfeajVngFpa44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732737; c=relaxed/simple;
	bh=jNab0oLL/RBkbk8mmmauMqYTChmYimVCRjsDW+q0CM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuAcqhobhgvS7PBR7wcyToc9zxl9E554l0m0X1nCJzpp02q7RHFWNtYyDEd4SQyRjo3Ivc5zGN5OXZAIYXWXzPBC4AdOfEijw9C4tyhenX5izEIwn6PwQHE0WIKFCatcMWcC0PbHMh8BkxZRnfcjL4IXO1NA5rZm0GPVBuMhzoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVqrlLHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVqrlLHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E00BC4CEFB;
	Fri, 21 Nov 2025 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732736;
	bh=jNab0oLL/RBkbk8mmmauMqYTChmYimVCRjsDW+q0CM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVqrlLHijLAXL4DSNNbt3dNfGN9S/II16NhQCU8sK4ex2X72kzHpRpCtYAGUjDUN0
	 TCVRcU8alJfS/5JPA9YE5+B4xgsIzELB5FNfFDjFj+mYGGyDv+yXYulEhgCW7I1V4P
	 NV5wvRNrmrR5ITTFJb+BzoC9nyCgctgIcwqXOzYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Sangwook Shin <sw617.shin@samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/529] watchdog: s3c2410_wdt: Fix max_timeout being calculated larger
Date: Fri, 21 Nov 2025 14:08:44 +0100
Message-ID: <20251121130239.018663604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b4bd883ff28a..183d77a6c4b31 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -26,6 +26,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <linux/delay.h>
+#include <linux/math64.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -302,9 +303,14 @@ static inline unsigned long s3c2410wdt_get_freq(struct s3c2410_wdt *wdt)
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



