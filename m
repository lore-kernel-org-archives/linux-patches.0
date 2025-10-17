Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14956330B00;
	Fri, 17 Oct 2025 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716475; cv=none; b=hxY+4h5t8H+WQqU7La5Cl796nsWqNEdYYbRq1ls19Ki8o441V7CVgMscRGsrAXbU7xxCMTyihMyNLON17FiTQqDZ7bFJpOz4gCPLnk6z62dsCAFd+S+qFKjlhvH9ixbGprTO0RcN+vOpk9xpdQpdJBX14ZzyPVexFtCqNsEZ398=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716475; c=relaxed/simple;
	bh=kHvgyH9hG29mmLXti7jhfo+LoHAkEvALoASPOXQEEuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+axDe1JpwX4QCwkU7sw5xyJsdEVRtNTnt7k3KWQaVcuxxErOGX+v6GpycfEDuoFlio2cLMYhECvnlgoMGLmwOW3UiBJbRbUWbVva7WqNv4Ov7EgMY+xlPL2ac6TGnrqrfqlrvjwO+kXnO+TsPTyEkYXKmwEPu2F+4AKsvMOwLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS4TKjt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS4TKjt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B541C4CEE7;
	Fri, 17 Oct 2025 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716474;
	bh=kHvgyH9hG29mmLXti7jhfo+LoHAkEvALoASPOXQEEuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS4TKjt42VRPwSs2j8SDnwBeDu8HE7VQaXeCbiExZPeA2bSv3Ks8GnSutTCNAiDnT
	 u7x6qjhOEZ0Jgkwynqd8y9i14SBbU90VpmW+4p78bEjCtsuF8lwFoM9K3QUvt5lztE
	 p9xTqvOdI1ttxD+KONjUq/K7fZUcgclUpUGFGduc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 203/276] rtc: interface: Fix long-standing race when setting alarm
Date: Fri, 17 Oct 2025 16:54:56 +0200
Message-ID: <20251017145149.879224571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

commit 795cda8338eab036013314dbc0b04aae728880ab upstream.

As described in the old comment dating back to
commit 6610e0893b8b ("RTC: Rework RTC code to use timerqueue for events")
from 2010, we have been living with a race window when setting alarm
with an expiry in the near future (i.e. next second).
With 1 second resolution, it can happen that the second ticks after the
check for the timer having expired, but before the alarm is actually set.
When this happen, no alarm IRQ is generated, at least not with some RTC
chips (isl12022 is an example of this).

With UIE RTC timer being implemented on top of alarm irq, being re-armed
every second, UIE will occasionally fail to work, as an alarm irq lost
due to this race will stop the re-arming loop.

For now, I have limited the additional expiry check to only be done for
alarms set to next seconds. I expect it should be good enough, although I
don't know if we can now for sure that systems with loads could end up
causing the same problems for alarms set 2 seconds or even longer in the
future.

I haven't been able to reproduce the problem with this check in place.

Cc: stable@vger.kernel.org
Signed-off-by: Esben Haabendal <esben@geanix.com>
Link: https://lore.kernel.org/r/20250516-rtc-uie-irq-fixes-v2-1-3de8e530a39e@geanix.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/interface.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -442,6 +442,29 @@ static int __rtc_set_alarm(struct rtc_de
 	else
 		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
 
+	/*
+	 * Check for potential race described above. If the waiting for next
+	 * second, and the second just ticked since the check above, either
+	 *
+	 * 1) It ticked after the alarm was set, and an alarm irq should be
+	 *    generated.
+	 *
+	 * 2) It ticked before the alarm was set, and alarm irq most likely will
+	 * not be generated.
+	 *
+	 * While we cannot easily check for which of these two scenarios we
+	 * are in, we can return -ETIME to signal that the timer has already
+	 * expired, which is true in both cases.
+	 */
+	if ((scheduled - now) <= 1) {
+		err = __rtc_read_time(rtc, &tm);
+		if (err)
+			return err;
+		now = rtc_tm_to_time64(&tm);
+		if (scheduled <= now)
+			return -ETIME;
+	}
+
 	trace_rtc_set_alarm(rtc_tm_to_time64(&alarm->time), err);
 	return err;
 }


