Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3D530F53B;
	Wed, 25 Feb 2026 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002714; cv=none; b=hQaekfcmIV8Xhz3BKtxLywh/geGB0cEFl3d4GU71WeRYcXElHhdn3Bu5qd3OUA31Xp14dyf8uIik3mnfR1VQsROfkAzbZ3eMmIkNfo5qq1aUI7nf6IclU2EvW081ob2Ic+V6fOzZPLLiyXSHAEF78kFtDIA79FA2QNsJkzB6TgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002714; c=relaxed/simple;
	bh=3eq+6kDWSmF+Aj8XL3qEt+45Lmb+8044A2dp9X4S/ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPwl44hqFIcOv5FdGT1hpTxO114nZ/OAyJ+ZgHijb8n8D2njE+tOmHRsf/7hL+oPAeuVHvRGcTScbkcN12iuyIiryVo6c/9zSHDofOJfacgPKTRDGg6wGOqfiuenykgx3o0592fF46TybruSwHOwdtWlZpx0O05TjQXPgXDLyRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIKAcmiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIKAcmiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45477C116D0;
	Wed, 25 Feb 2026 06:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002714;
	bh=3eq+6kDWSmF+Aj8XL3qEt+45Lmb+8044A2dp9X4S/ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIKAcmiPg3M04nUp6QM9yEFm1+EPWf0WA6NfMv85YqSwyHAEplPkN30O9y+bJW/Gn
	 5B0TRWt6TX8xAJN0sbQ4xmKM3QhVZX1zA0dZzn9IXiPU2jphzY8ijnmis/ApriXdej
	 rPTE4ajs4+MNbxQ4D4DJedLtiTlB324CklsXUB4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/641] net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()
Date: Tue, 24 Feb 2026 17:24:07 -0800
Message-ID: <20260225012401.153756617@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 026f6513c5880c2c89e38ad66bbec2868f978605 ]

ocelot_port_xmit_inj() calls ocelot_can_inject() and
ocelot_port_inject_frame() without holding the injection group lock.
Both functions contain lockdep_assert_held() for the injection lock,
and the correct caller felix_port_deferred_xmit() properly acquires
the lock using ocelot_lock_inj_grp() before calling these functions.

Add ocelot_lock_inj_grp()/ocelot_unlock_inj_grp() around the register
injection path to fix the missing lock protection. The FDMA path is not
affected as it uses its own locking mechanism.

Fixes: c5e12ac3beb0 ("net: mscc: ocelot: serialize access to the injection/extraction groups")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260208225602.1339325-4-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index a7966c174b2e2..1b82693204640 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -597,14 +597,22 @@ static netdev_tx_t ocelot_port_xmit_inj(struct sk_buff *skb,
 	int port = priv->port.index;
 	u32 rew_op = 0;
 
-	if (!ocelot_can_inject(ocelot, 0))
+	ocelot_lock_inj_grp(ocelot, 0);
+
+	if (!ocelot_can_inject(ocelot, 0)) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		return NETDEV_TX_BUSY;
+	}
 
-	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
+	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op)) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		return NETDEV_TX_OK;
+	}
 
 	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
+	ocelot_unlock_inj_grp(ocelot, 0);
+
 	consume_skb(skb);
 
 	return NETDEV_TX_OK;
-- 
2.51.0



