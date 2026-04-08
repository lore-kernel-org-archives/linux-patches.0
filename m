Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD28347517;
	Wed,  8 Apr 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671735; cv=none; b=IfZo0IDgr8iL8zoo1qnpQwxnCPPz7m8NuHGFvt5nYdVJsaMcejgd+79Pc/OggYVVKZU+KomfDZ8HUjS5DXVNxJKX7mQTC6xFoLRxWMbIfhfO8wzzl5RZnEYF9hrSM1HAVm/l6olroTLtS8StJuNGZUjlDHD6kUwOpLKQWNjP+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671735; c=relaxed/simple;
	bh=JVD1PV65oX/R8f7rUnyO8MrzdV6XgWC6cq33JvXQm+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Qx+lOfZD+tWd19VgcwOTbzmBALUYEf/RpXc5ZlOwPCQmDS+OoJbbW1PHnnVZLusUKkfGU5R1HEW+MdJ/8NTitcbH4+C+W0A55jm/J7Vsm0LxRGiYT/ojTT/E0NygJlDro5uLBKGS0hwya7wg+1QqFtjtUV5CQyKgRuiCmplCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8A43J3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8A43J3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A1DC19421;
	Wed,  8 Apr 2026 18:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671734;
	bh=JVD1PV65oX/R8f7rUnyO8MrzdV6XgWC6cq33JvXQm+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8A43J3vaOnH+TlST/Pi443TsL6O6lVyr7ckXT7LWJNYn+QkN6FUzWJbmZs5EmW9O
	 wUKeVqWTLQbP+6cG2tIdqijgmFkxMFv09KOMc3B0sdxQw0Ap8iYrqUY2icgf32q9OQ
	 XqXh7VhKtEH/VZ75hiQdZAsqfUKwfwiTaOOQJBjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/312] net: fix fanout UAF in packet_release() via NETDEV_UP race
Date: Wed,  8 Apr 2026 19:59:23 +0200
Message-ID: <20260408175935.455372441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Yochai Eisenrich <echelonh@gmail.com>

[ Upstream commit 42156f93d123436f2a27c468f18c966b7e5db796 ]

`packet_release()` has a race window where `NETDEV_UP` can re-register a
socket into a fanout group's `arr[]` array. The re-registration is not
cleaned up by `fanout_release()`, leaving a dangling pointer in the fanout
array.
`packet_release()` does NOT zero `po->num` in its `bind_lock` section.
After releasing `bind_lock`, `po->num` is still non-zero and `po->ifindex`
still matches the bound device. A concurrent `packet_notifier(NETDEV_UP)`
that already found the socket in `sklist` can re-register the hook.
For fanout sockets, this re-registration calls `__fanout_link(sk, po)`
which adds the socket back into `f->arr[]` and increments `f->num_members`,
but does NOT increment `f->sk_ref`.

The fix sets `po->num` to zero in `packet_release` while `bind_lock` is
held to prevent NETDEV_UP from linking, preventing the race window.

This bug was found following an additional audit with Claude Code based
on CVE-2025-38617.

Fixes: ce06b03e60fc ("packet: Add helpers to register/unregister ->prot_hook")
Link: https://blog.calif.io/p/a-race-within-a-race-exploiting-cve
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260319200610.25101-1-echelonh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8c06e3e6b52b5..502d2f6de18a2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3185,6 +3185,7 @@ static int packet_release(struct socket *sock)
 
 	spin_lock(&po->bind_lock);
 	unregister_prot_hook(sk, false);
+	WRITE_ONCE(po->num, 0);
 	packet_cached_dev_reset(po);
 
 	if (po->prot_hook.dev) {
-- 
2.51.0



