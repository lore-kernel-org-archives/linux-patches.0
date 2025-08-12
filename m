Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFCD22425B;
	Tue, 12 Aug 2025 19:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025296; cv=none; b=rkWB8QUgmy8oH7pMttLl6zixJDU4S+KP8qao3uR9v4HE4JChsUtRgc/pnNhviv9/20WiQCBU6KfI13QVF/cvrc+W17rmLwLa/Uiaj+0zamhS9pA3FFQtGTn8+pDA4yevVuWmgkiJahFAQM6ek8Jliw2lpEXyY051/iijvL+uPa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025296; c=relaxed/simple;
	bh=JQvlHGTMaSaEnkW5xW84NAYooASxOoKim2/FS1Y1mKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOZ+ky4EMoPovZnmZlrzhO5GHQnB+1Ubj+Giwr76GMWN4jMA7DJglpIclq3Ff2KTZJpQbYqD3l0HdhUQboXsKtz/rLk6YrMw34rxdcn/7dGGSYeTyL/eqlRKpVDJZxr/bMs+4F8d2ZDDK8C/NNrpthLCw92XwgLFaaklQI/RvCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PltcxDVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PltcxDVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B767AC4CEF0;
	Tue, 12 Aug 2025 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025295;
	bh=JQvlHGTMaSaEnkW5xW84NAYooASxOoKim2/FS1Y1mKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PltcxDVxdKcPspFeHd+pRW4KC+ZpC3ILtBFGei1GHsPmC3/M9RMvsR7FPKZx7R7SP
	 V2srpIrFYmRCGrnldygImw/UHNSJEglyMOQBq2PTj60pgiRgMMHPLUYVQuopW41Snw
	 K89kVjyVa4y137OJ/x1vxTNLwUSeMLtdHBMkEcZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.16 626/627] wifi: ath12k: install pairwise key first
Date: Tue, 12 Aug 2025 19:35:21 +0200
Message-ID: <20250812173455.695186756@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

commit 66e865f9dc78d00e6d1c8c6624cb0c9004e5aafb upstream.

As station, WCN7850 firmware requires pairwise key to be installed before
group key. Currently host does not care about this, so it is up to kernel
or userspace to decide which one will be installed first. In case above
requirement is not met, WCN7850 firmware's EAPOL station machine is messed
up, and finally connection fails [1].

Reorder key install for station interface in that case: this is done by
caching group key first; Later when pairwise key arrives, both can be
installed in required order.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00217-QCAHKSWPL_SILICONZ-1

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218733
Link: https://lore.kernel.org/all/AS8P190MB12051DDBD84CD88E71C40AD7873F2@AS8P190MB1205.EURP190.PROD.OUTLOOK.COM # [1]
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250523-ath12k-unicast-key-first-v1-2-f53c3880e6d8@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/core.h |    4 +
 drivers/net/wireless/ath/ath12k/mac.c  |   76 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath12k/wmi.h  |    1 
 3 files changed, 74 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -345,6 +345,10 @@ struct ath12k_link_vif {
 	bool is_sta_assoc_link;
 
 	struct ath12k_reg_tpc_power_info reg_tpc_info;
+
+	bool group_key_valid;
+	struct wmi_vdev_install_key_arg group_key;
+	bool pairwise_key_done;
 };
 
 struct ath12k_vif {
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4723,14 +4723,13 @@ static int ath12k_install_key(struct ath
 		.key_len = key->keylen,
 		.key_data = key->key,
 		.key_flags = flags,
+		.ieee80211_key_cipher = key->cipher,
 		.macaddr = macaddr,
 	};
 	struct ath12k_vif *ahvif = arvif->ahvif;
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
-	reinit_completion(&ar->install_key_done);
-
 	if (test_bit(ATH12K_FLAG_HW_CRYPTO_DISABLED, &ar->ab->dev_flags))
 		return 0;
 
@@ -4739,7 +4738,7 @@ static int ath12k_install_key(struct ath
 		/* arg.key_cipher = WMI_CIPHER_NONE; */
 		arg.key_len = 0;
 		arg.key_data = NULL;
-		goto install;
+		goto check_order;
 	}
 
 	switch (key->cipher) {
@@ -4767,19 +4766,82 @@ static int ath12k_install_key(struct ath
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV |
 			      IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
 
+check_order:
+	if (ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
+	    arg.key_flags == WMI_KEY_GROUP) {
+		if (cmd == SET_KEY) {
+			if (arvif->pairwise_key_done) {
+				ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
+					   "vdev %u pairwise key done, go install group key\n",
+					   arg.vdev_id);
+				goto install;
+			} else {
+				/* WCN7850 firmware requires pairwise key to be installed
+				 * before group key. In case group key comes first, cache
+				 * it and return. Will revisit it once pairwise key gets
+				 * installed.
+				 */
+				arvif->group_key = arg;
+				arvif->group_key_valid = true;
+				ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
+					   "vdev %u group key before pairwise key, cache and skip\n",
+					   arg.vdev_id);
+
+				ret = 0;
+				goto out;
+			}
+		} else {
+			arvif->group_key_valid = false;
+		}
+	}
+
 install:
-	ret = ath12k_wmi_vdev_install_key(arvif->ar, &arg);
+	reinit_completion(&ar->install_key_done);
 
+	ret = ath12k_wmi_vdev_install_key(arvif->ar, &arg);
 	if (ret)
 		return ret;
 
 	if (!wait_for_completion_timeout(&ar->install_key_done, 1 * HZ))
 		return -ETIMEDOUT;
 
-	if (ether_addr_equal(macaddr, arvif->bssid))
-		ahvif->key_cipher = key->cipher;
+	if (ether_addr_equal(arg.macaddr, arvif->bssid))
+		ahvif->key_cipher = arg.ieee80211_key_cipher;
+
+	if (ar->install_key_status) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
+	    arg.key_flags == WMI_KEY_PAIRWISE) {
+		if (cmd == SET_KEY) {
+			arvif->pairwise_key_done = true;
+			if (arvif->group_key_valid) {
+				/* Install cached GTK */
+				arvif->group_key_valid = false;
+				arg = arvif->group_key;
+				ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
+					   "vdev %u pairwise key done, group key ready, go install\n",
+					   arg.vdev_id);
+				goto install;
+			}
+		} else {
+			arvif->pairwise_key_done = false;
+		}
+	}
+
+out:
+	if (ret) {
+		/* In case of failure userspace may not do DISABLE_KEY
+		 * but triggers re-connection directly, so manually reset
+		 * status here.
+		 */
+		arvif->group_key_valid = false;
+		arvif->pairwise_key_done = false;
+	}
 
-	return ar->install_key_status ? -EINVAL : 0;
+	return ret;
 }
 
 static int ath12k_clear_peer_keys(struct ath12k_link_vif *arvif,
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3760,6 +3760,7 @@ struct wmi_vdev_install_key_arg {
 	u32 key_idx;
 	u32 key_flags;
 	u32 key_cipher;
+	u32 ieee80211_key_cipher;
 	u32 key_len;
 	u32 key_txmic_len;
 	u32 key_rxmic_len;


