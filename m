Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458373064AA;
	Mon, 27 Oct 2025 19:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592354; cv=none; b=brL6QIO126xTiSFbaWtmpCkUSIy/+6+PQ8cs3IjKTbvTOxb+uFKAv0LHstcNNyf2sWIaze37uWX9TL9dN99yFdJcLOKvxxGVi+/fqNtt2oWKlcTJQdF4o5bmDGfEjM/UtChLZqUcR11aZLjSpSJ57Hf1yea93op7CS2zqRfR0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592354; c=relaxed/simple;
	bh=2GLVcb/VzMP2WW5eqio5u69YTbOWQOqTSPjRBHJk0wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7AQUNUHZWvNImBO7hIcVNWr2kwOQpuksaXHKV6QL1q2CJyw3xP5K4mzXEZezKSz0bGALeQtBeexxktJ7YvX7ERQpDBwLovv4uciY6f+lOrbeBKB2sITHk+Yq3kezO9MQ5ODfl1L052CVk+EzR9vQv51RBZnnyR63ERiN6GtXF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TS27N/MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TS27N/MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA177C4CEF1;
	Mon, 27 Oct 2025 19:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592354;
	bh=2GLVcb/VzMP2WW5eqio5u69YTbOWQOqTSPjRBHJk0wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TS27N/MG9GwoMXK4986/gZM38cCioUO53tndBrT1J6MhNw0O5uFsTMBMcpEyJQ90P
	 +aLtsJA4x5LtF8nTUJok5ZHTPykkB+snkXv2J+MGbl/O6vF5zbCZK8lgAXKxKskJ1d
	 0vmGozZe7+/WNwjA8Mqg8OfaeHkhS42ygJuxtmS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrey.lalaev@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 090/157] can: netlink: can_changelink(): allow disabling of automatic restart
Date: Mon, 27 Oct 2025 19:35:51 +0100
Message-ID: <20251027183503.683885982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 8e93ac51e4c6dc399fad59ec21f55f2cfb46d27c upstream.

Since the commit c1f3f9797c1f ("can: netlink: can_changelink(): fix NULL
pointer deref of struct can_priv::do_set_mode"), the automatic restart
delay can only be set for devices that implement the restart handler struct
can_priv::do_set_mode. As it makes no sense to configure a automatic
restart for devices that doesn't support it.

However, since systemd commit 13ce5d4632e3 ("network/can: properly handle
CAN.RestartSec=0") [1], systemd-networkd correctly handles a restart delay
of "0" (i.e. the restart is disabled). Which means that a disabled restart
is always configured in the kernel.

On systems with both changes active this causes that CAN interfaces that
don't implement a restart handler cannot be brought up by systemd-networkd.

Solve this problem by allowing a delay of "0" to be configured, even if the
device does not implement a restart handler.

[1] https://github.com/systemd/systemd/commit/13ce5d4632e395521e6205c954493c7fc1c4c6e0

Cc: stable@vger.kernel.org
Cc: Andrei Lalaev <andrey.lalaev@gmail.com>
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/all/20251020-certain-arrogant-vole-of-sunshine-141841-mkl@pengutronix.de
Fixes: c1f3f9797c1f ("can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode")
Link: https://patch.msgid.link/20251020-netlink-fix-restart-v1-1-3f53c7f8520b@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -252,7 +252,9 @@ static int can_changelink(struct net_dev
 	}
 
 	if (data[IFLA_CAN_RESTART_MS]) {
-		if (!priv->do_set_mode) {
+		unsigned int restart_ms = nla_get_u32(data[IFLA_CAN_RESTART_MS]);
+
+		if (restart_ms != 0 && !priv->do_set_mode) {
 			NL_SET_ERR_MSG(extack,
 				       "Device doesn't support restart from Bus Off");
 			return -EOPNOTSUPP;
@@ -261,7 +263,7 @@ static int can_changelink(struct net_dev
 		/* Do not allow changing restart delay while running */
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
-		priv->restart_ms = nla_get_u32(data[IFLA_CAN_RESTART_MS]);
+		priv->restart_ms = restart_ms;
 	}
 
 	if (data[IFLA_CAN_RESTART]) {


