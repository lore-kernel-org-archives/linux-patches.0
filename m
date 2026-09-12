Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD22F8E90;
	Sat, 12 Sep 2026 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224040; cv=none; b=k+iz7I/tyc7lKe8GpdeeuHcLPCQJ5Xem9YN4J5mD8FV6g55m+bjaf14iPxfjvr+mbVV5liHF2XapW7/bquVoQ9HD+4ft4c7r1NadFgHXZ9G6Uix/vGMDlfBhlFttBpFwyU7quOD9sWd7DOy2gzHn8TZIjttlK7JNukpSiYKGDqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224040; c=relaxed/simple;
	bh=t+XsvdhlJDLPo0xGM88vWFqbvn6PCVZw7dwo001GiqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4rjQS+ADKwPY77Pd6Q7UDK2S2ttcTmFaSTHHozcpePZ0oxrZsU9QRjVy/JIAHw4eyz8vRy32pRdk1wyXmQL5jufkh8Gxd/RKfRbiDdLqaDw4oCB0FR+6Xn4so/JO7HqJgxAXUM/yalWp/S9JyT4vaVkfnXIguDTgTUk/3UhwsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sddmdCIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sddmdCIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E557A1F000FF;
	Sat, 12 Sep 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224039;
	bh=E/0208BapZ8G67feUBu7irxx2ETalR268+s6IYeYdSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sddmdCIRUCyO4LD7qgFf3WOczqhe1MFUSnOVfWRiyauyvGYTKWgyGkhmQElJbJY9C
	 bTtc5zoCRZUc3wpRwutEB6lMxjvAmZw4jEPHfacZAynHsPQc/aBqneHRdK1jngaRf2
	 AJftrK46qqF8dpRhx1IdD9EfPNTsCiYj3p2WStsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0858/1424] wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()
Date: Sat, 12 Sep 2026 08:54:50 +0200
Message-ID: <20260912065626.530783732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ae0cd76ae361f..aa6f89ccfeae4 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8659,13 +8659,15 @@ static void ath11k_wmi_tlv_op_rx(struct ath11k_base *ab, struct sk_buff *skb)
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



