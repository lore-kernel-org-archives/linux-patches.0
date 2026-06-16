Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B4344BCBE;
	Tue, 16 Jun 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629543; cv=none; b=VGXQ1QA5gfw2/eN0hxEFzcKHnLKuQAeP+r01L4guVH+qngdOHQWRSA092PUEN3msTJYxodJaAa+2zQi2LzqTVej5emapDQL3SeSJiydRQlvHhDekKGvGTaTlrZK741AtUtbOH9rmzVcd/mX5WiAal3sw3Ge1qT8tixG0zImDcJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629543; c=relaxed/simple;
	bh=ZqqdC3zN4GqqzEyJm90zDOp9S+1CIoew9lqOSO3oV28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbsri8LNXMnV7pO5ccxLY46uUk2AojB7ri05eFHmQxmVui9z/aZ+9zQOfusjb6G/4DMQc+kfqKMXwTgYlXuMt+bSMGNVllLNmmCXdK4RVcsApKSZfLdj0O2seMvCAFTLKXwhQJEGAASyv5VvyfpL6/E+effzFPsIsLiBuvmlRHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lbJGptu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lbJGptu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196DF1F000E9;
	Tue, 16 Jun 2026 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629542;
	bh=bVTdkRei5xZt8JZh8TAsKwm5uZFiC5wgBMVzw+sboAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lbJGptumtOPd34KW7sPcHeRDg75aOi+TRKab4ROOjhcnw9JZ1pciZ2UZhK4iavNZ
	 3O81R3nfHZkk7tguGiDwpkzzQLHUGh2PBv0jQJ4y4IUGrcoUf8WSAThZvCe6fxDhlj
	 eftFy/5v1xomBVBmJIxcLZj9+WwAbs7NWHlIrFYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 293/452] Bluetooth: L2CAP: reject BR/EDR signaling packets over MTUsig
Date: Tue, 16 Jun 2026 20:28:40 +0530
Message-ID: <20260616145132.939849042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit dd214733544427587a95f66dbf3adff072568990 upstream.

net/bluetooth/l2cap_core.c:l2cap_sig_channel() accepts BR/EDR
signaling packets up to the channel MTU and dispatches each command
without enforcing the signaling MTU (MTUsig). A Bluetooth BR/EDR peer
within radio range can send a fixed-channel CID 0x0001 packet that is
larger than MTUsig and contains many L2CAP_ECHO_REQ commands before
pairing. In a real-radio stock-kernel run, one 681-byte signaling
packet containing 168 zero-length ECHO_REQ commands made the target
transmit 168 ECHO_RSP frames over about 220 ms.

Impact: a Bluetooth BR/EDR peer within radio range, before pairing, can
force 168 ECHO_RSP frames from one 681-byte fixed-channel signaling
packet containing packed ECHO_REQ commands.

Define Linux's BR/EDR signaling MTU as the spec minimum of 48 bytes and
reject any larger signaling packet with one L2CAP_COMMAND_REJECT_RSP
carrying L2CAP_REJ_MTU_EXCEEDED before any command is dispatched.

The Bluetooth Core spec wording for MTUExceeded says the reject
identifier shall match the first request command in the packet, and
that packets containing only responses shall be silently discarded.
Linux intentionally deviates from that prescription: silently
discarding desynchronizes the peer because the remote stack never
learns its responses were dropped, and locating the first request
command requires walking command headers past MTUsig, i.e. processing
bytes from a packet we have already decided is too large to process.
We therefore always emit one reject and use the identifier from the
first command header, a single fixed-offset byte read.

The unrestricted BR/EDR signaling parser and ECHO_REQ response path both
trace to the initial git import; no later introducing commit is
available for a Fixes tag.

Cc: stable@vger.kernel.org
Suggested-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Link: https://lore.kernel.org/r/20260518002800.1361430-1-michael.bommarito@gmail.com
Link: https://lore.kernel.org/r/20260520135034.1060859-1-michael.bommarito@gmail.com
Link: https://lore.kernel.org/r/20260521000555.3712030-1-michael.bommarito@gmail.com
Assisted-by: Claude:claude-opus-4-7
Assisted-by: Codex:gpt-5-5-xhigh
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/l2cap.h |    1 
 net/bluetooth/l2cap_core.c    |   46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -33,6 +33,7 @@
 /* L2CAP defaults */
 #define L2CAP_DEFAULT_MTU		672
 #define L2CAP_DEFAULT_MIN_MTU		48
+#define L2CAP_SIG_MTU			48	/* BR/EDR signaling MTU */
 #define L2CAP_DEFAULT_FLUSH_TO		0xFFFF
 #define L2CAP_EFS_DEFAULT_FLUSH_TO	0xFFFFFFFF
 #define L2CAP_DEFAULT_TX_WINDOW		63
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5576,6 +5576,15 @@ static inline void l2cap_sig_send_rej(st
 	l2cap_send_cmd(conn, ident, L2CAP_COMMAND_REJ, sizeof(rej), &rej);
 }
 
+static inline void l2cap_sig_send_mtu_rej(struct l2cap_conn *conn, u8 ident)
+{
+	struct l2cap_cmd_rej_mtu rej;
+
+	rej.reason = cpu_to_le16(L2CAP_REJ_MTU_EXCEEDED);
+	rej.max_mtu = cpu_to_le16(L2CAP_SIG_MTU);
+	l2cap_send_cmd(conn, ident, L2CAP_COMMAND_REJ, sizeof(rej), &rej);
+}
+
 static inline void l2cap_sig_channel(struct l2cap_conn *conn,
 				     struct sk_buff *skb)
 {
@@ -5588,6 +5597,43 @@ static inline void l2cap_sig_channel(str
 	if (hcon->type != ACL_LINK)
 		goto drop;
 
+	/*
+	 * Bluetooth Core v5.4, Vol 3, Part A, Section 4: the BR/EDR
+	 * signaling channel has a fixed signaling MTU (MTUsig) whose
+	 * minimum and default is 48 octets.  Section 4.1 says that on
+	 * an MTUExceeded command reject the identifier "shall match
+	 * the first request command in the L2CAP packet" and that
+	 * packets containing only response commands "shall be
+	 * silently discarded".
+	 *
+	 * Linux intentionally deviates from that prescription:
+	 *
+	 *   1. Silently discarding desynchronizes the peer.  The
+	 *      remote stack never learns its responses were dropped,
+	 *      so any state machine waiting on a paired response
+	 *      stalls until its own timer fires.
+	 *
+	 *   2. Locating "the first request command" requires walking
+	 *      command headers past MTUsig, i.e. processing bytes
+	 *      from a packet we have already decided is too large to
+	 *      process.
+	 *
+	 * Reject every over-MTUsig signaling packet with one
+	 * L2CAP_REJ_MTU_EXCEEDED command reject.  The reject's
+	 * reason field is what tells the peer that the whole packet
+	 * was discarded; the identifier value is informational, so
+	 * we use the identifier from the first command header, a
+	 * single fixed-offset byte read.
+	 */
+	if (skb->len > L2CAP_SIG_MTU) {
+		u8 ident = skb->data[1];
+
+		BT_DBG("signaling packet exceeds MTU: %u > %u",
+		       skb->len, L2CAP_SIG_MTU);
+		l2cap_sig_send_mtu_rej(conn, ident);
+		goto drop;
+	}
+
 	while (skb->len >= L2CAP_CMD_HDR_SIZE) {
 		u16 len;
 


