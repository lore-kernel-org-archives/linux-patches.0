Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B2D38C437;
	Tue, 16 Jun 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635326; cv=none; b=plyPNoPXRHrWBGIkWeTLEdFoBhLlkR/LNZCXTViRF7v6Nz9080rptecLsJF1tYrftQ0M0f/oW716fIofBPckK17y9Hh1zNrSQM5qXi6OnHIn6/fk79lByt2B/oT+kwBvXj/FY1Kcli07UOW3O8YMGiOQ7FZIgwRfMQZKnkDphjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635326; c=relaxed/simple;
	bh=FB22KC/jibS//Q4HwMhYedqlfMig7mEbWSCPoRG7SHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9+hAeRx1wIdEHXfyv2evjYqGqWvFfH7a8dHAe02hPE/Qg1V2+D4V7BZ6bTT6/IXsvz4xF+NErgyBeADfQktIRkuQScreyOCSKbHlcD4FPHNtoBURpVzIBDrCiUu+FTQmyD0H965oR74fbFBRxoYo3LEw6+b7pzqjxehJEwGghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlz8y9lJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlz8y9lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCA91F000E9;
	Tue, 16 Jun 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635325;
	bh=f46pBipB4Oh44cWPxroOr2x9Pyk/7/Js6ia7ZX9kCAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlz8y9lJzq6gO+wcaTXY31F7glf/8wFsp9w/9bYh4APGb9bMmTCWg0ssG2y1eHm4b
	 4eF7bKRVVOHWmaprhHgT/uZCvh0Wh4+DNLTzIFf/tAE9nOo4r3DeNyaNeU98R1Dgf7
	 u+9xZGdEW/hXynpqHM2PNtpSLqMDq4/1uy+jLp1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/342] Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp
Date: Tue, 16 Jun 2026 20:25:24 +0530
Message-ID: <20260616145049.568957286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f30624d20bb09c..89e770f359ef20 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6232,6 +6232,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	cmd_len -= sizeof(*rsp);
 
 	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
+		struct l2cap_chan *orig;
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
@@ -6253,8 +6254,10 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 		BT_DBG("dcid[%d] 0x%4.4x", i, dcid);
 
+		orig = __l2cap_get_chan_by_dcid(conn, dcid);
+
 		/* Check if dcid is already in use */
-		if (dcid && __l2cap_get_chan_by_dcid(conn, dcid)) {
+		if (dcid && orig) {
 			/* If a device receives a
 			 * L2CAP_CREDIT_BASED_CONNECTION_RSP packet with an
 			 * already-assigned Destination CID, then both the
@@ -6263,10 +6266,24 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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



