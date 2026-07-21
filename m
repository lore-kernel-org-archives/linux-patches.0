Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22241392C29;
	Tue, 21 Jul 2026 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658215; cv=none; b=XT8yK/d/fVrmdtMN5TI3jzhx4Kz/+eMgNt0GiGaWHPXcNt+nJEcwD8tgyOni1fWGEES/0PNnli+c0BpCJUMiZQ2xNyUmp1zlyoPY0KMZxFIYxY8SGnn9roAdGK8dpg/lAJhs90iPiy8JveG6psfdob2SKijXRsPFCS14V6S19ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658215; c=relaxed/simple;
	bh=PkQIyTpezkqtjZ4ZUXDi78WbcAkt3YrIYb+o4WzC5g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD9Qh5cNaZzVuKEXXnCVogjBYzxVnaEWnVrmZ/b3+C+BKbyTHhD7gnNhPMhEyj9kDDKqT5BfOxWzqqEcNr//GsRQ6lRE6kTzdBLMoLXYlK3EPBQ0a5XGOhVTbRs6JbMxpdyR+ofk637t1rsZjMQ6j+xIv+AqcCCF/FMgr0G4EvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoCayTTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoCayTTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C2D1F000E9;
	Tue, 21 Jul 2026 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658214;
	bh=CZmiL+XK7BYYsahV+zburvCCnjLnkpS6WmzR5mx/lh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoCayTTBu/ikQnasSct7wYzyuR93jxJ1gmYcRLsoGjS+Wy+VYBhnuMsur1LgPvzzp
	 cry4jk8Ucmn+nGDM7EfpUVhWylTISNq14hfvublbCuZK4FXTuKJA+/fR+kgV8rS/TP
	 7SRkV4pmih+ot49AK/ZJHUA/vhnM4C/jU/DFTtn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stig Hornang <stig@hornang.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1058/1611] Bluetooth: L2CAP: fix tx ident leak for commands without a response
Date: Tue, 21 Jul 2026 17:19:34 +0200
Message-ID: <20260721152539.204577656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Stig Hornang <stig@hornang.me>

[ Upstream commit 6e1930ece855a4c256f1c7e6632d634cfb9888b5 ]

Commit 6c3ea155e5ee ("Bluetooth: L2CAP: Fix not tracking outstanding
TX ident") changed ident allocation to use an IDA, releasing idents in
l2cap_put_ident() when the matching response command is received.

But identifiers allocated for commands that have no response defined
are never released. In particular L2CAP_LE_CREDITS is sent repeatedly for
the lifetime of an LE CoC channel, so a peer streaming data to the
host exhausts the 1-255 ident range after 254 credit packets. From
then on l2cap_get_ident() fails:

    kernel: Bluetooth: Unable to allocate ident: -28

and every subsequent L2CAP_LE_CREDITS packet is sent with ident 0,
which is invalid (Core Spec, Vol 3, Part A, Section 4: "Signaling
identifier 0x00 is an invalid identifier and shall never be used in
any command"). Remote stacks that validate the ident drop these
commands, never receive new credits, and the channel stalls
permanently. With default socket buffers this happens after roughly 0.5 MB
of received data (the exact amount depends on the socket receive buffer):

  < ACL Data TX: Handle 2048 flags 0x00 dlen 12
        LE L2CAP: LE Flow Control Credit (0x16) ident 0 len 4
          Source CID: 64
          Credits: 1

Release the ident immediately after sending L2CAP_LE_CREDITS since no
response will ever release it. Use a local variable instead of
chan->ident so that an ident that an EXT_FLOWCTL channel may be waiting on
(e.g. a pending reconfigure) is not overwritten by a credit packet.

Also add the missing L2CAP_LE_CONN_RSP case to l2cap_put_ident() so
idents allocated for outgoing L2CAP_LE_CONN_REQ commands are released
when the response arrives.

Fixes: 6c3ea155e5ee ("Bluetooth: L2CAP: Fix not tracking outstanding TX ident")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221629
Assisted-by: Claude:claude-opus-4.8
Assisted-by: Fable:5
Signed-off-by: Stig Hornang <stig@hornang.me>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0b4e84f02c2d89..0289d418ac70ad 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4832,6 +4832,7 @@ static void l2cap_put_ident(struct l2cap_conn *conn, u8 code, u8 id)
 	case L2CAP_ECHO_RSP:
 	case L2CAP_INFO_RSP:
 	case L2CAP_CONN_PARAM_UPDATE_RSP:
+	case L2CAP_LE_CONN_RSP:
 	case L2CAP_ECRED_CONN_RSP:
 	case L2CAP_ECRED_RECONF_RSP:
 		/* First do a lookup since the remote may send bogus ids that
@@ -6729,6 +6730,7 @@ static void l2cap_chan_le_send_credits(struct l2cap_chan *chan)
 	struct l2cap_conn *conn = chan->conn;
 	struct l2cap_le_credits pkt;
 	u16 return_credits = l2cap_le_rx_credits(chan);
+	int ident;
 
 	if (chan->mode != L2CAP_MODE_LE_FLOWCTL &&
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL)
@@ -6746,9 +6748,18 @@ static void l2cap_chan_le_send_credits(struct l2cap_chan *chan)
 	pkt.cid     = cpu_to_le16(chan->scid);
 	pkt.credits = cpu_to_le16(return_credits);
 
-	chan->ident = l2cap_get_ident(conn);
+	ident = l2cap_get_ident(conn);
 
-	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CREDITS, sizeof(pkt), &pkt);
+	l2cap_send_cmd(conn, ident, L2CAP_LE_CREDITS, sizeof(pkt), &pkt);
+
+	/* L2CAP_LE_CREDITS has no response so the ident is never released by
+	 * l2cap_put_ident() - release it right away, otherwise the tx_ida
+	 * range is exhausted after 254 packets and from then on credits are
+	 * sent with the invalid ident 0, which some remote stacks ignore,
+	 * stalling the channel.
+	 */
+	if (ident > 0)
+		ida_free(&conn->tx_ida, ident);
 }
 
 void l2cap_chan_rx_avail(struct l2cap_chan *chan, ssize_t rx_avail)
-- 
2.53.0



