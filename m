Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1F6196D99;
	Thu,  6 Jun 2024 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682999; cv=none; b=IiKcIdOFeUdRpaehpFz89yXwE4RSoti9UqUf3hvZrGr9ASY2QW/GhXlO/a1CAZYsCqM4r6B4OwDgSZrOk2hP6M6kOAhdlGCvAa6RHszvs9mXAP4m1u54MIoKwbh8B2QBSbqQ3tJ+XOl1T4Nu9drkNNsgTvjo2A41uPRfwU4wb1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682999; c=relaxed/simple;
	bh=f3Prjbmfra6Fgc6lt1CQ4aYO7hQY2yPF5vsL/mc4qr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS+G3KqAkHhNS7FhIQxPUZ78M8KlzacjvgrqU0MhfvG9XJzWkT4/8Eapcsz+OrXA8ohLNg92/EYUUGQIuK52C8GPpyqXpxnDMZHMtFKhXRoqZ6eAPZmqkgv+lJ1aJLNe4oj8ywiS6VsqNq8MGRJsA2t0R1fen9WigCKjXr/knpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqYol4yH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqYol4yH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7E1C32786;
	Thu,  6 Jun 2024 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682999;
	bh=f3Prjbmfra6Fgc6lt1CQ4aYO7hQY2yPF5vsL/mc4qr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqYol4yHoLdwv0q1+cMJ88V/zy1eCOtiGZZ/Xrcz6ARG/Oy+/iLwYmWdFVq4eDojQ
	 x/lsxUAxX1f1PlQynYn8GFdxZ1o/NcNuT1HqzqsDcZUPn8E6Qy25kV9etOuaLkNmHJ
	 QBqeyfXSnLx4PFOiEi+H01h2XW+I9A5YSZTKzS9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.9 201/374] media: cec: core: avoid confusing "transmit timed out" message
Date: Thu,  6 Jun 2024 16:03:00 +0200
Message-ID: <20240606131658.563766556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a493cbce24567..da09834990b87 100644
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
@@ -771,6 +780,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 {
 	struct cec_data *data;
 	bool is_raw = msg_is_raw(msg);
+	int err;
 
 	if (adap->devnode.unregistered)
 		return -ENODEV;
@@ -935,10 +945,13 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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



