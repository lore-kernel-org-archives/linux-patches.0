Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670974315F;
	Mon, 17 Aug 2026 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976592; cv=none; b=InDIGluTtki3DPIH479L0s6tlZduzGGkmgqn9LlNj22CWZxO5E1P54ntbZaJX18X+1B8VpcK6Q9+F4lEMKk3wq321a7uW2NxlcnKVBb2qD7CIW6Re2U6OviOOUHz1hiYOmyPH6B4V6AXzuKpm+9ma6IMi5m7GnEPGAnfTK4KBRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976592; c=relaxed/simple;
	bh=cSXfEkYMkZK/mwAKwIBtr+4gmoL9crsPDbbOEUOlrTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USnw+9+Jr0I1aaWiPJny/VvmiuB1xupfE6kYOYD7jnIZ7qTGKgQqWcOJMFeGCvb66wvXW2RIDm8ePqrVjjXtngKerF50Z8ZxzpIkBBANtXYnj9NIxyFwEAUBTDvnL88LDu1wDSjMrmhoG/yIv4PrRS8mzSSVAwV2apeoLU0FWLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGhU+a71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGhU+a71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08351F00A3A;
	Mon, 17 Aug 2026 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976591;
	bh=BqUUMnL/QDmg7CMH9RYPahaVlFHaMBTiVLN3Y6dCC3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGhU+a71IbJW+Yo/n2V10dj1T3e8eRMolvSxhRoCDxJseCZO5tfG03ddQGv4KXldi
	 sUPw4AoTuwCP04WOyV0ZnBgclHScB9OnccDqxAJdThhmly5kaYyUtpzMypkhmX1OL2
	 Cm+u/sHtQc9RGFmnVcF8NgbxLEbKZLh/8jBMdMUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/456] firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context
Date: Mon, 17 Aug 2026 15:27:06 +0200
Message-ID: <20260817132541.440135716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



