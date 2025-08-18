Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DAFA93D;
	Mon, 18 Aug 2025 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524604; cv=none; b=Op7Wq2j5VO3thaienJSdYoNt2CS3HtQqWIptDLyNMk8l44z9tFarrN653uhEuI7CoX007cX5HmmBhmfEQAxrzmKDXiQZ57OUkF6F5/i7ftNLJ/4VF8+KwRQADAe7h1CjQigAe2Ug+c9Z/fvJglfidAWfITL7QqtFDGYak7mYFN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524604; c=relaxed/simple;
	bh=AKKAxKxNkE7+MkiZj+4/lFTbkHgkKSOhux9FqAl8ok8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5ObR1KzTaY/a2t3GVwpFzGYAbdhpGLUZ3Nsqsnya/INUrnUK1cMzyBV2szzhHQIFo/j+Fdm29gDUUc01DnkR5VmhesVzvvRIKXEkh1/tcEyx+2YlHwzXFtFZPlM1/pgRjRp7Q3RmRQWF7B7ONj2m6bavq+/COrPL+dt7I9zw/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJAej5Ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJAej5Ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775BAC113D0;
	Mon, 18 Aug 2025 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524604;
	bh=AKKAxKxNkE7+MkiZj+4/lFTbkHgkKSOhux9FqAl8ok8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJAej5EcfFQEazAkhI8eIYzdoNW19miBoQkBzneAzOj01OwdEWjS14E8jxARCk1s4
	 ZiTaUiokFFJ5aSTTQ8yPrkwMBA2gt+vJRubxA9rBVQD3pR75Nsx0NXgghI7zuSkwRl
	 Gct79xxUojHnKFCyGxhfe6iIrUfq0JrrL1DtMfLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH 6.15 508/515] wifi: ath12k: install pairwise key first
Date: Mon, 18 Aug 2025 14:48:14 +0200
Message-ID: <20250818124517.996585646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/core.h |    4 +
 drivers/net/wireless/ath/ath12k/mac.c  |   76 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath12k/wmi.h  |    1 
 3 files changed, 74 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -303,6 +303,10 @@ struct ath12k_link_vif {
 	struct ath12k_rekey_data rekey_data;
 
 	u8 current_cntdown_counter;
+
+	bool group_key_valid;
+	struct wmi_vdev_install_key_arg group_key;
+	bool pairwise_key_done;
 };
 
 struct ath12k_vif {
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4645,14 +4645,13 @@ static int ath12k_install_key(struct ath
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
 
@@ -4661,7 +4660,7 @@ static int ath12k_install_key(struct ath
 		/* arg.key_cipher = WMI_CIPHER_NONE; */
 		arg.key_len = 0;
 		arg.key_data = NULL;
-		goto install;
+		goto check_order;
 	}
 
 	switch (key->cipher) {
@@ -4689,19 +4688,82 @@ static int ath12k_install_key(struct ath
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
@@ -3725,6 +3725,7 @@ struct wmi_vdev_install_key_arg {
 	u32 key_idx;
 	u32 key_flags;
 	u32 key_cipher;
+	u32 ieee80211_key_cipher;
 	u32 key_len;
 	u32 key_txmic_len;
 	u32 key_rxmic_len;


