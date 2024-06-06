Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7511BC063;
	Thu,  6 Jun 2024 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683501; cv=none; b=F/e1+Zwv4QsNvfuAsyBMNJp1nN3Cj24wqGaZT3YKgoSprKBjHU6Qy81Qcpq3pAYJbFSvmQamTwTyYdwNXPge2flgoZmnmQWg25L9aAXnIALklOUBljIibxkLoe8DYN1j0BG1VNMLYP7q8khcvauNiPQf1ANguTZY4fNwHA1hQY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683501; c=relaxed/simple;
	bh=fmIrb+T4oPu5BVtuF8ptg71CZyq0Xu8ywElI9HYpFCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6zQR/0kuZ/eRhNG+ZIfhFIuZMUvioMVEh02pdBDuXi3ayN/GAkQAVVhYmB0ve1z3P3Cs3YWhJ10EOwvEZOTVs7+t8KMsw1tl6YmITYEpmuniIC+YdIV2/L2G2MgFCbzJCHseQ9Ijh1/92InIBC4kzIA6Sq9NYDrPGp8q8+4ls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNLqrIr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNLqrIr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4EBC2BD10;
	Thu,  6 Jun 2024 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683501;
	bh=fmIrb+T4oPu5BVtuF8ptg71CZyq0Xu8ywElI9HYpFCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNLqrIr1n/j04kNMnIk0eHmSXyivRLCFU8Hkxs7+2qd6d2ypJAIV1Y5DK0cJ9bC51
	 bELzuLGpeI/+MZtv5dSmB3OYVZyfr3y1PlYUyGlbobFeOgy/ptV3eBDvLGJYlP6pd1
	 uEiIEt/aLsPjr1K57l/cLlJhCCBiY0VUtgMrW2DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.1 391/473] media: cec: core: avoid confusing "transmit timed out" message
Date: Thu,  6 Jun 2024 16:05:20 +0200
Message-ID: <20240606131712.768765631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit cbe499977bc36fedae89f0a0d7deb4ccde9798fe ]

If, when waiting for a transmit to finish, the wait is interrupted,
then you might get a "transmit timed out" message, even though the
transmit was interrupted and did not actually time out.

Set transmit_in_progress_aborted to true if the
wait_for_completion_killable() call was interrupted and ensure
that the transmit is properly marked as ABORTED.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yang, Chenyuan <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-media/PH7PR11MB57688E64ADE4FE82E658D86DA09EA@PH7PR11MB5768.namprd11.prod.outlook.com/
Fixes: 590a8e564c6e ("media: cec: abort if the current transmit was canceled")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 28e3f0091155d..a5e5f6a4af917 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -490,6 +490,15 @@ int cec_thread_func(void *_adap)
 			goto unlock;
 		}
 
+		if (adap->transmit_in_progress &&
+		    adap->transmit_in_progress_aborted) {
+			if (adap->transmitting)
+				cec_data_cancel(adap->transmitting,
+						CEC_TX_STATUS_ABORTED, 0);
+			adap->transmit_in_progress = false;
+			adap->transmit_in_progress_aborted = false;
+			goto unlock;
+		}
 		if (adap->transmit_in_progress && timeout) {
 			/*
 			 * If we timeout, then log that. Normally this does
@@ -744,6 +753,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 {
 	struct cec_data *data;
 	bool is_raw = msg_is_raw(msg);
+	int err;
 
 	if (adap->devnode.unregistered)
 		return -ENODEV;
@@ -908,10 +918,13 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	 * Release the lock and wait, retake the lock afterwards.
 	 */
 	mutex_unlock(&adap->lock);
-	wait_for_completion_killable(&data->c);
+	err = wait_for_completion_killable(&data->c);
 	cancel_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);
 
+	if (err)
+		adap->transmit_in_progress_aborted = true;
+
 	/* Cancel the transmit if it was interrupted */
 	if (!data->completed) {
 		if (data->msg.tx_status & CEC_TX_STATUS_OK)
-- 
2.43.0



