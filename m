Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5B51A08CB;
	Thu, 15 Aug 2024 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730569; cv=none; b=DL5YnIxtsoZtizoQaQj2QV6dvT8cscMEXifNVHzNfU4rsOVcUxcKiM9sbczS/WlRTCFGKWWUxSwTb9Cs+tAa/5T99a8ZcKxQHTJT2bXIa+PoFL+QPylXg2Z0EIg6a0+5YuHpr+ZUpyIfwd/jpXQdpSDYAnni/DpvDBBkbU3fwg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730569; c=relaxed/simple;
	bh=WQQIlOYtIY/1lewFsCqEuOKa06aYP6DvOkeb92C4+ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNCMxtLP3Skm0R79JKyfr7eAGS92dRAeV1Jnvd5k10TIgAnVRUrY6v5xbqyude9KVFBfYBCa3Y29eL2gM1bKzD4BPSNzd4jzEFxDoxUclAyHyamqpUC9Di/2xd7WxiezS9Z9CXRb0ulufab6WFMd4VJxL7B+uoXIxdoMx7m9Kfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSVSqbrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSVSqbrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43122C32786;
	Thu, 15 Aug 2024 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730568;
	bh=WQQIlOYtIY/1lewFsCqEuOKa06aYP6DvOkeb92C4+ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSVSqbrzXLpY7abXI4VJ8LSzQMCmaUowScewd7rYrjhPNhXXjY66kDo+jeS5mb2sN
	 tfEEEi7XFdpanXO/rtaoP7DLrKTfnizEiAIV8P0nN7YnnchzUch2Fibdy2GXsGUam4
	 gYY4cRo+xag+cT8fDMwXIS5qp8s7nY9/+18bI8tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/484] clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()
Date: Thu, 15 Aug 2024 15:24:50 +0200
Message-ID: <20240815131958.144511459@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit f2655ac2c06a15558e51ed6529de280e1553c86e ]

The current "nretries > 1 || nretries >= max_retries" check in
cs_watchdog_read() will always evaluate to true, and thus pr_warn(), if
nretries is greater than 1.  The intent is instead to never warn on the
first try, but otherwise warn if the successful retry was the last retry.

Therefore, change that "||" to "&&".

Fixes: db3a34e17433 ("clocksource: Retry clock read if long delays detected")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240802154618.4149953-2-paulmck@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c3b59f2250a17..3ccb383741d08 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -229,7 +229,7 @@ static enum wd_read_status cs_watchdog_read(struct clocksource *cs, u64 *csnow,
 		wd_delay = clocksource_cyc2ns(wd_delta, watchdog->mult,
 					      watchdog->shift);
 		if (wd_delay <= WATCHDOG_MAX_SKEW) {
-			if (nretries > 1 || nretries >= max_retries) {
+			if (nretries > 1 && nretries >= max_retries) {
 				pr_warn("timekeeping watchdog on CPU%d: %s retried %d times before success\n",
 					smp_processor_id(), watchdog->name, nretries);
 			}
-- 
2.43.0



