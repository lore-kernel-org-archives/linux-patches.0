Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76A172BAE;
	Tue, 10 Sep 2024 10:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964170; cv=none; b=F+bygduXegr6e8pHZ7bow6ORKLz6ej/gr5AKBt3nkz7574ONNVxBDqCrDl2MFLbRvfcQDcT1Xfl7vDSpEP7Lw/b2BNc1qSpUcxrI4/9bZEnz97nTQvmKu+xxbvb6GaL9IqPnXQR2DZM9Y9goMHPQAJ+720dP7Gy/YeaO8xUCJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964170; c=relaxed/simple;
	bh=JlYtmfnpUhhvAa79kYU+P47ND6drVxOcFJXDylZaTUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cr7nA8NGptFZjpcKXDVLVL+iJ8TYeRmgGrnSqDvKP4NfgqSQ5MAGwQjPzUn6N3hjPAswbJYzFhGv0X3IFkJTkQyDThHMGhxk1TMRB33JdknVAb70x7agJpkIL1a3jINoo+OCdyVPIomCU/BBzYaSjc/0ed57vllei7rjgh4FcDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVsEyOLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVsEyOLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DB3C4CEC3;
	Tue, 10 Sep 2024 10:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964170;
	bh=JlYtmfnpUhhvAa79kYU+P47ND6drVxOcFJXDylZaTUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVsEyOLgFBBKTSvf8upHu+t4arJxqBh0n6ppcXJ6jxKu53uWNIz2WPgZtSTDxAuFA
	 5blSOpBJmkL5iGwZEByxzI5DnUWlobQ4tcw7nDlYT/3R0XjKQbx+ss0AQcdZ0ewMek
	 O6eqCNrQynzst1e9HS99F5Ikeq+iRkxF+8ON09vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajith C <quic_ajithc@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/269] wifi: ath12k: fix firmware crash due to invalid peer nss
Date: Tue, 10 Sep 2024 11:30:51 +0200
Message-ID: <20240910092610.475788096@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Ajith C <quic_ajithc@quicinc.com>

[ Upstream commit db163a463bb93cd3e37e1e7b10b9726fb6f95857 ]

Currently, if the access point receives an association
request containing an Extended HE Capabilities Information
Element with an invalid MCS-NSS, it triggers a firmware
crash.

This issue arises when EHT-PHY capabilities shows support
for a bandwidth and MCS-NSS set for that particular
bandwidth is filled by zeros and due to this, driver obtains
peer_nss as 0 and sending this value to firmware causes
crash.

Address this issue by implementing a validation step for
the peer_nss value before passing it to the firmware. If
the value is greater than zero, proceed with forwarding
it to the firmware. However, if the value is invalid,
reject the association request to prevent potential
firmware crashes.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Ajith C <quic_ajithc@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240613053528.2541645-1-quic_ajithc@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 618eeaf6e331..dd2a7c95517b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3357,6 +3357,11 @@ static int ath12k_station_assoc(struct ath12k *ar,
 
 	ath12k_peer_assoc_prepare(ar, vif, sta, &peer_arg, reassoc);
 
+	if (peer_arg.peer_nss < 1) {
+		ath12k_warn(ar->ab,
+			    "invalid peer NSS %d\n", peer_arg.peer_nss);
+		return -EINVAL;
+	}
 	ret = ath12k_wmi_send_peer_assoc_cmd(ar, &peer_arg);
 	if (ret) {
 		ath12k_warn(ar->ab, "failed to run peer assoc for STA %pM vdev %i: %d\n",
-- 
2.43.0



