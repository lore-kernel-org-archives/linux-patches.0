Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DEC175A6B;
	Mon, 17 Aug 2026 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978953; cv=none; b=pHMn35AqFddINpVeWFcWcXz9KWOZAG7lYLyYIKISN0/kMkZDyrppfvT2pXtfPspZIkH9m4tqkr09D4TilmKGFPLywc2oHqchNhNocqVLZnp90og2Pywzh86h5JQ3K7A0i+J0D1PlAREo33EE2RAN41M5BjV8plDqg8pQ4NgdDmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978953; c=relaxed/simple;
	bh=IReRz1IEPO5UIAnClFywfiwelNEBYhgFkx3O+CAO/50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjOcgdli67mRLVk7D71Y0KqJJNpo6Wm81xDYHLbUkmcDJe/LyCmZZybLfD1LCgMUbRY5VCh5Oq0edrjXKBdiSdX61kPBG+kIOMZ0QS1EKetbz6oc+WwcrVTeld8vItyVxgrCeWYZUOAvQvsft5U+M69m4y3fLCO1yZQVAObh87g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydZ2vWNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydZ2vWNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA051F000E9;
	Mon, 17 Aug 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978952;
	bh=Ubcp9WKKR3L/qOm53yLJj9PrBsYbdYesSgJVw5ROyEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydZ2vWNywUP9wu3GBBXIvQf/RzZBXq+PbO2/INIrGMH2jz83zVy3In+xJxLOLO01I
	 NwxxSYq7WM22njB/ZeuhW/zGKD7X4bBOadu0DjY2xlkG6FXRx3Pk+wvMeidFa/b9Mk
	 H6Eh2RlxkL6ybj35gkfk1Kfo0otA9YsvBNGKuhk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/609] firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context
Date: Mon, 17 Aug 2026 15:25:52 +0200
Message-ID: <20260817132545.316754611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 4782b115e6ec51..1bc715fe3968c3 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -595,9 +595,9 @@ int scmi_notify(const struct scmi_handle *handle, u8 proto_id, u8 evt_id,
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



