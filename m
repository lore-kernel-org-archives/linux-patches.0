Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C9043C04B;
	Thu, 30 Jul 2026 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421820; cv=none; b=P1XaZsKDmLchxjDwxDxhhTbFRlhKXEzcnzg5ox70mnHP3jIQ7Cyk3X72tDmJUXJqhNuJibD+a9TfZ7mekdbnn5g1ErdjjhIBJgr3/bg4LQcj2KCJKL220FmcjSj83HpWvkPvtOBxmaqPPq+s+qropgk6POA9LCIadkhpIeb4hXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421820; c=relaxed/simple;
	bh=dSRVVXXnKM7ub1rynG5YAVPiD5d/TFZCRZJO37Icjao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mijvTafPgX3yoiFfJgQ1KWZp7sEJ0pQBJVqjxaFqyQRiuVPRNP227dyIPUWYb1LNKgpKHkA3yJKBOyeH9nAf8XuFfiIIS+I9Dx1p1C6FcfGF+aWi6Lh80V//+Hd1YECxOfrQMSjto1oW8nNVUAeJbSDW9uAFHQ7I/LdvG61U+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DULjhGqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DULjhGqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8191F000E9;
	Thu, 30 Jul 2026 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421819;
	bh=rG5Kz3Un5OkIpWE4Xc9DSKhYzMGItsQkikof1zeOuCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DULjhGqrZmhGW4i/pbuMhO8RIW0ViOZeirekTVqV1+sJY7G7rQRUeC7KxW2bv6DOl
	 a/ixF9xO331PMdB1njh23LSsjb671zfZ3cPgi+fRrSFMQ6dtkYTaSdRJXMqw56B0ll
	 SuHHjNz7zhU34zuTPCkDLfZNU1Lziozw1bvBObsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 232/744] net/packet: avoid fanout hook re-registration after unregister
Date: Thu, 30 Jul 2026 16:08:25 +0200
Message-ID: <20260730141449.222390238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 50aff80475abd3533eef4320477037e6fcc6b56e ]

packet_set_ring() temporarily detaches a socket from packet delivery while
reconfiguring its ring. It records the previous running state, clears
po->num, unregisters the protocol hook when needed, drops po->bind_lock,
and later restores po->num and re-registers the hook from the saved
was_running value.

That unlocked window can race with NETDEV_UNREGISTER. The notifier can
observe the socket as not running, skip __unregister_prot_hook(), and
invalidate the per-socket binding by setting po->ifindex to -1 and clearing
po->prot_hook.dev. A one-member fanout group can still retain its shared
fanout hook device pointer. When packet_set_ring() resumes, re-registering
solely from the stale was_running state can re-add the fanout hook after
the device has been unregistered.

Treat po->ifindex == -1 as an invalidated binding after reacquiring
po->bind_lock. This is distinct from ifindex 0, the normal
unbound/wildcard state: ifindex -1 marks an existing device binding that
was invalidated when the device was unregistered. Restore po->num as
before, but do not re-register the hook if device unregister already
detached the socket.

Fixes: dc99f600698d ("packet: Add fanout support.")
Link: https://lore.kernel.org/netdev/20260701113947.23180-1-david.lee@trailofbits.com/
Signed-off-by: David Lee <david.lee@trailofbits.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260707104440.833129-1-david.lee@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8e6f3a734ba0bd..e75d2932475ac0 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4561,7 +4561,11 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	spin_lock(&po->bind_lock);
 	WRITE_ONCE(po->num, num);
-	if (was_running)
+	/*
+	 * NETDEV_UNREGISTER may have invalidated the binding while bind_lock
+	 * was dropped above.  Do not re-add a fanout hook to a dead device.
+	 */
+	if (was_running && READ_ONCE(po->ifindex) != -1)
 		register_prot_hook(sk);
 
 	spin_unlock(&po->bind_lock);
-- 
2.53.0



