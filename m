Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A244E1D8;
	Tue, 23 Jan 2024 00:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969978; cv=none; b=NCYOx+g6OqH2rehFCX1glY4cVP9l2uf5i/CStnuqQVUlvhhaVvQ9nh1xT8+utC2tnQ1bOgjTs9Gd7a/7uZvGQlFIZLsif1WLuLjmTm18L0AM8WdbVZiPnIxK9x9rDeIUP1dv1/ytr6UrXP8mkpYm3n2vBj0SE0al04z5nMHWM74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969978; c=relaxed/simple;
	bh=U/m1Mgsi94hP6LGvWYMQsqhe9yq/hYl0BIWK9vb6iOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szaIxFP0A8TCKbWNcAM8brDoaIKGaaQo5MKVTYZwthqzUVYh9bgkwzr2w6nzu2PBO3UIZbYbBcgY/AYld/nSTvvoCSPMVTncZT/W8ZL7TBVx0aLfvpTzTSZPWRUbAV2oeAdZz3TdEHtdTuCwOJc/MTuhm1BXCOA5BtAS5Wywsd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypXFWMLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypXFWMLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BAAC433C7;
	Tue, 23 Jan 2024 00:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969977;
	bh=U/m1Mgsi94hP6LGvWYMQsqhe9yq/hYl0BIWK9vb6iOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypXFWMLYP4i4QujpYGpyD96VEsVzw2M+HI22xSYspXk6otqlsSugUpj07NR/LDwtU
	 QOYZhQVRet04tPbHPGvqD5wGTv47oLUduUcPdYfao+MVV6e3sUTG/G6W0nIIcAzFWj
	 VTFi4RQSXuJZwr1wWsXXKII5qUPSNqslfkbYq8ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayush Singh <ayushdevel1325@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 547/641] greybus: gb-beagleplay: Remove use of pad bytes
Date: Mon, 22 Jan 2024 15:57:31 -0800
Message-ID: <20240122235835.254998345@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Singh <ayushdevel1325@gmail.com>

[ Upstream commit 08b3485540d9e94ed8335f82e5fc491fc02f8423 ]

Make gb-beagleplay greybus spec compliant by moving cport information to
transport layer instead of using `header->pad` bytes.

Greybus HDLC frame now has the following payload:
1. le16 cport
2. gb_operation_msg_hdr msg_header
3. u8 *msg_payload

Fixes: ec558bbfea67 ("greybus: Add BeaglePlay Linux Driver")
Signed-off-by: Ayush Singh <ayushdevel1325@gmail.com>
Link: https://lore.kernel.org/r/20231217121133.74703-2-ayushdevel1325@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/gb-beagleplay.c | 58 ++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/greybus/gb-beagleplay.c b/drivers/greybus/gb-beagleplay.c
index 43318c1993ba..7d98ae1a8263 100644
--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -85,17 +85,31 @@ struct hdlc_payload {
 	void *buf;
 };
 
+/**
+ * struct hdlc_greybus_frame - Structure to represent greybus HDLC frame payload
+ *
+ * @cport: cport id
+ * @hdr: greybus operation header
+ * @payload: greybus message payload
+ *
+ * The HDLC payload sent over UART for greybus address has cport preappended to greybus message
+ */
+struct hdlc_greybus_frame {
+	__le16 cport;
+	struct gb_operation_msg_hdr hdr;
+	u8 payload[];
+} __packed;
+
 static void hdlc_rx_greybus_frame(struct gb_beagleplay *bg, u8 *buf, u16 len)
 {
-	u16 cport_id;
-	struct gb_operation_msg_hdr *hdr = (struct gb_operation_msg_hdr *)buf;
-
-	memcpy(&cport_id, hdr->pad, sizeof(cport_id));
+	struct hdlc_greybus_frame *gb_frame = (struct hdlc_greybus_frame *)buf;
+	u16 cport_id = le16_to_cpu(gb_frame->cport);
+	u16 gb_msg_len = le16_to_cpu(gb_frame->hdr.size);
 
 	dev_dbg(&bg->sd->dev, "Greybus Operation %u type %X cport %u status %u received",
-		hdr->operation_id, hdr->type, cport_id, hdr->result);
+		gb_frame->hdr.operation_id, gb_frame->hdr.type, cport_id, gb_frame->hdr.result);
 
-	greybus_data_rcvd(bg->gb_hd, cport_id, buf, len);
+	greybus_data_rcvd(bg->gb_hd, cport_id, (u8 *)&gb_frame->hdr, gb_msg_len);
 }
 
 static void hdlc_rx_dbg_frame(const struct gb_beagleplay *bg, const char *buf, u16 len)
@@ -336,25 +350,39 @@ static struct serdev_device_ops gb_beagleplay_ops = {
 	.write_wakeup = gb_tty_wakeup,
 };
 
+/**
+ * gb_message_send() - Send greybus message using HDLC over UART
+ *
+ * @hd: pointer to greybus host device
+ * @cport: AP cport where message originates
+ * @msg: greybus message to send
+ * @mask: gfp mask
+ *
+ * Greybus HDLC frame has the following payload:
+ * 1. le16 cport
+ * 2. gb_operation_msg_hdr msg_header
+ * 3. u8 *msg_payload
+ */
 static int gb_message_send(struct gb_host_device *hd, u16 cport, struct gb_message *msg, gfp_t mask)
 {
 	struct gb_beagleplay *bg = dev_get_drvdata(&hd->dev);
-	struct hdlc_payload payloads[2];
+	struct hdlc_payload payloads[3];
+	__le16 cport_id = cpu_to_le16(cport);
 
 	dev_dbg(&hd->dev, "Sending greybus message with Operation %u, Type: %X on Cport %u",
 		msg->header->operation_id, msg->header->type, cport);
 
-	if (msg->header->size > RX_HDLC_PAYLOAD)
+	if (le16_to_cpu(msg->header->size) > RX_HDLC_PAYLOAD)
 		return dev_err_probe(&hd->dev, -E2BIG, "Greybus message too big");
 
-	memcpy(msg->header->pad, &cport, sizeof(cport));
-
-	payloads[0].buf = msg->header;
-	payloads[0].len = sizeof(*msg->header);
-	payloads[1].buf = msg->payload;
-	payloads[1].len = msg->payload_size;
+	payloads[0].buf = &cport_id;
+	payloads[0].len = sizeof(cport_id);
+	payloads[1].buf = msg->header;
+	payloads[1].len = sizeof(*msg->header);
+	payloads[2].buf = msg->payload;
+	payloads[2].len = msg->payload_size;
 
-	hdlc_tx_frames(bg, ADDRESS_GREYBUS, 0x03, payloads, 2);
+	hdlc_tx_frames(bg, ADDRESS_GREYBUS, 0x03, payloads, 3);
 	greybus_message_sent(bg->gb_hd, msg, 0);
 
 	return 0;
-- 
2.43.0



