Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E02C1595;
	Sun,  7 Jun 2026 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828887; cv=none; b=jFvgkq0Yn2z3x/75qC9w6DDKWj13tfJrEJ521W0ZqYE3koQ19IiAaDIQa2AjwUKb7px8JN5lmBx1enrrCkoGoa/b/vtbcIqUIa3oax0OKCirbQJSnH1N6ejPX74REX137YAW8vpN0VjaFtFGiQm5dZWXNtOBr0BxNZZ7MFPJU9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828887; c=relaxed/simple;
	bh=e3qF5TNgq/8FwsWLTJDVFTg0S3QzrKqLoxouKvCLvjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/90bq0HOReuqz2uR64RmrMoTXEVB6r237OMsKlH/3GcMc9u75klwOig8wUTLVY2bJtAbmDKtBnJMuIr5Y5RTE1qSPmo7HnwP/zDSMvzvN905+IgvmUVXkqq0wQqtz8zrC153CNnnH4s7y66FOsBqplo4OD2cFIo8IcnaJepGMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jts7goZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jts7goZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561531F00893;
	Sun,  7 Jun 2026 10:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828885;
	bh=SKTARaohvO3beBSjEdFLP0jj7IHZh4ez3cIBT2rn9N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jts7goZ5UpNKQcWPDzldtuxmSWxt1Bx1aKZWvBpfGfY+j2BlzGh81qka6DVdAf22f
	 SUU6Nq1A4s2mhOP8JGYoozrIFJLixu68cH7SE//W50TYmcOooKjCDjvr0EPNWLHIpz
	 h8aGp3em5CP/YAg6QjvkzqCQPNoKKdp5o1rygg7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.18 199/315] nfc: hci: fix out-of-bounds read in HCP header parsing
Date: Sun,  7 Jun 2026 11:59:46 +0200
Message-ID: <20260607095734.880577528@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -439,6 +439,11 @@ void nci_hci_data_received_cb(void *cont
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
@@ -482,6 +487,11 @@ void nci_hci_data_received_cb(void *cont
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


