Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604B82566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8549C433A0;
	Tue, 18 Apr 2023 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820659;
	bh=doowgFivflW0L+cXwPIZz4lx1IisSdGBiFOXO3tkNgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11TRj37TtjAdVz10aZqkBiSd6miSIOizgHncLpZzmrCfEbKP6aNd3CtfYXjxlKxx7
	 gZV0TyHB3WDYzjsYbC/+aRz7XpttK7IS8ivF/JpgWxmJSjicE1jzOukPzJxuGO96K8
	 TumgP2/tEfgjdpDfOXZE9DVPl10LhnMpBZwx5H4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Min Li <lm0963hack@gmail.com>
Subject: [PATCH 4.14 21/37] Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}
Date: Tue, 18 Apr 2023 14:21:31 +0200
Message-Id: <20230418120255.412004523@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit a2a9339e1c9deb7e1e079e12e27a0265aea8421a upstream.

Similar to commit d0be8347c623 ("Bluetooth: L2CAP: Fix use-after-free
caused by l2cap_chan_put"), just use l2cap_chan_hold_unless_zero to
prevent referencing a channel that is about to be destroyed.

Cc: stable@kernel.org
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4350,33 +4350,27 @@ static inline int l2cap_disconnect_req(s
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, dcid);
+	chan = l2cap_get_chan_by_scid(conn, dcid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	rsp.dcid = cpu_to_le16(chan->scid);
 	rsp.scid = cpu_to_le16(chan->dcid);
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_DISCONN_RSP, sizeof(rsp), &rsp);
 
 	chan->ops->set_shutdown(chan);
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, ECONNRESET);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 
@@ -4396,33 +4390,27 @@ static inline int l2cap_disconnect_rsp(s
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, scid);
+	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
 		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	if (chan->state != BT_DISCONN) {
 		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, 0);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 


