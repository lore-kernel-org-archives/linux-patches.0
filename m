Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178E225F780;
	Mon, 22 Sep 2025 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569604; cv=none; b=RZSKrsTuNsm0IQk+nJxbVFHDWwVBGLuuoL6XLZIUdYlqZ75+5MyNC1aucrdOAXGOlwsy35U8BbFIv41vavAwadoy6MwUsyWeQgZIS94EQOOkiMEMPm2jREDmUJ6XwJO0QukYQRKqAN0V3NpW4T2t0yit/yEIYKF3QOHWdQSN8nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569604; c=relaxed/simple;
	bh=fihMmEFUvOFdaD7x/f3wh8dKA2nISy2qN7KJ9I0nSs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0lwVpz6cMvX6PN0tpRPjHCnW0j9INh72cvDhkCAsu0Oa7Cspe/TTEhGC49s7cVXouOx6AC5Y/uUD6uSJBtF68cQdQrBmhUkr/xBarEihEDJhbkSlxMsw6c8J+WJ6KbphTh6MmIgVsXw+IINCPfy2ojHws9oJ9yfVybk7sncsww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MC8U0SfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MC8U0SfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A421AC4CEF0;
	Mon, 22 Sep 2025 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569604;
	bh=fihMmEFUvOFdaD7x/f3wh8dKA2nISy2qN7KJ9I0nSs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MC8U0SfDNybeiB5PLzc8ST2NOc39nNZZHRHf043QSrf8OVzgSkzGtTMAtAVMkx6oO
	 c5AZI9QUWCPv4HMGHPn2fue9FTNDcyFAwvxfBO8Hj0rIE47PnfOvvmzY7a35NBH5t4
	 kc0LFq8w5mTOO0kK+XutUdPvDaVNx9bVtDPFX5DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Majkowski <marek@cloudflare.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 46/61] mptcp: pm: nl: announce deny-join-id0 flag
Date: Mon, 22 Sep 2025 21:29:39 +0200
Message-ID: <20250922192404.863982531@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 2293c57484ae64c9a3c847c8807db8c26a3a4d41 upstream.

During the connection establishment, a peer can tell the other one that
it cannot establish new subflows to the initial IP address and port by
setting the 'C' flag [1]. Doing so makes sense when the sender is behind
a strict NAT, operating behind a legacy Layer 4 load balancer, or using
anycast IP address for example.

When this 'C' flag is set, the path-managers must then not try to
establish new subflows to the other peer's initial IP address and port.
The in-kernel PM has access to this info, but the userspace PM didn't.

The RFC8684 [1] is strict about that:

  (...) therefore the receiver MUST NOT try to open any additional
  subflows toward this address and port.

So it is important to tell the userspace about that as it is responsible
for the respect of this flag.

When a new connection is created and established, the Netlink events
now contain the existing but not currently used 'flags' attribute. When
MPTCP_PM_EV_FLAG_DENY_JOIN_ID0 is set, it means no other subflows
to the initial IP address and port -- info that are also part of the
event -- can be established.

Link: https://datatracker.ietf.org/doc/html/rfc8684#section-3.1-20.6 [1]
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Reported-by: Marek Majkowski <marek@cloudflare.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/532
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-2-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_pm.yaml, and mptcp_pm.h, because these files have
  been added later by commit bc8aeb2045e2 ("Documentation: netlink: add
  a YAML spec for mptcp"), and commit 9d1ed17f93ce ("uapi: mptcp: use
  header file generated from YAML spec"), which are not in this version.
  Applying the same modifications, but only in mptcp.h.
  Conflict in pm_netlink.c, because of a difference in the context,
  introduced by commit b9f4554356f6 ("mptcp: annotate lockless access
  for token"), which is not in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h |    6 ++++--
 net/mptcp/pm_netlink.c     |    7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -81,6 +81,8 @@ enum {
 
 #define MPTCP_PM_ADDR_ATTR_MAX (__MPTCP_PM_ADDR_ATTR_MAX - 1)
 
+#define MPTCP_PM_EV_FLAG_DENY_JOIN_ID0		_BITUL(0)
+
 #define MPTCP_PM_ADDR_FLAG_SIGNAL			(1 << 0)
 #define MPTCP_PM_ADDR_FLAG_SUBFLOW			(1 << 1)
 #define MPTCP_PM_ADDR_FLAG_BACKUP			(1 << 2)
@@ -127,13 +129,13 @@ struct mptcp_info {
 
 /*
  * MPTCP_EVENT_CREATED: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *                      sport, dport
+ *                      sport, dport, server-side, [flags]
  * A new MPTCP connection has been created. It is the good time to allocate
  * memory and send ADD_ADDR if needed. Depending on the traffic-patterns
  * it can take a long time until the MPTCP_EVENT_ESTABLISHED is sent.
  *
  * MPTCP_EVENT_ESTABLISHED: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *			    sport, dport
+ *			    sport, dport, server-side, [flags]
  * A MPTCP connection is established (can start new subflows).
  *
  * MPTCP_EVENT_CLOSED: token
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2242,6 +2242,7 @@ static int mptcp_event_created(struct sk
 			       const struct sock *ssk)
 {
 	int err = nla_put_u32(skb, MPTCP_ATTR_TOKEN, msk->token);
+	u16 flags = 0;
 
 	if (err)
 		return err;
@@ -2249,6 +2250,12 @@ static int mptcp_event_created(struct sk
 	if (nla_put_u8(skb, MPTCP_ATTR_SERVER_SIDE, READ_ONCE(msk->pm.server_side)))
 		return -EMSGSIZE;
 
+	if (READ_ONCE(msk->pm.remote_deny_join_id0))
+		flags |= MPTCP_PM_EV_FLAG_DENY_JOIN_ID0;
+
+	if (flags && nla_put_u16(skb, MPTCP_ATTR_FLAGS, flags))
+		return -EMSGSIZE;
+
 	return mptcp_event_add_subflow(skb, ssk);
 }
 


