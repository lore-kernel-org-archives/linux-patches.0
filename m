Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7851A49620;
	Tue, 21 Jul 2026 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666725; cv=none; b=XkatG4t+HighQBNl1Aslgp8hHeF8fplesRXDDhfqp3CYs9CnJ7awAYq7yFFEqw6Iies3pdOZlOSWHhg5WXbFG/IBrqBpy8ajXoWFSshud2XZ3osyBHxJRiNQ1glFdDNza+hk4mAvNhny5+4AA9XG55LUj+h1n85eZmm8EaIrnwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666725; c=relaxed/simple;
	bh=LqiMntej6fF/UwhNghzz2nNSqVf/w5Ai2Y2CkeDagw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt2WkSIAqcUolMuCqdyKrjx3NrWvb6iBw4hfdMuxdDP4FVlOflTZe4PJ0ODoZZUpkYdCVEe3c4WsdqLH6NqEZ59BGRAWk9SCUWMTnYao8eDs15obDada3xgpA/JW5Q2tbgTR8csGXPzw58q9thOb18JhQuMW6kYj2ZWOgT4d/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncN7DckA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncN7DckA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83571F000E9;
	Tue, 21 Jul 2026 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666723;
	bh=dXFs9+Q6m8Axml4Wiwz3L8GgorqAPZ9+/LyppJJ8hq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncN7DckAvEBUo9g4lmleMmp4pc2TOShCiqYowhazFI8CC3UlXGSFQtNmeRftYjkOR
	 g14ONlHHu5ziDtiUrH6COlDXIrZyO5AY1GLaqsIBcK0iBFGUJ6zgmcLnZlub1R3RXh
	 Dj13UKPLXjouV/B7YiYksP3AwJ9mZ7ncz0v/do14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Fredrik M Olsson <fredrik.m.olsson@axis.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0792/1266] rtc: ds1307: Fix off-by-one issue with wday for rx8130
Date: Tue, 21 Jul 2026 17:20:29 +0200
Message-ID: <20260721152459.583952028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Fredrik M Olsson <fredrik.m.olsson@axis.com>

[ Upstream commit 6882aab3c66112b33b251be95c09c8ead3e8d580 ]

The RTC represent each weekday with a individual bit set in the WDAY
register, where the 0th bit represent the first day of the week and the
6th bit represents the last day of the week. For each passed day the
chip performs a rotary-left-shift by one to advance the weekday by one.

The tm_wday field represent weekdays by a value in the range of 0-6.

The fls() function return the bit index of the last bit set. To handle
when there are no bits set it will return 0, and if the 0th bit is set
it will return 1, and if the 1st bit is set it will return 2, and so on.

In order to make the result of the fls() function fall into the expected
range of 0-6 (instead of 1-7) this patch subtracts one from the result
(which matches how the value is written in ds1307_set_time()).

Fixes: 204756f016726 ("rtc: ds1307: Fix wday settings for rx8130")
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Fredrik M Olsson <fredrik.m.olsson@axis.com>
Link: https://patch.msgid.link/20260520-ds1307-rx8901-add-v2-2-e069ea32e1db@axis.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 26b63cd0929154..e7ba52cb541204 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -306,7 +306,7 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 	t->tm_hour = bcd2bin(tmp);
 	/* rx8130 is bit position, not BCD */
 	if (ds1307->type == rx_8130)
-		t->tm_wday = fls(regs[DS1307_REG_WDAY] & 0x7f);
+		t->tm_wday = fls(regs[DS1307_REG_WDAY] & 0x7f) - 1;
 	else
 		t->tm_wday = bcd2bin(regs[DS1307_REG_WDAY] & 0x07) - 1;
 	t->tm_mday = bcd2bin(regs[DS1307_REG_MDAY] & 0x3f);
-- 
2.53.0



