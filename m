Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0407D37E5D1;
	Sat, 12 Sep 2026 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216717; cv=none; b=SfvN2m5ZviyGN4UzzHPj9idBIf9e4otKa495QHrsfLi5Jam5P/TsA2SO+okcp2xSOqJcFV4smooYPATM/93S9OkPGMR2yocET3+p3jvPJ+4hfsEnACRJ3CayofjubHD044T7sfapIjoXdnQTCkOuJiSRMo7iPSX+M/7HQdB4bSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216717; c=relaxed/simple;
	bh=a0sbBfW+WHF8SjRG2rZFV79xcwGmyPe7brmbbXY96Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWdbCUQgfpJptoAEypAq4sOcghLI87Yu5sDVdPYl3NWHdRMetqOuBNwI7s0JPEHY3xzfMfTKdIyr3Dw0es2GQ8XNM+7gLC3Rue5OeNkTYyltfB8EwF/x+ud1GFMVpbKQp5pkjvtmQqwZloout7ZLs9KITQpLMsDNOSZOWvqhy9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0xf2XjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0xf2XjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C711F000FF;
	Sat, 12 Sep 2026 12:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216715;
	bh=YFbZ+ib22WTeDmNwhFf2dBVEcstSD1JmIxe2R27YTGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0xf2XjZ/ZbdG4lB8/ZmQ+0stqWLeB8N2w7EUf3/o3O5Eow5k4k233mcD5hUAq95B
	 cVvLQTjTd3vSISjX+HPbkoXJq+eN7A4X77f6xexLUeRjj0UQxkLfb7RC1oHwIkJNrd
	 DJwqGkRCamndVT11McgsYp08d0KfBbok27LTM9ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0751/1376] wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
Date: Sat, 12 Sep 2026 08:52:57 +0200
Message-ID: <20260912065624.280119949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 4c6eb712a91fa079be6f9f1419c96e0ad2227081 ]

Currently, in ath12k_wmi_mac_phy_caps_parse(), kzalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct ath12k_wmi_mac_phy_caps_params)). The
subsequent memcpy() destination advances by sizeof(full struct) per slot
via C pointer arithmetic, not by the clamped len. When firmware sends
short TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath12k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260728-mac_phy_caps_parse-stride-mismatch-v1-1-27a9c1a3fbd0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 111b0c91d4dee..598a69f9e6df0 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4073,14 +4073,16 @@ static int ath12k_wmi_mac_phy_caps_parse(struct ath12k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct ath12k_wmi_mac_phy_caps_params));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kzalloc((svc_rdy_ext->tot_phy_id) * len,
-						    GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kzalloc_objs(*svc_rdy_ext->mac_phy_caps,
+				     svc_rdy_ext->tot_phy_id,
+				     GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct ath12k_wmi_mac_phy_caps_params));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;
-- 
2.53.0



