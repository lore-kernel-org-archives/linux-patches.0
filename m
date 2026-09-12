Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C6C165F16;
	Sat, 12 Sep 2026 07:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199553; cv=none; b=uCpy8kmXGb4+ugUwT+98h6l42s7R/KV9wpOnTUk/B6WzAQznHLovSnL5XPuvskE4J35sMpOm1zzmyE89mkXbPjjs8hQLgFJByAtbxFei58uo5zf3VZP5BNqUMdEstoWATy8yt1YDz0LRzVpvYIMoq0G7zqowXb+r086g3ungqCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199553; c=relaxed/simple;
	bh=34YTYt4WO3QHlkzIIQb8orX8Dqied/nbM9AvKcTjAPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIw+NmQf8KwS8FZ8b+5/muJLwxkg2CwnVf6ISofvArFoya0IdZQAPSQz6sVH+1NvX/SPiz39kPL8b8DhVVrH9GSQ8HxjlIFTex+bx2PXb9R0caqgXQR/W+2JQxEsRujHvvI33MUVAbw+GgamfIHfGZgCngSzGlqYtczvkmTnWMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBmnMmTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBmnMmTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F891F000FF;
	Sat, 12 Sep 2026 07:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199551;
	bh=t9043ty37NCbh9GATMUVcvrHeltCyfcHixubjqZUnzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBmnMmTrtBnHrlhRibqppqvQsYmfdCulsxM1FJ7eP5hmXVz57nBCDU6pz6YzFx1Eh
	 L1xWaKV/Q7xmijTx6C3mMos5mUgHP4fDzCZbVLBg+vt3eF+DXUX3OYsTaD1Hwy7euN
	 12Jr2wPHs2dIafg0yOvwLOlgpvLeJSL1lXUvgoq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0609/1815] wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()
Date: Sat, 12 Sep 2026 08:39:19 +0200
Message-ID: <20260912065703.179127580@linuxfoundation.org>
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
index ee9e50aef03fc..9840dd950ac9f 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -10279,12 +10279,12 @@ static void ath12k_wmi_op_rx(struct ath12k_base *ab, struct sk_buff *skb)
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



