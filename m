Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82951078F;
	Tue, 30 Jul 2024 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356442; cv=none; b=PTA66VwvbHtfxNHgY41P33xhlmqf08CuVOH1Ag+DC9ZfF5VNyB7yD7nDeCfb2r+loBdU+Gw9pCgd/aQgB3ykk+4FEuU6+/y/XR3HnvFQB84v1oxikmd4WA+AWZbUMccPfjBCXyaqCAc+iWHeaUbVl8b+ArplIJDPkiWBD1D2SGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356442; c=relaxed/simple;
	bh=h9h2//KZL6ze7uETSv7ve//h34lZ6OEXrb1gYeUBlng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUT16iRO92i4X5UgMfew5QXzkbs1prgncItazBdcA5/vwyHjPeJvlTQMqRkjrQDICYgfSdDhS+2rkt3dvQjfrfifwzNsj36F2tILowKHvB0eY3vcRnTeOoVRkUPpbO/dfJy0NTPt95VzWXr/uPwmu1NiHDsolek5dDwxAhgLn4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfmvN9bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfmvN9bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D962C32782;
	Tue, 30 Jul 2024 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356442;
	bh=h9h2//KZL6ze7uETSv7ve//h34lZ6OEXrb1gYeUBlng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfmvN9bC9XTh0pseVXLyKT4qrGIlc3xczqG2FAsolHj+w7YvgNpvWikBXVsNg3RsF
	 CsiGKHuktka35rbnsMNIpsRMvCAZ3xShIapbrLS/tu5TlgHPvvTPn3h1jU4ollgpUd
	 b3O24jYRBYjhMfrT3fs3EhG49dl5QBgWCMPL0IkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <quic_kangyang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 150/809] wifi: ath12k: avoid duplicated vdev stop
Date: Tue, 30 Jul 2024 17:40:26 +0200
Message-ID: <20240730151730.530800849@linuxfoundation.org>
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

From: Kang Yang <quic_kangyang@quicinc.com>

[ Upstream commit 3b0989e925f38df733a03ff5a320d6841006b3f9 ]

ath12k_mac_op_unassign_vif_chanctx() will do vdev stop in
ath12k_mac_monitor_stop(). This ath12k_mac_vdev_stop() will do vdev stop
again, then might trigger firmware crash.

So add judgement to avoid duplicated vdev stop.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: c9e4e41e71ff ("wifi: ath12k: move peer delete after vdev stop of station for WCN7850")
Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240429081525.983-3-quic_kangyang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 805cb084484a4..b3530d1dd728b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7386,7 +7386,8 @@ ath12k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		arvif->is_started = false;
 	}
 
-	if (arvif->vdev_type != WMI_VDEV_TYPE_STA) {
+	if (arvif->vdev_type != WMI_VDEV_TYPE_STA &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
 		ath12k_bss_disassoc(ar, arvif);
 		ret = ath12k_mac_vdev_stop(arvif);
 		if (ret)
-- 
2.43.0



