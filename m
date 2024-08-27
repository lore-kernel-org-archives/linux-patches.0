Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687021C57B3;
	Tue, 27 Aug 2024 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770033; cv=none; b=A5d+je/xaUEaUDPaB5CHcnl2GnfZpkcvyhfTYuwY6IdA7mKtechVBDUCpVwbTzQpTO+U642/t7qfAus8J0WAOdX4mO7xu3C63ruYaBS+0v+bFDPljUwonY6k1sV0IgfovQAYp+f2p+rUp9ygseQVsrwRfElIvDK7K/1q/hXww5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770033; c=relaxed/simple;
	bh=cGZ09dkFccZNW4A8hH6WX7I/0OXijXZuOL6ozEkhKeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qg+4l5nxfqaSfS6MD9Lkk98KwqGMAJHadimHugdKfhO89FWLQsPfHt8Dkr9VeWH4U1MQGfVpkzIVjGMj5PgVLnAuDFv4uAIIh9+VCKVHrc4sOXwD+T170utXIPCDPifgKH3ldrRnU2hVZLOr8RTSv/CcEj8cXeiOSVJCx15pYZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3by+0Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3by+0Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CA3C4AF11;
	Tue, 27 Aug 2024 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770033;
	bh=cGZ09dkFccZNW4A8hH6WX7I/0OXijXZuOL6ozEkhKeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3by+0VhRqHgaLCXBbTr/VPA0klGYCaVWtFszygcTmksN23chW3CyUpb7kJXBWE22
	 p1nCqX7fiTx7uNxEvZBEBy3O5KR6+zS2PTECCE8I6ayNu7jmLNTz4mAGOIWbQIOXAw
	 qdMZEYXae3JhZtsSu+zf/mUFITF+Q+Kz7514p4XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/341] wifi: ath11k: fix ath11k_mac_op_remain_on_channel() stack usage
Date: Tue, 27 Aug 2024 16:35:38 +0200
Message-ID: <20240827143847.481327133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 4fd15bb705d3faa7e6adab2daba2e3af80d9b6bd ]

When compiling with clang 16.0.6, I've noticed the following:

drivers/net/wireless/ath/ath11k/mac.c:8903:12: warning: stack frame
size (1032) exceeds limit (1024) in 'ath11k_mac_op_remain_on_channel'
[-Wframe-larger-than]
static int ath11k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
           ^
68/1032 (6.59%) spills, 964/1032 (93.41%) variables

So switch to kzalloc()'ed instance of 'struct scan_req_params' like
it's done in 'ath11k_mac_op_hw_scan()'. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230926042906.13725-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 44 +++++++++++++++------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 33f2c189b4d86..4247c0f840a48 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8910,7 +8910,7 @@ static int ath11k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
 {
 	struct ath11k *ar = hw->priv;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
-	struct scan_req_params arg;
+	struct scan_req_params *arg;
 	int ret;
 	u32 scan_time_msec;
 
@@ -8942,27 +8942,31 @@ static int ath11k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
 
 	scan_time_msec = ar->hw->wiphy->max_remain_on_channel_duration * 2;
 
-	memset(&arg, 0, sizeof(arg));
-	ath11k_wmi_start_scan_init(ar, &arg);
-	arg.num_chan = 1;
-	arg.chan_list = kcalloc(arg.num_chan, sizeof(*arg.chan_list),
-				GFP_KERNEL);
-	if (!arg.chan_list) {
+	arg = kzalloc(sizeof(*arg), GFP_KERNEL);
+	if (!arg) {
 		ret = -ENOMEM;
 		goto exit;
 	}
+	ath11k_wmi_start_scan_init(ar, arg);
+	arg->num_chan = 1;
+	arg->chan_list = kcalloc(arg->num_chan, sizeof(*arg->chan_list),
+				 GFP_KERNEL);
+	if (!arg->chan_list) {
+		ret = -ENOMEM;
+		goto free_arg;
+	}
 
-	arg.vdev_id = arvif->vdev_id;
-	arg.scan_id = ATH11K_SCAN_ID;
-	arg.chan_list[0] = chan->center_freq;
-	arg.dwell_time_active = scan_time_msec;
-	arg.dwell_time_passive = scan_time_msec;
-	arg.max_scan_time = scan_time_msec;
-	arg.scan_flags |= WMI_SCAN_FLAG_PASSIVE;
-	arg.scan_flags |= WMI_SCAN_FILTER_PROBE_REQ;
-	arg.burst_duration = duration;
-
-	ret = ath11k_start_scan(ar, &arg);
+	arg->vdev_id = arvif->vdev_id;
+	arg->scan_id = ATH11K_SCAN_ID;
+	arg->chan_list[0] = chan->center_freq;
+	arg->dwell_time_active = scan_time_msec;
+	arg->dwell_time_passive = scan_time_msec;
+	arg->max_scan_time = scan_time_msec;
+	arg->scan_flags |= WMI_SCAN_FLAG_PASSIVE;
+	arg->scan_flags |= WMI_SCAN_FILTER_PROBE_REQ;
+	arg->burst_duration = duration;
+
+	ret = ath11k_start_scan(ar, arg);
 	if (ret) {
 		ath11k_warn(ar->ab, "failed to start roc scan: %d\n", ret);
 
@@ -8988,7 +8992,9 @@ static int ath11k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
 	ret = 0;
 
 free_chan_list:
-	kfree(arg.chan_list);
+	kfree(arg->chan_list);
+free_arg:
+	kfree(arg);
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
2.43.0



