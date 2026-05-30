Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A951D30E853;
	Sat, 30 May 2026 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162471; cv=none; b=Mgag2VxbsPzrg9aRkFRyZGsZz47ZrXVwmP9Zkc9TUd5uIJM5uD9UpxZoPj9gi5W9qTAUwN/VtONpnLtBf2HR84SU1O+2QExlrL3hrvzdJsiCChRzbRX7rWZwjVYd1pLoY4Orf3r/qUC7m83DN4l6jB8izvZsutbQQkL5o2/BRqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162471; c=relaxed/simple;
	bh=vUFKYkDPdN3ZVk0gFgfVcBKas13BBDHYSebXH8BW1Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnIqW8YGbsEVS5rvqE3MJrRacU1wP4Tp5zwTQyHM9CiscV9j762LZhrwVD/USqmYKsaQefJRzku6FvxiT+yh6KcPWl3HsHpTs5Bzrl8K5rEWLrTPNVcLwcEoM3p/D6z5RmW7RgUfFYBux3Cbe6XLOK5PYiAVi8Ev5n9RdD6tlIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyIla3rL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyIla3rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8381F00893;
	Sat, 30 May 2026 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162470;
	bh=gjkQmGtFbvzwLRJ7bJwc/9BVx/oa8sDr5/CgzWALCIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KyIla3rLCfm/xDpiuuzC+n/QRh9ArEp4XWKur+vbYmORy1DguOdY9WU5mu7AzuH6U
	 IzPCouPL2PhO5XkSMuZXxsXGr8kOvMZGbcj2zDDefrP3qzB22BOq46Wk2aa65IGBi4
	 Wdq7j1KkLbbwT726sRKxvI3NrBsqt9ZlW+Uv6z2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 930/969] wifi: ath11k: fix error path leaks in some WMI WOW calls
Date: Sat, 30 May 2026 18:07:34 +0200
Message-ID: <20260530160326.425909066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 55dda532bbc261aef495e403c8900c5e2ab5fa34 ]

Fix two instances where we used to directly return the result of
ath11k_wmi_cmd_send(...). Because we did not check the return value, we
also did not free the skb in the error path.

Fixes: 79802b13a492 ("ath11k: implement WoW enable and wakeup commands")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260506134240.2284016-2-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 8b50dbc47300b..31128630d8b62 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8482,6 +8482,7 @@ int ath11k_wmi_wow_host_wakeup_ind(struct ath11k *ar)
 	struct wmi_wow_host_wakeup_ind *cmd;
 	struct sk_buff *skb;
 	size_t len;
+	int ret;
 
 	len = sizeof(*cmd);
 	skb = ath11k_wmi_alloc_skb(ar->wmi->wmi_ab, len);
@@ -8495,14 +8496,20 @@ int ath11k_wmi_wow_host_wakeup_ind(struct ath11k *ar)
 
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI, "wmi tlv wow host wakeup ind\n");
 
-	return ath11k_wmi_cmd_send(ar->wmi, skb, WMI_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID);
+	ret = ath11k_wmi_cmd_send(ar->wmi, skb, WMI_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID);
+	if (ret) {
+		ath11k_warn(ar->ab, "failed to send WMI_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID\n");
+		dev_kfree_skb(skb);
+	}
+
+	return ret;
 }
 
 int ath11k_wmi_wow_enable(struct ath11k *ar)
 {
 	struct wmi_wow_enable_cmd *cmd;
 	struct sk_buff *skb;
-	int len;
+	int ret, len;
 
 	len = sizeof(*cmd);
 	skb = ath11k_wmi_alloc_skb(ar->wmi->wmi_ab, len);
@@ -8517,7 +8524,13 @@ int ath11k_wmi_wow_enable(struct ath11k *ar)
 	cmd->pause_iface_config = WOW_IFACE_PAUSE_ENABLED;
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI, "wmi tlv wow enable\n");
 
-	return ath11k_wmi_cmd_send(ar->wmi, skb, WMI_WOW_ENABLE_CMDID);
+	ret = ath11k_wmi_cmd_send(ar->wmi, skb, WMI_WOW_ENABLE_CMDID);
+	if (ret) {
+		ath11k_warn(ar->ab, "failed to send WMI_WOW_ENABLE_CMDID\n");
+		dev_kfree_skb(skb);
+	}
+
+	return ret;
 }
 
 int ath11k_wmi_scan_prob_req_oui(struct ath11k *ar,
-- 
2.53.0



