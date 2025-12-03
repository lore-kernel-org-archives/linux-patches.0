Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E4D3612DE;
	Wed,  3 Dec 2025 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781023; cv=none; b=BbPvNmDgrBGVMoGbHn7o8sAI5BUcQ8joE+TvdenpSL0GJtO47nmKeLsBpuetiVc/7QXkdq+DdcwL5bCaK0T9axJpXBaIr9AYrSLM4ejCzER2M9ezbT+2gyM3L+kg8Wcp4Hz/OFh4IwbkN5JvXUC3JZH9RLWXs85HHWddOoKCmpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781023; c=relaxed/simple;
	bh=dIalSW39EoXkLyMc5pbre8i8ETBvR7eATBZUudacDwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTcspIu8VkifatPH+w6EHEMrLh8Sol6/OUaSdLMLyVQHVkxOZcKbsKuVycUWIASGvfZeVgYTnkY6fnh87hLH+Eb7z4SwVWt4bBpOjoD9h6sXYJQS25WuB/kl9wJt52a0OS2/8USxVoy2tUZsDq6lpOOXzJkSgB1F7Ppv0eQv+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITXLYCYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITXLYCYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E721EC4CEF5;
	Wed,  3 Dec 2025 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781023;
	bh=dIalSW39EoXkLyMc5pbre8i8ETBvR7eATBZUudacDwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITXLYCYuJjkhyxbrzV8jz0zXAVvFw2XQbnh+g0i3LDfqAkudXQY7ZynBgzwVeqtKj
	 cHi0b5LdlJatzQIDsMYC9kVRtRv5CIadlZtPnMQB9yqZkGbs2KuGkVJhTC+Z/Bi5Ic
	 h5gXkV5fHBcc/u5+bWmZLJNTzeMo1W38Eko5/iG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/93] net: fec: do not update PEROUT if it is enabled
Date: Wed,  3 Dec 2025 16:29:11 +0100
Message-ID: <20251203152337.185317072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit e97faa0c20ea8840f45569ba434e30538fff8fc9 ]

If the previously set PEROUT is already active, updating it will cause
the new PEROUT to start immediately instead of at the specified time.
This is because fep->reload_period is updated whithout check whether
the PEROUT is enabled, and the old PEROUT is not disabled. Therefore,
the pulse period will be updated immediately in the pulse interrupt
handler fec_pps_interrupt().

Currently, the driver does not support directly updating PEROUT and it
will make the logic be more complicated. To fix the current issue, add
a check before enabling the PEROUT, the driver will return an error if
PEROUT is enabled. If users wants to update a new PEROUT, they should
disable the old PEROUT first.

Fixes: 350749b909bf ("net: fec: Add support for periodic output signal of PPS")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20251125085210.1094306-3-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h     |  1 +
 drivers/net/ethernet/freescale/fec_ptp.c | 43 ++++++++++++++++++------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 733af928caffc..d80a8c07c0200 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -683,6 +683,7 @@ struct fec_enet_private {
 	unsigned int reload_period;
 	int pps_enable;
 	unsigned int next_counter;
+	bool perout_enable;
 	struct hrtimer perout_timer;
 	u64 perout_stime;
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index cb3f05da3eee6..a3853fccdc7b6 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -244,6 +244,7 @@ static int fec_ptp_pps_perout(struct fec_enet_private *fep)
 	 * the FEC_TCCR register in time and missed the start time.
 	 */
 	if (fep->perout_stime < curr_time + 100 * NSEC_PER_MSEC) {
+		fep->perout_enable = false;
 		dev_err(&fep->pdev->dev, "Current time is too close to the start time!\n");
 		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		return -1;
@@ -501,6 +502,7 @@ static int fec_ptp_pps_disable(struct fec_enet_private *fep, uint channel)
 	hrtimer_cancel(&fep->perout_timer);
 
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	fep->perout_enable = false;
 	writel(0, fep->hwp + FEC_TCSR(channel));
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
@@ -532,6 +534,8 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 
 		return ret;
 	} else if (rq->type == PTP_CLK_REQ_PEROUT) {
+		u32 reload_period;
+
 		/* Reject requests with unsupported flags */
 		if (rq->perout.flags)
 			return -EOPNOTSUPP;
@@ -551,12 +555,14 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 			return -EOPNOTSUPP;
 		}
 
-		fep->reload_period = div_u64(period_ns, 2);
-		if (on && fep->reload_period) {
+		reload_period = div_u64(period_ns, 2);
+		if (on && reload_period) {
+			u64 perout_stime;
+
 			/* Convert 1588 timestamp to ns*/
 			start_time.tv_sec = rq->perout.start.sec;
 			start_time.tv_nsec = rq->perout.start.nsec;
-			fep->perout_stime = timespec64_to_ns(&start_time);
+			perout_stime = timespec64_to_ns(&start_time);
 
 			mutex_lock(&fep->ptp_clk_mutex);
 			if (!fep->ptp_clk_on) {
@@ -565,18 +571,35 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 				return -EOPNOTSUPP;
 			}
 			spin_lock_irqsave(&fep->tmreg_lock, flags);
+
+			if (fep->perout_enable) {
+				dev_err(&fep->pdev->dev,
+					"PEROUT has been enabled\n");
+				ret = -EBUSY;
+				goto unlock;
+			}
+
 			/* Read current timestamp */
 			curr_time = timecounter_read(&fep->tc);
-			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-			mutex_unlock(&fep->ptp_clk_mutex);
+			if (perout_stime <= curr_time) {
+				dev_err(&fep->pdev->dev,
+					"Start time must be greater than current time\n");
+				ret = -EINVAL;
+				goto unlock;
+			}
 
 			/* Calculate time difference */
-			delta = fep->perout_stime - curr_time;
+			delta = perout_stime - curr_time;
+			fep->reload_period = reload_period;
+			fep->perout_stime = perout_stime;
+			fep->perout_enable = true;
 
-			if (fep->perout_stime <= curr_time) {
-				dev_err(&fep->pdev->dev, "Start time must larger than current time!\n");
-				return -EINVAL;
-			}
+unlock:
+			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+			mutex_unlock(&fep->ptp_clk_mutex);
+
+			if (ret)
+				return ret;
 
 			/* Because the timer counter of FEC only has 31-bits, correspondingly,
 			 * the time comparison register FEC_TCCR also only low 31 bits can be
-- 
2.51.0



