Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405E12DEA74;
	Tue, 21 Jul 2026 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660128; cv=none; b=dq9Hh2MQl9gtSw85RYeENhBYrvwjSSnZ8JIEMLZItbp/w3uOu1MD246w5IkAStf2rukY7SW/CudXPDCR5HQ95kVX93FtXLj/nlKixJNRFcbZwhLwvrgUwzjnaMt/P8SdYKtu/NERTJZW8pST1Px+ux2ZXRP8i1skJWuGY/f80QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660128; c=relaxed/simple;
	bh=K5zB3gH1G49aHPMCQ0Zclw8HZJBivJkH1WS7bJuN3Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4RldYWj6F9BS24NK5YHX3Ztr+WBfZzUJxV6VNf7e8hN14YKtPhmfDkyNcMku9dtY2J0kNxDlUkrrDs8SMijhNysCK2c4KcZlwa2pV0+takWD+hxV7UoAldvAxDVWznZsoCPWRFLCVheS8t0MC/z9nzSIYX2McEefTubzWZ7ZKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njJuzmMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njJuzmMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C11F000E9;
	Tue, 21 Jul 2026 18:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660127;
	bh=yvTn3KOonCnyjGnpXyVVaXHktKhHLBdfRafEauE1B4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njJuzmMakJ8DAzI2KouYxeqycEVt7tYuZcuZAj/Y9KofEdPEsTV6hJYtwV2V6E85X
	 Ky7n1YSRkT5LJSWXIao4MPwJhQSYUZ+gKvtsC2Iqr8WFViJOIjV9Bug2dScgKaLP3E
	 pwWsdPJCDVptKDlriwJpwilV24w3tebNMjQcWtTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Kumar <sumit.kumar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0861/2077] bus: mhi: ep: Add missing state_lock protection for mhi_state access
Date: Tue, 21 Jul 2026 17:08:54 +0200
Message-ID: <20260721152613.099974936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Kumar <sumit.kumar@oss.qualcomm.com>

[ Upstream commit ce3e534ee9c8d13a68c8a611c3b7bd0c2152d2ab ]

The mhi_cntrl->mhi_state field should be protected by state_lock to
ensure atomic state transitions. However, mhi_ep_power_up() access
mhi_state without holding this lock, which can race with concurrent state
transitions and lead to state corruption.

Add proper state_lock protection around mhi_state access.

Fixes: fb3a26b7e8af ("bus: mhi: ep: Add support for powering up the MHI endpoint stack")
Fixes: f7d0806bdb1b3 ("bus: mhi: ep: Add support for handling SYS_ERR condition")
Signed-off-by: Sumit Kumar <sumit.kumar@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260414-reset_worker_deadlock-v2-2-42fd682b45db@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 425525e232f919..5330b03dc6369c 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -1147,7 +1147,9 @@ int mhi_ep_power_up(struct mhi_ep_cntrl *mhi_cntrl)
 	for (i = 0; i < mhi_cntrl->event_rings; i++)
 		mhi_ep_ring_init(&mhi_cntrl->mhi_event[i].ring, RING_TYPE_ER, i);
 
+	mutex_lock(&mhi_cntrl->state_lock);
 	mhi_cntrl->mhi_state = MHI_STATE_RESET;
+	mutex_unlock(&mhi_cntrl->state_lock);
 
 	/* Set AMSS EE before signaling ready state */
 	mhi_ep_mmio_set_env(mhi_cntrl, MHI_EE_AMSS);
-- 
2.53.0



