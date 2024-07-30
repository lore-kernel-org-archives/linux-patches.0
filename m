Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517D61A619B;
	Tue, 30 Jul 2024 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357463; cv=none; b=eK5CxgBQRuBR8QELaVIZluPuhLytowvlMtdCMZamdiMjlnI25A4C4tN50HMQydPBPn5zCzZ767MIqeVJqSHsikj7iNqLTsiesxAnHVat6NIxOs6ZaJ58aaDWzZ+lNvtOg0FU1MbypJNpGDkr7HlciefB2I/JQvGBNKL9SBMXLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357463; c=relaxed/simple;
	bh=mm9BzEdhL+PRjS1+FjdahzLeWDku+oZgU4bXrfi3Wtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MU83tUcIgcXqYfvPuaMsTd/+Ut/BEBPvFqIU27eK64U8gr6dBz6UVs5072Uo/JPL4GgwOB+d4rA/pEhPHUgOSIpQZuBsvYMKvX3rPKg2pQLbh8HUfoj2UvmNUY39HuAoCtugFrz6l7KCHPHtGJWKmiqc+G1pDDDPCaIzIQQR+lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yM3d2A4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yM3d2A4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CB8C32782;
	Tue, 30 Jul 2024 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357463;
	bh=mm9BzEdhL+PRjS1+FjdahzLeWDku+oZgU4bXrfi3Wtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yM3d2A4YE613j68w3vBl4R06Nft/vHL0TT3NMRWGhtXIaxAqClayY/9Bguzxn3yri
	 1+4sCdFvi6eX5RlOBOiUp8g9QZNNrgHQ0rxqk0zS2rPWdXuk+vdhm7y4Q/PQPBl+Nc
	 r1uEnq341g7fe3clCVuF+1s1yHOz1ygFznr7Rx9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 256/809] Bluetooth: btnxpuart: Add handling for boot-signature timeout errors
Date: Tue, 30 Jul 2024 17:42:12 +0200
Message-ID: <20240730151734.706726801@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

[ Upstream commit 27489364299a2ddb5c54cd9f29a3f41bd8d151ab ]

This handles the timeout error codes sent by the chip as part of the
bootloader signatures during firmware download process.

When the bootloader does not receive a response packet from the host
within a specific time, it adds an error code to the bootloader
signature while requesting for the FW chunk from the same offset.

The host is expected to clear this error code with a NAK, and reply to
only those bootloader signatures which have error code 0.

However, the driver was ignoring this error code and replying with the
firmware chunks instead, which is apparently ignored by the chip and the
chip resends the same bootloader signature with the error code again. This
happens in a loop until the error code self clears and firmware download
proceeds ahead, adding a couple of milliseconds to the total firmware
download time.

Commit 689ca16e5232 was an initial implementation which simply printed
the following line during driver debug:
- FW Download received err 0x04 from chip

This commit adds the expected handling to the error codes.

This error handling is valid for data_req bootloader signatures for V3
and future bootloader versions.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 52 ++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 9bfa9a6ad56c8..6a863328b8053 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -187,6 +187,11 @@ struct btnxpuart_dev {
 #define NXP_NAK_V3		0x7b
 #define NXP_CRC_ERROR_V3	0x7c
 
+/* Bootloader signature error codes */
+#define NXP_ACK_RX_TIMEOUT	0x0002	/* ACK not received from host */
+#define NXP_HDR_RX_TIMEOUT	0x0003	/* FW Header chunk not received */
+#define NXP_DATA_RX_TIMEOUT	0x0004	/* FW Data chunk not received */
+
 #define HDR_LEN			16
 
 #define NXP_RECV_CHIP_VER_V1 \
@@ -277,6 +282,17 @@ struct nxp_bootloader_cmd {
 	__be32 crc;
 } __packed;
 
+struct nxp_v3_rx_timeout_nak {
+	u8 nak;
+	__le32 offset;
+	u8 crc;
+} __packed;
+
+union nxp_v3_rx_timeout_nak_u {
+	struct nxp_v3_rx_timeout_nak pkt;
+	u8 buf[6];
+};
+
 static u8 crc8_table[CRC8_TABLE_SIZE];
 
 /* Default configurations */
@@ -899,6 +915,32 @@ static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *skb)
 	return 0;
 }
 
+static void nxp_handle_fw_download_error(struct hci_dev *hdev, struct v3_data_req *req)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	__u32 offset = __le32_to_cpu(req->offset);
+	__u16 err = __le16_to_cpu(req->error);
+	union nxp_v3_rx_timeout_nak_u nak_tx_buf;
+
+	switch (err) {
+	case NXP_ACK_RX_TIMEOUT:
+	case NXP_HDR_RX_TIMEOUT:
+	case NXP_DATA_RX_TIMEOUT:
+		nak_tx_buf.pkt.nak = NXP_NAK_V3;
+		nak_tx_buf.pkt.offset = __cpu_to_le32(offset);
+		nak_tx_buf.pkt.crc = crc8(crc8_table, nak_tx_buf.buf,
+				      sizeof(nak_tx_buf) - 1, 0xff);
+		serdev_device_write_buf(nxpdev->serdev, nak_tx_buf.buf,
+					sizeof(nak_tx_buf));
+		break;
+	default:
+		bt_dev_dbg(hdev, "Unknown bootloader error code: %d", err);
+		break;
+
+	}
+
+}
+
 static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
@@ -913,7 +955,12 @@ static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
 	if (!req || !nxpdev->fw)
 		goto free_skb;
 
-	nxp_send_ack(NXP_ACK_V3, hdev);
+	if (!req->error) {
+		nxp_send_ack(NXP_ACK_V3, hdev);
+	} else {
+		nxp_handle_fw_download_error(hdev, req);
+		goto free_skb;
+	}
 
 	len = __le16_to_cpu(req->len);
 
@@ -940,9 +987,6 @@ static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
 		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
 		goto free_skb;
 	}
-	if (req->error)
-		bt_dev_dbg(hdev, "FW Download received err 0x%02x from chip",
-			   req->error);
 
 	offset = __le32_to_cpu(req->offset);
 	if (offset < nxpdev->fw_v3_offset_correction) {
-- 
2.43.0



