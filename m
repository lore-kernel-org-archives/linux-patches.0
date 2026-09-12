Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032642D5C68;
	Sat, 12 Sep 2026 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226835; cv=none; b=JG5qsis9HKhfIDfKHTh4plScXOQBIrc7pJLNshsaq64lXXcoX7NpFdFLqTpOJiauTOP1vO5loSHl6OxXDxpdeKWxkgY/TPQ3c0GQku5d7N7eO0hgE0U8Ju1R5cXxV8PHUp04q2SE7h14Wx38FXklxio2d/dUu77IMkcbKn1X8uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226835; c=relaxed/simple;
	bh=9fJ1tndi96oy+RIu0PDn23Gj18Vyb1HTuynJIQHg+14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOqVYSNaAOVe70t3StrumFTzq/xvgBUUBWQuUXK119KndeSOBYY0Tslhhcv17rQFTZmZgC2LUogJdEB2Pjn0qTkOHEoX8PAhyeRlumWj4X6pHs8j6WUsi8CoCguE7eCPTdki2iDJDa80uVAmhnLjmsrgcUoil2h2MeQr73zooN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj7hqZ5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj7hqZ5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664671F000FF;
	Sat, 12 Sep 2026 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226833;
	bh=l63BVZpp52OHJyWANisySyHilUWXbRqWeC/SfNzfv4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aj7hqZ5qnn8OjJtxFuhT0Acsv2YiHAgtXhTQlidYVsyzZ8P1ngMjcQuhZds5X5wgV
	 8Rr5gGd/6dHDy1fmts9MSws+c93LdGkBg4+8is00M+IU/hpOzTb6HfmmqdgDVeenHc
	 242207l4d44z4YtcsFap1O6IQxE4S/mge30i3LeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Sizhe Liu <liusizhe5@huawei.com>,
	Yicong Yang <yangyccccc@gmail.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.1 0015/1191] hwtracing: hisi_ptt: Propagate DMA reset timeout in trace_start()
Date: Sat, 12 Sep 2026 08:45:43 +0200
Message-ID: <20260912065548.451918061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 75d42d990335322852ed5f7ce324b701c0949d79 upstream.

hisi_ptt_wait_dma_reset_done() discards the return value of
readl_poll_timeout_atomic(). If the DMA engine does not complete its
reset within the timeout, hisi_ptt_trace_start() proceeds to start
tracing regardless.

Return a bool from hisi_ptt_wait_dma_reset_done(), consistent with the
other wait helpers in this driver. On timeout, log an error, de-assert
the reset bit, and return -ETIMEDOUT. Move ctrl->started to the
successful path so a failed start does not leave the trace marked as
active.

Fixes: ff0de066b463 ("hwtracing: hisi_ptt: Add trace function support for HiSilicon PCIe Tune and Trace device")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Reviewed-by: Sizhe Liu <liusizhe5@huawei.com>
Reviewed-by: Yicong Yang <yangyccccc@gmail.com>
Tested-by: Sizhe Liu <liusizhe5@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260414172451.14331-2-sanman.pradhan@hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/ptt/hisi_ptt.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -171,13 +171,13 @@ static bool hisi_ptt_wait_trace_hw_idle(
 					  HISI_PTT_WAIT_TRACE_TIMEOUT_US);
 }
 
-static void hisi_ptt_wait_dma_reset_done(struct hisi_ptt *hisi_ptt)
+static bool hisi_ptt_wait_dma_reset_done(struct hisi_ptt *hisi_ptt)
 {
 	u32 val;
 
-	readl_poll_timeout_atomic(hisi_ptt->iobase + HISI_PTT_TRACE_WR_STS,
-				  val, !val, HISI_PTT_RESET_POLL_INTERVAL_US,
-				  HISI_PTT_RESET_TIMEOUT_US);
+	return !readl_poll_timeout_atomic(hisi_ptt->iobase + HISI_PTT_TRACE_WR_STS,
+					  val, !val, HISI_PTT_RESET_POLL_INTERVAL_US,
+					  HISI_PTT_RESET_TIMEOUT_US);
 }
 
 static void hisi_ptt_trace_end(struct hisi_ptt *hisi_ptt)
@@ -198,14 +198,18 @@ static int hisi_ptt_trace_start(struct h
 		return -EBUSY;
 	}
 
-	ctrl->started = true;
-
 	/* Reset the DMA before start tracing */
 	val = readl(hisi_ptt->iobase + HISI_PTT_TRACE_CTRL);
 	val |= HISI_PTT_TRACE_CTRL_RST;
 	writel(val, hisi_ptt->iobase + HISI_PTT_TRACE_CTRL);
 
-	hisi_ptt_wait_dma_reset_done(hisi_ptt);
+	if (!hisi_ptt_wait_dma_reset_done(hisi_ptt)) {
+		pci_err(hisi_ptt->pdev, "timed out waiting for DMA reset\n");
+		val = readl(hisi_ptt->iobase + HISI_PTT_TRACE_CTRL);
+		val &= ~HISI_PTT_TRACE_CTRL_RST;
+		writel(val, hisi_ptt->iobase + HISI_PTT_TRACE_CTRL);
+		return -ETIMEDOUT;
+	}
 
 	val = readl(hisi_ptt->iobase + HISI_PTT_TRACE_CTRL);
 	val &= ~HISI_PTT_TRACE_CTRL_RST;
@@ -230,6 +234,8 @@ static int hisi_ptt_trace_start(struct h
 	if (!hisi_ptt->trace_ctrl.is_port)
 		val |= HISI_PTT_TRACE_CTRL_FILTER_MODE;
 
+	ctrl->started = true;
+
 	/* Start the Trace */
 	val |= HISI_PTT_TRACE_CTRL_EN;
 	writel(val, hisi_ptt->iobase + HISI_PTT_TRACE_CTRL);


