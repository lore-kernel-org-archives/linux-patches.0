Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E13093CA;
	Mon, 27 Oct 2025 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591371; cv=none; b=IHHX3T+XAnyFL+VH/BXDgYQ3ntvZ6W+sZiAXQ6aw+oAzT7xOx6YMRxR9RSpiYRnRe/U0Q57lGJ/W/SJdACHQ/zpfR8Hcumwby1TZc9Ag05YFBODcxjVLWi7MGeh5zJR1jvk7MMcIKjQu6P9OgSX07BMrItJVErONVv9OKmY6ps4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591371; c=relaxed/simple;
	bh=WmGQ8tgXMNmGf4M3aexQJkQ3kXdSTfmnhwY+pHxEoeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsBi5VPMflUMKt2QCSdspsseehnoRoN0X1L9MFnCDA+gQVN6WqH/PDiGUqipwZIBRq+VGNz3t7+BUFe/EhIrCzJYMk90OqHY/YrkGK9ksVo72TasB+BPQTOf0aweik+tfGcWcMOn7HXQoLi7tvMZEMzG35AU1jTAHt6j0ltQD5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmFj8Wip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmFj8Wip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E23C4CEF1;
	Mon, 27 Oct 2025 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591371;
	bh=WmGQ8tgXMNmGf4M3aexQJkQ3kXdSTfmnhwY+pHxEoeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmFj8Wipl9pTN2Ji3MTJ7GKHxHuRUOHdHkHvINCZB46XIwY8X065KLy/nDqRLj3gY
	 OZWxfoJMBNjhDHOzhOWh6TY6pv66GiBwBuH0l1LH68jHJHATGK5GIlrnTRTzzaLWRD
	 MBc3Yz+j0OZXXgs5pNmkDiGbopwUGZLp96gMfHgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 154/332] rtc: interface: Ensure alarm irq is enabled when UIE is enabled
Date: Mon, 27 Oct 2025 19:33:27 +0100
Message-ID: <20251027183528.696381962@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -579,6 +579,10 @@ int rtc_update_irq_enable(struct rtc_dev
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


