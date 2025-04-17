Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA68B261388;
	Thu, 17 Apr 2025 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914673; cv=none; b=Vh9GKI/NH9t2C4G9TPGdo7J+/5wr3jhjFJmRGVh/bESP1jdAKfzSbDrpR/E7jT4T3R/cvjacSk40C1dtOwrrEHpGMEdrTTRwaFsWnda0EzAkaj73nGPPFdpsqAnZa2z08rxUxkEX+dlXg++gF4Sk6A8M2ngNJ3Rey3R0ipDQ4WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914673; c=relaxed/simple;
	bh=1KprZBp084yJx9Rb1E3lPke7/D+9Pdtimi/c07wmMXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twtJM+yG7ljZPXA+51lgf/cnScerLPcU06Zi6uPAI8ju08MUkOmgWeyCUagy8KhEofy2HtY1oBYsGlRwl+CZjs9Y1/rRFx4xx0XHPc1nx6J0swO+Ed1XpXbiNh9Uz23elRX3fSM3A8pVcEAudcuMT/G1gbgMOPmCyw77VnuwglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+4+iHj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+4+iHj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02C6C4CEE4;
	Thu, 17 Apr 2025 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914673;
	bh=1KprZBp084yJx9Rb1E3lPke7/D+9Pdtimi/c07wmMXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+4+iHj31AiyqS951PJ/vIVgmIdvt1aHGR/UB/t6gJQMu+jma9PKoEUcJCmyctvnh
	 +qLMZLcLwkHZbAx+L4y35mS37OhbdXjm4lku2a8E3Lt8nT5bWfAa4GjYpBO8GgqVrQ
	 YOTc4YWXaWPqx8liOqLmULR82JRgBSPSb9EdJtcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Troy Hanson <quic_thanson@quicinc.com>
Subject: [PATCH 6.13 276/414] bus: mhi: host: Fix race between unprepare and queue_buf
Date: Thu, 17 Apr 2025 19:50:34 +0200
Message-ID: <20250417175122.529116473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Hugo <quic_jhugo@quicinc.com>

commit 0686a818d77a431fc3ba2fab4b46bbb04e8c9380 upstream.

A client driver may use mhi_unprepare_from_transfer() to quiesce
incoming data during the client driver's tear down. The client driver
might also be processing data at the same time, resulting in a call to
mhi_queue_buf() which will invoke mhi_gen_tre(). If mhi_gen_tre() runs
after mhi_unprepare_from_transfer() has torn down the channel, a panic
will occur due to an invalid dereference leading to a page fault.

This occurs because mhi_gen_tre() does not verify the channel state
after locking it. Fix this by having mhi_gen_tre() confirm the channel
state is valid, or return error to avoid accessing deinitialized data.

Cc: stable@vger.kernel.org # 6.8
Fixes: b89b6a863dd5 ("bus: mhi: host: Add spinlock to protect WP access when queueing TREs")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Reviewed-by: Youssef Samir <quic_yabdulra@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Troy Hanson <quic_thanson@quicinc.com>
Link: https://lore.kernel.org/r/20250306172913.856982-1-jeff.hugo@oss.qualcomm.com
[mani: added stable tag]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -1207,11 +1207,16 @@ int mhi_gen_tre(struct mhi_controller *m
 	struct mhi_ring_element *mhi_tre;
 	struct mhi_buf_info *buf_info;
 	int eot, eob, chain, bei;
-	int ret;
+	int ret = 0;
 
 	/* Protect accesses for reading and incrementing WP */
 	write_lock_bh(&mhi_chan->lock);
 
+	if (mhi_chan->ch_state != MHI_CH_STATE_ENABLED) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	buf_ring = &mhi_chan->buf_ring;
 	tre_ring = &mhi_chan->tre_ring;
 
@@ -1229,10 +1234,8 @@ int mhi_gen_tre(struct mhi_controller *m
 
 	if (!info->pre_mapped) {
 		ret = mhi_cntrl->map_single(mhi_cntrl, buf_info);
-		if (ret) {
-			write_unlock_bh(&mhi_chan->lock);
-			return ret;
-		}
+		if (ret)
+			goto out;
 	}
 
 	eob = !!(flags & MHI_EOB);
@@ -1250,9 +1253,10 @@ int mhi_gen_tre(struct mhi_controller *m
 	mhi_add_ring_element(mhi_cntrl, tre_ring);
 	mhi_add_ring_element(mhi_cntrl, buf_ring);
 
+out:
 	write_unlock_bh(&mhi_chan->lock);
 
-	return 0;
+	return ret;
 }
 
 int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,


