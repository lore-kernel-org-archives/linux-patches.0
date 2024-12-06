Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EACB1FCF7D;
	Fri,  6 Dec 2024 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498460; cv=none; b=Yy5hLSDHt7NSzk3G/6Eyp5lwyZWW3i0zlnB/WFUU7oZ/6F08jWqCkHvA5kzaI2qbJXc8wX5Qq9/YPzeCAqLm0tkcMF6LWU6T/eoIHoTpmAUhLWvCLbkyAibU7UmNq3HG7GZHYzfF9EYbFKk9afOlhtAr7fkRfwaaydk3R50bRXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498460; c=relaxed/simple;
	bh=gwMiC+zk1LRNi9qwazw31bZ/qx3qpuGsZObfzOJFzR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEXbzBB4G3sL2EbC1yM57lXOLgo52oqJOIvFJVFd5uGIc5eHYHx7Pfvai7zIsqgIRyGk2bm2sQlwyhxev+YanSnHGGOHc2IKX5DLxcMef6+i+LczWa55mLd8ipQV8TQA3wNwXnlVUrgHd1iKB4GWIvr2KFQEyBuxigmrTGQLh+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9OC6KgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9OC6KgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A34C4CED1;
	Fri,  6 Dec 2024 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498460;
	bh=gwMiC+zk1LRNi9qwazw31bZ/qx3qpuGsZObfzOJFzR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9OC6KgZzrtZqdVAppgKoorIcTRYDPSoBMbfA7qzQU2TgbRuYTs52uXn9JEovGppO
	 SAYTAbuvpfUMCYFAYbip+FBhUoiV4MY7g6gcqFCWJ3Byq/xr0MU0iF8EsbhwlO0u9c
	 h0SfYUTgo0CpMovVkauSZxQbiACee5NwHp+0vW94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongliang Gao <leonylgao@tencent.com>,
	Jingqun Li <jingqunli@tencent.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 560/676] rtc: check if __rtc_read_time was successful in rtc_timer_do_work()
Date: Fri,  6 Dec 2024 15:36:19 +0100
Message-ID: <20241206143715.242501007@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b23706d9fd3c..4a7c41a6c21e7 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -904,13 +904,18 @@ void rtc_timer_do_work(struct work_struct *work)
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



