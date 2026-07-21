Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015EF471276;
	Tue, 21 Jul 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656608; cv=none; b=UJvJp/wfqmgc/rBimiCb89IcGOioB45KLQ5twbtFUgsLyrIrKuQP8/iD+sAVqX1NeCeCL8GHztt6tLqgTzvfEOqf8PebcxW1o9uc7gY1f91HbkgdDwWn2QY9cXUtDgSkXj96ZB0YFRVC4lX5N40WUJaOo6mVe3X4htiqwLsVDqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656608; c=relaxed/simple;
	bh=N80SjfqdY2JMKC4l/xS+Ho31x6GwF+byTXYX0VjVnMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdWT7s4hKSUXddzrYhWDWcvHi6gbnhkmd59vt5ikSE7XfzK1ZdgbpMTyPTjnO2qR/xm2DNS2F8KJ05Jr8i69U4GqnOUnrxeGNwrXlzS/W7Elyy/A2WsgLlKHqHlBIQW9LvrPhSJxXFpPl1L+bUlaJr9Bf+HdacfOMu30uNLYoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBdfpfms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBdfpfms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D331F000E9;
	Tue, 21 Jul 2026 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656606;
	bh=iQKyESxCf1+49BnnO5SewvrYHGfu+N175cj86jhzrVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBdfpfmsnu1u6yuhIHkK3MUVZ8kSAo3ryl9oHgZs4Ra18o0+thJKl8csBFV9KLoMu
	 e+0qjYOWrlxlWyY4oMrCTZ6gR7LLH7MaodhJtucwsSJXn1vIy3ubO6Gc8Q0HoPSaiz
	 atskGSjA8CbcHRM4eg5JMBo1BjQ2egMGhdk0Ae64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0450/1611] bonding: 3ad: fix mux port state on oper down
Date: Tue, 21 Jul 2026 17:09:26 +0200
Message-ID: <20260721152525.425403115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Louis Scalbert <louis.scalbert@6wind.com>

[ Upstream commit 807afc7544b865d4d09068a415fd5b71bf5665cc ]

When the bonding interface has carrier down due to the absence of
usable slaves and a slave transitions from down to up, the bonding
interface briefly goes carrier up, then down again, and finally up
once LACP negotiates collecting and distributing on the port.

When lacp_strict mode is on, the interface should not transition to
carrier up until LACP negotiation is complete.

This happens because the actor and partner port states remain in
Collecting_Distributing when the port goes down. When the port
comes back up, it temporarily remains in this state until LACP
renegotiation occurs.

Previously this was mostly cosmetic, but since the bonding carrier
state may depend on the LACP negotiation state, it causes the
interface to flap.

According to IEEE 802.3ad-2000 and IEEE 802.1ax-2014, Collecting and
Distributing should be reset when a port goes down:
- In the Receive state machine, port_enabled == FALSE causes a
  transition to the PORT_DISABLED state, which is expected to clear
  Partner_Oper_Port_State.Synchronization.
- In the Mux state machine, Partner_Oper_Port_State.Synchronization ==
  FALSE causes a transition to the ATTACHED state, which disables
  Collecting and Distributing.

However, Partner_Oper_Port_State.Synchronization is not cleared in the
PORT_DISABLED state.

Clear Partner_Oper_Port_State.Synchronization in the Receive
PORT_DISABLED state.

Fixes: 655f8919d549 ("bonding: add min links parameter to 802.3ad")
Signed-off-by: Louis Scalbert <louis.scalbert@6wind.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260603150331.1919611-6-louis.scalbert@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index bc8efdea5c2901..7148dd19710a81 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1322,6 +1322,7 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			fallthrough;
 		case AD_RX_PORT_DISABLED:
 			port->sm_vars &= ~AD_PORT_MATCHED;
+			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			break;
 		case AD_RX_LACP_DISABLED:
 			port->sm_vars &= ~AD_PORT_SELECTED;
-- 
2.53.0



