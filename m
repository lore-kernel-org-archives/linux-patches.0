Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D822882AB;
	Sat, 12 Sep 2026 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230960; cv=none; b=kGWaX6qXjB92THwsa64TXJ1pyqQd9xlf6/lXaIgWGt/m9KRKli0VLM8HTUryMOi7e4lBU4Wq9C4YAYpLbtT8+uFXYM5zypsOfqk3Dz1I6aR1jEW3xiVogIUYQQ5vOU5j4XvsZw8cXQEwl1gM9+qyzHlocWm8Jt9jMzGRRXBRG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230960; c=relaxed/simple;
	bh=BqEDphVA8H9K7/wCUqwRI5J9ixRv0LcAS4MjIF+3wOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inq1lsumwb6PotVhaNZM/S5szVhumoa1I/yBzWTTbqVwPC5IotPij4u82auGYeJvKnpEi1CkzINKqrkNXJQAfxfqr1E+MXhlZll5Ao7vnvlMnjo40KxLaNimnR5nG3xxJ6XcT5qv60H/Pix9KqLuCaBBmbHnusqGpW84YouMS2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUsX8cqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUsX8cqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8601F000FF;
	Sat, 12 Sep 2026 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230959;
	bh=7TuhVPEj80D0jgvSmFiZz/jfFBMBDS1JyFdGoRnkE3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUsX8cqEVmzW76b/dm8Db55PKkKA12LTakSmJZ7lCQyRXYbKE5I/DGpHn8l0iWNO7
	 uPbgxvkiIqqpEfztfLi+Iub6E1KY0Ica4uc1yEKoo0dFlSi3KZw+LUKONp6eebajcE
	 ZvJKl9AzFtJ0f030OEz+XSxTzGXlDqd5qZRujJM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0901/1191] mfd: rave-sp: validate received frame payload lengths
Date: Sat, 12 Sep 2026 09:00:29 +0200
Message-ID: <20260912065608.472629659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0be718b5451bd83865d6e2a8d750ca7886c4772a ]

A received RAVE-SP frame contains protocol data followed by a
variant-specific one- or two-byte checksum. rave_sp_receive_frame() derives
a checksum pointer before proving that the frame contains the checksum,
then passes the checksum-inclusive length to handlers that index the
command, acknowledgment ID and event-data bytes or derive a reply payload
length.

Name those protocol field offsets, prove the checksum extent before
deriving the protocol-data length, pass only that data length to the
handlers, and require the complete event or reply prefix before consuming
it.

Fixes: 538ee27290fa ("mfd: Add driver for RAVE Supervisory Processor")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/all/20260706092337.78754-1-pengpeng@iscas.ac.cn/
Link: https://patch.msgid.link/20260720115523.99956-1-pengpeng@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rave-sp.c | 64 +++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/rave-sp.c b/drivers/mfd/rave-sp.c
index 545196c85b5ca..07c98b6fdc9d1 100644
--- a/drivers/mfd/rave-sp.c
+++ b/drivers/mfd/rave-sp.c
@@ -63,6 +63,12 @@
 #define RAVE_SP_TX_BUFFER_SIZE				\
 	(RAVE_SP_STX_ETX_SIZE + 2 * RAVE_SP_RX_BUFFER_SIZE)
 
+enum rave_sp_frame_offset {
+	RAVE_SP_FRAME_CODE_OFFSET,
+	RAVE_SP_FRAME_ACK_ID_OFFSET,
+	RAVE_SP_FRAME_DATA_OFFSET,
+};
+
 /**
  * enum rave_sp_deframer_state - Possible state for de-framer
  *
@@ -352,7 +358,7 @@ int rave_sp_exec(struct rave_sp *sp,
 	int command, ret = 0;
 	u8 ackid;
 
-	command = sp->variant->cmd.translate(data[0]);
+	command = sp->variant->cmd.translate(data[RAVE_SP_FRAME_CODE_OFFSET]);
 	if (command < 0)
 		return command;
 
@@ -366,8 +372,8 @@ int rave_sp_exec(struct rave_sp *sp,
 	sp->reply = &reply;
 	mutex_unlock(&sp->reply_lock);
 
-	data[0] = command;
-	data[1] = ackid;
+	data[RAVE_SP_FRAME_CODE_OFFSET] = command;
+	data[RAVE_SP_FRAME_ACK_ID_OFFSET] = ackid;
 
 	rave_sp_write(sp, data, data_size);
 
@@ -388,16 +394,23 @@ EXPORT_SYMBOL_GPL(rave_sp_exec);
 static void rave_sp_receive_event(struct rave_sp *sp,
 				  const unsigned char *data, size_t length)
 {
-	u8 cmd[] = {
-		[0] = rave_sp_reply_code(data[0]),
-		[1] = data[1],
-	};
+	unsigned long action;
+	u8 cmd[RAVE_SP_FRAME_DATA_OFFSET];
+
+	if (length < RAVE_SP_FRAME_DATA_OFFSET + 1) {
+		dev_warn(&sp->serdev->dev, "Dropping short event frame\n");
+		return;
+	}
+
+	cmd[RAVE_SP_FRAME_CODE_OFFSET] =
+		rave_sp_reply_code(data[RAVE_SP_FRAME_CODE_OFFSET]);
+	cmd[RAVE_SP_FRAME_ACK_ID_OFFSET] = data[RAVE_SP_FRAME_ACK_ID_OFFSET];
 
 	rave_sp_write(sp, cmd, sizeof(cmd));
 
-	blocking_notifier_call_chain(&sp->event_notifier_list,
-				     rave_sp_action_pack(data[0], data[2]),
-				     NULL);
+	action = rave_sp_action_pack(data[RAVE_SP_FRAME_CODE_OFFSET],
+				     data[RAVE_SP_FRAME_DATA_OFFSET]);
+	blocking_notifier_call_chain(&sp->event_notifier_list, action, NULL);
 }
 
 static void rave_sp_receive_reply(struct rave_sp *sp,
@@ -405,27 +418,35 @@ static void rave_sp_receive_reply(struct rave_sp *sp,
 {
 	struct device *dev = &sp->serdev->dev;
 	struct rave_sp_reply *reply;
-	const  size_t payload_length = length - 2;
+	size_t payload_length;
+
+	if (length < RAVE_SP_FRAME_DATA_OFFSET) {
+		dev_warn(dev, "Dropping short reply frame\n");
+		return;
+	}
+	payload_length = length - RAVE_SP_FRAME_DATA_OFFSET;
 
 	mutex_lock(&sp->reply_lock);
 	reply = sp->reply;
 
 	if (reply) {
-		if (reply->code == data[0] && reply->ackid == data[1] &&
+		if (reply->code == data[RAVE_SP_FRAME_CODE_OFFSET] &&
+		    reply->ackid == data[RAVE_SP_FRAME_ACK_ID_OFFSET] &&
 		    payload_length >= reply->length) {
 			/*
 			 * We are relying on memcpy(dst, src, 0) to be a no-op
 			 * when handling commands that have a no-payload reply
 			 */
-			memcpy(reply->data, &data[2], reply->length);
+			memcpy(reply->data, &data[RAVE_SP_FRAME_DATA_OFFSET],
+			       reply->length);
 			complete(&reply->received);
 			sp->reply = NULL;
 		} else {
 			dev_err(dev, "Ignoring incorrect reply\n");
 			dev_dbg(dev, "Code:   expected = 0x%08x received = 0x%08x\n",
-				reply->code, data[0]);
+				reply->code, data[RAVE_SP_FRAME_CODE_OFFSET]);
 			dev_dbg(dev, "ACK ID: expected = 0x%08x received = 0x%08x\n",
-				reply->ackid, data[1]);
+				reply->ackid, data[RAVE_SP_FRAME_ACK_ID_OFFSET]);
 			dev_dbg(dev, "Length: expected = %zu received = %zu\n",
 				reply->length, payload_length);
 		}
@@ -439,10 +460,10 @@ static void rave_sp_receive_frame(struct rave_sp *sp,
 				  size_t length)
 {
 	const size_t checksum_length = sp->variant->checksum->length;
-	const size_t payload_length  = length - checksum_length;
-	const u8 *crc_reported       = &data[payload_length];
 	struct device *dev           = &sp->serdev->dev;
 	u8 crc_calculated[RAVE_SP_CHECKSUM_SIZE];
+	const u8 *crc_reported;
+	size_t payload_length;
 
 	if (unlikely(checksum_length > sizeof(crc_calculated))) {
 		dev_warn(dev, "Checksum too long, dropping\n");
@@ -457,6 +478,9 @@ static void rave_sp_receive_frame(struct rave_sp *sp,
 		return;
 	}
 
+	payload_length = length - checksum_length;
+	crc_reported = &data[payload_length];
+
 	sp->variant->checksum->subroutine(data, payload_length,
 					  crc_calculated);
 
@@ -465,10 +489,10 @@ static void rave_sp_receive_frame(struct rave_sp *sp,
 		return;
 	}
 
-	if (rave_sp_id_is_event(data[0]))
-		rave_sp_receive_event(sp, data, length);
+	if (rave_sp_id_is_event(data[RAVE_SP_FRAME_CODE_OFFSET]))
+		rave_sp_receive_event(sp, data, payload_length);
 	else
-		rave_sp_receive_reply(sp, data, length);
+		rave_sp_receive_reply(sp, data, payload_length);
 }
 
 static int rave_sp_receive_buf(struct serdev_device *serdev,
-- 
2.53.0



