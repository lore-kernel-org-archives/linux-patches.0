Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07A3C10B9;
	Wed, 30 Sep 2026 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795035; cv=none; b=Z+DmPmLpMHUzOl0yqpdScsshpO4asafiyQKW1OU14zVaAemE7f6GinWnLo10wL7ZUGAeP6d9q/JhaIsMVhPamdsGcU+OV1K+WTMsRqSsWDxK6oX3oTMkuL9TEDPYSDKWAPmPNnPI98nX+WrmVqm9soz/PUzZIPQdU9J3w8M9LYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795035; c=relaxed/simple;
	bh=0jariqycOyMMiU4Dc6x8jzdKbWJEWzfXehtTPAmH0Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXP1OAoGP/1qUQJ2AXmOtGC1mCuJvZ5zrGWQX/cWGEkk/+kMkQeMN74llFQSaOUxv38Er3EdnOh491xG+nyE8QxXF/K3Iyg07dI4Qdx+XnI6Jvxyv/7Wly+8BAXkNAEK0ItF3NHQ+G3TdyMdXZrtNytGZPmkRhzu00N/envqL3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgQSR1HP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgQSR1HP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E164E1F000FF;
	Wed, 30 Sep 2026 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795034;
	bh=gMAB8vpHfXTpo0llDsFaX8C4h57WtwGW+TKrn58owck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgQSR1HPkyoJw0TZT2axTK8PwQlL91ZB41Ng7s+l/T2Hqrsw9nerDpTwvPnmcjmV+
	 hw0Lv1YSwRE0JXQc/ENm6djsAK2EMaeXBWinwWD6XlEoot4uNZeUJNPWTfIeeQ5cys
	 edf5CuN0Fde6E51Ixzxfi9JpFWqCsmHSev7MrxVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0418/1193] Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan
Date: Wed, 30 Sep 2026 17:18:22 +0200
Message-ID: <20260930152443.489624227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 0f2fe83215cf3..6a4b22ae9570a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3841,6 +3841,9 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 {
 	struct l2cap_ecred_rsp_data *rsp = data;
 
+	if (chan->mode != L2CAP_MODE_EXT_FLOWCTL)
+		return;
+
 	/* Check if channel for outgoing connection or if it wasn't deferred
 	 * since in those cases it must be skipped.
 	 */
@@ -3851,6 +3854,10 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	/* Reset ident so only one response is sent */
 	chan->ident = 0;
 
+	/* Unreachable, check in l2cap_ecred_conn_req. If reached, drop rest */
+	if (WARN_ON_ONCE(rsp->count >= ARRAY_SIZE(rsp->pdu.scid)))
+		rsp->pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_NO_MEM);
+
 	/* Include all channels pending with the same ident */
 	if (!rsp->pdu.rsp.result)
 		rsp->pdu.rsp.dcid[rsp->count++] = cpu_to_le16(chan->scid);
@@ -4995,6 +5002,7 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 	chan->ident = cmd->ident;
+	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 		l2cap_state_change(chan, BT_CONNECT2);
-- 
2.53.0



