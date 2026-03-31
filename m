Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5CE401A2C;
	Tue, 31 Mar 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974389; cv=none; b=YKbkQ1jK098N3hUaR6xQsf8Pw8dsxxuQXxi2mPO/fPShwYKnROh2cWodJIK28zC4zrvDjYqxeQBDOjgpmbNZDSbsM6EVX0m/cGVxWszauMDKRg2y3oU5Z2TfA3EzCPGexjZayxoslf8R0Tjb8x+X0Syc3DQ1IE26k/DaD0/hU8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974389; c=relaxed/simple;
	bh=Gna5beid00FQYg4U/fsZZP0WXaaHLAcEcFjyCEqzFzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzEz2kuz47m4rcDDPHn+Y5TvSI6u/astS+cSxK+XWsCWzZP/lJp93/h16kZ7vcKSptuAemIP0u24X0ttr6yd6wprXct904dHXDrSRHvRYIZkkitWbSwkdTHTEYRc3/znxa0tz6h/Xdil5n9daTu2zLMLdHoW/plQ8IM1UkJurJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR2xCMWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR2xCMWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C3C19424;
	Tue, 31 Mar 2026 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974389;
	bh=Gna5beid00FQYg4U/fsZZP0WXaaHLAcEcFjyCEqzFzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR2xCMWtNXQ2+B0eHvMdYe+TifFFAIs6myYVd7tjZhJkyAwzOZbaAEatikrhdr7SQ
	 8Qj8I4YovAd0QKEkh+cfElIyOFRvLsZBdhaS9nxCRd3IKQN/WVenFA7iiXwiMhXMNr
	 vZTaBGTGLKg3VM9fOB9j+0ggnq1/tlGk/IBG/0pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/175] Bluetooth: L2CAP: Fix ERTM re-init and zero pdu_len infinite loop
Date: Tue, 31 Mar 2026 18:20:50 +0200
Message-ID: <20260331161732.206807852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index 47625ea36106f..3da3e9fddd049 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2383,6 +2383,9 @@ static int l2cap_segment_sdu(struct l2cap_chan *chan,
 	/* Remote device may have requested smaller PDUs */
 	pdu_len = min_t(size_t, pdu_len, chan->remote_mps);
 
+	if (!pdu_len)
+		return -EINVAL;
+
 	if (len <= pdu_len) {
 		sar = L2CAP_SAR_UNSEGMENTED;
 		sdu_len = 0;
@@ -4281,14 +4284,16 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
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



