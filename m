Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2581C51588D;
	Wed, 30 Sep 2026 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793757; cv=none; b=fnamjtfpvVtiNOCVur+L0ClMZY6h2wI08dgPuWm3cioieGCAYvG59uA9egKCsLXI/iHQwEsMQfqBgfbw8aAR80yVEg0uRxwmcMUOKGTIF3L2hOIdXvkQvyjA/bsvwWju73wujthWymzSEOIJ6l8n0bcGDGy1AnldblvCXOmECiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793757; c=relaxed/simple;
	bh=QsVnZ/nfhpdYUmONjgv6aqyfgKRK+n3ZGO6hkv540ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DICgFFWhj5bbMVHNJMumhhaa4UKKyQJDX/JaCKnPJlrT+XH2/fO5dYN6eeLzRjN3znKNchpuxkHX0on5yTlDuWNg54AMGbOy277WYQ1a3fXDhHJF3Lirm4+P5wbOMxD33txMJzt/dCaX9Hp/3IDctgee5Gu2J+Mm1GpXYFY0x5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQXSczDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQXSczDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FBB1F000FF;
	Wed, 30 Sep 2026 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793756;
	bh=AtTg1s3HY5N/Iiz8qxslzU4LIWHM+FxRkcryINce3Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQXSczDOMaDsptHd9fGUWc4WXXBqAkqeiCCDwH6sJyesSc1MfHL9skbgZJ6/0t5QG
	 5XKPhk4P3jgcVJmPF0oGsEqhrTC3/OSeeUdIXl+CMIDPWJY88VTUrnkf2u6+v/Gktb
	 q3JGEmIXiXJr1CbAomtokosLehsfW/tFPR5aWeM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 322/395] Bluetooth: hci_sock: validate event length before filtering
Date: Wed, 30 Sep 2026 17:29:44 +0200
Message-ID: <20260930152347.644866667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit b0a6cf99afd57a39598b1beca0e86ef5004980de upstream.

is_filtered_packet() reads the event code from skb->data[0] without first
checking that the skb is nonempty. When an opcode filter is configured,
it also reads the command opcode at offsets 3 or 4 without checking that
a Command Complete or Command Status event is long enough.

hci_send_to_sock() invokes the filter before hci_event_packet() validates
the event header. A malformed event supplied by a controller or a vhci
device can therefore cause an out-of-bounds read.

Keep the unmasked event code for the opcode checks. The masked value is
needed for the 64-bit event bitmap, but using it to identify command events
aliases event codes above 0x3f. In particular, Synchronous Train Complete
(0x4f) was treated as Command Status (0x0f) even though its payload has no
opcode.

Reject actual command events that are too short for the field being
inspected. A truncated command event cannot match a configured opcode.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -166,6 +166,7 @@ static bool is_filtered_packet(struct so
 {
 	struct hci_filter *flt;
 	int flt_type, flt_event;
+	u8 event;
 
 	/* Apply filter */
 	flt = &hci_pi(sk)->filter;
@@ -179,7 +180,11 @@ static bool is_filtered_packet(struct so
 	if (hci_skb_pkt_type(skb) != HCI_EVENT_PKT)
 		return false;
 
-	flt_event = (*(__u8 *)skb->data & HCI_FLT_EVENT_BITS);
+	if (skb->len < 1)
+		return true;
+
+	event = *(__u8 *)skb->data;
+	flt_event = event & HCI_FLT_EVENT_BITS;
 
 	if (!hci_test_bit(flt_event, &flt->event_mask))
 		return true;
@@ -188,11 +193,17 @@ static bool is_filtered_packet(struct so
 	if (!flt->opcode)
 		return false;
 
-	if (flt_event == HCI_EV_CMD_COMPLETE &&
+	if (event == HCI_EV_CMD_COMPLETE && skb->len < 5)
+		return true;
+
+	if (event == HCI_EV_CMD_COMPLETE &&
 	    flt->opcode != get_unaligned((__le16 *)(skb->data + 3)))
 		return true;
 
-	if (flt_event == HCI_EV_CMD_STATUS &&
+	if (event == HCI_EV_CMD_STATUS && skb->len < 6)
+		return true;
+
+	if (event == HCI_EV_CMD_STATUS &&
 	    flt->opcode != get_unaligned((__le16 *)(skb->data + 4)))
 		return true;
 


