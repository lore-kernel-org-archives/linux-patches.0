Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919292E7379;
	Thu, 28 May 2026 20:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000049; cv=none; b=N0eCKGQpeR95AE/fH3M71gDeajXPLpzdQYhbaihDf6W8ok5RLQ2pNBKc+qAX7d5f+gehACk+RfiaIxBassUj+Du7Gl0YF4krwTMZzmsasDJvol8b/+vdk5ake7A5/cg2YzZjMH5d+LymRnJEedn0uSpGwWfo6Cs55DVxwNtQZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000049; c=relaxed/simple;
	bh=noBcnNfQ2QAcFuspZIDB7HuTo8cXzYxu6c9iAVc2adU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTNqbjq2Vekn7v8S/RCIXOdSB4jeghlUxAneQxy12NW5Moiyb6P+1/Fm7SOHslJkzrnDL1m2sI5wtOyyDnTNUsMFw6FwTj+1L8/hb6ujsol9zMEfL7vXRw8ekXHvPF9gAZ7ci0tk2biQOqYRUO+N23qbtGagRM9uMM/Dgj0P3K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzksZPqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzksZPqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB0A1F000E9;
	Thu, 28 May 2026 20:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000048;
	bh=HjypbyNYFe9g7sHU0nG9pJ8sg99wOCh+qnnlhhEtj64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzksZPqI/D67iVJRydNTbfjgWl8k9ilezdhWuAaiNzGeL3XbNH88Df8n/02atZdrU
	 +gMHk8OrbG/mP/6ooim5l+YT+/DgJ8RN4irPff9e4DvxlLgDTG6/GNBOdXlHqXUgpI
	 oc0DAOoQ6rXcrIzjQt0VD0IisoFFBmXL25g+gWko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Carlier <devnexen@gmail.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/377] ovpn: respect peer refcount in CMD_NEW_PEER error path
Date: Thu, 28 May 2026 21:48:43 +0200
Message-ID: <20260528194646.605024537@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 1fef6614673ff0846d30acdeeaf3cf98bb5f6116 ]

ovpn_nl_peer_new_doit()'s error path calls ovpn_peer_release() directly
rather than ovpn_peer_put(), bypassing the kref. The accompanying
comment ("peer was not yet hashed, thus it is not used in any context")
holds for UDP but not for TCP.

For UDP, the ovpn_socket union uses the .ovpn arm and never points back
at a peer; UDP encap_recv looks up peers via the not-yet-populated
hashtables, so the new peer is unreachable until ovpn_peer_add()
publishes it.

For TCP, ovpn_socket_new() sets ovpn_sock->peer and
ovpn_tcp_socket_attach() publishes ovpn_sock via rcu_assign_sk_user_data().
>From that moment until ovpn_socket_release() detaches in the error path,
the TCP fd is fully wired: userspace recvmsg / sendmsg / close / poll
on the fd, as well as the strparser-driven ovpn_tcp_rcv() path, can
reach the peer through sk_user_data -> ovpn_sock->peer and bump its
refcount via ovpn_peer_hold().

ovpn_tcp_socket_wait_finish() (called inside ovpn_socket_release())
drains strparser and the tx work, but does not synchronize with
userspace syscall callers that already hold a peer reference. If
ovpn_nl_peer_modify() or ovpn_peer_add() returns an error while such
a caller is in flight - notably an ovpn_tcp_recvmsg() blocked in
__skb_recv_datagram() on peer->tcp.user_queue - the direct
ovpn_peer_release() destroys the peer while the caller still holds
the reference, and the eventual ovpn_peer_put() from that caller
operates on freed memory.

Replace the direct destructor call with ovpn_peer_put() so the kref
correctly defers destruction until the last reference is dropped.
In the common case where no concurrent user is present, behaviour is
unchanged: the kref hits zero immediately and ovpn_peer_release_kref()
runs the same destructor.

With this conversion ovpn_peer_release() has no callers outside peer.c
- ovpn_peer_release_kref() in the same translation unit is the only
remaining user - so make it static and drop its declaration from
peer.h.

Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/netlink.c | 8 +++++---
 drivers/net/ovpn/peer.c    | 2 +-
 drivers/net/ovpn/peer.h    | 1 -
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ovpn/netlink.c b/drivers/net/ovpn/netlink.c
index c7f3824376302..bdb56ef0c9040 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -455,10 +455,12 @@ int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
 sock_release:
 	ovpn_socket_release(peer);
 peer_release:
-	/* release right away because peer was not yet hashed, thus it is not
-	 * used in any context
+	/* For UDP, the peer is unreachable until added to the hashtables, so
+	 * dropping the initial reference is enough. For TCP, the peer may be
+	 * concurrently reachable via sk_user_data->peer until
+	 * ovpn_socket_release() detaches; rely on the refcount.
 	 */
-	ovpn_peer_release(peer);
+	ovpn_peer_put(peer);
 
 	return ret;
 }
diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 4bfcab0c8652e..a3d856724b84a 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -348,7 +348,7 @@ static void ovpn_peer_release_rcu(struct rcu_head *head)
  * ovpn_peer_release - release peer private members
  * @peer: the peer to release
  */
-void ovpn_peer_release(struct ovpn_peer *peer)
+static void ovpn_peer_release(struct ovpn_peer *peer)
 {
 	ovpn_crypto_state_release(&peer->crypto);
 	spin_lock_bh(&peer->lock);
diff --git a/drivers/net/ovpn/peer.h b/drivers/net/ovpn/peer.h
index a1423f2b09e06..4de5aeae33f7d 100644
--- a/drivers/net/ovpn/peer.h
+++ b/drivers/net/ovpn/peer.h
@@ -125,7 +125,6 @@ static inline bool ovpn_peer_hold(struct ovpn_peer *peer)
 	return kref_get_unless_zero(&peer->refcount);
 }
 
-void ovpn_peer_release(struct ovpn_peer *peer);
 void ovpn_peer_release_kref(struct kref *kref);
 
 /**
-- 
2.53.0



