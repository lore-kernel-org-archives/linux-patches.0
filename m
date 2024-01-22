Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641C45579B;
	Tue, 23 Jan 2024 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974013; cv=none; b=i+crV8Y3RqHV6IEa3Io8aQIK4CZ8ZJy/1jHkqe83QwkWS1XuzBz8xDzTgx6D3uxt4TJ23u3PjtaL/OfN9ZFyN7jM4zTe/M+ZWwyqW51vfdoZvFv/JPN6w83ZeT4kXw98/Iuwe3Lvt5BqjjNQQU5M3riD2h/BWU6DJ452Kz6F048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974013; c=relaxed/simple;
	bh=QMLTt7emjdLvUjxRZLgRFLVDdqAliwSQJhrHXwvATsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFCh3mHxfXVhgTqZs8rYVXVSfBPnvOl2Ua+sSwpqRUY4O3E93MYHVwyAIf/kuMA1PsicETbeRKihTCd78PWvsU2EUAJ6jxoPWgvlSwqHSfDhzSPgH8xpoJQdAKcHQA005qsRbZcDfSZYwCWtd5lJ9fJ37TymBevxz0BTug51enk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqmnDCei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqmnDCei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4E1C43394;
	Tue, 23 Jan 2024 01:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974012;
	bh=QMLTt7emjdLvUjxRZLgRFLVDdqAliwSQJhrHXwvATsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqmnDCeit123fLeS7k+/3msUXPNGoWPaGAT0phcRjK4TXJb+xNxKAXaL7Z11YWQpk
	 dpRAb4vZfZ6tOQ8LbO5Cr37aKqnCelzV/pWeIJijNM0OFrzPt7PoBWXPMz67QYThfU
	 ZA8qLAGZL4DK+sI5eQBJhHeI/Z8tQVi3MP5EMni0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/374] wifi: ath11k: Defer on rproc_get failure
Date: Mon, 22 Jan 2024 15:56:16 -0800
Message-ID: <20240122235748.801876838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 24bd0520926b..853a5df4f38c 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -650,8 +650,8 @@ static int ath11k_core_get_rproc(struct ath11k_base *ab)
 
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



