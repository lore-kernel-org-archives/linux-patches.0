Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F182F12D6;
	Fri, 17 Oct 2025 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713263; cv=none; b=PB/iTU2SvfrEPUBNb9Si4y7wiZXl/wKTEWQSl7eW1Mz2Oyqb/1i+NuuYTGdMrkyQWc7vp0zS4j3KlQ/VH29cS4nv6ZwuCJWNRxh8O+H7byle/qTOJfVwyd321L+CddDYQj05gKlqjiFxKqaQ0S9m3BFqpqt3zlkad0Rn4Bf1YCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713263; c=relaxed/simple;
	bh=ga9xnGzZO3+LfhUahlJA0OGVApkTR53Cjd+aG08cJmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy+HEF80rCreMOSH6gEOE4zGPaJUsij0rPa5D8gpFD/mY8ep/HGnSUxoq5r804lxpanOoK0/2MsZeCVKSGrb4ZuHFj9piicopAaghD1qgvHnnRb2ZTYqBeNUDcaiZXpJl4hkUp8NMclXPu+yGiWfnQfF2kCi/uL4RYD1v4Vnuj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6DuhV/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6DuhV/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04D2C4CEE7;
	Fri, 17 Oct 2025 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713263;
	bh=ga9xnGzZO3+LfhUahlJA0OGVApkTR53Cjd+aG08cJmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6DuhV/A648othNB6ZkSVxLK2/LaSnajDIP1C8nWIcat+DiryN5rZcoUj7UFMMPgT
	 5e+uDoxOnuF8XpXCU6Cnd/SCtx6/7CLfzsZwYjcuqWspf/9WOWXlyBerp6c05D/leo
	 MltVu0GfMdh9rMsYKCW+tbGD070Mlv/vKghRM7ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 105/168] rtc: interface: Ensure alarm irq is enabled when UIE is enabled
Date: Fri, 17 Oct 2025 16:53:04 +0200
Message-ID: <20251017145132.894465369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -594,6 +594,10 @@ int rtc_update_irq_enable(struct rtc_dev
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


