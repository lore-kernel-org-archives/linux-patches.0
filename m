Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7FC1F6663;
	Tue,  3 Dec 2024 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236840; cv=none; b=M4jUo2ep5TVr8i4ZMH/JVp1yRN+BtNA8Oq+h6LD+54J3lH3TFgCimLk30xevcLt/ZJtTj2L0J2KGQLAVnSQAlIHGlg30Ra4I1EBJwZYp2+kc4XYj2U8Qq+kYbGkA3CIic/DTnUZyGZ7kqbi8SylmuWUrss8RSlKg+8r3dk315DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236840; c=relaxed/simple;
	bh=BWtMpcy3WKaiYRSii7IG+fST9rc00NiJWAk2wgic+oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Td8DQucWwFXU4LCM+k4xfvHlGpub3P4q6TvG87QJcRYJYv4Xgrk3iD4uAol9Gf71rh1b4mpvUIKeonOVNxc9aKAv/CUUSjcBGfbvDsuuhiCXOwoyFAQXeVewN6Bwzc+jnU2JSXTJDjym6/90PfBzxOGks0R8XW5uR5XiVpLNmN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfbdtujF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfbdtujF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A04C4CECF;
	Tue,  3 Dec 2024 14:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236839;
	bh=BWtMpcy3WKaiYRSii7IG+fST9rc00NiJWAk2wgic+oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfbdtujFUDUMCqEL1SGqY9ClWR+vRNcrKg2KRNbmlqXQq5G/7hH6iVhDn4mcHoP20
	 4DJxVbQI8urWaAQjwNKJBMSF+wdQWSbKsefq6zxMsRmpFFLip65ODmuubBFFrkpl+h
	 +fFxs/DNoX6/aq29YWZlXjZ/bEeSIWi9kfBXuk1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongliang Gao <leonylgao@tencent.com>,
	Jingqun Li <jingqunli@tencent.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/138] rtc: check if __rtc_read_time was successful in rtc_timer_do_work()
Date: Tue,  3 Dec 2024 15:32:39 +0100
Message-ID: <20241203141928.540130736@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ce051f91829f9..1ab619fb978a4 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -914,13 +914,18 @@ void rtc_timer_do_work(struct work_struct *work)
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



