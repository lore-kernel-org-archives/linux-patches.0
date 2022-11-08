Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C33415CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042D0C433D7;
	Tue,  8 Nov 2022 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915320;
	bh=QeulpgIhMoDzDaG+n9QbTXxY0K8mVzIjaIF8xR3s8qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuoXsENHAuXzzLI7/fnbn0+MA6aGolsoCbT/d+n2/YnOjWiq4ePjygn1SCc/462uu
	 cTZWsvq8UQEijpYV4GzVGD450tHORlQJgKQNQuHdzRWbTibzv1XfqpPEOQ4gyuWnC1
	 tv7fTFRTNt/wYnGoAyeY7JzqWsyyof0DJgHxYR9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	"Denis V. Lunev" <den@openvz.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/74] net, neigh: Fix null-ptr-deref in neigh_table_clear()
Date: Tue,  8 Nov 2022 14:38:56 +0100
Message-Id: <20221108133334.877369186@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit f8017317cb0b279b8ab98b0f3901a2e0ac880dad ]

When IPv6 module gets initialized but hits an error in the middle,
kenel panic with:

KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
CPU: 1 PID: 361 Comm: insmod
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
RIP: 0010:__neigh_ifdown.isra.0+0x24b/0x370
RSP: 0018:ffff888012677908 EFLAGS: 00000202
...
Call Trace:
 <TASK>
 neigh_table_clear+0x94/0x2d0
 ndisc_cleanup+0x27/0x40 [ipv6]
 inet6_init+0x21c/0x2cb [ipv6]
 do_one_initcall+0xd3/0x4d0
 do_init_module+0x1ae/0x670
...
Kernel panic - not syncing: Fatal exception

When ipv6 initialization fails, it will try to cleanup and calls:

neigh_table_clear()
  neigh_ifdown(tbl, NULL)
    pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev == NULL))
    # dev_net(NULL) triggers null-ptr-deref.

Fix it by passing NULL to pneigh_queue_purge() in neigh_ifdown() if dev
is NULL, to make kernel not panic immediately.

Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Denis V. Lunev <den@openvz.org>
Link: https://lore.kernel.org/r/20221101121552.21890-1-chenzhongjin@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index aa81aead0a65..67820219e3b6 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -373,7 +373,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
 	pneigh_ifdown_and_unlock(tbl, dev);
-	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
 		del_timer_sync(&tbl->proxy_timer);
 	return 0;
-- 
2.35.1



