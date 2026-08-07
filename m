Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E6A27466A;
	Fri,  7 Aug 2026 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116089; cv=none; b=F06hUevu4epkVG+ub0f2O+I3a3teLlHHCQD+7kwcbe+s/49GgmlK+l6U1aF5ocIkH9Wc1v1vm4f2OVIXQK/Pwc+WcaGsuDk5Tfmx1C1/p+SHKk7ld2FnFaAoLSHci+CdhMOj3oUbjiKz+HPcegR2lnInTUDK/DAkYnTuDApA0CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116089; c=relaxed/simple;
	bh=POGMpIV4TKh7a+J474CfMOlHu2Iox4Hix5Ohw74I6Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVCEtB3ZWJ3KLZfAbnrFKFtZG3oULSTWYe3V3LOSSPiRR/Sel+c2AsIiz5hnKpF1/Vq+KzWYWCnsZC3xp3lbwa8hBIIOZ21dovZRm7AbZU4XQY6JBV6fcHv01ie/DRF0jdV+16ayXTdvOjs+Cb7fhRIc1foveF85Wi+IpyvH+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iV4kYf1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iV4kYf1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1EE1F000E9;
	Fri,  7 Aug 2026 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116087;
	bh=WRoo+cxut6MLZQF6cyCrzXDp+JNIs8IS7Npy2Hcy0f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iV4kYf1km/HtSmq/f3O+HGNkTKyq71DkybQwoh+rG44U5SZ1GK1Fu5Kr1lIKhS8/W
	 4ekuznznGFsP/1W/PLuAeiM9DiTj5HGTQmU8vR1ytCQLFTgYJ+bENRvHpuebUkFp5Q
	 ZfhZGFkZdGYLeVnq4sIPVGC0JnzXFxMEQfZwFL0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangho Lee <kudo3228@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 106/261] Bluetooth: HIDP: reject frames without a transaction header
Date: Fri,  7 Aug 2026 16:37:43 +0200
Message-ID: <20260807143417.666963171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
 


