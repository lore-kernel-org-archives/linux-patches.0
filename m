Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EED15B998;
	Mon, 29 Jan 2024 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548315; cv=none; b=nnk4E3lWRgR3C7K0gcDVeGNgKbo1Jt9AIzbJq98NZvJ4sK24mTd/T9Qi7i5i7FpxFsT9xpiHIPOe/GwW8yzEQW4ggMp/pLzH3SqhVdn2DMqa5BvFHJJgsiysBASNy2YqCJ45dXpXR8P+xV9vTMG1cxHaqIpEx0Uq7RsJCIO/XUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548315; c=relaxed/simple;
	bh=9c2fAlKnUvkzbBCq0eGrcp148UU6dNCatzl8kg2hG/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stXLom3nGy5tUw0WJ8OVsZnh/yHwIAHigF0xZ0V6NdnY4jI2vvTs3AAwLRTaznJnqkCVNp8teDJT/8I/yfgZbluBI4ZsMd4dH7rDspagDMTFYP2zSnUk9Qk0QWzK4hgPBWqAw8kSb83dY0i64kIe/ueWBuz7FHe5v+jTCSPCcPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L01oyacw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L01oyacw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCFBC433F1;
	Mon, 29 Jan 2024 17:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548315;
	bh=9c2fAlKnUvkzbBCq0eGrcp148UU6dNCatzl8kg2hG/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L01oyacwlEJDhNPEcWH+KAlPewt12APcOkSyB4Kvzlnq2mskCDQeF9E+9MR5VGuah
	 Bj2+RX+SckyW8SOGrFOR8jJuGBRhQXn7+NqBe2xMh2TAt6VjWi0jMyQuYlwj7LEFRA
	 qP42oZJUw70eJDgBEoX8MUC5Fpk/3SeJcAkBssl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 319/346] firmware: arm_scmi: Use xa_insert() when saving raw queues
Date: Mon, 29 Jan 2024 09:05:50 -0800
Message-ID: <20240129170025.861445382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



