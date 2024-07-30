Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1331898E0;
	Tue, 30 Jul 2024 16:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356592; cv=none; b=QjXvEOuNjHe4qQwXt1S3eoKfoVcVvwW925DUE7g4ztcYBCNVn8kVN7jd2u8Jj8TOK6DlUQfs8pC5Hh4sLcMyzv1JFn0eZBaESSEHk6808tU2uTYFPVMu6dL9T0OSlmDSrQGYLTpb3dfoWU0H3oZWIa4z029zBZm/+VEit1rFuig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356592; c=relaxed/simple;
	bh=ussxRMrdVVNBWZhbbyvedjHCffzPvFJdWjSUGldjEaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0+mYUpXmVG4OeAdFrmtdLMjg01W4mFOnX6yT/2WL6HFkXTUEiSekW8ehI3vJjNVkL+q6ACHxx5ZHr/7m0Ph5sq9sc4hvg/jd5rEqfo5a15R2Sa479galu+8v2Q/qwh0Z4NjD81fZ8ECFnaqN1WUVaVs8vYhtbw6rsNSPhBJ7P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dhw3S3+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dhw3S3+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2389DC4AF0E;
	Tue, 30 Jul 2024 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356592;
	bh=ussxRMrdVVNBWZhbbyvedjHCffzPvFJdWjSUGldjEaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dhw3S3+n9ZmVznDmdb4vsWQDJ9/QJxblVxaYh+mPpSLL8sXr6rB9ry/NcyQCsqNBf
	 HB0O74Ew+WGq5mG110DmxK46PnpGxcOr33tPWY+Ng17UunFcrilFm9mmp0T0s0x9Do
	 s7rBuft18296gkyTkI+i0Ri0UG0IAd2OBFDhnl8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/809] wifi: ath11k: restore country code during resume
Date: Tue, 30 Jul 2024 17:40:41 +0200
Message-ID: <20240730151731.123577781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 7f0343b7b8710436c1e6355c71782d32ada47e0c ]

We got report that regdomain is not correct after
return from hibernation:

Before hibernation:
% iw reg get
[...]
phy#0 (self-managed)
country CH: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20), (N/A)
        (5170 - 5250 @ 80), (N/A, 23), (N/A), NO-OUTDOOR, AUTO-BW
        (5250 - 5330 @ 80), (N/A, 23), (0 ms), NO-OUTDOOR, DFS, AUTO-BW
        (5490 - 5590 @ 80), (N/A, 30), (0 ms), DFS, AUTO-BW
        (5590 - 5650 @ 40), (N/A, 30), (600000 ms), DFS, AUTO-BW
        (5650 - 5730 @ 80), (N/A, 30), (0 ms), DFS, AUTO-BW
        (5735 - 5875 @ 80), (N/A, 14), (N/A), AUTO-BW

After hibernation:
% iw reg get
[...]
phy#0 (self-managed)
country na: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20), (N/A)
        (2457 - 2482 @ 20), (N/A, 20), (N/A), PASSIVE-SCAN
        (5170 - 5330 @ 160), (N/A, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (5490 - 5730 @ 160), (N/A, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (5735 - 5895 @ 160), (N/A, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (5945 - 7125 @ 160), (N/A, 30), (N/A), AUTO-BW, PASSIVE-SCAN

The reason is, during resume, firmware is reinitialized but host does
not send current country code to firmware. So default reg rules with
country code set to 'na' is uploaded to host, as shown above.

Fix it by restoring country code to firmware during resume.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: 166a490f59ac ("wifi: ath11k: support hibernation")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240520024148.5472-3-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index a14d0c65000ad..47554c3619633 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1009,6 +1009,16 @@ int ath11k_core_resume(struct ath11k_base *ab)
 		return -ETIMEDOUT;
 	}
 
+	if (ab->hw_params.current_cc_support &&
+	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
+		ret = ath11k_reg_set_cc(ar);
+		if (ret) {
+			ath11k_warn(ab, "failed to set country code during resume: %d\n",
+				    ret);
+			return ret;
+		}
+	}
+
 	ret = ath11k_dp_rx_pktlog_start(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to start rx pktlog during resume: %d\n",
-- 
2.43.0



