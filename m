Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19377CF08;
	Wed, 21 Feb 2024 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525550; cv=none; b=L3jRVDGpjx4L3IkyJ7E7PJzyrbHb/5VPg9PThONs58gC7Xvs4acXv0j6Svhm3M3zfBRQxaWGeBDuOFEyJXZnTOKfLogiIupN80fvRofsYz8S4xsN3/kuhGQm9selXVEO6ASSg8nje/gf6Gvbe42iEjQ4R3zo2iGgNybDv+UPlLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525550; c=relaxed/simple;
	bh=zQRsgaI6n+s9dZpZyyCrmXgR9dHV49ONaFGjcG1mnG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUK7IaR2mqry1q4bIXoNE7nCv0B3Ckk0nseMY0RtSnYaPdv6qN1oFbq2gBsmIS8lgDpJ6Nz6l6gA1J1T7gfki61FrnEJFuAP00BkboABxNLRR9j3bOU8IcZ6XkOGDTu+4vUKbhLyC3m0pcZFDQ1vIeAKM+9fRENvLMna05lTUsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RY0xZCWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RY0xZCWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CF2C433F1;
	Wed, 21 Feb 2024 14:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525549;
	bh=zQRsgaI6n+s9dZpZyyCrmXgR9dHV49ONaFGjcG1mnG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RY0xZCWZHbI1aIIYYc0RC9SfXTtbcvRqsUJ7aFKsBSUJYgWblVTepqb13By0Dewm8
	 0xIPHnBbXwpUhkMeZUkJaatRwZY1R0pM0kTW1LUtB0H78jZ/v3EAqbuxTtn3EKt4ML
	 3WZO6aTqYH0a3Gx2AwLjIA9rASLch2pAHh6EAjUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+c5da1f087c9e4ec6c933@syzkaller.appspotmail.com
Subject: [PATCH 5.4 190/267] ppp_async: limit MRU to 64K
Date: Wed, 21 Feb 2024 14:08:51 +0100
Message-ID: <20240221125946.093030650@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cb88cb53badb8aeb3955ad6ce80b07b598e310b8 ]

syzbot triggered a warning [1] in __alloc_pages():

WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp)

Willem fixed a similar issue in commit c0a2a1b0d631 ("ppp: limit MRU to 64K")

Adopt the same sanity check for ppp_async_ioctl(PPPIOCSMRU)

[1]:

 WARNING: CPU: 1 PID: 11 at mm/page_alloc.c:4543 __alloc_pages+0x308/0x698 mm/page_alloc.c:4543
Modules linked in:
CPU: 1 PID: 11 Comm: kworker/u4:0 Not tainted 6.8.0-rc2-syzkaller-g41bccc98fb79 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
Workqueue: events_unbound flush_to_ldisc
pstate: 204000c5 (nzCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __alloc_pages+0x308/0x698 mm/page_alloc.c:4543
 lr : __alloc_pages+0xc8/0x698 mm/page_alloc.c:4537
sp : ffff800093967580
x29: ffff800093967660 x28: ffff8000939675a0 x27: dfff800000000000
x26: ffff70001272ceb4 x25: 0000000000000000 x24: ffff8000939675c0
x23: 0000000000000000 x22: 0000000000060820 x21: 1ffff0001272ceb8
x20: ffff8000939675e0 x19: 0000000000000010 x18: ffff800093967120
x17: ffff800083bded5c x16: ffff80008ac97500 x15: 0000000000000005
x14: 1ffff0001272cebc x13: 0000000000000000 x12: 0000000000000000
x11: ffff70001272cec1 x10: 1ffff0001272cec0 x9 : 0000000000000001
x8 : ffff800091c91000 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 00000000ffffffff x4 : 0000000000000000 x3 : 0000000000000020
x2 : 0000000000000008 x1 : 0000000000000000 x0 : ffff8000939675e0
Call trace:
  __alloc_pages+0x308/0x698 mm/page_alloc.c:4543
  __alloc_pages_node include/linux/gfp.h:238 [inline]
  alloc_pages_node include/linux/gfp.h:261 [inline]
  __kmalloc_large_node+0xbc/0x1fc mm/slub.c:3926
  __do_kmalloc_node mm/slub.c:3969 [inline]
  __kmalloc_node_track_caller+0x418/0x620 mm/slub.c:4001
  kmalloc_reserve+0x17c/0x23c net/core/skbuff.c:590
  __alloc_skb+0x1c8/0x3d8 net/core/skbuff.c:651
  __netdev_alloc_skb+0xb8/0x3e8 net/core/skbuff.c:715
  netdev_alloc_skb include/linux/skbuff.h:3235 [inline]
  dev_alloc_skb include/linux/skbuff.h:3248 [inline]
  ppp_async_input drivers/net/ppp/ppp_async.c:863 [inline]
  ppp_asynctty_receive+0x588/0x186c drivers/net/ppp/ppp_async.c:341
  tty_ldisc_receive_buf+0x12c/0x15c drivers/tty/tty_buffer.c:390
  tty_port_default_receive_buf+0x74/0xac drivers/tty/tty_port.c:37
  receive_buf drivers/tty/tty_buffer.c:444 [inline]
  flush_to_ldisc+0x284/0x6e4 drivers/tty/tty_buffer.c:494
  process_one_work+0x694/0x1204 kernel/workqueue.c:2633
  process_scheduled_works kernel/workqueue.c:2706 [inline]
  worker_thread+0x938/0xef4 kernel/workqueue.c:2787
  kthread+0x288/0x310 kernel/kthread.c:388
  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+c5da1f087c9e4ec6c933@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240205171004.1059724-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_async.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 29a0917a81e6..34c31d6da734 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -470,6 +470,10 @@ ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
 	case PPPIOCSMRU:
 		if (get_user(val, p))
 			break;
+		if (val > U16_MAX) {
+			err = -EINVAL;
+			break;
+		}
 		if (val < PPP_MRU)
 			val = PPP_MRU;
 		ap->mru = val;
-- 
2.43.0



