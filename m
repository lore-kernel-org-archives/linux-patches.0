Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30F235C682;
	Tue, 21 Jul 2026 22:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671663; cv=none; b=bYWmQfybrjIJajOWaixkiaZrF9Bgwkf6+YJ9MsHgnkcZnuguswP6uOOlnGnKajM9lIaTq6pBHqbGbuvzngPP3UqohKpUpObL3bJcbpbs+els2YXo+I0ByH2Wr8OaqtUq8VI8Wjjchr2YSi8Ztc3msYbkZnJxkOUhExlhqprJSHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671663; c=relaxed/simple;
	bh=V3Zq5SH3CqDUZNioNUw14vuxyIwiFZV6Mhwz2LadvXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8Hd8idUPppz2fvAs7G21PqRMRGVrzMj2acWO5imYXoGPDmQhxRuOjFrGbhQRONgegO63vaI/kPAAPdU5NRviHlg48huyX+S4jKp7El+VZx8TwQXjygg2TM5jVguksIkldGsE/nfUh3zsHjW/Wa3Ahi2F4SVXt/kVZDUQXoCB6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TT/1BHZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TT/1BHZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645C71F000E9;
	Tue, 21 Jul 2026 22:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671661;
	bh=TwJJLuaMYgobCDTFy7pHc1nA2dIrS9fMEE419RGjFi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TT/1BHZ4nftwWujh/n7l3Cf5MjDJEsPafHoGTVaPUzwcQG5oFkpeC8r/JZbFL9eB/
	 aGdORXDKcpgLQyAtpg81TEbsCmDLffWNQLq/Jk0moEg+6kc5RYfhBvQ2f/Q5aT7Q2g
	 R5H+DryKMCmjoWxI4RHEXvaCwU/MksrXgJKvYJ1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/843] bonding: 3ad: fix mux port state on oper down
Date: Tue, 21 Jul 2026 17:19:26 +0200
Message-ID: <20260721152413.466221409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fcbd70ad45b9e2..b6f86bb5a1aec7 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1171,6 +1171,7 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			fallthrough;
 		case AD_RX_PORT_DISABLED:
 			port->sm_vars &= ~AD_PORT_MATCHED;
+			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			break;
 		case AD_RX_LACP_DISABLED:
 			port->sm_vars &= ~AD_PORT_SELECTED;
-- 
2.53.0



