Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD37E422540;
	Thu, 30 Jul 2026 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421514; cv=none; b=cFTuB1TJo+bzWWPihWyXBCZ2FlddcZuIPo7q4ucOuAj2SVjLrOD+9zjGmGqHU9S9eOgosWZJNlxRLUicluzU6JXxQflz4rMsfzsR+v0RLZRGWoOLuosQl7DjWFej5zO5EPxObwcyPiCje1YGtRTL6f8VczEpCjb0WN1c4/W4F9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421514; c=relaxed/simple;
	bh=5YmGE9xRWfUZIC2dYtlkTqHo4AhIIxNwSxlNkzrmzWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFnst+3qKFBwYEad7CiYgHVfGNQX+ugWX18ahBU/eM06ijlTJXOrTexnXym6FCcIWSOgw7mqZ0tDLIAPxJeNc29onYBDLX8oXFXiLuvhljIhN8r9mJJdGmz1FBNstzF8+IU4caNAVzuv0ROuHksG68tog6SD94T4M6BeiQ3lWMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVQdZ9Aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVQdZ9Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449291F000E9;
	Thu, 30 Jul 2026 14:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421512;
	bh=ZsaRPsQiVj288y9PBhjLG06K1suidxYodpi/bE7FMjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVQdZ9AwSyaxDyZViL4J2i6jfU1cYVRJ7We4wds//ghIlTfP01Fb/kXJZKT7+PYmf
	 iGir0hfJS5M8ZtVICeyGs6nAi2ZVp0eTdC8jh+VTW1VW1O3Yy4xEFAACZwaXaKhTmU
	 +9Y2A4o7ZXGStGPkTsLUxWyjrWHb7vpYGry+bFSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 084/744] firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context
Date: Thu, 30 Jul 2026 16:05:57 +0200
Message-ID: <20260730141446.054839493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>

[ Upstream commit a4447c0693830d5ecadd6e755cb7fdc55d86aacc ]

The scmi_notify() function is called from interrupt context to queue
received notification events onto a per-protocol kfifo. When the kfifo
is full, it logs a warning via dev_warn() for every dropped event.

Under conditions where the platform sends a burst of SCMI notifications
faster than the deferred worker can drain the queue, this results in a
flood of dev_warn() calls from IRQ context. Each call acquires the
console lock and may execute blocking console writes, causing the CPU
to be held in interrupt context for an extended period and leading to
observable system stalls.

Fix this by switching to dev_warn_ratelimited() to limit the frequency
of log messages when the notification queue is full. This reduces
console overhead in interrupt context and prevents CPU stalls caused by
excessive logging, while still preserving diagnostic visibility.

Fixes: bd31b249692e ("firmware: arm_scmi: Add notification dispatch and delivery")
Signed-off-by: Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20260708072339.3021140-1-pushpendra.singh@oss.qualcomm.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/notify.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/notify.c b/drivers/firmware/arm_scmi/notify.c
index 40ec184eedaecc..0a192cf2deab62 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -600,9 +600,9 @@ int scmi_notify(const struct scmi_handle *handle, u8 proto_id, u8 evt_id,
 		return -EINVAL;
 	}
 	if (kfifo_avail(&r_evt->proto->equeue.kfifo) < sizeof(eh) + len) {
-		dev_warn(handle->dev,
-			 "queue full, dropping proto_id:%d  evt_id:%d  ts:%lld\n",
-			 proto_id, evt_id, ktime_to_ns(ts));
+		dev_warn_ratelimited(handle->dev,
+				     "queue full, dropping proto_id:%d  evt_id:%d  ts:%lld\n",
+				     proto_id, evt_id, ktime_to_ns(ts));
 		return -ENOMEM;
 	}
 
-- 
2.53.0



