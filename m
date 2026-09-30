Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C2A4FDA5D;
	Wed, 30 Sep 2026 15:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782882; cv=none; b=lCSv2Ed4Xaw8lhomTLLP5r2MKRVuw9gavyKmxo+GuRvFQzP1KkdbGoX0iJO8I+24b8IaozBfWvSYD/tYuCUidvJy1gT3htmR+pAp77qTtcKwvhTY/9JXRMcrmavbKHN04ca6oD5uiABMkz50vJco1H3HPmQ9QJ7W42oaD1M3Pyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782882; c=relaxed/simple;
	bh=KYCOIQ2q+yykEBrjy+64YndWS6Ngl/zFwfVK/pruTOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJglkOJc1u1wO82urAWuDA4+0gpUCMleBDKfxY6JFKELOBhaTTQEt9LzPL/i87hVB390MNYd1q2+NT9dk3QDK7xv8LtKkiqqKNU8ozloYAgTuEJbE0zfhDSDTDW8RDe7eLFrO9xtr3idsGuRAYIi7niSMZcggQ/59HrMk7N/UQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6QdyQ0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6QdyQ0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6504E1F0089B;
	Wed, 30 Sep 2026 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782876;
	bh=dnSW5DiFdVoSPeUwg89EsaLJxiQ43261sMGr0Lj8Ec8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6QdyQ0FmEAOzdZqCadvpc7TgvElH9KZ3Hn9hLrt3CjVL2pSkEqrNBEHnI5Pcp1Yr
	 ATV+cZ/2zVxu7qiYtrgsIou0NrqFMV2dq6iLzr1NOzyP5J5T5FFM44z9ve1vehklyt
	 DGkvL3ygdaAahn2dJrKrhr+0MZ9V3iMpzEMcnwN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/595] Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan
Date: Wed, 30 Sep 2026 17:21:32 +0200
Message-ID: <20260930152352.016598827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index b9031c92f99c7..df2daa2c2ef3a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4061,6 +4061,9 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 {
 	struct l2cap_ecred_rsp_data *rsp = data;
 
+	if (chan->mode != L2CAP_MODE_EXT_FLOWCTL)
+		return;
+
 	/* Check if channel for outgoing connection or if it wasn't deferred
 	 * since in those cases it must be skipped.
 	 */
@@ -4071,6 +4074,10 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	/* Reset ident so only one response is sent */
 	chan->ident = 0;
 
+	/* Unreachable, check in l2cap_ecred_conn_req. If reached, drop rest */
+	if (WARN_ON_ONCE(rsp->count >= ARRAY_SIZE(rsp->pdu.scid)))
+		rsp->pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_NO_MEM);
+
 	/* Include all channels pending with the same ident */
 	if (!rsp->pdu.rsp.result)
 		rsp->pdu.rsp.dcid[rsp->count++] = cpu_to_le16(chan->scid);
@@ -6048,6 +6055,7 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 	chan->ident = cmd->ident;
+	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 		l2cap_state_change(chan, BT_CONNECT2);
-- 
2.53.0



