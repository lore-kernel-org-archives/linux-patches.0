Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9469B417355;
	Tue, 21 Jul 2026 19:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662384; cv=none; b=XENt8OBH9gAIAOSR0cBYB1kOZQHbwn1IIoSANsTkHLNu6WQ2SbUXZqTOa0o52BqHnug3RfbOJBQQCOUXTslKC1hkKPqyvertXTPXIjBBVvRy67hCOn72uoEhTBLni9pbqFg3DRN0ttOi1XlKQW/ltDBKo/Vr7tJE1V0+OL+B3eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662384; c=relaxed/simple;
	bh=ra6YnCQn8PNFA1+VWXOWOru/5sO4AJK6X9FqrP8QRHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFh/3ucw2WqnY/96tsGr9gBisUQPBpfaLl9aLAyoqGWod7Nm2wRprLoVm6jr534acF6wuYprw8hP8XO1y17v7DNuIS91CtuavcOtyLPJ7qp86yH3IqyHht5muIRMb13cwttLN/m4CrpkWnwxmX1yzMhrnQlYu74RtUw7kzC90uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgCMZrDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgCMZrDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DABF1F000E9;
	Tue, 21 Jul 2026 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662383;
	bh=q8MEb8aFczhLWJ8LrAsAZZrpUMiaAuJUBd+bKmCOYNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgCMZrDTT6OjUdGnMRimQsahNCLbvrUWpinYra/N13nq9bXBrXD66rX+x+3X1UxoS
	 1onMwzQ/Bvnz+hCOecQPQCl9f2Lk15gKMgzd6DzezzNa5oDqKmnj09zliApATMYUVs
	 xthKeTsY/myX73MXlqk7oZKslcYdx26xAFsGXPS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0425/1276] bus: mhi: ep: Fix potential deadlock in mhi_ep_reset_worker()
Date: Tue, 21 Jul 2026 17:14:28 +0200
Message-ID: <20260721152455.613532951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cdea24e9291959..4bb007d1933315 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1087,11 +1087,12 @@ static void mhi_ep_reset_worker(struct work_struct *work)
 
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
@@ -1100,8 +1101,6 @@ static void mhi_ep_reset_worker(struct work_struct *work)
 	 */
 	if (cur_state == MHI_STATE_SYS_ERR)
 		mhi_ep_power_up(mhi_cntrl);
-
-	mutex_unlock(&mhi_cntrl->state_lock);
 }
 
 /*
-- 
2.53.0



