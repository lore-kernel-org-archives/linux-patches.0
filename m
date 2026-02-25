Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A2E18B0A;
	Wed, 25 Feb 2026 01:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983234; cv=none; b=cyTzwkKbPkd24Q1Zhg2mYqps/q3iAWWaYm7+7J7LCOI98NuI6BVXbTcPX80JV6jf7NCO1PONunfvj5GbxGO1dVY/dVUCh7dftMAh0MdsHQD0dvfRmNL13GJtst9wFN0cAbwN74XpQh/WEc7g+8QGM0iesCdPbJlRZbfk9Cw4q24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983234; c=relaxed/simple;
	bh=ySEq7xpCw64/HmUu4VHQNSY93V5dlrv5kEaAAixBMKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqqVK9s5JKr2lErTY1vbjuWRiOTyb9ls73f/QI5XexxqYkTR7HYxgdEpdvoP/3wzp69PgLrOofSNnKItIlXrbRrrz83fvhNc7f8My4J0XuvVVUEoiXfT1b3r47Lw5VW5qYwPB/eTge6o0nbAmq+ah5cExRQm50ck+TUVNIG3m5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHAk7E50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHAk7E50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E221C116D0;
	Wed, 25 Feb 2026 01:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983234;
	bh=ySEq7xpCw64/HmUu4VHQNSY93V5dlrv5kEaAAixBMKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHAk7E50xE13PATiGFuJMl0wDmF+IC9X07b/JzZ9T+QNPAOSeMSvOfXNJdwmmh70k
	 LlANgih4khUIv7Z+bQFSG5f33EsWL5ivp4iHSEuqOALrUtNYUoEGbMEYTacNP/dSYq
	 XM+zzmiQ5p0x/fVrYXrAL1QkWj3mHeLmHmWrnVxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 377/781] wifi: ath12k: clear stale link mapping of ahvif->links_map
Date: Tue, 24 Feb 2026 17:18:06 -0800
Message-ID: <20260225012408.939323766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index e0e49f782bf8d..63684ff9332d4 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4175,8 +4175,10 @@ ath12k_mac_op_change_vif_links(struct ieee80211_hw *hw,
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



