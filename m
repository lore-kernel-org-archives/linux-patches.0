Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6079E0;
	Sat, 30 Dec 2023 12:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLn98ofb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA4CC433C8;
	Sat, 30 Dec 2023 12:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937976;
	bh=Bk43Hkq/xQMTlsO3sW/brVJmuvoVrvrkGQbGedhlDU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLn98ofbGoNCU24+GjelK+CrhNPPSAP+IW2H/y4Q6SorcvvUSRP+yWYhpUBCBUGQm
	 FoXbP3J4AT3/jNR/6vn9Vv5Jh45U79D5Ia2/Fxk5HFE8m73M/m7uo6L9u+NxRwTFDY
	 Y6c3/2VZvXoemGYj+ODtYDpkcQPZWzrz7ESy/epI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 111/156] Bluetooth: L2CAP: Send reject on command corrupted request
Date: Sat, 30 Dec 2023 11:59:25 +0000
Message-ID: <20231230115815.996277895@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

commit 78b99eb1faa7371bf9c534690f26a71b6996622d upstream.

L2CAP/COS/CED/BI-02-C PTS test send a malformed L2CAP signaling packet
with 2 commands in it (a connection request and an unknown command) and
expect to get a connection response packet and a command reject packet.
The second is currently not sent.

Cc: stable@vger.kernel.org
Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6492,6 +6492,14 @@ drop:
 	kfree_skb(skb);
 }
 
+static inline void l2cap_sig_send_rej(struct l2cap_conn *conn, u16 ident)
+{
+	struct l2cap_cmd_rej_unk rej;
+
+	rej.reason = cpu_to_le16(L2CAP_REJ_NOT_UNDERSTOOD);
+	l2cap_send_cmd(conn, ident, L2CAP_COMMAND_REJ, sizeof(rej), &rej);
+}
+
 static inline void l2cap_sig_channel(struct l2cap_conn *conn,
 				     struct sk_buff *skb)
 {
@@ -6517,23 +6525,24 @@ static inline void l2cap_sig_channel(str
 
 		if (len > skb->len || !cmd->ident) {
 			BT_DBG("corrupted command");
+			l2cap_sig_send_rej(conn, cmd->ident);
 			break;
 		}
 
 		err = l2cap_bredr_sig_cmd(conn, cmd, len, skb->data);
 		if (err) {
-			struct l2cap_cmd_rej_unk rej;
-
 			BT_ERR("Wrong link type (%d)", err);
-
-			rej.reason = cpu_to_le16(L2CAP_REJ_NOT_UNDERSTOOD);
-			l2cap_send_cmd(conn, cmd->ident, L2CAP_COMMAND_REJ,
-				       sizeof(rej), &rej);
+			l2cap_sig_send_rej(conn, cmd->ident);
 		}
 
 		skb_pull(skb, len);
 	}
 
+	if (skb->len > 0) {
+		BT_DBG("corrupted command");
+		l2cap_sig_send_rej(conn, 0);
+	}
+
 drop:
 	kfree_skb(skb);
 }


