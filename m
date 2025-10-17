Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02EE23EA9E;
	Fri, 17 Oct 2025 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713890; cv=none; b=Hj6FLk2xv+RdQbL7Ule0rMuFY3A0RIxuqJbWlTmUcHCb+gQzgY/vs65mHhiw39VhTubtN0RGEAj+N82B56Z+Eh2IbMC9xRSxjRfpusbSrEsKMXKhXfAAdebiQYLduEU9YxWisXcuuyeCFlt7o5OuImnrfOo9ZgHii/ikjwgTxV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713890; c=relaxed/simple;
	bh=NWqSh39vH0zK9UvxTr0ECfXAmHnPQPHPDG6ryVHwCl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZYXudorFFgFGWxJU43sH0a32K9aCirrMBEwnkuIl8FURc8BA53+hIVOd6p7GOAt9BlSq+2WHEdE0en+cE3B6Q73e3yVwU1gzQ57v0msODTs7I2p1atO9R10AcdiS3+QePbO0IG28m7l9MHqvxwf8eNp24/kH+zKNekSeR2XKmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tknb5A2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tknb5A2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A17AC4CEE7;
	Fri, 17 Oct 2025 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713890;
	bh=NWqSh39vH0zK9UvxTr0ECfXAmHnPQPHPDG6ryVHwCl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tknb5A2s95AWRgWyhsKs5H/7r5xliA80qFyCyZsD+CiXA7a4nAAVnWSrxKumKNNpy
	 D58WEP42YyGSRJJpLNldo4m/Z/8yETk4D8c56U1QTOKb4314SeaqCEUSo1a2JicZi8
	 K0fgm9U+9WCKDdJWa8GAzX21IYwQXkXbgcRhIif0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 122/201] rtc: interface: Ensure alarm irq is enabled when UIE is enabled
Date: Fri, 17 Oct 2025 16:53:03 +0200
Message-ID: <20251017145139.224062273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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


