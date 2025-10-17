Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947D330B0F;
	Fri, 17 Oct 2025 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716472; cv=none; b=uuRfi8A8I7FxsDA5nQvQrIMxaMUA+PgUbj5Kx1CsxySRTdTxYMNJaV9SnjvtPwSutOjg2SPUaSp29ryAGcnd8XxtY4d+Z84+vty22YNY9Hs+ILP7tVSPsV0xeLxqr8KGl/4Oek6AjeJsAY3euJrmCLoSO5q4M4gR50hwsUp1EFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716472; c=relaxed/simple;
	bh=Vf6eDq0zkVRdwgrrJ1hLpTzAQfsp9cvLF/+v92zGmrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB6ezS8wOseN05Sxc2V+V1Ui3y+nmDjmKCMXrSc3cXPGuPhdQb6v6saqwAtUNB2+0cV6uB3M96W2TEo1yAZ1eD9OACP3mr8fbqCvQBum1JSFVid5/rmal0owxeD6qZx9mW0ordAdt7YtIAPbv0px2AvGtBH1i1gxpYgRvjtNlz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1BNaVE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1BNaVE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F9BC4CEE7;
	Fri, 17 Oct 2025 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716472;
	bh=Vf6eDq0zkVRdwgrrJ1hLpTzAQfsp9cvLF/+v92zGmrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1BNaVE20aFdIMU9Q53uNHslF5/TQB1lwDSQmDGUWzdny03YH+K0RX+Sb9D3UM7tN
	 425Bmp0lEuTTbUH3FIJGdbB6dcoQe2YQoBrWluILmFoSqZb3qI9NZLGgioqwB+gDT3
	 k3S4bbgR5SYhiZMZeo331N3jyzC4J8SctfQ3pv1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 202/276] rtc: interface: Ensure alarm irq is enabled when UIE is enabled
Date: Fri, 17 Oct 2025 16:54:55 +0200
Message-ID: <20251017145149.843353388@linuxfoundation.org>
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

commit 9db26d5855d0374d4652487bfb5aacf40821c469 upstream.

When setting a normal alarm, user-space is responsible for using
RTC_AIE_ON/RTC_AIE_OFF to control if alarm irq should be enabled.

But when RTC_UIE_ON is used, interrupts must be enabled so that the
requested irq events are generated.
When RTC_UIE_OFF is used, alarm irq is disabled if there are no other
alarms queued, so this commit brings symmetry to that.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250516-rtc-uie-irq-fixes-v2-5-3de8e530a39e@geanix.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/interface.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -583,6 +583,10 @@ int rtc_update_irq_enable(struct rtc_dev
 		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
 		rtc->uie_rtctimer.period = ktime_set(1, 0);
 		err = rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
+		if (!err && rtc->ops && rtc->ops->alarm_irq_enable)
+			err = rtc->ops->alarm_irq_enable(rtc->dev.parent, 1);
+		if (err)
+			goto out;
 	} else {
 		rtc_timer_remove(rtc, &rtc->uie_rtctimer);
 	}


