Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0E54F7975;
	Tue, 13 Oct 2026 12:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894143; cv=none; b=R4fxbDMlWjwmgnl3imG0B/J2sEswfjVQxF3qLZfaksGSEeXxP8lFPaEIL5FV4XWfIdgXdyExQ3zGbxkTIDsg9OV4HfuHXJhYo8JNtMk4tPdH4xHIMhOYf4Fs4GN3MXZZUALZt8VWTIjpXUQ7v45sNBST1yHxZdD0UVmZ9RV1OtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894143; c=relaxed/simple;
	bh=lihK/I+ydFeC6KyWQz5M/DAuubIc3QWG4THOGmdlwD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw30Kg7JQ+BZsdHPTS02p2RX6nzf+13byUGC5jVMnAeAs+svUJtHeFKN7gx/2Z/Ik7L1GZGPH4r7KdA90SIcxVsGBQX46qY1aVZ05I7qIiTGPfoaNHb4F03DuoR9+3BOXOZifB9XY4og7JITcz4VFMxqxVec/hsGYyGIUGhicgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=robybvn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="robybvn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48441F000FF;
	Tue, 13 Oct 2026 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894142;
	bh=lg0rmPwLG280A914EjPeJW3WHuJKEiTZyr6BO622Ngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=robybvn6IghhxxwTsUwVBDAAnpcNpwNZEoot16vJkr3P9nktKaog/rdDOLAeLUov2
	 j4B+n21zba0F4SyQvcGd99iOf2h8DwgHglWRa3cM1PN1CRdBYPgzvzUu8hi5M0GEPw
	 U3O4tqFWpHh7wTZQfr94yBWjQrElST0dEiieZZjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 461/621] wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
Date: Tue, 13 Oct 2026 13:37:36 +0200
Message-ID: <20261013112931.772292473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 878654eb78c6aa0ff585baf1376567c775ca28ec ]

There is no policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT, so
the parse infrastructure does not enforce a minimum length for the event
struct. Additionally, the num_vdevs field is taken directly from firmware
and used as a loop bound over the vdev_ids array without checking that it
fits within the TLV payload. Either condition can cause an out-of-bounds
read.

Add a TLV policy entry for WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT so
the parse infrastructure enforces a minimum length for the fixed-size event
struct. Add a helper ath12k_wmi_tlv_data_len() to recover the payload
length of a parsed TLV from the header preceding its data pointer. Use it
in ath12k_wmi_process_csa_switch_count_event() to bound num_vdevs before
the loop.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-1-02a45d7246c0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index f4392462ae3a2..ade14ba6703f3 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -190,6 +190,8 @@ static const struct ath12k_wmi_tlv_policy ath12k_wmi_tlv_policies[] = {
 		.min_len = sizeof(struct wmi_11d_new_cc_event) },
 	[WMI_TAG_PER_CHAIN_RSSI_STATS] = {
 		.min_len = sizeof(struct wmi_per_chain_rssi_stat_params) },
+	[WMI_TAG_PDEV_CSA_SWITCH_COUNT_STATUS_EVENT] = {
+		.min_len = sizeof(struct ath12k_wmi_pdev_csa_event) },
 };
 
 __le32 ath12k_wmi_tlv_hdr(u32 cmd, u32 len)
@@ -402,6 +404,13 @@ ath12k_wmi_tlv_parse_alloc(struct ath12k_base *ab,
 	return tb;
 }
 
+static u32 ath12k_wmi_tlv_data_len(const void *data)
+{
+	const struct wmi_tlv *tlv = (const struct wmi_tlv *)data - 1;
+
+	return le32_get_bits(tlv->header, WMI_TLV_LEN);
+}
+
 static int ath12k_wmi_cmd_send_nowait(struct ath12k_wmi_pdev *wmi, struct sk_buff *skb,
 				      u32 cmd_id)
 {
@@ -8529,12 +8538,19 @@ ath12k_wmi_process_csa_switch_count_event(struct ath12k_base *ab,
 					  const u32 *vdev_ids)
 {
 	u32 current_switch_count = le32_to_cpu(ev->current_switch_count);
+	u32 vdev_ids_len = ath12k_wmi_tlv_data_len(vdev_ids);
 	u32 num_vdevs = le32_to_cpu(ev->num_vdevs);
 	struct ieee80211_bss_conf *conf;
 	struct ath12k_link_vif *arvif;
 	struct ath12k_vif *ahvif;
 	int i;
 
+	if (num_vdevs > vdev_ids_len / sizeof(*vdev_ids)) {
+		ath12k_warn(ab, "csa switch count num_vdevs %u exceeds tlv array length %u\n",
+			    num_vdevs, vdev_ids_len);
+		return;
+	}
+
 	rcu_read_lock();
 	for (i = 0; i < num_vdevs; i++) {
 		arvif = ath12k_mac_get_arvif_by_vdev_id(ab, vdev_ids[i]);
-- 
2.53.0



