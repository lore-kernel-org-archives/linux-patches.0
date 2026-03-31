Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616ED3009D4;
	Tue, 31 Mar 2026 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976521; cv=none; b=nSzTAl9+eq+mzzSYg6utHlVbVrOL8IAO9397lB6t2JVaLXjQ9GLl7rVBIzCyyYjlGiy2nVY5fUercI/zUwCTDxlzds/qIh4udgd5k3CP7oqPdqc7BdpNTcN3BrggX/QaJkRnmM5CT3x3G2LePC39f+lcaC4cvfNYD182RDVVg8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976521; c=relaxed/simple;
	bh=qAcLVZsg5YhMu8MYZ2agD4hpNJ/aPwXAxzSsR6fX6t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IslZIkhlWWvSNyOSTE8TkXmeCAOZ8FzlFVQ4iO2yPntLnRCXXvHSskJo6vOMqupEjY2e2wUAWREAXO45Dq6n0BQyJr32X6K+xfNfWQVdZlmMkmXCX9+Gxdmyrmbu6oVyWJSRYp89A1Sw7Ji3oB/Mlp6pZsTgpY4SUzF8RAoLDxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KTqo3Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KTqo3Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB064C19423;
	Tue, 31 Mar 2026 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976521;
	bh=qAcLVZsg5YhMu8MYZ2agD4hpNJ/aPwXAxzSsR6fX6t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KTqo3NuWEXzt+USOWB9Q5sRv3Vl/EHvB0cubYGTmdRPbPCjhMWyI1Jf/n0BV38T4
	 ZB2ly0QgbUi4tv/T6W4XvnCoR/gExjs74v6/74rYJaCkl1RB1NNnR+EAdGM/4oOccb
	 uBn25aP9/SKxQgsrbtPukG0YaWcsM9rIfWaHCGAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/309] Bluetooth: L2CAP: Fix ERTM re-init and zero pdu_len infinite loop
Date: Tue, 31 Mar 2026 18:20:26 +0200
Message-ID: <20260331161758.008994812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index 734cbb5dc1bfa..b72f2da57257d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2375,6 +2375,9 @@ static int l2cap_segment_sdu(struct l2cap_chan *chan,
 	/* Remote device may have requested smaller PDUs */
 	pdu_len = min_t(size_t, pdu_len, chan->remote_mps);
 
+	if (!pdu_len)
+		return -EINVAL;
+
 	if (len <= pdu_len) {
 		sar = L2CAP_SAR_UNSEGMENTED;
 		sdu_len = 0;
@@ -4310,14 +4313,16 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
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



