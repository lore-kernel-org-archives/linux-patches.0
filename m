Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E7C27A133;
	Tue, 27 May 2025 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367072; cv=none; b=UofK9NTShD8vsp7uHmRTQd9c66KptTgDLEhGGloQzegiTlf6jpAONMkUJI2V0La0kx0hpqg6SOpx7k+qie1LlIMoDwn3Mm6LjdJzSTAlZ/gOMHUt9qellZvxKJQDRpWs4Y4gLIz/phPJl/IZjGCDC3VOvr8j1peYRxtX43ydTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367072; c=relaxed/simple;
	bh=XJx8j7paseCel01xDpNC9a54BkshGVWKQ+AFSkKIWkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKeBhFXZFzLfSZdBgj730K7WV0q5Tl1kTJEATv2rZw3+lbbLhwt1FHijoLvPJA0esR+Mz5U/X9k9KCsJai5ZY8cgqEQ7TGdGqNFSrANlHuLNSi/gQ2vUwFhZrCv0dH85E1F/YhfG/MXaxHVBebEGPobL/m8f/1eAxPKU0Q69UZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqpUa+A7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqpUa+A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEF3C4CEE9;
	Tue, 27 May 2025 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367072;
	bh=XJx8j7paseCel01xDpNC9a54BkshGVWKQ+AFSkKIWkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqpUa+A7FuXGHVaz6iAjnGuGhl8x7cWHBhGoRluYCFXjbVfkfVgwaKwUpfWVrZigO
	 sTxZ7KTBpW8VwYbB9r6jeRd1yq+rtQP2hbf0ze3lC2vX/3pkd+hsmSgNUP0xQhuCvW
	 +yX+IwF6/gP9MMlHdPv94v30bzy3wYS3Uc5VVqnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 269/783] media: cec: use us_to_ktime() where appropriate
Date: Tue, 27 May 2025 18:21:06 +0200
Message-ID: <20250527162524.041381779@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit c0c1a6bf80e9075e3f6b81fd542550d8eb91e57a ]

[Why]
There are several ns_to_ktime() calls that require using nanoseconds. It is
better to replace them with us_to_ktime() to make code clear, getting rid
of multiplication by 1000.

Also the timer function code may have an integer wrap-around issue. Since
both tx_custom_low_usecs and tx_custom_high_usecs can be set to up to
9999999 from the user space via cec_pin_error_inj_parse_line(), this may
cause usecs to be overflowed when adap->monitor_pin_cnt is zero and usecs
is multiplied by 1000.

[How]
Take advantage of using an appropriate helper func us_to_ktime() instead of
ns_to_ktime() to improve readability and to make the code clearer. And this
also mitigates possible integer wrap-arounds when usecs value is too large
and it is multiplied by 1000.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-pin.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/cec/core/cec-pin.c b/drivers/media/cec/core/cec-pin.c
index a70451d99ebc9..f232c3df7ee16 100644
--- a/drivers/media/cec/core/cec-pin.c
+++ b/drivers/media/cec/core/cec-pin.c
@@ -873,19 +873,19 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 		if (pin->wait_usecs > 150) {
 			pin->wait_usecs -= 100;
 			pin->timer_ts = ktime_add_us(ts, 100);
-			hrtimer_forward_now(timer, ns_to_ktime(100000));
+			hrtimer_forward_now(timer, us_to_ktime(100));
 			return HRTIMER_RESTART;
 		}
 		if (pin->wait_usecs > 100) {
 			pin->wait_usecs /= 2;
 			pin->timer_ts = ktime_add_us(ts, pin->wait_usecs);
 			hrtimer_forward_now(timer,
-					ns_to_ktime(pin->wait_usecs * 1000));
+					us_to_ktime(pin->wait_usecs));
 			return HRTIMER_RESTART;
 		}
 		pin->timer_ts = ktime_add_us(ts, pin->wait_usecs);
 		hrtimer_forward_now(timer,
-				    ns_to_ktime(pin->wait_usecs * 1000));
+				    us_to_ktime(pin->wait_usecs));
 		pin->wait_usecs = 0;
 		return HRTIMER_RESTART;
 	}
@@ -1020,13 +1020,12 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 	if (!adap->monitor_pin_cnt || usecs <= 150) {
 		pin->wait_usecs = 0;
 		pin->timer_ts = ktime_add_us(ts, usecs);
-		hrtimer_forward_now(timer,
-				ns_to_ktime(usecs * 1000));
+		hrtimer_forward_now(timer, us_to_ktime(usecs));
 		return HRTIMER_RESTART;
 	}
 	pin->wait_usecs = usecs - 100;
 	pin->timer_ts = ktime_add_us(ts, 100);
-	hrtimer_forward_now(timer, ns_to_ktime(100000));
+	hrtimer_forward_now(timer, us_to_ktime(100));
 	return HRTIMER_RESTART;
 }
 
-- 
2.39.5



