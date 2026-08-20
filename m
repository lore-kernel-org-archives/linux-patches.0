Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FB825C6EE;
	Thu, 20 Aug 2026 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244501; cv=none; b=cX3N3ztyvhDevawtRbZZ1Rag8q/KOaHe7EPcAcjYDB7s64koIeqTRlnbYip5gR/wNkQ85YpUAPwlP9CXa2rDYounSlSppFIR+FcLosI5z6qS+gsUBKOlzM9xHCROSb035B0EG4slnObR2C/to9jkWkNNZ5d7LnVfUoWbJSLvnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244501; c=relaxed/simple;
	bh=wLmK2o2SvxdcGRksPVitFMivS7ZbtukqQaIDNs/EdeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBzrRwXnNuLOXMSobc98Bn73ML3C/yi5tauavtht0ro8whJX44Oqw+tCgQK3aHghjGlVoEOHK6gysGg/azf0XAJzjmzWhf2AITCqijw4Rn8RiWNMzOQTW1f+zJGlAcrWA3dZm59AXFc/9J6pSg7C9Z1bHdyZCrJaVqCZuuTLfDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZigqSVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZigqSVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254391F000E9;
	Thu, 20 Aug 2026 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244499;
	bh=5DBBuOg2cD4pv/16sHwy80fefceSELYP+Ymi94+aU+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZigqSVaoe9F36bsNuSjvKmrpFktOrBDouAX4qwQAGbfK3WrRh7wqcMoLvKVQzr+c
	 0WEZ/WxQgOd0cI1Itgo0MFLKOqHykwFJJjoCf47e4PvnGR/azuzTd9rNHNkj3ZnvWY
	 g6ri1hLshT7rR8Vi6uZwPCVLdSl7mGCNw0B8ANaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/235] Bluetooth: HIDP: reject frames without a transaction header
Date: Thu, 20 Aug 2026 16:57:07 +0200
Message-ID: <20260820145222.333261427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sangho Lee <kudo3228@gmail.com>

[ Upstream commit 47778d2c2087b5d192398f6fddf692d16a5431cf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hidp/core.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -551,16 +551,18 @@ static int hidp_process_data(struct hidp
 static void hidp_recv_ctrl_frame(struct hidp_session *session,
 					struct sk_buff *skb)
 {
-	unsigned char hdr, type, param;
+	unsigned char type, param;
+	u8 *hdr;
 	int free_skb = 1;
 
 	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
 
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
@@ -581,6 +583,7 @@ static void hidp_recv_ctrl_frame(struct
 		break;
 	}
 
+free:
 	if (free_skb)
 		kfree_skb(skb);
 }
@@ -588,14 +591,15 @@ static void hidp_recv_ctrl_frame(struct
 static void hidp_recv_intr_frame(struct hidp_session *session,
 				struct sk_buff *skb)
 {
-	unsigned char hdr;
+	u8 *hdr;
 
 	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
 
-	hdr = skb->data[0];
-	skb_pull(skb, 1);
+	hdr = skb_pull_data(skb, 1);
+	if (!hdr)
+		goto free;
 
-	if (hdr == (HIDP_TRANS_DATA | HIDP_DATA_RTYPE_INPUT)) {
+	if (*hdr == (HIDP_TRANS_DATA | HIDP_DATA_RTYPE_INPUT)) {
 		hidp_set_timer(session);
 
 		if (session->input)
@@ -607,9 +611,10 @@ static void hidp_recv_intr_frame(struct
 			BT_DBG("report len %d", skb->len);
 		}
 	} else {
-		BT_DBG("Unsupported protocol header 0x%02x", hdr);
+		BT_DBG("Unsupported protocol header 0x%02x", *hdr);
 	}
 
+free:
 	kfree_skb(skb);
 }
 


