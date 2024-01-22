Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A0B6169A;
	Tue, 23 Jan 2024 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971202; cv=none; b=EkrGQWLagDs7FW5jklzk3F2jPELZ0QSW+6VLjDRIS5CW5/iXDncIprWN4aMlN/o+4QiEcS+g/jzt3vcfBeUZSTNCsfyDtoSjTnusVEUv/es870NPPzyTkPBdohWWstIbx3EUmLt6BT2jHfkF1Jp/jeZY39Hb3cpos1GffGMjXqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971202; c=relaxed/simple;
	bh=9SaZdhMoExEm2Eb/DMitWdIM+hkl9BFDKloySszNfjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr+GGpk7Qh5yfYqKIZRty7iPRhkyeZXyy7w1yKTj+90LR1XLXq9aOCx9XaydUX8tMC4MoYaxZnrPETl/EU3xqsLUiv8mGHW+PtQCzmAWQZOYhosg7G6VVo4HBfauyugipnYJtA7J/LkgNTn2MC+kEey8TOvJQ4oRPMLCoMDQhUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGaIQc+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGaIQc+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14B5C43394;
	Tue, 23 Jan 2024 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971202;
	bh=9SaZdhMoExEm2Eb/DMitWdIM+hkl9BFDKloySszNfjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGaIQc+DzrhnAyLmDqUilupFz+zWmRBqEtHxXrrz278TPH1sD/lXoLJaVAq6af+YX
	 LRLBDcz0UpSe5BzdRxpOplNCWcw4CQQIeFvnySocnKtSR87CuH0m8yixqKkkY36Qbo
	 MXnCEAQ435ZA9hPsc9Mw6ZnWQwqGULpF6tNLJguc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/286] wifi: ath11k: Defer on rproc_get failure
Date: Mon, 22 Jan 2024 15:56:57 -0800
Message-ID: <20240122235736.369111749@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 190bc5712e96..24006ddfba89 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -625,8 +625,8 @@ static int ath11k_core_get_rproc(struct ath11k_base *ab)
 
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



