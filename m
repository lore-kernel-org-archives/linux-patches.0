Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26345318EE1;
	Thu, 28 May 2026 20:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998829; cv=none; b=bQTIxB+iVxjQq9ghb3Yi5u1E49mq76ea8JC+clugQZ7Xr1sBhlJr6+fU/6q8NRpbNp2GbDC5jfLa+v+8QkPo08zroF7p7UjBaOfa7eP0x7hG94hja/rounnyVjw5BWLy4PW66oB7RnaRoR5qp75hQ2MuvLxculHe1geiM96e9D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998829; c=relaxed/simple;
	bh=2Us8Uns27ViR8ewzBdceB4u6svvDPS/F5+xI6VkuWMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox4y0QIMCGy5lOl2QwNG7vUMU+dx9Ubd++E1Pi3qLLoTA21Ig8Hrat+XfpO1n2dtBZjiavbO1F7k2z4p0bLS9xm8TatLacuInVh2h885Owd39kWVJeeLfEO0h6Xff6EFokwKjmNWvFg3wLU7rB0v2fmp/+CsqaG/uRd7/O/0Oc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc+NXgT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc+NXgT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8F1F000E9;
	Thu, 28 May 2026 20:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998828;
	bh=ykQDdeHA4fG7N8S/X72mivhTl1yacqOV7wH5SiIoFSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tc+NXgT7G1EEWb7lbh52oloDDk5xvdEEM88ZCCfqEIUIoA7sF6IcvyoCttF0QOjQk
	 frQs2L9zyVa+MIBqHMv8zIpSSDBEb5jZd+RbpZVGpKn6PfxflD2VcHJ+67dSyvFZVt
	 T7Hh7kz5g6ooKHg4C7QmSXNuyyg8Iy8+NaL3Pq0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 276/461] wifi: ath11k: fix error path leaks in some WMI WOW calls
Date: Thu, 28 May 2026 21:46:45 +0200
Message-ID: <20260528194655.166394645@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 40747fba3b0c0..024c2aad9fb4e 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -9332,6 +9332,7 @@ int ath11k_wmi_wow_host_wakeup_ind(struct ath11k *ar)
 	struct wmi_wow_host_wakeup_ind *cmd;
 	struct sk_buff *skb;
 	size_t len;
+	int ret;
 
 	len = sizeof(*cmd);
 	skb = ath11k_wmi_alloc_skb(ar->wmi->wmi_ab, len);
@@ -9345,14 +9346,20 @@ int ath11k_wmi_wow_host_wakeup_ind(struct ath11k *ar)
 
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI, "tlv wow host wakeup ind\n");
 
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
@@ -9367,7 +9374,13 @@ int ath11k_wmi_wow_enable(struct ath11k *ar)
 	cmd->pause_iface_config = WOW_IFACE_PAUSE_ENABLED;
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI, "tlv wow enable\n");
 
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



