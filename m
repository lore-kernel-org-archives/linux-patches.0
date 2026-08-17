Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81303E00B6;
	Mon, 17 Aug 2026 14:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975565; cv=none; b=Gmcasm8WayGPLejHomXNxKNCjS3BipgvcvvLrRyNdZt4Rgi8uzIYCCu/N9x4Qk3JTbA6ygHzUaS5qFa5dbXMNGda0mMoxkHrPMbI/jn9MNCV31oWAT9gnqYkI5na5eDvP2/ottBQmWMwNCQD6icLI+63p1WGa27mY7Lf2EU23WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975565; c=relaxed/simple;
	bh=4Uxa+gEZR+FIi+ppliXSN6WlP9GxkDF4HxILl4Q5j5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWYufKyuuNR2Q2AVgJF4r9Q65m7WTvEsYFsrXdHUoJ8iXY+L+7H+Na9hFxF2YzZFklPGpQtuvgNqpa+NfGS5M82b4u1nLV8qe6E7PmuWD6X4G7Ib49vJejlycNT0n/0o0rvuo1ce5ZcdiebU8GRbWLlkhJdB7vTbRB0+Q3vw4Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPWUGO/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPWUGO/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE431F000E9;
	Mon, 17 Aug 2026 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975564;
	bh=vugB5lU+IjNw4fmy9pKQDFrVGq1QnsBpK4+dYNGt76E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPWUGO/pZ55kkDGssZrBPiWAFHda8G1xRer1MkZjDC6lK47UCMVPIZPbcSPvi4lae
	 hdH5r00ZL2Vllhd5M+ChzpwfafojbsGv1hzDROFZOgZlY7LBf8IRyjWfhPvhbwqWEf
	 9JWGWk+jndQDkSXH1ZdDlbZHpBLDbiGaDssF1eMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/389] firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context
Date: Mon, 17 Aug 2026 15:27:50 +0200
Message-ID: <20260817132540.172087060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 66196b293b6c2a..99887349de2383 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -594,9 +594,9 @@ int scmi_notify(const struct scmi_handle *handle, u8 proto_id, u8 evt_id,
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



