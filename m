Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CFC392829;
	Sat, 17 Oct 2026 17:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258597; cv=none; b=kN03OVfYKRZN3GHDU94OAIvipBOzXi5yVhThyIkZ9Je9U8lqHF26slSLgBwcWs7ZCfuWGK5NVZGyENYpTl2mZOpLI/qYQWlBRSt9ATYNynremj1fzB4RQznoq6Jk+FVWo81eNQkBJynXBBPQJsEsBlnHZLc8MbKdOd4TuMm2rH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258597; c=relaxed/simple;
	bh=V1GwtuJNrmUXVZ4kdl9wQIrhsFK+mOxMnQGcU1rP4WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7tYWvmCzYTOeBw3/UqgIePWyqUWE7E7xpJstSWgF1g6b/3tOjwQXfIwlkPhH4mlN6HOmYfUGwEAnqFfLEwRO872FTt1IMqZHAY2JA7v5S29lQtpDju2wPg7tumypPuhKVTasQ9vvYHiibBbZ37hv5e1IU28BK+J/YZBGFFlT9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldHr+IQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldHr+IQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33421F000C4;
	Sat, 17 Oct 2026 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258596;
	bh=aUnj8e6Y+bTQvTDQRhOGK6Bo7zEl7KN4KURygen5vQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldHr+IQnnPFxgr+OJbs7AJVApTfrjoBzNJJrL/XLq8wvXcOYZ/Ml/qWfiZagNB9vm
	 7MIsFo2OTv28FT9ZMYmkDV4COeuoS2ajPaMkChJbzN/AODg1HQmHFjEBNJK4/4CKlz
	 9B2wPQ5KfX147Js3k/1xOaPQsX2L/g8gF8VgJAJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0938/1674] i3c: mipi-i3c-hci: Fix race in DMA ring dequeue
Date: Sat, 17 Oct 2026 17:53:30 +0200
Message-ID: <20261017160455.206489841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1dca8aee80eea76d2aae21265de5dd64f6ba0f09 ]

The HCI DMA dequeue path (hci_dma_dequeue_xfer()) may be invoked for
multiple transfers that timeout around the same time.  However, the
function is not serialized and can race with itself.

When a timeout occurs, hci_dma_dequeue_xfer() stops the ring, processes
incomplete transfers, and then restarts the ring.  If another timeout
triggers a parallel call into the same function, the two instances may
interfere with each other - stopping or restarting the ring at unexpected
times.

Add a mutex so that hci_dma_dequeue_xfer() is serialized with respect to
itself.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 3 +++
 drivers/i3c/master/mipi-i3c-hci/dma.c  | 2 ++
 drivers/i3c/master/mipi-i3c-hci/hci.h  | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 10c400da66403..6cc89cf01c662 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -747,6 +747,9 @@ static int i3c_hci_probe(struct platform_device *pdev)
 	hci = devm_kzalloc(&pdev->dev, sizeof(*hci), GFP_KERNEL);
 	if (!hci)
 		return -ENOMEM;
+
+	mutex_init(&hci->control_mutex);
+
 	hci->base_regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(hci->base_regs))
 		return PTR_ERR(hci->base_regs);
diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 7b13508ccca66..60da4be20c5f2 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -450,6 +450,8 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	bool did_unqueue = false;
 	u32 ring_status;
 
+	guard(mutex)(&hci->control_mutex);
+
 	ring_status = rh_reg_read(RING_STATUS);
 	if (ring_status & RING_STATUS_RUNNING) {
 		/* stop the ring */
diff --git a/drivers/i3c/master/mipi-i3c-hci/hci.h b/drivers/i3c/master/mipi-i3c-hci/hci.h
index f109923f6c3f3..39490bc9f84f6 100644
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -43,6 +43,7 @@ struct i3c_hci {
 	const struct hci_io_ops *io;
 	void *io_data;
 	const struct hci_cmd_ops *cmd;
+	struct mutex control_mutex;
 	atomic_t next_cmd_tid;
 	u32 caps;
 	unsigned int quirks;
-- 
2.53.0



