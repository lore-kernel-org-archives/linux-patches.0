Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350D4657F8;
	Tue, 16 Jun 2026 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630970; cv=none; b=pcB8/uL5Zjyn6nO7iqPZJj5TSin2sU38n/GQ9MZLpuvlPUQzRyonxX3OqY01yUmNrunlA9QAAJNSDkEjq0yOJNs1JKjNY5IJaXIzNJK7vYOCb9x6M6K1BkFuEcMaSOt+6xCZ1BgNx8VrEN1byfdrE4PJ+mQIOQEye+Ef2rX7Um8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630970; c=relaxed/simple;
	bh=uyNrQXdN6B00EApAajn8e0dnERtlOHEzWo2L6072tNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD9yVk7tGSCEzMAUS62uCfxlkBlRMsLIfKn/HCAXEmj70sFNf492LomzYyhPTBW9XQxnYGBeSofnxqGgLJxPUxiRU8WKdmsFgYzFnsAwx8RYR1mBmOBISDXfsR/pdPWUyTNlGInf629wx/fB+2fFIAi1lNfADK26MSuHneORAAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBMFiD8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBMFiD8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749621F000E9;
	Tue, 16 Jun 2026 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630969;
	bh=FUeP3s13XplMMpr0evy1HqdZX7352MVaOvwVoWW3Lx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBMFiD8BTrb2k55bta8Yx1ecVHuNmX9Xl6IgFyhWezhWFGRx5CCk2rT1h6NGW+6c5
	 7QRNN9i0+h+A12gHjufloHSXHGDa8fgVc3GW0atRDdXEa8yOd7iNsJVqKfOpYucdeJ
	 gEl5vYdfFkS0ZUFpP8s9fEWlsZVd16E/KpI+/3v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.1 130/522] nfc: hci: fix out-of-bounds read in HCP header parsing
Date: Tue, 16 Jun 2026 20:24:37 +0530
Message-ID: <20260616145132.184495988@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit f040e590c035bfd9553fe79ee9585caf1b14d67b upstream.

Both nfc_hci_recv_from_llc() and nci_hci_data_received_cb() read
packet->header from skb->data at function entry without first checking
that the buffer holds at least one byte. A malicious NFC peer can send
a 0-byte HCP frame that passes through the SHDLC layer and reaches
these functions, causing an out-of-bounds heap read of packet->header.
The same 0-byte frame, if queued as a non-final fragment, also causes
the reassembly loop to underflow msg_len to UINT_MAX, triggering
skb_over_panic() when the reassembled skb is written.

Fix this by adding a pskb_may_pull() check at the entry of each
function before packet->header is first accessed. The existing
pskb_may_pull() checks before the reassembled hcp_skb is cast to
struct hcp_packet remain in place to guard the 2-byte HCP message
header.

Fixes: 8b8d2e08bf0d ("NFC: HCI support")
Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Link: https://patch.msgid.link/20260505170712.96560-1-ashutoshdesai993@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/hci/core.c |   10 ++++++++++
 net/nfc/nci/hci.c  |   10 ++++++++++
 2 files changed, 20 insertions(+)

--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -861,6 +861,11 @@ static void nfc_hci_recv_from_llc(struct
 	struct sk_buff *frag_skb;
 	int msg_len;
 
+	if (!pskb_may_pull(skb, NFC_HCI_HCP_PACKET_HEADER_LEN)) {
+		kfree_skb(skb);
+		return;
+	}
+
 	packet = (struct hcp_packet *)skb->data;
 	if ((packet->header & ~NFC_HCI_FRAGMENT) == 0) {
 		skb_queue_tail(&hdev->rx_hcp_frags, skb);
@@ -904,6 +909,11 @@ static void nfc_hci_recv_from_llc(struct
 	 * unblock waiting cmd context. Otherwise, enqueue to dispatch
 	 * in separate context where handler can also execute command.
 	 */
+	if (!pskb_may_pull(hcp_skb, NFC_HCI_HCP_HEADER_LEN)) {
+		kfree_skb(hcp_skb);
+		return;
+	}
+
 	packet = (struct hcp_packet *)hcp_skb->data;
 	type = HCP_MSG_GET_TYPE(packet->message.header);
 	if (type == NFC_HCI_HCP_RESPONSE) {
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -437,6 +437,11 @@ void nci_hci_data_received_cb(void *cont
 		return;
 	}
 
+	if (!pskb_may_pull(skb, NCI_HCI_HCP_PACKET_HEADER_LEN)) {
+		kfree_skb(skb);
+		return;
+	}
+
 	packet = (struct nci_hcp_packet *)skb->data;
 	if ((packet->header & ~NCI_HCI_FRAGMENT) == 0) {
 		skb_queue_tail(&ndev->hci_dev->rx_hcp_frags, skb);
@@ -480,6 +485,11 @@ void nci_hci_data_received_cb(void *cont
 	 * unblock waiting cmd context. Otherwise, enqueue to dispatch
 	 * in separate context where handler can also execute command.
 	 */
+	if (!pskb_may_pull(hcp_skb, NCI_HCI_HCP_HEADER_LEN)) {
+		kfree_skb(hcp_skb);
+		return;
+	}
+
 	packet = (struct nci_hcp_packet *)hcp_skb->data;
 	type = NCI_HCP_MSG_GET_TYPE(packet->message.header);
 	if (type == NCI_HCI_HCP_RESPONSE) {


