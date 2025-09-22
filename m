Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BD22F3623;
	Mon, 22 Sep 2025 19:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570054; cv=none; b=Pz8zyjYBxdEIQGuaknSpozNkhRQv/4XMkL6L+SCJ6eKE243aKL103vRTVbjEuFXgJ16rUbwLiBFmIuVF67Z22bDBpuQi67NVsDSPtaXD12pbH/WSUl/cy9rUIS78kkaxEccX3MeowQyfVnZXTxhGRCo+0YfCTz5RYVjbwn8YshE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570054; c=relaxed/simple;
	bh=Ou+IegcwJw//EYjUgkTuO3dynB9t9dSIJree1jcEl9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXR8AveVM3/aB/P96hW4qDR2AjpOe+bResx1JXAhOm7II3eO27zMFKMf8A9E9C2WVPhPmRuw0r9v6kIqO5fHXF3rSD2dMGtPurEtz3BTq8BJ/8llKL9mHU5Wz5qHx7JtN96Fu6DR4icvrFvLafuDj4ev16umFT7oariwa7T5Xw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFBgT8Zy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFBgT8Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361C7C4CEF0;
	Mon, 22 Sep 2025 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570054;
	bh=Ou+IegcwJw//EYjUgkTuO3dynB9t9dSIJree1jcEl9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFBgT8Zyuwj+Xx1Fc/cs2stBU5YIwlgmZjZsZ44O998XQJ29ZRdM711eMFSNvp+Bd
	 fV2WaNxx95Tgkn0lDFm4kTgvMB9IuqM9I7pCnwv9Q0P04gJXGd5Q3Ib5sL6kKlC1nN
	 dmU0VU+pbnPx+h8qO2zVld8b7/wfGHmchYzMUHT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Majkowski <marek@cloudflare.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 093/105] mptcp: pm: nl: announce deny-join-id0 flag
Date: Mon, 22 Sep 2025 21:30:16 +0200
Message-ID: <20250922192411.337136523@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ Conflicts in mptcp_pm.yaml, because the indentation has been modified
  in commit ec362192aa9e ("netlink: specs: fix up indentation errors"),
  which is not in this version. Applying the same modifications, but at
  a different level. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/mptcp_pm.yaml |    4 ++--
 include/uapi/linux/mptcp.h                |    2 ++
 include/uapi/linux/mptcp_pm.h             |    4 ++--
 net/mptcp/pm_netlink.c                    |    7 +++++++
 4 files changed, 13 insertions(+), 4 deletions(-)

--- a/Documentation/netlink/specs/mptcp_pm.yaml
+++ b/Documentation/netlink/specs/mptcp_pm.yaml
@@ -28,13 +28,13 @@ definitions:
         traffic-patterns it can take a long time until the
         MPTCP_EVENT_ESTABLISHED is sent.
         Attributes: token, family, saddr4 | saddr6, daddr4 | daddr6, sport,
-        dport, server-side.
+        dport, server-side, [flags].
      -
       name: established
       doc: >-
         A MPTCP connection is established (can start new subflows).
         Attributes: token, family, saddr4 | saddr6, daddr4 | daddr6, sport,
-        dport, server-side.
+        dport, server-side, [flags].
      -
       name: closed
       doc: >-
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -31,6 +31,8 @@
 #define MPTCP_INFO_FLAG_FALLBACK		_BITUL(0)
 #define MPTCP_INFO_FLAG_REMOTE_KEY_RECEIVED	_BITUL(1)
 
+#define MPTCP_PM_EV_FLAG_DENY_JOIN_ID0		_BITUL(0)
+
 #define MPTCP_PM_ADDR_FLAG_SIGNAL                      (1 << 0)
 #define MPTCP_PM_ADDR_FLAG_SUBFLOW                     (1 << 1)
 #define MPTCP_PM_ADDR_FLAG_BACKUP                      (1 << 2)
--- a/include/uapi/linux/mptcp_pm.h
+++ b/include/uapi/linux/mptcp_pm.h
@@ -16,10 +16,10 @@
  *   good time to allocate memory and send ADD_ADDR if needed. Depending on the
  *   traffic-patterns it can take a long time until the MPTCP_EVENT_ESTABLISHED
  *   is sent. Attributes: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *   sport, dport, server-side.
+ *   sport, dport, server-side, [flags].
  * @MPTCP_EVENT_ESTABLISHED: A MPTCP connection is established (can start new
  *   subflows). Attributes: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *   sport, dport, server-side.
+ *   sport, dport, server-side, [flags].
  * @MPTCP_EVENT_CLOSED: A MPTCP connection has stopped. Attribute: token.
  * @MPTCP_EVENT_ANNOUNCED: A new address has been announced by the peer.
  *   Attributes: token, rem_id, family, daddr4 | daddr6 [, dport].
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2211,6 +2211,7 @@ static int mptcp_event_created(struct sk
 			       const struct sock *ssk)
 {
 	int err = nla_put_u32(skb, MPTCP_ATTR_TOKEN, READ_ONCE(msk->token));
+	u16 flags = 0;
 
 	if (err)
 		return err;
@@ -2218,6 +2219,12 @@ static int mptcp_event_created(struct sk
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
 


