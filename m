Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD474E77FE;
	Thu, 17 Sep 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668971; cv=none; b=KydDczEcyWuK4FwmmZwQqLX9S7gMr1wSitHcE5I9e5WOPToCI4NHbixX5u6MUpKbstML5FEYXBbCJwadKRe1ExppCIEaei393JOaBLPC+H7s87sqgs9y6zxmPSEzo2EksXEJsfYsrzzeTsvfuWMfz/CITmXxKJukMLHZkwveeJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668971; c=relaxed/simple;
	bh=2S6IQorDO0epiSD54bTkcaATV//u/R41VnxxDWNB95k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk845xmtBvpyyEAf0ElbX2/01dLaNZuJX6Q54De/kopYZPeEbLG3f9gYYJsmTBuTs1dE26t8MzUDlflbcNnleiZw2ljJS/XMIzywkfnb7piIc2EeWrIxP8Bh1ald/VPIutVMS/1T+lbrsxQ/Myeg5BVAp7x4gH/Svn9jNKVoQIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dffwEuk8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dffwEuk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8150D1F000FF;
	Thu, 17 Sep 2026 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668970;
	bh=L61pqgXlldMW8daZGqhK5c0udX0Fh5ReBMkJBw35loQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dffwEuk8lI+2EppNFzeM8w8//1/cvzCzy62GsGIO+x8eE/YdoAzopZ7g+xzJKrXcN
	 cYyEGw3GKxAAHNcj7vRcf7jeWuOiodhslKKtijQePFyqB7euXAB0oKpd/1u5DlyPZZ
	 t1z39R7z3605mtbS11eDG/rWenzRg5NopLC5lIJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0553/1102] Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan
Date: Thu, 17 Sep 2026 16:08:16 +0100
Message-ID: <20260917151553.728149590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 4ef05db5b08b176a551b4a6287372045998806b0 ]

l2cap_new_connection() sets default value of channel mode to match the
parent channel.  l2cap_le_connect_req() left this at the default, and
created L2CAP_MODE_EXT_FLOWCTL channels if listening pchan has that
mode.  This causes FLAG_DEFER_SETUP channels to reply to
L2CAP_LE_CONN_REQ with L2CAP_ECRED_CONN_RSP, which is incorrect.

It can also result to stack OOB write (of l2cap_alloc_cid determined
values) in l2cap_ecred_rsp_defer(), as l2cap_le_connect_req() does not
limit maximum number of deferred channels or check for duplicate ident.

Fix by setting chan->mode correctly in l2cap_le_connect_req().

Also check channel mode in l2cap_ecred_rsp_defer(), and do WARN_ON_ONCE
instead of OOB write to make it less brittle.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index c88caeefb6786..b98bb57ef6781 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3858,6 +3858,9 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	struct l2cap_ecred_conn_rsp *rsp_flex =
 		container_of(&rsp->pdu.rsp, struct l2cap_ecred_conn_rsp, hdr);
 
+	if (chan->mode != L2CAP_MODE_EXT_FLOWCTL)
+		return;
+
 	/* Check if channel for outgoing connection or if it wasn't deferred
 	 * since in those cases it must be skipped.
 	 */
@@ -3868,6 +3871,10 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	/* Reset ident so only one response is sent */
 	chan->ident = 0;
 
+	/* Unreachable, check in l2cap_ecred_conn_req. If reached, drop rest */
+	if (WARN_ON_ONCE(rsp->count >= ARRAY_SIZE(rsp->pdu.scid)))
+		rsp->pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_NO_MEM);
+
 	/* Include all channels pending with the same ident */
 	if (!rsp->pdu.rsp.result)
 		rsp_flex->dcid[rsp->count++] = cpu_to_le16(chan->scid);
@@ -5042,6 +5049,7 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 	chan->ident = cmd->ident;
+	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 		l2cap_state_change(chan, BT_CONNECT2);
-- 
2.53.0



