Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD202C11CF;
	Wed, 25 Feb 2026 06:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002585; cv=none; b=bJmZkwer9C8yr2c45Qm/Q2c9kTKEKzPhYs3Y7PK5xiSBw57fZ4L9utr+Tf8pP9vQodYBZG30CZsWnB+XnmHrK+CPBri6wAKh+SOguFiOQAhyzYuNdgXSe4XW1OJlenWq22wOhVeV4dacHPQAwCK+KjQihd6cUtDE5IAy0fqPcks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002585; c=relaxed/simple;
	bh=AgDQM/LC6JYpJ6ULfXyB/OADw+K2Yn4pqU+t7s0JdBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnhIo9p2uzUlFbxF3L4RGh1tvvDKjkVOactC7GxLIKrA5WINy+tnEEEv72qb71/mBhWWotzC0Zcy7EUx/me7fEaQWPxnALUtrz7LriKQX5wAxCn2wxew9dofnEtQOx7RxIYKg9h2405T3Cx1cShugnBzjFJNoCU0kCOLrc7mmdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuFYroCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuFYroCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076C6C116D0;
	Wed, 25 Feb 2026 06:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002585;
	bh=AgDQM/LC6JYpJ6ULfXyB/OADw+K2Yn4pqU+t7s0JdBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuFYroCVouz7uPfENH1dfEDtBMjFDl2aX0MQxbIb77cvJ0hEFjtPNrbxZTmoOQErS
	 9LG+Mt+R2JaDeTBvRmvF8SpGeZeQPWIkuDVB23oJ3aO7h0DhGgymXba3rBl2cy+S17
	 kG6vJ9Lwc3TPRPZLW6a+DNKlBdIivbDSWssCV+b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/641] wifi: ath12k: clear stale link mapping of ahvif->links_map
Date: Tue, 24 Feb 2026 17:20:12 -0800
Message-ID: <20260225012355.694378882@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 2c1ba9c2adf0fda96eaaebd8799268a7506a8fc9 ]

When an arvif is initialized in non-AP STA mode but MLO connection
preparation fails before the arvif is created
(arvif->is_created remains false), the error path attempts to delete all
links. However, link deletion only executes when arvif->is_created is true.
As a result, ahvif retains a stale entry of arvif that is initialized but
not created.

When a new arvif is initialized with the same link id, this stale mapping
triggers the following WARN_ON.

WARNING: drivers/net/wireless/ath/ath12k/mac.c:4271 at ath12k_mac_op_change_vif_links+0x140/0x180 [ath12k], CPU#3: wpa_supplicant/275

Call trace:
 ath12k_mac_op_change_vif_links+0x140/0x180 [ath12k] (P)
 drv_change_vif_links+0xbc/0x1a4 [mac80211]
 ieee80211_vif_update_links+0x54c/0x6a0 [mac80211]
 ieee80211_vif_set_links+0x40/0x70 [mac80211]
 ieee80211_prep_connection+0x84/0x450 [mac80211]
 ieee80211_mgd_auth+0x200/0x480 [mac80211]
 ieee80211_auth+0x14/0x20 [mac80211]
 cfg80211_mlme_auth+0x90/0xf0 [cfg80211]
 nl80211_authenticate+0x32c/0x380 [cfg80211]
 genl_family_rcv_msg_doit+0xc8/0x134

Fix this issue by unassigning the link vif and clearing ahvif->links_map
if arvif is only initialized but not created.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1

Fixes: 81e4be30544e ("wifi: ath12k: handle link removal in change_vif_links()")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260127033400.1721220-1-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 256ffae4d7f7d..b97469dca0467 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4004,8 +4004,10 @@ ath12k_mac_op_change_vif_links(struct ieee80211_hw *hw,
 		if (WARN_ON(!arvif))
 			return -EINVAL;
 
-		if (!arvif->is_created)
+		if (!arvif->is_created) {
+			ath12k_mac_unassign_link_vif(arvif);
 			continue;
+		}
 
 		if (WARN_ON(!arvif->ar))
 			return -EINVAL;
-- 
2.51.0



