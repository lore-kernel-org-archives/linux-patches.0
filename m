Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045E2324B28;
	Mon, 27 Oct 2025 19:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593291; cv=none; b=mn1ZLZ71FSI6YSg7GXh4YnF1uoHuh4rYYvzn+Tgv8w9aKLFwxUwU9kh9MnIRLZE/HJJcw3emG+4Wlltv6md1jz8TOsQs+vtzEdjvA2LpnAjVCM8LdVtYhLJDzgTF8zWRRRd/b9IWPG+ijOniQpKKgdh/56l4WSWyQMfOfYWsbNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593291; c=relaxed/simple;
	bh=7uK/YHEm+gClKJLaRABNExJLXnHpZsjp0eTndbFmzTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV3r3vXpcTtpXdRbGCcedkRbQ3ztoU1n35xHap8L44qNahPUTye2tDAzxMrnRvMWnvAZ/DZk7a+Bu2/dJOzox6vT5zj9bHg61nSz045vCm2FajyMLG6lmgt2RSQY3uWA4t0JNo3p0DrhDhKRzL/ZrVyvvXPLjn6fMAZ9qZqrtU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpz5ST6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpz5ST6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E867C4CEFD;
	Mon, 27 Oct 2025 19:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593290;
	bh=7uK/YHEm+gClKJLaRABNExJLXnHpZsjp0eTndbFmzTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpz5ST6eIxFGFtEPt4ib4J9/cfuso51Ujdgf58bVxQNgPQA7/vlYMVLakaW77F38v
	 g6fhR7OXuE0MZYNLtZEAHuwxsMerdHDDp8R6aOQ+43qKfr816MeS0Vofw/eW41Qlo7
	 2S0NJj+ahWFDTv0GDtVyps6HVm5kKVovMR/E2JOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrey.lalaev@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.17 087/184] can: netlink: can_changelink(): allow disabling of automatic restart
Date: Mon, 27 Oct 2025 19:36:09 +0100
Message-ID: <20251027183517.240550796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -285,7 +285,9 @@ static int can_changelink(struct net_dev
 	}
 
 	if (data[IFLA_CAN_RESTART_MS]) {
-		if (!priv->do_set_mode) {
+		unsigned int restart_ms = nla_get_u32(data[IFLA_CAN_RESTART_MS]);
+
+		if (restart_ms != 0 && !priv->do_set_mode) {
 			NL_SET_ERR_MSG(extack,
 				       "Device doesn't support restart from Bus Off");
 			return -EOPNOTSUPP;
@@ -294,7 +296,7 @@ static int can_changelink(struct net_dev
 		/* Do not allow changing restart delay while running */
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
-		priv->restart_ms = nla_get_u32(data[IFLA_CAN_RESTART_MS]);
+		priv->restart_ms = restart_ms;
 	}
 
 	if (data[IFLA_CAN_RESTART]) {


