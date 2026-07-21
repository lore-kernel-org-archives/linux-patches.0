Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEB744AB68;
	Tue, 21 Jul 2026 21:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669243; cv=none; b=DVu3Iz+UR7JVhEE+1pBa3IWCQ05HQGw5ao3Im34Z3Q8X5x3UcJyy1qY9oaPgKB9X10vFZPx1OTYbEibLGT6hAABRvkxWlW6abF3C5nlq5BPSMmUY3uAR2/jAWaAXlDO1VszY2bXYZK96Hidc8BJDf0dVXnj8Qi6n37qnYKkTPCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669243; c=relaxed/simple;
	bh=YlwkpP+B0f447UAx/onXbnYLbKx69B1AeEJAwfcBSeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9IEcqVrH81ddibDTbsjQuZ0tB0alqiio0WOrP8EN5rMx/Knd4yulGfKw5pHo3ZHWR3UjPmVBazWj+qnTWIqE1Q2gMHy463ti29AKTfaZLpDsD9Djmx2gno9xq66jm8X6y6T4/bmSRMhXNa3mJ9/QY42yWIniI8ceKzd962pAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8SWC0ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8SWC0ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FDE1F000E9;
	Tue, 21 Jul 2026 21:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669242;
	bh=C8lL1QnVOXvez3ebuqJhrBYeDcKF3CPi4UC3noa8QW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8SWC0ssyGTLg/DQXNes5wqAae6LorOSpH4eGM19Dzfwwb3IRhQOTS1Hn/pAABsmB
	 TCtdREbZ+mNqT4kPQYGY0R54FEfKqqXbSRBIYi6q2eCCmGf1rdGxjKMUHUoNAvgnWU
	 75asxY++jmysS2JL1apRU7X2EvkScr+JaHsM4wvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0482/1067] bus: mhi: ep: Fix potential deadlock in mhi_ep_reset_worker()
Date: Tue, 21 Jul 2026 17:18:03 +0200
Message-ID: <20260721152435.399976472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Sumit Kumar <sumit.kumar@oss.qualcomm.com>

[ Upstream commit 9dece4435d396e9877e27483552b910ba8654169 ]

There is a potential deadlock scenario in mhi_ep_reset_worker() where
the state_lock mutex is acquired twice in the same call chain:

mhi_ep_reset_worker()
  mutex_lock(&mhi_cntrl->state_lock)
    mhi_ep_power_up()
      mhi_ep_set_ready_state()
        mutex_lock(&mhi_cntrl->state_lock)  <- Deadlock

Fix this by releasing the state_lock before calling mhi_ep_power_up().
The lock is only needed to protect current MHI state read operation. The
lock can be safely released before proceeding with the power up sequence.

Fixes: 7a97b6b47353 ("bus: mhi: ep: Add support for handling MHI_RESET")
Signed-off-by: Sumit Kumar <sumit.kumar@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260414-reset_worker_deadlock-v2-1-42fd682b45db@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 34e0ba6f52d059..4b9c7043a07a80 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1026,11 +1026,12 @@ static void mhi_ep_reset_worker(struct work_struct *work)
 
 	mhi_ep_power_down(mhi_cntrl);
 
-	mutex_lock(&mhi_cntrl->state_lock);
-
 	/* Reset MMIO to signal host that the MHI_RESET is completed in endpoint */
 	mhi_ep_mmio_reset(mhi_cntrl);
+
+	mutex_lock(&mhi_cntrl->state_lock);
 	cur_state = mhi_cntrl->mhi_state;
+	mutex_unlock(&mhi_cntrl->state_lock);
 
 	/*
 	 * Only proceed further if the reset is due to SYS_ERR. The host will
@@ -1039,8 +1040,6 @@ static void mhi_ep_reset_worker(struct work_struct *work)
 	 */
 	if (cur_state == MHI_STATE_SYS_ERR)
 		mhi_ep_power_up(mhi_cntrl);
-
-	mutex_unlock(&mhi_cntrl->state_lock);
 }
 
 /*
-- 
2.53.0



