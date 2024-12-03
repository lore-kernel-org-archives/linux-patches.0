Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ABF1DFD91;
	Tue,  3 Dec 2024 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239940; cv=none; b=RDmbtD4LUggtYyiIsLJdeZXSUkQ4h+wmD9yzPYVvAG6VS2HIk5x3gve6BsOI3qwPY12xozfLLltXbvWGGXbfkA8PfAanW8Lz15lm9jSM4/1OPObdQuP983LvJEX/uD2TkLnNJzyRBOFIlayJdFN0jhPQlArB+Hy5HBeexH6asEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239940; c=relaxed/simple;
	bh=bLFi9niiZ796hqo8zl50pEqBFEKr3clwxj7YeMvK45E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdZIlH6wBN6/eMX7faz0S9TVFXWNptKE/+DDNcA9ssEIMKBSF7vaJkO+wIJJfBQtt0zAPb+lhNp5tVaKPoLDDgY0nmaJ0BhrEeWSse5FydqZtasKpRqH4j0LED041LL/rkyPv8fA61wCR4z3y4vXcbFQCfXWkDAGix7G71vXnaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+JEYRzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+JEYRzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FE4C4CECF;
	Tue,  3 Dec 2024 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239940;
	bh=bLFi9niiZ796hqo8zl50pEqBFEKr3clwxj7YeMvK45E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+JEYRziUQ8+xiEKuIn6UoeYIXky5Xdl9zzaSp3OAEOiGxnjNK2cRg6jB2SqeCatz
	 lV0vShjJfqmTVWsfqt/uMViyM2jfp125TwfToulhEysj6Cpil9qFa1Gekmlrj31RR0
	 ncNreTwdsBjNnpOfJLEO8/R0l3iYC92CSpM9XWj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 779/817] rtc: rzn1: fix BCD to rtc_time conversion errors
Date: Tue,  3 Dec 2024 15:45:51 +0100
Message-ID: <20241203144026.420961629@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



