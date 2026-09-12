Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1BB1E1024;
	Sat, 12 Sep 2026 07:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199557; cv=none; b=cO1oxSERBMyGSitirg6TyFs9f6vbPq7ljaMfKsPQEo3rB9XXfbE60Cs7aKw3M5CdvFJHlZZO3lXO5yTnyFBEVopGk9RnR9LmRxvR5IedQAYPG8Rvbu7u5GY5vw78bvsPDzIauizwEjSoaLBVqfbGJ9lHTlATGQk/ELDFaZPUpGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199557; c=relaxed/simple;
	bh=iTAET+BE9vUpZdI9OIuLUJbtsa09u1fo48BE11O5M08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6+EjABaxeo0j698kxzr1M7DMSW4GDRg7wYpbAJcAs6T5JqOfXtY7qWqHNZggKudw2l/WmtI/sc68st6yo/4jh3nUXyEuv7oeatqM39sBvILVz7v5K/X139iGq0RTAcUKtLxqKe+jitzD84of0RCDLATjLWb5CFaPsH16Bk1+c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbonky2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbonky2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27AB1F000FF;
	Sat, 12 Sep 2026 07:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199556;
	bh=tiSvJqhFKxF/6liRWHopXUgz35QHwxBlWbk5KwhWBX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbonky2B63RfNl4RuCQFdhvV/YQcunYWS+pZFxYRKi8eiNNdEYk+YPFt+xQJzpp2v
	 TjH069O9vH10dMaViLyA+OHjxWyw7l6Xekws0kMJaTSMQvPOhfLQalMB/GwkfjzhbG
	 /XYxE6zf6s4jEIPpLJqJoug9krWbrM4/mbgI8L8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0610/1815] wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()
Date: Sat, 12 Sep 2026 08:39:20 +0200
Message-ID: <20260912065703.202026290@linuxfoundation.org>
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

[ Upstream commit 9ef9dd30058cc9223c72f711dca1a28a5947d0c5 ]

Currently, in ath11k_wmi_tlv_op_rx(), the firmware buffer is read
without first verifying that the buffer has enough data to hold a
header. This could result in a buffer overread.

Add an upfront length check before dereferencing skb->data as a
wmi_cmd_hdr. The check is placed before the trace_ath11k_wmi_event()
call to preserve the existing trace semantics (tracing the full raw
WMI event including the header), unlike the analogous ath12k fix which
could use skb_pull_data() directly.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index c54f50b98a133..72e0b2305e853 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8895,13 +8895,15 @@ static void ath11k_wmi_tlv_op_rx(struct ath11k_base *ab, struct sk_buff *skb)
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_tlv_event_id id;
 
+	if (skb->len < sizeof(*cmd_hdr))
+		goto out;
+
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = FIELD_GET(WMI_CMD_HDR_CMD_ID, (cmd_hdr->cmd_id));
 
 	trace_ath11k_wmi_event(ab, id, skb->data, skb->len);
 
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		goto out;
+	skb_pull(skb, sizeof(*cmd_hdr));
 
 	switch (id) {
 		/* Process all the WMI events here */
-- 
2.53.0



