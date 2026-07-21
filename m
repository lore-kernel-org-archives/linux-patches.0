Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E35224B05;
	Tue, 21 Jul 2026 23:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674860; cv=none; b=op6iL//V0pBqQHz0E0xP2YRsiCZxx0PNZT3sdGtQeTwE+T/d9vS8G9/PaRqfARIve591kxDIKiBr2pUOygjPtRgOqEUiEoUZzXYaMHZ27INcUjp07ZUOFM/cwaML7s2YGVqW/1rnzsz0chbt96P7SnNtSKA03mfdWoGQvc0rT5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674860; c=relaxed/simple;
	bh=txPI3IQ1vi2H3PgNwcHrrM+zO6oPyCqQ/oCJ5xiuQrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW4Keb9GH87xP8wrWWiVDSU8J+ndpQYJe1F31plqpoew1qa35E9n9fS9jcaJkSltAN1R2A9SD7/ARNHyf9XZ4DFID1041UWngI3VLYMywa+zGghaRxw9CyGDB57U6n0LKyDkPFlRWGhbhYvDY9+IVJCs0+2wlk5v5yU2uks05cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guEwP3PE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guEwP3PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EC71F000E9;
	Tue, 21 Jul 2026 23:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674857;
	bh=3lqeAiS47Kly5zEb/jzCA4l96Rl5JD40qIIjxL+OKvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guEwP3PE4Fp2Sh+JYIaFKEV2M8tYs5QybksHDxoAaBGTe922nU0ID/4hFWH5gPTA6
	 /uabYErhKpvG4m/GCTdqOgPdEuJwlkY2taY8Q7gfBqacgW/MRG2GtdlJR+mCEcJ15Q
	 fq6D1N8UHi/TnPEMW6j8okZmDrZBowBG5XvdrXOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 699/699] mld: fix suspicious RCU usage in __ipv6_dev_mc_dec()
Date: Tue, 21 Jul 2026 17:27:38 +0200
Message-ID: <20260721152411.552194478@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

commit aa8caa767e319bad34a82bfce7da1ed2b9c0ed6f upstream.

__ipv6_dev_mc_dec() internally uses sleepable functions so that caller
must not acquire atomic locks. But caller, which is addrconf_verify_rtnl()
acquires rcu_read_lock_bh().
So this warning occurs in the __ipv6_dev_mc_dec().

Test commands:
    ip netns add A
    ip link add veth0 type veth peer name veth1
    ip link set veth1 netns A
    ip link set veth0 up
    ip netns exec A ip link set veth1 up
    ip a a 2001:db8::1/64 dev veth0 valid_lft 2 preferred_lft 1

Splat looks like:
============================
WARNING: suspicious RCU usage
5.12.0-rc6+ #515 Not tainted
-----------------------------
kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side
critical section!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
4 locks held by kworker/4:0/1997:
 #0: ffff88810bd72d48 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at:
process_one_work+0x761/0x1440
 #1: ffff888105c8fe00 ((addr_chk_work).work){+.+.}-{0:0}, at:
process_one_work+0x795/0x1440
 #2: ffffffffb9279fb0 (rtnl_mutex){+.+.}-{3:3}, at:
addrconf_verify_work+0xa/0x20
 #3: ffffffffb8e30860 (rcu_read_lock_bh){....}-{1:2}, at:
addrconf_verify_rtnl+0x23/0xc60

stack backtrace:
CPU: 4 PID: 1997 Comm: kworker/4:0 Not tainted 5.12.0-rc6+ #515
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 dump_stack+0xa4/0xe5
 ___might_sleep+0x27d/0x2b0
 __mutex_lock+0xc8/0x13f0
 ? lock_downgrade+0x690/0x690
 ? __ipv6_dev_mc_dec+0x49/0x2a0
 ? mark_held_locks+0xb7/0x120
 ? mutex_lock_io_nested+0x1270/0x1270
 ? lockdep_hardirqs_on_prepare+0x12c/0x3e0
 ? _raw_spin_unlock_irqrestore+0x47/0x50
 ? trace_hardirqs_on+0x41/0x120
 ? __wake_up_common_lock+0xc9/0x100
 ? __wake_up_common+0x620/0x620
 ? memset+0x1f/0x40
 ? netlink_broadcast_filtered+0x2c4/0xa70
 ? __ipv6_dev_mc_dec+0x49/0x2a0
 __ipv6_dev_mc_dec+0x49/0x2a0
 ? netlink_broadcast_filtered+0x2f6/0xa70
 addrconf_leave_solict.part.64+0xad/0xf0
 ? addrconf_join_solict.part.63+0xf0/0xf0
 ? nlmsg_notify+0x63/0x1b0
 __ipv6_ifa_notify+0x22c/0x9c0
 ? inet6_fill_ifaddr+0xbe0/0xbe0
 ? lockdep_hardirqs_on_prepare+0x12c/0x3e0
 ? __local_bh_enable_ip+0xa5/0xf0
 ? ipv6_del_addr+0x347/0x870
 ipv6_del_addr+0x3b1/0x870
 ? addrconf_ifdown+0xfe0/0xfe0
 ? rcu_read_lock_any_held.part.27+0x20/0x20
 addrconf_verify_rtnl+0x8a9/0xc60
 addrconf_verify_work+0xf/0x20
 process_one_work+0x84c/0x1440

In order to avoid this problem, it uses rcu_read_unlock_bh() for
a short time. RCU is used for avoiding freeing
ifp(struct *inet6_ifaddr) while ifp is being used. But this will
not be released even if rcu_read_unlock_bh() is used.
Because before rcu_read_unlock_bh(), it uses in6_ifa_hold(ifp).
So this is safe.

Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4550,7 +4550,9 @@ restart:
 			    age >= ifp->valid_lft) {
 				spin_unlock(&ifp->lock);
 				in6_ifa_hold(ifp);
+				rcu_read_unlock_bh();
 				ipv6_del_addr(ifp);
+				rcu_read_lock_bh();
 				goto restart;
 			} else if (ifp->prefered_lft == INFINITY_LIFE_TIME) {
 				spin_unlock(&ifp->lock);


