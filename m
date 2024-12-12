Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C29223326;
	Thu, 12 Dec 2024 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022882; cv=none; b=U4qcMCVFSEepYslRdI5APT0JkSqO6attWMNdPWeQZU+T2lweWHw6J7VkVzwwYPa3FRAfIEviUctxE31pLHD2TtZEsQFmT3Rw7f+c4YtU37B6kr9ATiEea/L1xt6PZUx5SSh19veB6pcOn02H1jqs9g+a7Ilrt6PDjLgrnVEPgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022882; c=relaxed/simple;
	bh=9dwRpKNZzeU8bP53oaQ8l9iAeAWZCr78a48qaLPtSvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXA7EtwVQJywR7n1D6lErJaPXj14l5KJYHJH0C03VoKIxdPwfoAobRlxQkb4yx+VlXQw0+fjbmIJ+aVk6oYQQu8uvKqQg+wKcdPP9AcjIirWhPimi7jmFYqpCu1NQIuD7Us8p5yizPMoIYfteyH3rQ0eBzJ3Gt8nEOF4Rw4Dljc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNhouiAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNhouiAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3ECC4CECE;
	Thu, 12 Dec 2024 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022881;
	bh=9dwRpKNZzeU8bP53oaQ8l9iAeAWZCr78a48qaLPtSvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNhouiAxaTE/5MjQfxZ8YHxWrlby3+ZTlyuZdtFtqEVnyQIfIE4ZKDxv04U+RtvnJ
	 nW7e0rDoHIqm/Ju4nF7eE6jenG9Z4KpaYggYQGRmxonTeD4Uw8IpwC6HkV7Bz0TAW4
	 jHp+4WPJmQZkxsj581E7twAyuNsVzPSQTWtdhSVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongliang Gao <leonylgao@tencent.com>,
	Jingqun Li <jingqunli@tencent.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/565] rtc: check if __rtc_read_time was successful in rtc_timer_do_work()
Date: Thu, 12 Dec 2024 15:59:15 +0100
Message-ID: <20241212144325.842764285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 29c12947e73fc..7c62b13077627 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -893,13 +893,18 @@ void rtc_timer_do_work(struct work_struct *work)
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



