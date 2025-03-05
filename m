Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1C425290D;
	Wed,  5 Mar 2025 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198527; cv=none; b=Q5KFnabNd0ATEnpAcVzNrnN+Q8PBe9bDKy2oWx7Mwd4M4J9X/5lvq7ps9lKqWfrKSBL612vBGIBvWIOyw4qj+gXzZGfwObvP9G9mrJKZeo4JjJ0P4Svz3OHR+nC+jeJEW0BsTQaCPo7km5IyNgs0/UwwGDlmx8hgNIRkqQyZFSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198527; c=relaxed/simple;
	bh=0jc6SXYPa2xl2RyTLhUyakL9N7sbHMXiwCYY8lPLDM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1vsa0EbApQFU2/U15Rfm1bXjUtqk0kDtultxT/djkYHoIJ43zIG2VFFOsXUVVg1efTY7oMDqGvSAQKUIEw0iXs56W+LsJOgTw7rCpzvnCjepHoUwQm85qnZf0t4Bpgk8ZJ5RFPvlcF5G/v1vkkVqr3UGHg1DIHscVoCTp6imYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzzzXLlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzzzXLlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086CEC4CED1;
	Wed,  5 Mar 2025 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198527;
	bh=0jc6SXYPa2xl2RyTLhUyakL9N7sbHMXiwCYY8lPLDM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzzzXLlkPXpl1jB4oJmHZ4h66drHYmXAz572i4JOGpzoYWyYspxSr96OeswTuFZVV
	 wkUkKjQWLF0LXWGSvSNRKU8rLxdI368yuysoKKRP84qz6EzJiNIl/AuCK03Ii8BtiA
	 g5KKGQsECW/e10Nh6kgZgyR3xwDtpcEEor4JNGrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 026/157] Bluetooth: L2CAP: Fix L2CAP_ECRED_CONN_RSP response
Date: Wed,  5 Mar 2025 18:47:42 +0100
Message-ID: <20250305174506.346672912@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b25120e1d5f2ebb3db00af557709041f47f7f3d0 ]

L2CAP_ECRED_CONN_RSP needs to respond DCID in the same order received as
SCID but the order is reversed due to use of list_add which actually
prepend channels to the list so the response is reversed:

> ACL Data RX: Handle 16 flags 0x02 dlen 26
      LE L2CAP: Enhanced Credit Connection Request (0x17) ident 2 len 18
        PSM: 39 (0x0027)
        MTU: 256
        MPS: 251
        Credits: 65535
        Source CID: 116
        Source CID: 117
        Source CID: 118
        Source CID: 119
        Source CID: 120
< ACL Data TX: Handle 16 flags 0x00 dlen 26
      LE L2CAP: Enhanced Credit Connection Response (0x18) ident 2 len 18
        MTU: 517
        MPS: 247
        Credits: 3
        Result: Connection successful (0x0000)
        Destination CID: 68
        Destination CID: 67
        Destination CID: 66
        Destination CID: 65
        Destination CID: 64

Also make sure the response don't include channels that are not on
BT_CONNECT2 since the chan->ident can be set to the same value as in the
following trace:

< ACL Data TX: Handle 16 flags 0x00 dlen 12
      LE L2CAP: LE Flow Control Credit (0x16) ident 6 len 4
        Source CID: 64
        Credits: 1
...
> ACL Data RX: Handle 16 flags 0x02 dlen 18
      LE L2CAP: Enhanced Credit Connection Request (0x17) ident 6 len 10
        PSM: 39 (0x0027)
        MTU: 517
        MPS: 251
        Credits: 255
        Source CID: 70
< ACL Data TX: Handle 16 flags 0x00 dlen 20
      LE L2CAP: Enhanced Credit Connection Response (0x18) ident 6 len 12
        MTU: 517
        MPS: 247
        Credits: 3
        Result: Connection successful (0x0000)
        Destination CID: 64
        Destination CID: 68

Closes: https://github.com/bluez/bluez/issues/1094
Fixes: 9aa9d9473f15 ("Bluetooth: L2CAP: Fix responding with wrong PDU type")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 27b4c4a2ba1fd..728a5ce9b5058 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -636,7 +636,8 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 	    test_bit(FLAG_HOLD_HCI_CONN, &chan->flags))
 		hci_conn_hold(conn->hcon);
 
-	list_add(&chan->list, &conn->chan_l);
+	/* Append to the list since the order matters for ECRED */
+	list_add_tail(&chan->list, &conn->chan_l);
 }
 
 void l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
@@ -3776,7 +3777,11 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	struct l2cap_ecred_conn_rsp *rsp_flex =
 		container_of(&rsp->pdu.rsp, struct l2cap_ecred_conn_rsp, hdr);
 
-	if (test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+	/* Check if channel for outgoing connection or if it wasn't deferred
+	 * since in those cases it must be skipped.
+	 */
+	if (test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags) ||
+	    !test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
 		return;
 
 	/* Reset ident so only one response is sent */
-- 
2.39.5



