Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5CC38DCC;
	Tue, 23 Jan 2024 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970628; cv=none; b=p815saBHpx8/8dw30Rg3SPgZVJNxAATsWhTQha/UvGc4fLPW0HReSIiwTq6/9sQ3plviHUsYu+nKv7llg4Dw+HsY4Q2QA8xYpBlR2hRX890u2dVCP5BFLy+HvawtrsSL7WAaX4HbwTrAf5XjfXGvjzERj1qTW1gMjvhWgKpB18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970628; c=relaxed/simple;
	bh=+sg60xSOcseQ7a8KKzBBdDa5TdfVbdorMK4AtJIRYxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHTzZ6iajMwW0z9RkNHh3Ij2M/kkVQhq6j7TNJDp4oCCpW8lExLyU3GqtgFkfgo3ZBDJeJl5MIL5zcBMRukFs9sXz8wmIHNSFegBCs8mt1U8DdHdi/y6x7pK/of4A6X+amDMGnqQDyHnGZ+rNE3s/ZaTopX+85TzC5rQb3hr8T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcjpVg1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcjpVg1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF44C433C7;
	Tue, 23 Jan 2024 00:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970628;
	bh=+sg60xSOcseQ7a8KKzBBdDa5TdfVbdorMK4AtJIRYxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcjpVg1M7pekHdblbNhQvBuPA+N0a/RdtLVAwh5ptp2hiAKNG9JaaGoaJPDqWpxuE
	 l++FcF8F58/wjWUE22K5p/fsAbjoBQHWV+CQ+zhs3YHTikiQ7XCzCKGwBx+fkYQmfO
	 4Pnl0qe8TX/B6Rw66yiQt7RHxoere/drd8iTEIo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/417] wifi: ath11k: Defer on rproc_get failure
Date: Mon, 22 Jan 2024 15:54:00 -0800
Message-ID: <20240122235754.210143763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 2a3ec40b98b46c339adb57313d3b933ee5e7a8e8 ]

If we already have gotten the rproc_handle (meaning the "qcom,rproc"
property is defined in the devicetree), it's a valid state that the
remoteproc module hasn't probed yet so we should defer probing instead
of just failing to probe.

This resolves a race condition when the ath11k driver probes and fails
before the wpss remoteproc driver has probed, like the following:

  [    6.232360] ath11k 17a10040.wifi: failed to get rproc
  [    6.232366] ath11k 17a10040.wifi: failed to get rproc: -22
  [    6.232478] ath11k: probe of 17a10040.wifi failed with error -22
       ...
  [    6.252415] remoteproc remoteproc2: 8a00000.remoteproc is available
  [    6.252776] remoteproc remoteproc2: powering up 8a00000.remoteproc
  [    6.252781] remoteproc remoteproc2: Booting fw image qcom/qcm6490/fairphone5/wpss.mdt, size 7188

So, defer the probe if we hit that so we can retry later once the wpss
remoteproc is available.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-01264-QCAMSLSWPLZ-1.37886.3

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231027-ath11k-rproc-defer-v1-1-f6b6a812cd18@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 76f275ca53e9..70d468f01338 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -813,8 +813,8 @@ static int ath11k_core_get_rproc(struct ath11k_base *ab)
 
 	prproc = rproc_get_by_phandle(rproc_phandle);
 	if (!prproc) {
-		ath11k_err(ab, "failed to get rproc\n");
-		return -EINVAL;
+		ath11k_dbg(ab, ATH11K_DBG_AHB, "failed to get rproc, deferring\n");
+		return -EPROBE_DEFER;
 	}
 	ab_ahb->tgt_rproc = prproc;
 
-- 
2.43.0



