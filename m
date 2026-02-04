Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE483D413D;
	Wed,  4 Feb 2026 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216769; cv=none; b=bpOaBSEGIFry2/5ogP7buaywNeK6PXrTur+4LsPLa6VIHdcsRJPwHWx5rExXTb1oxU5VXJ12A1xg+WzWD3lsHx9xVHwgFaO8mPo77cp9Bq7/YXrgxcbSdd2iy+A42zUgYaoWwS1r3djRo4f+ZTfa8UK8woH3SeVg243I8HUokOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216769; c=relaxed/simple;
	bh=TRBzE80msyGAXWD7nb9cbUj9AgT3UzLfjW3vRrKPNb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5AJOaUzodtibYaaxbytIcSUKj0T7ebFOkXuBpPpCZyZbnchUsLMMrOd82Y8E5QuIg10w88LEOCmEeS6Xr4Lwk+mRAfUOZ+PWVeugi/oh1ksrrcX0HiPKVJZg7n5OR/KuMa2ups6OAeHE68cWnjEH8ohSb6QEbIYJACMjLVjE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6Qr52U5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6Qr52U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A577C4CEF7;
	Wed,  4 Feb 2026 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216768;
	bh=TRBzE80msyGAXWD7nb9cbUj9AgT3UzLfjW3vRrKPNb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6Qr52U5Z72leRl3EZSXt659xvmu/xvOw7Qo3E0urXXeC241kZm7FcOMS7HIW6jcA
	 jB6F+T50gIv64zozhS4eQC2hrFtCeJrAwk/vlIavmF3/7eOWI2exoFqJ2uGuVvVknf
	 iGSxstBH4E2cET/TqqGldh23KwlZD6zh5O+eTxv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7c134e1c3aa3283790b9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/206] ipv4: ip_gre: make ipgre_header() robust
Date: Wed,  4 Feb 2026 15:37:20 +0100
Message-ID: <20260204143858.533801760@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e67c577d89894811ce4dcd1a9ed29d8b63476667 ]

Analog to commit db5b4e39c4e6 ("ip6_gre: make ip6gre_header() robust")

Over the years, syzbot found many ways to crash the kernel
in ipgre_header() [1].

This involves team or bonding drivers ability to dynamically
change their dev->needed_headroom and/or dev->hard_header_len

In this particular crash mld_newpack() allocated an skb
with a too small reserve/headroom, and by the time mld_sendpack()
was called, syzbot managed to attach an ipgre device.

[1]
skbuff: skb_under_panic: text:ffffffff89ea3cb7 len:2030915468 put:2030915372 head:ffff888058b43000 data:ffff887fdfa6e194 tail:0x120 end:0x6c0 dev:team0
 kernel BUG at net/core/skbuff.c:213 !
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 1322 Comm: kworker/1:9 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: mld mld_ifc_work
 RIP: 0010:skb_panic+0x157/0x160 net/core/skbuff.c:213
Call Trace:
 <TASK>
  skb_under_panic net/core/skbuff.c:223 [inline]
  skb_push+0xc3/0xe0 net/core/skbuff.c:2641
  ipgre_header+0x67/0x290 net/ipv4/ip_gre.c:897
  dev_hard_header include/linux/netdevice.h:3436 [inline]
  neigh_connected_output+0x286/0x460 net/core/neighbour.c:1618
  NF_HOOK_COND include/linux/netfilter.h:307 [inline]
  ip6_output+0x340/0x550 net/ipv6/ip6_output.c:247
  NF_HOOK+0x9e/0x380 include/linux/netfilter.h:318
  mld_sendpack+0x8d4/0xe60 net/ipv6/mcast.c:1855
  mld_send_cr net/ipv6/mcast.c:2154 [inline]
  mld_ifc_work+0x83e/0xd60 net/ipv6/mcast.c:2693
  process_one_work kernel/workqueue.c:3257 [inline]
  process_scheduled_works+0xad1/0x1770 kernel/workqueue.c:3340
  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
  kthread+0x711/0x8a0 kernel/kthread.c:463
  ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Reported-by: syzbot+7c134e1c3aa3283790b9@syzkaller.appspotmail.com
Closes: https://www.spinics.net/lists/netdev/msg1147302.html
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260108190214.1667040-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index eeb48b0bb94cd..2f9f5c583dba1 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -857,10 +857,17 @@ static int ipgre_header(struct sk_buff *skb, struct net_device *dev,
 			const void *daddr, const void *saddr, unsigned int len)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct iphdr *iph;
 	struct gre_base_hdr *greh;
+	struct iphdr *iph;
+	int needed;
+
+	needed = t->hlen + sizeof(*iph);
+	if (skb_headroom(skb) < needed &&
+	    pskb_expand_head(skb, HH_DATA_ALIGN(needed - skb_headroom(skb)),
+			     0, GFP_ATOMIC))
+		return -needed;
 
-	iph = skb_push(skb, t->hlen + sizeof(*iph));
+	iph = skb_push(skb, needed);
 	greh = (struct gre_base_hdr *)(iph+1);
 	greh->flags = gre_tnl_flags_to_gre_flags(t->parms.o_flags);
 	greh->protocol = htons(type);
-- 
2.51.0



