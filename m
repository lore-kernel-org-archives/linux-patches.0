Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2E67E110;
	Tue, 29 Apr 2025 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946070; cv=none; b=c6cqJu41fSSPBv3yB9bGiyLPeXD056hYXMufkQnNtCV+gEbdAFL/vQt7fw7Fc/QNSqxgPC5a1TwwflRHNWlu9Du6jQ9OzX+rHqr/ZR2XPi9DhYLcKr7UPCAACcElXnNaGgRYd8WklTM7CT7OkOQzvPlEwbg6+J1o6QxPwuRID70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946070; c=relaxed/simple;
	bh=yMB5aH9jlERouRRhls6uDop36thiYR6QKd+NJGKCXtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8NufKnSFdM1Phr5syQ1CcLya49F3YhP6WOlY1zIC0wJYjJ27WHJEJUl91M97177BjNHT2VqO9rF6/xIFUXNJ18MMJBu1ODXyM2lz6K4N1hQnGjwfRFY47GhXDoifp8vD5mYasn1XFDs1HImVJfclh0AwKrIyZL58MQQgYfQ8Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgsDZo6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgsDZo6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED8EC4CEE3;
	Tue, 29 Apr 2025 17:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946069;
	bh=yMB5aH9jlERouRRhls6uDop36thiYR6QKd+NJGKCXtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgsDZo6FRda543DL4t/hZ4wZfRdC7hH4N7ty5SshUhi1+eWQ0AbFWLePkdRIKTV4g
	 1+mCA7F4N25H+/7Lq8iuYXmBBpmseLCqJKoqf6bdzR8L23+DOTcloE3BVxx8tN6sNX
	 0h44VOIn+qiyCWr5f+qUHfy6Cl7/vKz2ol1Z3B28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.14 144/311] mei: vsc: Fix fortify-panic caused by invalid counted_by() use
Date: Tue, 29 Apr 2025 18:39:41 +0200
Message-ID: <20250429161126.934725564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 00f1cc14da0f06d2897b8c528df7c7dcf1b8da50 upstream.

gcc 15 honors the __counted_by(len) attribute on vsc_tp_packet.buf[]
and the vsc-tp.c code is using this in a wrong way. len does not contain
the available size in the buffer, it contains the actual packet length
*without* the crc. So as soon as vsc_tp_xfer() tries to add the crc to
buf[] the fortify-panic handler gets triggered:

[   80.842193] memcpy: detected buffer overflow: 4 byte write of buffer size 0
[   80.842243] WARNING: CPU: 4 PID: 272 at lib/string_helpers.c:1032 __fortify_report+0x45/0x50
...
[   80.843175]  __fortify_panic+0x9/0xb
[   80.843186]  vsc_tp_xfer.cold+0x67/0x67 [mei_vsc_hw]
[   80.843210]  ? seqcount_lockdep_reader_access.constprop.0+0x82/0x90
[   80.843229]  ? lockdep_hardirqs_on+0x7c/0x110
[   80.843250]  mei_vsc_hw_start+0x98/0x120 [mei_vsc]
[   80.843270]  mei_reset+0x11d/0x420 [mei]

The easiest fix would be to just drop the counted-by but with the exception
of the ack buffer in vsc_tp_xfer_helper() which only contains enough room
for the packet-header, all other uses of vsc_tp_packet always use a buffer
of VSC_TP_MAX_XFER_SIZE bytes for the packet.

Instead of just dropping the counted-by, split the vsc_tp_packet struct
definition into a header and a full-packet definition and use a fixed
size buf[] in the packet definition, this way fortify-source buffer
overrun checking still works when enabled.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Cc: stable@kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20250318141203.94342-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/vsc-tp.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -36,20 +36,24 @@
 #define VSC_TP_XFER_TIMEOUT_BYTES		700
 #define VSC_TP_PACKET_PADDING_SIZE		1
 #define VSC_TP_PACKET_SIZE(pkt) \
-	(sizeof(struct vsc_tp_packet) + le16_to_cpu((pkt)->len) + VSC_TP_CRC_SIZE)
+	(sizeof(struct vsc_tp_packet_hdr) + le16_to_cpu((pkt)->hdr.len) + VSC_TP_CRC_SIZE)
 #define VSC_TP_MAX_PACKET_SIZE \
-	(sizeof(struct vsc_tp_packet) + VSC_TP_MAX_MSG_SIZE + VSC_TP_CRC_SIZE)
+	(sizeof(struct vsc_tp_packet_hdr) + VSC_TP_MAX_MSG_SIZE + VSC_TP_CRC_SIZE)
 #define VSC_TP_MAX_XFER_SIZE \
 	(VSC_TP_MAX_PACKET_SIZE + VSC_TP_XFER_TIMEOUT_BYTES)
 #define VSC_TP_NEXT_XFER_LEN(len, offset) \
-	(len + sizeof(struct vsc_tp_packet) + VSC_TP_CRC_SIZE - offset + VSC_TP_PACKET_PADDING_SIZE)
+	(len + sizeof(struct vsc_tp_packet_hdr) + VSC_TP_CRC_SIZE - offset + VSC_TP_PACKET_PADDING_SIZE)
 
-struct vsc_tp_packet {
+struct vsc_tp_packet_hdr {
 	__u8 sync;
 	__u8 cmd;
 	__le16 len;
 	__le32 seq;
-	__u8 buf[] __counted_by(len);
+};
+
+struct vsc_tp_packet {
+	struct vsc_tp_packet_hdr hdr;
+	__u8 buf[VSC_TP_MAX_XFER_SIZE - sizeof(struct vsc_tp_packet_hdr)];
 };
 
 struct vsc_tp {
@@ -158,12 +162,12 @@ static int vsc_tp_dev_xfer(struct vsc_tp
 static int vsc_tp_xfer_helper(struct vsc_tp *tp, struct vsc_tp_packet *pkt,
 			      void *ibuf, u16 ilen)
 {
-	int ret, offset = 0, cpy_len, src_len, dst_len = sizeof(struct vsc_tp_packet);
+	int ret, offset = 0, cpy_len, src_len, dst_len = sizeof(struct vsc_tp_packet_hdr);
 	int next_xfer_len = VSC_TP_PACKET_SIZE(pkt) + VSC_TP_XFER_TIMEOUT_BYTES;
 	u8 *src, *crc_src, *rx_buf = tp->rx_buf;
 	int count_down = VSC_TP_MAX_XFER_COUNT;
 	u32 recv_crc = 0, crc = ~0;
-	struct vsc_tp_packet ack;
+	struct vsc_tp_packet_hdr ack;
 	u8 *dst = (u8 *)&ack;
 	bool synced = false;
 
@@ -280,10 +284,10 @@ int vsc_tp_xfer(struct vsc_tp *tp, u8 cm
 
 	guard(mutex)(&tp->mutex);
 
-	pkt->sync = VSC_TP_PACKET_SYNC;
-	pkt->cmd = cmd;
-	pkt->len = cpu_to_le16(olen);
-	pkt->seq = cpu_to_le32(++tp->seq);
+	pkt->hdr.sync = VSC_TP_PACKET_SYNC;
+	pkt->hdr.cmd = cmd;
+	pkt->hdr.len = cpu_to_le16(olen);
+	pkt->hdr.seq = cpu_to_le32(++tp->seq);
 	memcpy(pkt->buf, obuf, olen);
 
 	crc = ~crc32(~0, (u8 *)pkt, sizeof(pkt) + olen);


