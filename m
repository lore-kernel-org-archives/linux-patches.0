Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46122931FB;
	Sat, 12 Sep 2026 08:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200229; cv=none; b=dq/T43dQYPnwmB2UM88ZwQsnKBXaWZueqykvg4bWZf3euQ5+yD3RnLYA5HB2PNzybclyKjtlSmSctW2CL3A/J7Fn1wl4h32sC81HznqMhNaK+cOdCPQbiEubo1IjFNLGa2hKGQqVwUsxZaIPpM0cqKRljo43fooO9YRmDQ0aeko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200229; c=relaxed/simple;
	bh=EaFr61WUauY8khhcC4SwCWdCmJi+KrfPwJnfTp1tlg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5MByT256b+h3NfiY15Ji1HX/JPivgSB7VzHfLE7XjeyCSiS63BIi9H5Brb/M0mn1ynTajjQQFKvZOqnha9dF9ceicbmG4G/1VXnwxfP2eZbzyRp7/Mkq6yUjniPfG5uNnaIFCI/HpVv899q3mdHziPjjIHWe4gitYlzbWMVipU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWDeeuRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWDeeuRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE871F000FF;
	Sat, 12 Sep 2026 08:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200228;
	bh=SPyHsdAEHoTsqOSpgtmAMK/uPOP4PxiWw58bzSJFR/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWDeeuRNWydHfozcDeSLdzqEJp0mYcUXuhVUDv23hAFbvoBGLY2M7m7PIQICuTH2O
	 WN8EQNnrV7ssscKgyn/0eFZ5gm9LPbfTOhwRz8aIabHMErSu//zLmL/5JUKCMyvmz/
	 BstveYEJwR1/oheC0DVfbcjdDFrbis25WwPObTZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0747/1815] wifi: ath12k: validate TLV length in process_tpc_stats()
Date: Sat, 12 Sep 2026 08:41:37 +0200
Message-ID: <20260912065706.441383852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 8e415b8068480d51a057197ded974e2637e8c42b ]

The outer skb->len guard only confirms the SKB is large enough
to hold the full fixed_param struct, but the TLV's own WMI_TLV_LEN
field is never checked. Firmware advertising a TLV length shorter
than sizeof(*fixed_param) causes reads of pdev_id and event_count
beyond the declared TLV payload.

Add a check that the TLV length is at least sizeof(*fixed_param)
before casting and dereferencing the pointer.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index fa10f4119ea59..146ed6152ae0f 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -9967,6 +9967,7 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 	void *ptr = skb->data;
 	struct ath12k *ar;
 	u16 tlv_tag;
+	u16 tlv_len;
 	u32 event_count;
 	int ret;
 
@@ -9982,6 +9983,7 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 
 	tlv = (struct wmi_tlv *)ptr;
 	tlv_tag = le32_get_bits(tlv->header, WMI_TLV_TAG);
+	tlv_len = le32_get_bits(tlv->header, WMI_TLV_LEN);
 	ptr += sizeof(*tlv);
 
 	if (tlv_tag != WMI_TAG_HALPHY_CTRL_PATH_EVENT_FIXED_PARAM) {
@@ -9989,6 +9991,12 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 		return;
 	}
 
+	if (tlv_len < sizeof(*fixed_param)) {
+		ath12k_warn(ab, "TPC stats fixed param tlv len %u too short\n",
+			    tlv_len);
+		return;
+	}
+
 	fixed_param = (struct ath12k_wmi_pdev_tpc_stats_event_fixed_params *)ptr;
 	rcu_read_lock();
 	ar = ath12k_mac_get_ar_by_pdev_id(ab, le32_to_cpu(fixed_param->pdev_id) + 1);
-- 
2.53.0



