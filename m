Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6EB3DDB03;
	Tue, 21 Jul 2026 22:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673675; cv=none; b=nz9ggmEe84XT6Tuch0Bftbh/gmTlYijDDxMXhDJKJ8zxfEFkAQbIaRVx3YjeIeGnFeHduD1vDthv7Tak60ogJDBPKV4UMCh3Xmc9VBKWzEjhcMon7+/whMSmFZzmsxzq5nbli238hFATOIEjb1ON5oYI+wT0NfaPJ2sV96RNuVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673675; c=relaxed/simple;
	bh=P+uSE96ZmkIX6y1flk5QVbp6unkyJYpTEQl/UaTKl/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmqGYqkZisTRA5cxcBMv3RIEjj+aZozzxmJoWaggwOus8OLbvHg/98hpWd+34WOnHPqDV+ftqlDPUhUs3B71shhUYjEmeQSbxwmXvkWBUuHrIQ0UQBg3PCahyB/1wWvQ5XN8XtmeLwZK6ZzVEhaXJD5pG1wbHUPX4KUU+UztJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ECop7Xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ECop7Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377D51F000E9;
	Tue, 21 Jul 2026 22:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673674;
	bh=43FNRUKZW7S68b1bzbeZ7xUqRhWoXnJTqscFWgtBmZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ECop7Xgx9ohjG3diWRU4pFqd76uZUT9bDmYXEKDNZ1pHTmci0tAdwVLuavPKFZmJ
	 FPCnANqTw4ctfLIcawSZM1Y6D8rJ6X04oGZUcXfaHlkU0JuZf+mKff+j8jHSV4lg8n
	 Aj88ZBd1zCHhHCANqmrG6RsyfT5XqeDrtwo+3+ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/699] bonding: 3ad: fix mux port state on oper down
Date: Tue, 21 Jul 2026 17:20:10 +0200
Message-ID: <20260721152401.358458203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
index 320e5461853f77..7683808c66128b 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1153,6 +1153,7 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			fallthrough;
 		case AD_RX_PORT_DISABLED:
 			port->sm_vars &= ~AD_PORT_MATCHED;
+			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			break;
 		case AD_RX_LACP_DISABLED:
 			port->sm_vars &= ~AD_PORT_SELECTED;
-- 
2.53.0



