Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40F7140366;
	Thu, 11 Apr 2024 10:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831841; cv=none; b=t2hg1tZKz+0dZyAxh16iyI2oCZqN7IKAZDw8iQM+iE6OKleBcT9bzy7G3Du52tpc9RYjvLha1unqmyJ4zTdtQ1YG19IiFGCF3gKfxuGOCgve409n5kXO0XkcLZGhaWZJNfx5HnBhaKJ0u5bCL/bND4/oI/g6PZqclHXLXJg3G7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831841; c=relaxed/simple;
	bh=bMixFMMfX0jWy17fpwiEGEmJ34zdLXxmM3H0SyL5cQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Edi/NpJk2RFSKAdSo1XPd9t3KzTOjyP3E3z9nd8iPO0zhaRC4coAyhm5W/SbLXfJTBd7A80bbya41RDPuoxgzDslTIiqXCIHS9cSVanFDEDyXh4V+aq3/vRqG9U4pGTEXuRCPsG78EgTwpiFvqWxDnk6ILNNWhN2cpyKUGTn6Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7xCQVmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7xCQVmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E82C433C7;
	Thu, 11 Apr 2024 10:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831841;
	bh=bMixFMMfX0jWy17fpwiEGEmJ34zdLXxmM3H0SyL5cQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7xCQVmJTbSo6jWznfe4KcPxVeF9HMgxjMUh0Tx+CcuVFKegFJodwlx1nYPFY15l+
	 uag7KXNSAYDNTQ4oRl7iKReFV/sufg5WXfdMLziIKehr9fta2bXGTnTgCCPCbjquEj
	 MDoM56ZbLVzwHZGjXB7X2d/7zjJFCYFcyeqLJMj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lillian Berry <lillian@star-ark.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/294] wireguard: netlink: check for dangling peer via is_dead instead of empty list
Date: Thu, 11 Apr 2024 11:54:29 +0200
Message-ID: <20240411095438.862667211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 55b6c738673871c9b0edae05d0c97995c1ff08c4 ]

If all peers are removed via wg_peer_remove_all(), rather than setting
peer_list to empty, the peer is added to a temporary list with a head on
the stack of wg_peer_remove_all(). If a netlink dump is resumed and the
cursored peer is one that has been removed via wg_peer_remove_all(), it
will iterate from that peer and then attempt to dump freed peers.

Fix this by instead checking peer->is_dead, which was explictly created
for this purpose. Also move up the device_update_lock lockdep assertion,
since reading is_dead relies on that.

It can be reproduced by a small script like:

    echo "Setting config..."
    ip link add dev wg0 type wireguard
    wg setconf wg0 /big-config
    (
            while true; do
                    echo "Showing config..."
                    wg showconf wg0 > /dev/null
            done
    ) &
    sleep 4
    wg setconf wg0 <(printf "[Peer]\nPublicKey=$(wg genkey)\n")

Resulting in:

    BUG: KASAN: slab-use-after-free in __lock_acquire+0x182a/0x1b20
    Read of size 8 at addr ffff88811956ec70 by task wg/59
    CPU: 2 PID: 59 Comm: wg Not tainted 6.8.0-rc2-debug+ #5
    Call Trace:
     <TASK>
     dump_stack_lvl+0x47/0x70
     print_address_description.constprop.0+0x2c/0x380
     print_report+0xab/0x250
     kasan_report+0xba/0xf0
     __lock_acquire+0x182a/0x1b20
     lock_acquire+0x191/0x4b0
     down_read+0x80/0x440
     get_peer+0x140/0xcb0
     wg_get_device_dump+0x471/0x1130

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: Lillian Berry <lillian@star-ark.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index f5bc279c9a8c2..6523f9d5a1527 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -255,17 +255,17 @@ static int wg_get_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!peers_nest)
 		goto out;
 	ret = 0;
-	/* If the last cursor was removed via list_del_init in peer_remove, then
+	lockdep_assert_held(&wg->device_update_lock);
+	/* If the last cursor was removed in peer_remove or peer_remove_all, then
 	 * we just treat this the same as there being no more peers left. The
 	 * reason is that seq_nr should indicate to userspace that this isn't a
 	 * coherent dump anyway, so they'll try again.
 	 */
 	if (list_empty(&wg->peer_list) ||
-	    (ctx->next_peer && list_empty(&ctx->next_peer->peer_list))) {
+	    (ctx->next_peer && ctx->next_peer->is_dead)) {
 		nla_nest_cancel(skb, peers_nest);
 		goto out;
 	}
-	lockdep_assert_held(&wg->device_update_lock);
 	peer = list_prepare_entry(ctx->next_peer, &wg->peer_list, peer_list);
 	list_for_each_entry_continue(peer, &wg->peer_list, peer_list) {
 		if (get_peer(peer, skb, ctx)) {
-- 
2.43.0



