Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C43CEEDE;
	Tue, 20 May 2025 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749746; cv=none; b=EAlN4Kzsnw87ntBp89tgRLJo1I03Q8+546ZbnI044u1i3x2u+/FmtErAKWPoYGrkpX9hRdAFkTkAa8EDJoFp/5PVuFI5kYJgrQ1+rEPH24fygPgUBUfnmTHNf4NM5OXEZ0xGyNYqFabYVy1YXNPAMI/bo9U/J6VIGeb63Jj5BQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749746; c=relaxed/simple;
	bh=9SPc8xcWZbQy9LIgHBUPvCCK42hgFJoNZM0uAJOecbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm8IH72L71pbwrH93h9MTgvBH9dthm4X4m2Vym0vfWovT9P6v0m81BPZ8ABiDuF5LglGzBLd8hyeMjwTXSQ5yfWiebED0hl4Dr8GPCEqy08wbHiG+JEd+8SBq2GsGJJ9hq6aLX9V+jfPqu71doDYFnH8pXXQmgXunqwZOovoNhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIfaAwBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIfaAwBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877EBC4CEE9;
	Tue, 20 May 2025 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749745;
	bh=9SPc8xcWZbQy9LIgHBUPvCCK42hgFJoNZM0uAJOecbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIfaAwBvC7ABme4P+F+vXSUSGIUxc7jkvYODIMciHZT6T5fmFsgeShGPjz2NfOe2M
	 syW+6PeDXBldJddIuzEc/CUGLziiXXpmyGft7S8REavcrlaev8VtYLbO7fOAQDCdrq
	 DBBrZmG0YHTR8nMr4AsjIv/hQ2Lz/NTZPbf2TR5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/117] net: dsa: sja1105: discard incoming frames in BR_STATE_LISTENING
Date: Tue, 20 May 2025 15:50:10 +0200
Message-ID: <20250520125805.780214610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 498625a8ab2c8e1c9ab5105744310e8d6952cc01 ]

It has been reported that when under a bridge with stp_state=1, the logs
get spammed with this message:

[  251.734607] fsl_dpaa2_eth dpni.5 eth0: Couldn't decode source port

Further debugging shows the following info associated with packets:
source_port=-1, switch_id=-1, vid=-1, vbid=1

In other words, they are data plane packets which are supposed to be
decoded by dsa_tag_8021q_find_port_by_vbid(), but the latter (correctly)
refuses to do so, because no switch port is currently in
BR_STATE_LEARNING or BR_STATE_FORWARDING - so the packet is effectively
unexpected.

The error goes away after the port progresses to BR_STATE_LEARNING in 15
seconds (the default forward_time of the bridge), because then,
dsa_tag_8021q_find_port_by_vbid() can correctly associate the data plane
packets with a plausible bridge port in a plausible STP state.

Re-reading IEEE 802.1D-1990, I see the following:

"4.4.2 Learning: (...) The Forwarding Process shall discard received
frames."

IEEE 802.1D-2004 further clarifies:

"DISABLED, BLOCKING, LISTENING, and BROKEN all correspond to the
DISCARDING port state. While those dot1dStpPortStates serve to
distinguish reasons for discarding frames, the operation of the
Forwarding and Learning processes is the same for all of them. (...)
LISTENING represents a port that the spanning tree algorithm has
selected to be part of the active topology (computing a Root Port or
Designated Port role) but is temporarily discarding frames to guard
against loops or incorrect learning."

Well, this is not what the driver does - instead it sets
mac[port].ingress = true.

To get rid of the log spam, prevent unexpected data plane packets to
be received by software by discarding them on ingress in the LISTENING
state.

In terms of blame attribution: the prints only date back to commit
d7f9787a763f ("net: dsa: tag_8021q: add support for imprecise RX based
on the VBID"). However, the settings would permit a LISTENING port to
forward to a FORWARDING port, and the standard suggests that's not OK.

Fixes: 640f763f98c2 ("net: dsa: sja1105: Add support for Spanning Tree Protocol")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250509113816.2221992-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1a367e64bc3b1..843e50b5a0ec5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2076,6 +2076,7 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 	switch (state) {
 	case BR_STATE_DISABLED:
 	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
 		/* From UM10944 description of DRPDTAG (why put this there?):
 		 * "Management traffic flows to the port regardless of the state
 		 * of the INGRESS flag". So BPDUs are still be allowed to pass.
@@ -2085,11 +2086,6 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 		mac[port].egress    = false;
 		mac[port].dyn_learn = false;
 		break;
-	case BR_STATE_LISTENING:
-		mac[port].ingress   = true;
-		mac[port].egress    = false;
-		mac[port].dyn_learn = false;
-		break;
 	case BR_STATE_LEARNING:
 		mac[port].ingress   = true;
 		mac[port].egress    = false;
-- 
2.39.5



