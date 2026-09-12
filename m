Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8FB3DB983;
	Sat, 12 Sep 2026 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216010; cv=none; b=nvX5IiX8RB85hfbKfYulIyeMPcvilQETzDCMNISLbC3OAiWd4tnZtMlHz/Xvn4J8caNAFIwg8FCTS+tq/Ki9uCchSqZ40M2/qfAZwGPuWJagHJp8y27/rZXnJDANjT2zt63XCGvi8ioSO0nS+yXMXVhechJ0ixK+3n7m8dZEXWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216010; c=relaxed/simple;
	bh=Yzsb5/rJscnkbUedJggAT42g8m1Il62iMhcrUz7+Mpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyMhaxtnXg7f+RwZEOoUXqtvuUBQATeiG9pkRevzaW1lVtGJTgPxibh7WYZv4GPuhXznrb6oVn+C6gGKPk4dJK4e6Bt8oSljTT89cKrSbyM+RIz+YQRdbuSdIqMFYiZ/v4H+4PmYzrmNHsF3lJU1+6I6azL+4fq+6ad9cpYDuYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVw6hGfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVw6hGfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271201F000FF;
	Sat, 12 Sep 2026 12:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216009;
	bh=Anj8ohLjjdEsML/4Xn1dg/U/U2mCXkYquYzjBP1FaKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVw6hGfv4WGG+LY4LYG+OSloH1HCSzcFpZRn6gBaRa3ZtwUF0ajlH/alrPAgfHOHG
	 Ql6tEfgoA5YrKeoe0ouV1xExPSmpLT5Oyq4fI+TdUDxwB5chVFb+7qGMxrcofwki7S
	 YOfgIdy6ThYNqi9cMwjPmmZAKU+kmjzIg4zx7nNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0647/1376] wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()
Date: Sat, 12 Sep 2026 08:51:13 +0200
Message-ID: <20260912065621.962370252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 7698656a2f7b045af5a6859766238cefea1b1945 ]

Currently, in ath12k_wmi_op_rx(), the firmware buffer is read without
first verifying that the buffer has enough data to hold a header. This
could result in a buffer overread.

Update the logic to verify the buffer contains at least enough data to
hold a wmi_cmd_hdr before reading from the buffer.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 58cbacbb6f665..111b0c91d4dee 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7196,12 +7196,12 @@ static void ath12k_wmi_op_rx(struct ath12k_base *ab, struct sk_buff *skb)
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_tlv_event_id id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = le32_get_bits(cmd_hdr->cmd_id, WMI_CMD_HDR_CMD_ID);
-
-	if (!skb_pull(skb, sizeof(struct wmi_cmd_hdr)))
+	cmd_hdr = skb_pull_data(skb, sizeof(*cmd_hdr));
+	if (!cmd_hdr)
 		goto out;
 
+	id = le32_get_bits(cmd_hdr->cmd_id, WMI_CMD_HDR_CMD_ID);
+
 	switch (id) {
 		/* Process all the WMI events here */
 	case WMI_SERVICE_READY_EVENTID:
-- 
2.53.0



