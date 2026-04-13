Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008D317148;
	Mon, 13 Apr 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099243; cv=none; b=TKVNLce+Pto3YWXQmFDCqyd3z81ea2eSS1VaCje9tx+VoJvd6n0RKywN3Lm55D97NPQbJqVlyrmVOlly75Jm9eijrLhTqglGPbW/Xr3+VBriVBL9H73u5tMLaewbQikSu2KwhNQBYvqx3I0jXSWKpnoxOJGP1UsjmHOgxrHA/BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099243; c=relaxed/simple;
	bh=GsvBPmIO0USDuPlg0Cs1VgoXIqAk6jdJLRub9c9P684=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTmTV5VW68Exsuou9k5DTv1dt+pw2gVt4Ckr/hXLVranuJl0U+iUwaOhi9fd6ewlNRR6qPGRpoT1s3u1Y0dDKrlBPne6ct3Gf4TF1QlXgp5gU6xZL1y7fexuLWHjktnX0SHRsBxuFsoMCmR0ySZzrVo9JO3pot+YBcH0o+rjkH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxxowyRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxxowyRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0E5C2BCC7;
	Mon, 13 Apr 2026 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099243;
	bh=GsvBPmIO0USDuPlg0Cs1VgoXIqAk6jdJLRub9c9P684=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxxowyRQiXv8QNa0yBIoIPXPSVt+/X8MbEIOZ6KXHTK7SGqsS7WQ2UqYSwZpPCr+e
	 6b9bdaTCqjLIRWGyusxLZcit500vnRpxfslZ2cql8gidnXqaH21D6h7HEAqIAQ+8E3
	 BIlRghPbvZ5G6/7aN8cznxK+Y3QB4G+hsDpb8VqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/491] Bluetooth: L2CAP: Fix ERTM re-init and zero pdu_len infinite loop
Date: Mon, 13 Apr 2026 17:58:30 +0200
Message-ID: <20260413155828.972738070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 25f420a0d4cfd61d3d23ec4b9c56d9f443d91377 ]

l2cap_config_req() processes CONFIG_REQ for channels in BT_CONNECTED
state to support L2CAP reconfiguration (e.g. MTU changes). However,
since both CONF_INPUT_DONE and CONF_OUTPUT_DONE are already set from
the initial configuration, the reconfiguration path falls through to
l2cap_ertm_init(), which re-initializes tx_q, srej_q, srej_list, and
retrans_list without freeing the previous allocations and sets
chan->sdu to NULL without freeing the existing skb. This leaks all
previously allocated ERTM resources.

Additionally, l2cap_parse_conf_req() does not validate the minimum
value of remote_mps derived from the RFC max_pdu_size option. A zero
value propagates to l2cap_segment_sdu() where pdu_len becomes zero,
causing the while loop to never terminate since len is never
decremented, exhausting all available memory.

Fix the double-init by skipping l2cap_ertm_init() and
l2cap_chan_ready() when the channel is already in BT_CONNECTED state,
while still allowing the reconfiguration parameters to be updated
through l2cap_parse_conf_req(). Also add a pdu_len zero check in
l2cap_segment_sdu() as a safeguard.

Fixes: 96298f640104 ("Bluetooth: L2CAP: handle l2cap config request during open state")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index bca96302e59e5..e7af7faf558e8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2543,6 +2543,9 @@ static int l2cap_segment_sdu(struct l2cap_chan *chan,
 	/* Remote device may have requested smaller PDUs */
 	pdu_len = min_t(size_t, pdu_len, chan->remote_mps);
 
+	if (!pdu_len)
+		return -EINVAL;
+
 	if (len <= pdu_len) {
 		sar = L2CAP_SAR_UNSEGMENTED;
 		sdu_len = 0;
@@ -4526,14 +4529,16 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 	if (test_bit(CONF_INPUT_DONE, &chan->conf_state)) {
 		set_default_fcs(chan);
 
-		if (chan->mode == L2CAP_MODE_ERTM ||
-		    chan->mode == L2CAP_MODE_STREAMING)
-			err = l2cap_ertm_init(chan);
+		if (chan->state != BT_CONNECTED) {
+			if (chan->mode == L2CAP_MODE_ERTM ||
+			    chan->mode == L2CAP_MODE_STREAMING)
+				err = l2cap_ertm_init(chan);
 
-		if (err < 0)
-			l2cap_send_disconn_req(chan, -err);
-		else
-			l2cap_chan_ready(chan);
+			if (err < 0)
+				l2cap_send_disconn_req(chan, -err);
+			else
+				l2cap_chan_ready(chan);
+		}
 
 		goto unlock;
 	}
-- 
2.51.0



