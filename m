Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA745187C2;
	Wed, 30 Sep 2026 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788051; cv=none; b=CRg2HBNPlkI/IDUApE/UzYtpfpvd0rNo/igmS5BlE3JsNVkn9pMdA0cVAcEp3ScXTdYmLHHNbNCEiMUQLDLbWhr6GwVnjUS2XnRG4OMJmjTr+DU1fRejiEM1s231WkQq7l6fDOr/D7APDkBq5aXeVjMobSb+gULQceW6XsNaf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788051; c=relaxed/simple;
	bh=WR0pXQYFiBaYaI8LpX/t6WD4R32U4T9EahIdimIYCwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naaig5UQNA0ZNf+tFWbV2ymNji3B0Lak85gKxL5QAGYZRiKoXVnhjTLtuAAP/Kv4fCAG2P8JgfMKwq2c91AFJokljKeY5rQorTU7Pu6iIWwiaC15VE51BE2437EmdanGz7gQsDnEXdRnM08uFQ/DSzJP8sVyRb3VlUK6/0v+le0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lw51wpDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lw51wpDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CF01F000FF;
	Wed, 30 Sep 2026 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788049;
	bh=Qbinzr+SR8xaB6E2FReZZJNrhhb2Qf+5tJ0B01wYRRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lw51wpDwJCtOwuz8xUeBjYw0tTeWIwtURqvMKE127TL2el9yqRk+GDgV8tsz0TTK/
	 NSgktJ2YAWfxkNRH98cFE6mGMy/uIM0EQAnffME+WpVG/jqbj4vsFHWVThCOAPXRNp
	 oX/BAKA8bmWOgo8kDnl5K7bmkBg5XCJVPmD28Ta0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 401/457] Bluetooth: hci_sock: validate event length before filtering
Date: Wed, 30 Sep 2026 17:28:26 +0200
Message-ID: <20260930152354.648344370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,6 +164,7 @@ static bool is_filtered_packet(struct so
 {
 	struct hci_filter *flt;
 	int flt_type, flt_event;
+	u8 event;
 
 	/* Apply filter */
 	flt = &hci_pi(sk)->filter;
@@ -177,7 +178,11 @@ static bool is_filtered_packet(struct so
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
@@ -186,11 +191,17 @@ static bool is_filtered_packet(struct so
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
 


