Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C231F993;
	Sun,  7 Jun 2026 10:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827796; cv=none; b=g73X7z2fQLgMUUSJvRaRdMK/xC7RAhhD8nXCsna+e+riDji9n8BdCWpb78uw/rqnhTTp/g0y6PacFiYifCE4auf+wwjThjOZ7NxUXYF1qFBfqQQQGeZSObRyaaSmvLzDo6q5tPqLbOzhV7OwRY74aRxVrd4VRM3RgXErbegYcpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827796; c=relaxed/simple;
	bh=73vPq6iq4Re5e0PHOnV39sg6Tv0c1hBcHr9qL+X+sDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nblim6AT2XaCVDD+hb5pr2A2vLlF3uzp1qrM94am6hHCNSM7G1vL9IBj05e9cMPW9xBXVmSW3k6UfXhjTpgbBQSroouuH+YF774PRv67NhvuAhUhyy7KYj8LsKbuP7E/hzBvKah3UrORETIIHlLx+Sk2NUVP24Vp1fRmo72VmDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfDG9oAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfDG9oAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FA81F00893;
	Sun,  7 Jun 2026 10:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827795;
	bh=36HI4xnjwaYmu/kv6PuJLymjRwNce2RD3a60gYyxHwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfDG9oAqqkcOWPlwoqbfOhIBXomwd8l2La0dAy8c6IBzZWiBRJHW4DRpvMnf5XRTV
	 Uxg0Ms/aggo13CfsMWjCvcrla3WVrDHiOTpdfio30r+FtohnWEiNUyFkG+CZry+B5Y
	 4udm2j0vFLqYBM5KhdLtTlFGfBhznte65zwLNIr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/307] Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp
Date: Sun,  7 Jun 2026 11:58:04 +0200
Message-ID: <20260607095730.969886994@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
Message-ID: <20260607095804.z46o18KVs1io3063sw7bMmc7fm5p33heGe2-I19Z2Rc@z>

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 41c2713b204e6cb6a94587bc6bf6935107df5479 ]

If dcid is received for an already-assigned destination CID the spec
requires that both channels to be discarded, but calling l2cap_chan_del
may invalidate the tmp cursor created by list_for_each_entry_safe and
in fact it is the wrong procedure as the chan->dcid may be assigned
previously it really needs to be disconnected.

Calling l2cap_chan_clone directly may still lead to l2cap_chan_del so
instead schedule l2cap_chan_timeout with delay 0 to close the channel
asynchronously.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9de5d545966d60..f0b0f347ebc10a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5194,6 +5194,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	cmd_len -= sizeof(*rsp);
 
 	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
+		struct l2cap_chan *orig;
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
@@ -5215,8 +5216,10 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 		BT_DBG("dcid[%d] 0x%4.4x", i, dcid);
 
+		orig = __l2cap_get_chan_by_dcid(conn, dcid);
+
 		/* Check if dcid is already in use */
-		if (dcid && __l2cap_get_chan_by_dcid(conn, dcid)) {
+		if (dcid && orig) {
 			/* If a device receives a
 			 * L2CAP_CREDIT_BASED_CONNECTION_RSP packet with an
 			 * already-assigned Destination CID, then both the
@@ -5225,10 +5228,24 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 			 */
 			l2cap_chan_del(chan, ECONNREFUSED);
 			l2cap_chan_unlock(chan);
-			chan = __l2cap_get_chan_by_dcid(conn, dcid);
-			l2cap_chan_lock(chan);
-			l2cap_chan_del(chan, ECONNRESET);
-			l2cap_chan_unlock(chan);
+
+			/* Check that the dcid channel mode is
+			 * L2CAP_MODE_EXT_FLOWCTL since this procedure is only
+			 * valid for that mode and shouldn't disconnect a dcid
+			 * in other modes.
+			 */
+			if (orig->mode == L2CAP_MODE_EXT_FLOWCTL) {
+				l2cap_chan_lock(orig);
+				/* Disconnect the original channel as it may be
+				 * considered connected since dcid has already
+				 * been assigned; don't call l2cap_chan_close
+				 * directly since that could lead to
+				 * l2cap_chan_del and then removing the channel
+				 * from the list while we're iterating over it.
+				 */
+				__set_chan_timer(orig, 0);
+				l2cap_chan_unlock(orig);
+			}
 			continue;
 		}
 
-- 
2.53.0



