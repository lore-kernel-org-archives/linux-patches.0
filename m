Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801B11FE45D;
	Wed, 25 Feb 2026 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983996; cv=none; b=UoWL841rtdfdK9whLxzgpNqlxlo4YvgroGtbgQ3pW7Rsb/8EyhOVSedSd3LkGx5XFmVlW5OYk8j+nlt1WlS2+hUl/Am80bBh9rs7ORPmAfrKsS6SqrqwdWrBlxA49qrUSqk/mg6Z7jNTaDVzSHoQv3oenmWaPDFiidF/GOslG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983996; c=relaxed/simple;
	bh=Veu8Ppl5/aa19wLyEVBRlVVLRvdVscextJnh1/Xr77s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhcZ2/pwdlGOHdYxYkjwo6v4R+Yk/3994LPWJ0BjtC+m3EtgO1wfBDzQFOREI95Lptvn3xZtYX3+798w0ST5DLwuGUAkVE6AHpDQrkegJ7vwz1AtpYKb9PpM4YkUtsQZH/p9hqwtTL0SRMSz+I6m87si7P2RPedimb2AOABsUpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDILo/Ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDILo/Ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5F7C19424;
	Wed, 25 Feb 2026 01:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983996;
	bh=Veu8Ppl5/aa19wLyEVBRlVVLRvdVscextJnh1/Xr77s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDILo/Ah956X7ZDorxAb/wBMy44SxBoNTztBfuSXdWpGKLzR+PcipEuJEO9VezxyY
	 lFJH6q4PaGlK6EVhR6QeZaYfWQNqHuiJXQWQzH4NmJZOzToe6w8lIz4HYYn7JoWGoJ
	 pEYaoM4b8KjMe5QZilwfx3le2g+YweSpnluZbPvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/641] wifi: ath12k: do WoW offloads only on primary link
Date: Tue, 24 Feb 2026 17:19:36 -0800
Message-ID: <20260225012354.907837201@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit e62102ac9b773bdb08475aa9ca24dea61ae98708 ]

In case of multi-link connection, WCN7850 firmware crashes due to WoW
offloads enabled on both primary and secondary links.

Change to do it only on primary link to fix it.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: 32f7b19668bd ("wifi: ath12k: support MLO as well if single_chip_mlo_support flag is set")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251103-ath12-primary-link-wow-v1-1-3cf523dc09f0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wow.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wow.c b/drivers/net/wireless/ath/ath12k/wow.c
index e8481626f1940..c78aa95d49791 100644
--- a/drivers/net/wireless/ath/ath12k/wow.c
+++ b/drivers/net/wireless/ath/ath12k/wow.c
@@ -135,6 +135,9 @@ static int ath12k_wow_cleanup(struct ath12k *ar)
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (arvif != &arvif->ahvif->deflink)
+			continue;
+
 		ret = ath12k_wow_vif_cleanup(arvif);
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to clean wow wakeups on vdev %i: %d\n",
@@ -479,8 +482,12 @@ static int ath12k_wow_set_wakeups(struct ath12k *ar,
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (arvif != &arvif->ahvif->deflink)
+			continue;
+
 		if (ath12k_wow_is_p2p_vdev(arvif->ahvif))
 			continue;
+
 		ret = ath12k_wow_vif_set_wakeups(arvif, wowlan);
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to set wow wakeups on vdev %i: %d\n",
@@ -538,6 +545,9 @@ static int ath12k_wow_nlo_cleanup(struct ath12k *ar)
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (arvif != &arvif->ahvif->deflink)
+			continue;
+
 		if (ath12k_wow_is_p2p_vdev(arvif->ahvif))
 			continue;
 
@@ -745,6 +755,9 @@ static int ath12k_wow_arp_ns_offload(struct ath12k *ar, bool enable)
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ahvif = arvif->ahvif;
 
+		if (arvif != &ahvif->deflink)
+			continue;
+
 		if (ahvif->vdev_type != WMI_VDEV_TYPE_STA)
 			continue;
 
@@ -776,6 +789,9 @@ static int ath12k_gtk_rekey_offload(struct ath12k *ar, bool enable)
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (arvif != &arvif->ahvif->deflink)
+			continue;
+
 		if (arvif->ahvif->vdev_type != WMI_VDEV_TYPE_STA ||
 		    !arvif->is_up ||
 		    !arvif->rekey_data.enable_offload)
-- 
2.51.0



