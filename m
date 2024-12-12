Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA5F13CA93;
	Thu, 12 Dec 2024 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024430; cv=none; b=BaYz9WKR5qz+5hwM//5uIbR+oXLdRt8k4ofHw9Wr5rOLOA45A89H3pH+diMsRvMBIh/bf6A18hnnb2VGkznNK0XMTsSevs/MAJ5XGDKbJmSwgBvaW308pOlTwFVeX0eA5EVqWRkKsbx4K7jNnxjhQ/2tPrSIYfBacax9e69xavg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024430; c=relaxed/simple;
	bh=7IWzkiEw9LReODGudC7fbeOi5DVlZ6TEhiUE7zpbFKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex+DzKPgLv1+XFrRX1grSPaQWnavEaQx236bU+0dXPl0XFa+AXc9YadUvdUZhpXPtGFgQnN0ks28dCxJngq+tNZlK2tAteH1L5EZ/RrUmC9Z9T90f5R3f3/Q0ML9VVL9IN01DJ4pPtx7kYJN0Hn0LMzhFvDbNdygOnyich9jfuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBG4ZWCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBG4ZWCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAC8C4CED0;
	Thu, 12 Dec 2024 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024430;
	bh=7IWzkiEw9LReODGudC7fbeOi5DVlZ6TEhiUE7zpbFKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBG4ZWCk4F2B42LPXAWQcWXogqZA9jUiTLSlYdWBQ/6GDIKPux0LExeZt4FO/Dd1s
	 6paR1WwHUr0U2RS5mW9scYnCTMLI7fsvGZbByn8c/39+IrDglLp4Jr/rsO3VH//Rno
	 QrKtJ4G4fSVWQv9L7qnhlmRIdEIVBjFtJ2nW4xww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongliang Gao <leonylgao@tencent.com>,
	Jingqun Li <jingqunli@tencent.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/459] rtc: check if __rtc_read_time was successful in rtc_timer_do_work()
Date: Thu, 12 Dec 2024 16:00:32 +0100
Message-ID: <20241212144305.250865650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongliang Gao <leonylgao@tencent.com>

[ Upstream commit e8ba8a2bc4f60a1065f23d6a0e7cbea945a0f40d ]

If the __rtc_read_time call fails,, the struct rtc_time tm; may contain
uninitialized data, or an illegal date/time read from the RTC hardware.

When calling rtc_tm_to_ktime later, the result may be a very large value
(possibly KTIME_MAX). If there are periodic timers in rtc->timerqueue,
they will continually expire, may causing kernel softlockup.

Fixes: 6610e0893b8b ("RTC: Rework RTC code to use timerqueue for events")
Signed-off-by: Yongliang Gao <leonylgao@tencent.com>
Acked-by: Jingqun Li <jingqunli@tencent.com>
Link: https://lore.kernel.org/r/20241011043153.3788112-1-leonylgao@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/interface.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 154ea5ae2c0c3..a755f4af1c215 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -907,13 +907,18 @@ void rtc_timer_do_work(struct work_struct *work)
 	struct timerqueue_node *next;
 	ktime_t now;
 	struct rtc_time tm;
+	int err;
 
 	struct rtc_device *rtc =
 		container_of(work, struct rtc_device, irqwork);
 
 	mutex_lock(&rtc->ops_lock);
 again:
-	__rtc_read_time(rtc, &tm);
+	err = __rtc_read_time(rtc, &tm);
+	if (err) {
+		mutex_unlock(&rtc->ops_lock);
+		return;
+	}
 	now = rtc_tm_to_ktime(tm);
 	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
 		if (next->expires > now)
-- 
2.43.0



