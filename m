Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A7F4B95C5;
	Thu, 17 Sep 2026 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665312; cv=none; b=n4BSkoW6usnxYw+quh+gqMgXofTKn6nsOr5kO8/VXsMptrgFclRTb7mG/4mR9G1uJWXn5aCVucxsLw+8tFXLYcdue3bPjdFVkR7m17ILeIaXIvO0ScEixnmCck9VvdGCJvb5j6Ug8I0Uv4jKliBPLikTFIjMn5hV+JSqVIFFqpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665312; c=relaxed/simple;
	bh=ncuAj9nA/8H/zv9t7Ou78n1ypOTjNrqW4H3jOtrhZQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BISBiTMBS0Umh/AmuVH5rfXJgwVTQegQsTSVPBGtiof206/RtvWUqq3aRCGLTTO2h+1qaL6WOsJpbTCV/NX5AcbQB5Mg7aua9isj5v6OdO+ITUdcAdPqwa/XfLO9k7rN9PCmToH/eAgx8CYOHtdTQgRaZmZWP7PhPphrMjjEGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA1wdJD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA1wdJD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5DE1F000FF;
	Thu, 17 Sep 2026 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665311;
	bh=Qi78R7Gr+KOqLaCRFs4yXHPrcDdyJC4bSOSD1eGRv5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pA1wdJD/9MUiTM67VVINmhe5QzGyY+LHcjUj80DpkQp9vmC3raJM2MTbdMzbVDhO8
	 jgSqHukuzE/i5V4038lPUqdXi+hnj+31JQ2d+/pn7wUvsHvXkNiiTOO7ie+0cVSzTJ
	 KZuztakxiJC88Q3ZhRPaJ+GrkELrDpmLS7yjU/L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0664/1250] Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan
Date: Thu, 17 Sep 2026 16:07:39 +0100
Message-ID: <20260917151609.888239707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 1a38a667ef0b0..daf51a57cfa61 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3893,6 +3893,9 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	struct l2cap_ecred_conn_rsp *rsp_flex =
 		container_of(&rsp->pdu.rsp, struct l2cap_ecred_conn_rsp, hdr);
 
+	if (chan->mode != L2CAP_MODE_EXT_FLOWCTL)
+		return;
+
 	/* Check if channel for outgoing connection or if it wasn't deferred
 	 * since in those cases it must be skipped.
 	 */
@@ -3903,6 +3906,10 @@ static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
 	/* Reset ident so only one response is sent */
 	chan->ident = 0;
 
+	/* Unreachable, check in l2cap_ecred_conn_req. If reached, drop rest */
+	if (WARN_ON_ONCE(rsp->count >= ARRAY_SIZE(rsp->pdu.scid)))
+		rsp->pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_NO_MEM);
+
 	/* Include all channels pending with the same ident */
 	if (!rsp->pdu.rsp.result)
 		rsp_flex->dcid[rsp->count++] = cpu_to_le16(chan->scid);
@@ -5070,6 +5077,7 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 	chan->ident = cmd->ident;
+	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 		l2cap_state_change(chan, BT_CONNECT2);
-- 
2.53.0



