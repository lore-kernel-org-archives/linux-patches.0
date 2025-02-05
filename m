Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284F01E89C;
	Wed,  5 Feb 2025 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767522; cv=none; b=sEWfEzTiSvmI2g6m45oYnw05aJuz9P9dcHH7Q4uV+mEzJKQOAscxdxwtorFeagyd/w6aWbLuXEd0UpsfmYp0lFnuY5BAOibILIOWAkTV/HaXUW/jKe7SfheyoauhQbQi3L/50IIkEfRkuAGrF/oV4eKxsSs+BvkB1SxuQE3ldrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767522; c=relaxed/simple;
	bh=jDZa+VTAppIVRyhdk7bj/t56Jcm62/qxIAKZvLhoXwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHQtGH4AFtF8WhV5zXxNBPWKbf8x9ttjyTxxyqRHYrcbCPP79z8kb78Caqq/fCe01be9K9sS+yf+UkS28d6B2V3NRxJaVOqUGIa6NljJH5ikzWtKHN8dU9EUMywrF4BFUNj+kixi8VpWEY4ih1Nl+RWc4qBE9Tcv09s0ckE3ch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDoZH3Aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDoZH3Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A02C4CED1;
	Wed,  5 Feb 2025 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767521;
	bh=jDZa+VTAppIVRyhdk7bj/t56Jcm62/qxIAKZvLhoXwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDoZH3AqaFHoEbYNV7n8qm1p5/Qo8xLV6M7OhjMeAfL7FkGdLRM7YBfy+p8AMKPPN
	 EVYJ55ZOijEQ2amnJmcyWQjXTNEhetvcgqtgtokdmEWNXs4ekKNQbHYWkt+qQ/szWx
	 +jtx2A+baU6BkGTYnOpl1BSusu7N67852ddZC0tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/590] rtc: tps6594: Fix integer overflow on 32bit systems
Date: Wed,  5 Feb 2025 14:43:43 +0100
Message-ID: <20250205134513.164837253@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 09c4a610153286cef54d4f0c85398f4e32fc227e ]

The problem is this multiply in tps6594_rtc_set_offset()

	tmp = offset * TICKS_PER_HOUR;

The "tmp" variable is an s64 but "offset" is a long in the
(-277774)-277774 range.  On 32bit systems a long can hold numbers up to
approximately two billion.  The number of TICKS_PER_HOUR is really large,
(32768 * 3600) or roughly a hundred million.  When you start multiplying
by a hundred million it doesn't take long to overflow the two billion
mark.

Probably the safest way to fix this is to change the type of
TICKS_PER_HOUR to long long because it's such a large number.

Fixes: 9f67c1e63976 ("rtc: tps6594: Add driver for TPS6594 RTC")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/1074175e-5ecb-4e3d-b721-347d794caa90@stanley.mountain
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-tps6594.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-tps6594.c b/drivers/rtc/rtc-tps6594.c
index e696676341378..7c6246e3f0292 100644
--- a/drivers/rtc/rtc-tps6594.c
+++ b/drivers/rtc/rtc-tps6594.c
@@ -37,7 +37,7 @@
 #define MAX_OFFSET (277774)
 
 // Number of ticks per hour
-#define TICKS_PER_HOUR (32768 * 3600)
+#define TICKS_PER_HOUR (32768 * 3600LL)
 
 // Multiplier for ppb conversions
 #define PPB_MULT NANO
-- 
2.39.5



