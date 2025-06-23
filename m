Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2652015ADB4;
	Mon, 23 Jun 2025 22:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717397; cv=none; b=C1SQE2P7rykCXFyQOGzrqNcbEKIGtVuETko0aovhu5N6Aq2Un6R6P+KEyCmgNnH5SBXEuIjd2UQdw8fK/7QJWfdQMdc8nAAolz2e1FeYNWw2DPOE6lBZUPthKNZ7def7Q5WWcbFoTmDZMYB9rPCFGLuAHI9CqLKHB2Mw0KTkYyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717397; c=relaxed/simple;
	bh=CSK0nW4g2jm8evcgl3Z9LY5w8IgutJLnyIfDGb3/JTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIDTY8qXu6zLW3carUo0BAD4qvzOurxqPHZ/zhLFLX1w1KiCKwm5eC1Nowmcd6IGUT25jahCDkPWMZAKNP3R4tGTNVJyaz8+29BbYXfN4T85IMOV9zFgW6eq8EfQLCmukACWfiVDqug1HgnUeetENdHMjWunxJMaDBWFqY2IlzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGLstTIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGLstTIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC58C4CEEA;
	Mon, 23 Jun 2025 22:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717397;
	bh=CSK0nW4g2jm8evcgl3Z9LY5w8IgutJLnyIfDGb3/JTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGLstTIT4KJiBLPbfV523yoH1xxuu8BsdsQ2XbOoyCviiGrweGNwvexS+t/9IUAx1
	 Gh8x31A+wS+F4WQD3GddJ59LfwY0/zN0QKX0K6ACRpSOnbwlgHwcthYVA9dLWxf2vR
	 uyFb03xlVwKgn5PD/983mxZTBKUeBLR0EochZ6lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/414] wifi: carl9170: do not ping device which has failed to load firmware
Date: Mon, 23 Jun 2025 15:08:36 +0200
Message-ID: <20250623130651.426641232@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 15d25307692312cec4b57052da73387f91a2e870 ]

Syzkaller reports [1, 2] crashes caused by an attempts to ping
the device which has failed to load firmware. Since such a device
doesn't pass 'ieee80211_register_hw()', an internal workqueue
managed by 'ieee80211_queue_work()' is not yet created and an
attempt to queue work on it causes null-ptr-deref.

[1] https://syzkaller.appspot.com/bug?extid=9a4aec827829942045ff
[2] https://syzkaller.appspot.com/bug?extid=0d8afba53e8fb2633217

Fixes: e4a668c59080 ("carl9170: fix spurious restart due to high latency")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20250616181205.38883-1-dmantipov@yandex.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/usb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index a3e03580cd9ff..564ca6a619856 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -438,14 +438,21 @@ static void carl9170_usb_rx_complete(struct urb *urb)
 
 		if (atomic_read(&ar->rx_anch_urbs) == 0) {
 			/*
-			 * The system is too slow to cope with
-			 * the enormous workload. We have simply
-			 * run out of active rx urbs and this
-			 * unfortunately leads to an unpredictable
-			 * device.
+			 * At this point, either the system is too slow to
+			 * cope with the enormous workload (so we have simply
+			 * run out of active rx urbs and this unfortunately
+			 * leads to an unpredictable device), or the device
+			 * is not fully functional after an unsuccessful
+			 * firmware loading attempts (so it doesn't pass
+			 * ieee80211_register_hw() and there is no internal
+			 * workqueue at all).
 			 */
 
-			ieee80211_queue_work(ar->hw, &ar->ping_work);
+			if (ar->registered)
+				ieee80211_queue_work(ar->hw, &ar->ping_work);
+			else
+				pr_warn_once("device %s is not registered\n",
+					     dev_name(&ar->udev->dev));
 		}
 	} else {
 		/*
-- 
2.39.5



