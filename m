Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837A8356A0D;
	Sat, 12 Sep 2026 10:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208054; cv=none; b=JcTw8aStzjHkapY57tV4CgjuoEqvQBb82lDBqgVpMrgxKkx96+JK6WlNpGuNSDK41M4lUuYumobtFXAf6UAGnhTnQ4sCZ0h8R12FGHBMfEZsb9ZofqNfkJbAEdalbpHcW6knpkeLIW92CCVkKn6XiZ6LRvybJKqbhtjmf4LnMfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208054; c=relaxed/simple;
	bh=GTDC2AIsjBsoT8Ql6E4eW5988snLc4BVzpj5hpO1yro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4ZhJQN8GEG/S+3buUnt9q5t8ybnPf8Lzi3uv1c3hp3YUQp4P+9hDPkaiiEM1PEHH5cptgWpwjxHktU1BNuusK249w/S2F+/Icmu4pPMjC4GZVIY4lsBtmY6X3n1RTUt5fSvnmFWSLJjL+bLeQ6U4GYAuAXVOKX7EBKRixHOeU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2o+FtmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2o+FtmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E9E1F000FF;
	Sat, 12 Sep 2026 10:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208053;
	bh=ujkijYO+9bcomww3zKdQbD3PXp2KDsCVegqVTvgXdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2o+FtmKAPs9Km0MtTYyTDGRSfUEUiuy3tDSHkFox6v3EZM7C1+piZWYJrnyINPlq
	 Ambrkm5QHbs4eLmIeoSmwFb1z7/1vajuUjLg83Y5gVxw7ARJYMTXqNVqE3BFp5kKvt
	 +5vcQ0rkS16IPA/zlTM0EQ8zM9n0HMVUZU5yyMYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0538/1518] wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()
Date: Sat, 12 Sep 2026 08:45:07 +0200
Message-ID: <20260912065635.614290933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index aa99e07226103..077154b564aeb 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -9739,12 +9739,12 @@ static void ath12k_wmi_op_rx(struct ath12k_base *ab, struct sk_buff *skb)
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



