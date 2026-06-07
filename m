Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B620E2AD00;
	Sun,  7 Jun 2026 10:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827503; cv=none; b=e5ReOuB8frD1SVqVBM9rIvtvFzj8eSvSBHyz6aEufdvua5tLPa9t8g3F0qMRQCa/IHU9TuMyaTUGdyPACRddQ3BYpPe/DcPORBJr0o/rAPCc4mpGOVun4nlzEvLyZnYdNZz1B6zB2iW+QJW6U+tGcCnoNM7oIjChlPujHzdd0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827503; c=relaxed/simple;
	bh=k65aqkSb4Ye2lfXh3+fjeQIMLAUHp5nEBdvBSVWgyUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieiRnQKP9Sp3MtzMhrA7WcoNTh0f3IEn/G0GYA169ox5ftrqCQDWg9P3cxeTbt36oizgJ82/PARXpCc4cCSwqyccaXVkzY513ITy9WbVe/IC2ukYtdoaeH9Pp7OrmJHWyzK/MhramM4jAVKNQh4xPpxVRs213Yl5F7DHSH9LDtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLwejRGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLwejRGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD821F00893;
	Sun,  7 Jun 2026 10:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827502;
	bh=Z3YTHBZ36ehI7NEe72bp11kx5KXVrXR1C0WAh8NvNGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLwejRGS4ZcZeTdl1kINRPiBuoZNZ6aNP6WG3vt09MX4B4CRt4CYj/8NmKzdAvY4w
	 tAv12WLr7T+bAfTsHLfJ4M6W1JTEujlWhifnrOTrGu8m6WS/YQ/w/9WdA+rvMs7loo
	 YiWFQZOcjaIiUllolZqZnGgphFvZWDsFMhQH5Jzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 098/332] Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp
Date: Sun,  7 Jun 2026 11:57:47 +0200
Message-ID: <20260607095731.745126165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 83ea31926bd0f8..27b5d459e1217c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5268,6 +5268,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	cmd_len -= sizeof(*rsp);
 
 	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
+		struct l2cap_chan *orig;
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
@@ -5289,8 +5290,10 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 		BT_DBG("dcid[%d] 0x%4.4x", i, dcid);
 
+		orig = __l2cap_get_chan_by_dcid(conn, dcid);
+
 		/* Check if dcid is already in use */
-		if (dcid && __l2cap_get_chan_by_dcid(conn, dcid)) {
+		if (dcid && orig) {
 			/* If a device receives a
 			 * L2CAP_CREDIT_BASED_CONNECTION_RSP packet with an
 			 * already-assigned Destination CID, then both the
@@ -5299,10 +5302,24 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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



