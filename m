Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BE844A41B;
	Fri,  7 Aug 2026 15:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117235; cv=none; b=TbszsHb3g6c2dfP9WHkpoYrkOPWePMHiLdeyxmLBuudbO7O6jViu7rvBllEfe7ZsmDvwbjBf6PgwSFVxUGe0CdjmLsArJvqJxPXGQo6pKdm4TCG0Yxuq8ED16I3VDOL00aZyHRelpVFYl23lG1+1wIM1UShDRHMs/w0Dt2nN/X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117235; c=relaxed/simple;
	bh=anvpFTXkNTG2x6YaRIoZaLtVCCKcuVv4BhsAD8RhuGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAxQHEipJLh8XY25XecY6psfwJafY8NkO47zX95/gOGsFEgbH1mc93M56mhAi7wLMYENii/pz+0xTGgQzMLHK8Rk/DehzAsv3NZYv6kt9lUbtTOY2RtOGusRe/6uqVN2ctaljgco7eQxMk1wULQzdZyCGocQqqaSA794Wft8W+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHMrnLUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHMrnLUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AB81F00A3A;
	Fri,  7 Aug 2026 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117233;
	bh=EGcRkRyVrt/I/2RdSavJNqgoZUw0KlH+3Mlxa44yjmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHMrnLUZ+NIxCOrtE8qE4EeMgmJsq1rKjxuuctG3fTXE62ePA6QfLQYpHGI+PF4tp
	 wgVg8AiV52Bq8RXZ5/LHqQmdBM8tzF7aP/xXgXJFxT2vsFUjobu5+UPBgIjS0TbV9B
	 7xS50U7nrnJ134SDeitt2XF7rpDgwIw2zRoIymbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 246/438] Bluetooth: HIDP: reject frames without a transaction header
Date: Fri,  7 Aug 2026 16:37:22 +0200
Message-ID: <20260807143433.243494691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sangho Lee <kudo3228@gmail.com>

commit 47778d2c2087b5d192398f6fddf692d16a5431cf upstream.

hidp_recv_ctrl_frame() and hidp_recv_intr_frame() read skb->data[0]
before checking that the L2CAP SDU contains a transaction header. A
connected HIDP peer can send an empty basic-mode SDU and make both paths
use an uninitialized byte from skb tailroom.

KMSAN reports the use in hidp_session_run(), with the uninitialized value
originating in __alloc_skb() through vhci_write(). The control path
produces two reports and the interrupt path produces one.

The byte can also be controlled by a malformed lower-layer packet. If an
HCI ACL packet contains an L2CAP PDU with a declared zero-length payload
followed by an extra 0x15 byte, l2cap_recv_acldata() reduces skb->len to
the declared PDU length before dispatch. The current HIDP path nevertheless
consumes the extra byte as HIDP_TRANS_HID_CONTROL |
HIDP_CTRL_VIRTUAL_CABLE_UNPLUG and terminates the HIDP session. With this
change, the same packet is discarded and a subsequent feature report
request succeeds.

Pull the transaction header with skb_pull_data() and discard frames that
do not contain it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sangho Lee <kudo3228@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hidp/core.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -563,16 +563,18 @@ static int hidp_process_data(struct hidp
 static void hidp_recv_ctrl_frame(struct hidp_session *session,
 					struct sk_buff *skb)
 {
-	unsigned char hdr, type, param;
+	unsigned char type, param;
+	u8 *hdr;
 	int free_skb = 1;
 
 	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
-	hdr = skb->data[0];
-	skb_pull(skb, 1);
+	hdr = skb_pull_data(skb, 1);
+	if (!hdr)
+		goto free;
 
-	type = hdr & HIDP_HEADER_TRANS_MASK;
-	param = hdr & HIDP_HEADER_PARAM_MASK;
+	type = *hdr & HIDP_HEADER_TRANS_MASK;
+	param = *hdr & HIDP_HEADER_PARAM_MASK;
 
 	switch (type) {
 	case HIDP_TRANS_HANDSHAKE:
@@ -593,6 +595,7 @@ static void hidp_recv_ctrl_frame(struct
 		break;
 	}
 
+free:
 	if (free_skb)
 		kfree_skb(skb);
 }
@@ -600,14 +603,15 @@ static void hidp_recv_ctrl_frame(struct
 static void hidp_recv_intr_frame(struct hidp_session *session,
 				struct sk_buff *skb)
 {
-	unsigned char hdr;
+	u8 *hdr;
 
 	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
-	hdr = skb->data[0];
-	skb_pull(skb, 1);
+	hdr = skb_pull_data(skb, 1);
+	if (!hdr)
+		goto free;
 
-	if (hdr == (HIDP_TRANS_DATA | HIDP_DATA_RTYPE_INPUT)) {
+	if (*hdr == (HIDP_TRANS_DATA | HIDP_DATA_RTYPE_INPUT)) {
 		hidp_set_timer(session);
 
 		if (session->input)
@@ -619,9 +623,10 @@ static void hidp_recv_intr_frame(struct
 			BT_DBG("report len %d", skb->len);
 		}
 	} else {
-		BT_DBG("Unsupported protocol header 0x%02x", hdr);
+		BT_DBG("Unsupported protocol header 0x%02x", *hdr);
 	}
 
+free:
 	kfree_skb(skb);
 }
 


