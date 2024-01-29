Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A10E15B317;
	Mon, 29 Jan 2024 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548636; cv=none; b=or3VCzidnJ4h/OBAZbJ6DOfItKV9AoNfLXqOaer/+/pPMyC5dm9ruJckO5QBeQwhqr3BI5gQdglUCHImJ508Nm7gj/FworuphB0ZbfEeJ3Nq4scQDQCDu1sU8R8TSv4eoP5p0emM0hBisZFJzK+i1HE3cUlTQrjKygBFbIiY8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548636; c=relaxed/simple;
	bh=fTOEKKPxUnd2aYPyEm53SBhcdj7KpbxDeDX8CYjq88I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUYW2owphXa/x8an1cIj2A55cWxYQD5FLAS7vqz435DL0s5lTEtKfUK79i/0MeByLseM42k6yAKq9atqDIhQ8q5f8WkT22rwHVZa0I88xs8mwX1m7sAantqXWVpveidi36Rh1nKwFs71PLZto3i9LwKdzJsIZoFHjU+rOig3iAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2o0/ReF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2o0/ReF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C11C433F1;
	Mon, 29 Jan 2024 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548635;
	bh=fTOEKKPxUnd2aYPyEm53SBhcdj7KpbxDeDX8CYjq88I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2o0/ReFi0wtOp1M9cCfI0AZVKSs/ng/k5ZjtXt/H+2ltbQZJxloTg2Z6wAnNsoLk
	 ptEWFN0n7+FmRsG3r+pZRc0VWdK/GKTQyWaJ4b5OGGSEvwWs4YgACqtV+17KFPChLb
	 ooS0x72eSSJ3KYPDPAb0FjDAYNWp9X8E7VKM7hyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/331] firmware: arm_scmi: Use xa_insert() when saving raw queues
Date: Mon, 29 Jan 2024 09:06:15 -0800
Message-ID: <20240129170023.983613572@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit b5dc0ffd36560dbadaed9a3d9fd7838055d62d74 ]

Use xa_insert() when saving per-channel raw queues to better check for
duplicates.

Fixes: 7860701d1e6e ("firmware: arm_scmi: Add per-channel raw injection support")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240108185050.1628687-2-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/raw_mode.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 0493aa3c12bf..350573518503 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -1111,7 +1111,6 @@ static int scmi_raw_mode_setup(struct scmi_raw_mode_info *raw,
 		int i;
 
 		for (i = 0; i < num_chans; i++) {
-			void *xret;
 			struct scmi_raw_queue *q;
 
 			q = scmi_raw_queue_init(raw);
@@ -1120,13 +1119,12 @@ static int scmi_raw_mode_setup(struct scmi_raw_mode_info *raw,
 				goto err_xa;
 			}
 
-			xret = xa_store(&raw->chans_q, channels[i], q,
+			ret = xa_insert(&raw->chans_q, channels[i], q,
 					GFP_KERNEL);
-			if (xa_err(xret)) {
+			if (ret) {
 				dev_err(dev,
 					"Fail to allocate Raw queue 0x%02X\n",
 					channels[i]);
-				ret = xa_err(xret);
 				goto err_xa;
 			}
 		}
@@ -1322,6 +1320,12 @@ void scmi_raw_message_report(void *r, struct scmi_xfer *xfer,
 	dev = raw->handle->dev;
 	q = scmi_raw_queue_select(raw, idx,
 				  SCMI_XFER_IS_CHAN_SET(xfer) ? chan_id : 0);
+	if (!q) {
+		dev_warn(dev,
+			 "RAW[%d] - NO queue for chan 0x%X. Dropping report.\n",
+			 idx, chan_id);
+		return;
+	}
 
 	/*
 	 * Grab the msg_q_lock upfront to avoid a possible race between
-- 
2.43.0



