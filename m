Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CCC1C7D76;
	Thu,  6 Jun 2024 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683703; cv=none; b=jTaMwQXe6EppbfmYmxcECVY1T4har1ePM2Ur6Dr5Mur8t0rMwet6CM7mfmbfropiL0hqROTPLNikRDKUJcKSRWI/jgwO4TmLruEqIGHbzzvM7TT1DSYjqDnJA+O5TXV5ckqHzBtSrYl0Q1VW5poNdBYPiOW7Dl4RpwemfFjYG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683703; c=relaxed/simple;
	bh=NWRdHdzvlMYTirI7JCvCu7syK0YtcR89UkOsV7tZuPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1Ma/FxoqoniC4vOKqE4i8zrUSuLCleMYUhvwyTvgtTJTxm8hH7TlqrehZ8YvV630zWcdiB4CnFzKEWISxCODpnQjyocEsix9CaDqCdnjd8Cs6D4Sx14C/Sckg44NPyjT0RWW7xnofVGYCp5RM5M9coDgaXirpTea2ZLBR7BbIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgaaJ6Sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgaaJ6Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BF0C2BD10;
	Thu,  6 Jun 2024 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683703;
	bh=NWRdHdzvlMYTirI7JCvCu7syK0YtcR89UkOsV7tZuPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgaaJ6SvcKQJeI02wudhF0bsSd/mIHkL9UhfAXDvOaRFxAs42CB9L3yBs0eMfb+H/
	 BszC5jTVOHzE2IHZ4NEik0r8O9z0k6pMtxdVz/VkfgWIY2AuYSeSNTSpDD0zEua2fz
	 j6jz49iegLhi6CzeGOxN+bZWZxNtN3ho4BNiOEQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.6 610/744] media: cec: core: avoid confusing "transmit timed out" message
Date: Thu,  6 Jun 2024 16:04:42 +0200
Message-ID: <20240606131752.053623118@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c15abee3e9bc4..3b67e922f9815 100644
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



