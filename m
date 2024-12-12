Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A98223E62;
	Thu, 12 Dec 2024 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020321; cv=none; b=BkzdsmyMyVxB5mCxDqaba9MvUnCfmJhFkbf3gJ9Xy7DErHi4oHX2Ea1YJfov3qxJzFcgAH+iOdFy0vSHKNExjwQObdpMOkPnw2EwCHNkm3C9agJw/AufAXiIWMwzgdNtRvDLnPgP6/FX0l4ikMHmmQECeGgmRE8bKNGqbuWxsag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020321; c=relaxed/simple;
	bh=g/kGIXYvrZDVzZxnm7273c6XuGeNY35kVzf7cimj184=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8S98F6D6NqnpIYVkg5UvydSH0hCycLiVzvnJn1prh9/LQP1ZxCfWaqcG0+FKDcLG4nCSNbjWMT4FO1mvutJVjGHUMkw8P3s0WucXDDNEWouEokdxtzU9cixfb5INYRkVHrlWvBj2yaQLu2qHjev4JzWp9GQng6zyp9jTEHoykA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUPRcWpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUPRcWpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F09C4CECE;
	Thu, 12 Dec 2024 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020321;
	bh=g/kGIXYvrZDVzZxnm7273c6XuGeNY35kVzf7cimj184=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUPRcWpl2OGPrbQxDEXV10GOezpxc/gymJjHmLYrSvsr9Kse6wLhlGiHMSpEiBe5/
	 74daFrGcJtzhSvBXg6qswP1I49gArs1kWhkWQETQk/Sz3kGwI4InfLJHItBmUyANJD
	 exqLItA6e3GnHIAE32b0RKy0Q1bzBv4LSKc3VQrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/772] rtc: rzn1: fix BCD to rtc_time conversion errors
Date: Thu, 12 Dec 2024 15:56:23 +0100
Message-ID: <20241212144408.026141667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d36bc50197c1..ff094b3ce9e3c 100644
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



