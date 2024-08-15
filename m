Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A157DA9E;
	Thu, 15 Aug 2024 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729704; cv=none; b=mpWS+ie4a0eYEGKprHdf8TGPXqE8p7TUYxEGLQNc+a/gTs5SymvRMxKmgZg2XNjJT42z8i2zRoye4x8Zmvn6sSmghsuocdzxU/v1nmBZFeIfkQiUjKMLKTtQlUbAjpvZ1WlmBAIfJ7PXtU4LUwon/gefJNcL8KfI7XX+LPFDlJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729704; c=relaxed/simple;
	bh=1Fs2GtjcFIag3Q5uyoH9rK/XmeJvXLGFmEVruoukwOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xs/cIUZ4BOHN76ICHxr5SGxQpfHMQpLC0b9iGD/ycmBbJg4YM21vhhJv0vc9NUv24PDN107O6sIeQ9SiI56v2OPcvwQFHtxMKmATExNb8VVVgGkfM0F4zTpXyr6lX8farpuxaqCMOuKCEw6QuNMlN8r7yl9E1zq6kAMTDnAAXN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNYbcql0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNYbcql0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7226EC32786;
	Thu, 15 Aug 2024 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729703;
	bh=1Fs2GtjcFIag3Q5uyoH9rK/XmeJvXLGFmEVruoukwOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNYbcql06s9njobAXh+QuvXOzEuXL7foBR1n9V7qYeaXDxj3kCAf2ihoVX1FybDez
	 rGpz1QRRPRGKXTfabQVJmeBbZlB2uhDosq75NSbsY8DXIa6jMDTNlsPruIYgEalKmF
	 qYJtbUKOZSr4EL4bWWk0qlFkJPfCB0QkCM4cQHIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/484] rtc: interface: Add RTC offset to alarm after fix-up
Date: Thu, 15 Aug 2024 15:20:22 +0200
Message-ID: <20240815131947.744520175@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 463927a8902a9f22c3633960119410f57d4c8920 ]

`rtc_add_offset()` is called by `__rtc_read_time()`
and `__rtc_read_alarm()` to add the RTC's offset to
the raw read-outs from the device drivers. However,
in the latter case, a fix-up algorithm is run if
the RTC device does not report a full `struct rtc_time`
alarm value. In that case, the offset was forgot to be
added.

Fixes: fd6792bb022e ("rtc: fix alarm read and set offset")

Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Link: https://lore.kernel.org/r/20240619140451.2800578-1-csokas.bence@prolan.hu
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/interface.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index f49ab45455d7c..29c12947e73fc 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -274,10 +274,9 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 			return err;
 
 		/* full-function RTCs won't have such missing fields */
-		if (rtc_valid_tm(&alarm->time) == 0) {
-			rtc_add_offset(rtc, &alarm->time);
-			return 0;
-		}
+		err = rtc_valid_tm(&alarm->time);
+		if (!err)
+			goto done;
 
 		/* get the "after" timestamp, to detect wrapped fields */
 		err = rtc_read_time(rtc, &now);
@@ -379,6 +378,8 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	if (err)
 		dev_warn(&rtc->dev, "invalid alarm value: %ptR\n",
 			 &alarm->time);
+	else
+		rtc_add_offset(rtc, &alarm->time);
 
 	return err;
 }
-- 
2.43.0



