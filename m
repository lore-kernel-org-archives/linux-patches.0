Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B822FD1C2;
	Tue, 12 Aug 2025 18:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023860; cv=none; b=CyK3FtwYQqKPnjxLiDxbpZshMqkgSUzBvNS8M794H5bx8lRHMmHfB+ni0ORLxnJDAUldcXajY1lQj6hwzm4yOBU2tmoZiJFqH3OdUIwmxSxGF/3IfagQ68O95fOE/zh5ST2FxLz7GoKZa1IR70GDLQLd/qO5NNaA8IIjnURurAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023860; c=relaxed/simple;
	bh=I4nEyjtF/E5dmV0C2u64jcitbpaeoJSbZLURlTUhoLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJ6EK5FYXxArJ2Gi8dkdNM38kLHPkQlkYVwazx8slLKxYvJwWU8fbb/mBHDXcDOqQ8N19FRAeuEHyTWy4zlOhFLZPJDCZsdyx7Xribia8yDM7lfPcyR/YgRzvrOvZkAz7S7XfyY1X66fp9G3Z1Rz3lHNix/DozgUxIBhoEiUWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRvpJ84Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRvpJ84Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055DCC4CEF0;
	Tue, 12 Aug 2025 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023860;
	bh=I4nEyjtF/E5dmV0C2u64jcitbpaeoJSbZLURlTUhoLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRvpJ84QYhBYCNv0mR6n5OQUQ7QQBw5TCuFIOTdVepXvZ3bdV5ymV2iyQMrbkm/hj
	 SajhQmTUvn+wywzEuQtBcu6aon1T5xJ3FkTF4rk+8kc7czyC49YzPvSlQWz80LMfHF
	 V7VoD8jn+zL59lk5/wOd85FwaefXSo5qERDZ3S8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 171/627] wifi: ath12k: Clear auth flag only for actual association in security mode
Date: Tue, 12 Aug 2025 19:27:46 +0200
Message-ID: <20250812173425.784725350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>

[ Upstream commit c27bb624b3d789a337df3bbcc020a575680555cc ]

When setting a new bitrate, WMI peer association command is sent from
the host without the peer authentication bit set in peer_flags for
security mode, which causes ping failure.

The firmware handles peer_flags when the client is associating, as the
peer authentication bit in peer_flags is set after the key exchange.
When the WMI peer association command is sent from the host to update
the new bitrate for an associated STA, the firmware expects the WMI
peer authentication bit to be set in peer_flags.

Fix this issue by ensuring that the WMI peer auth bit is set in
peer_flags in WMI peer association command when updating the new
bitrate.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>
Signed-off-by: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250608145651.1735236-1-ramasamy.kaliappan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 ++++
 drivers/net/wireless/ath/ath12k/wmi.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 3616269538e6..0feb800a4921 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3235,6 +3235,7 @@ static void ath12k_bss_assoc(struct ath12k *ar,
 
 	rcu_read_unlock();
 
+	peer_arg->is_assoc = true;
 	ret = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
 	if (ret) {
 		ath12k_warn(ar->ab, "failed to run peer assoc for %pM vdev %i: %d\n",
@@ -5165,6 +5166,8 @@ static int ath12k_mac_station_assoc(struct ath12k *ar,
 			    "invalid peer NSS %d\n", peer_arg->peer_nss);
 		return -EINVAL;
 	}
+
+	peer_arg->is_assoc = true;
 	ret = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
 	if (ret) {
 		ath12k_warn(ar->ab, "failed to run peer assoc for STA %pM vdev %i: %d\n",
@@ -5411,6 +5414,7 @@ static void ath12k_sta_rc_update_wk(struct wiphy *wiphy, struct wiphy_work *wk)
 			ath12k_peer_assoc_prepare(ar, arvif, arsta,
 						  peer_arg, true);
 
+			peer_arg->is_assoc = false;
 			err = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
 			if (err)
 				ath12k_warn(ar->ab, "failed to run peer assoc for STA %pM vdev %i: %d\n",
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 465f877fc0fb..e19803bfba75 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2152,7 +2152,7 @@ static void ath12k_wmi_copy_peer_flags(struct wmi_peer_assoc_complete_cmd *cmd,
 		cmd->peer_flags |= cpu_to_le32(WMI_PEER_AUTH);
 	if (arg->need_ptk_4_way) {
 		cmd->peer_flags |= cpu_to_le32(WMI_PEER_NEED_PTK_4_WAY);
-		if (!hw_crypto_disabled)
+		if (!hw_crypto_disabled && arg->is_assoc)
 			cmd->peer_flags &= cpu_to_le32(~WMI_PEER_AUTH);
 	}
 	if (arg->need_gtk_2_way)
-- 
2.39.5



