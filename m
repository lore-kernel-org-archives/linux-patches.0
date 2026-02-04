Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC82417E0;
	Wed,  4 Feb 2026 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216331; cv=none; b=BNh75USGEjYCiAgqXACwcuhbpVV9bJ41gTpV9AjpC4LzaEDyhDKlRkvMc+9A3w2JbfMgc7AtWWXCz7xov8YNypgSnKI5wa8Iq/6KTOVVsn34eGPCUX81RfGfFecz78V0ja/CMOIWFqVBe+k+FPxCO4lhK6/Lkp3crCY4q+wZYIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216331; c=relaxed/simple;
	bh=6BVBQ8wQj3DY8csYZkTdOWrhDqybrffhL6VhgqkaJS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+F36DdBerLDsIvMe6qDjBObU850W9tR6FIPsqOOZ3FwVuHLV3Wx2QVhrCIOPMMS6KwWltdkgl1LLAnRut2UBeWVPM6bPihazlF4DpWGjRBvB34iCcxJ/GLGmRxjq1sfC/fx0OEELQBnkwgtyktAXPzc/6/LBNWLwRTVk7uy/lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5TJB+H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5TJB+H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB3AC4CEF7;
	Wed,  4 Feb 2026 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216331;
	bh=6BVBQ8wQj3DY8csYZkTdOWrhDqybrffhL6VhgqkaJS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5TJB+H1eXNYZSvElMQVQfa5nAjDC8dZ+9gx7tQ9L5ygqjJngvXyDjMrqPbUO2Zuv
	 UzTyFBK1lwmF6nhqTM6KMfXKabbGFmRTSNN3LZiTkwWusgbLqsxPbSpyYA0QKXVrJZ
	 9jV/jbIFrRBpv653GcqyA8Q/Rb8KcOODnAPCxO0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4d8c7d16b0e95c0d0f0d@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/161] gue: Fix skb memleak with inner IP protocol 0.
Date: Wed,  4 Feb 2026 15:38:38 +0100
Message-ID: <20260204143853.741288212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 9a56796ad258786d3624eef5aefba394fc9bdded ]

syzbot reported skb memleak below. [0]

The repro generated a GUE packet with its inner protocol 0.

gue_udp_recv() returns -guehdr->proto_ctype for "resubmit"
in ip_protocol_deliver_rcu(), but this only works with
non-zero protocol number.

Let's drop such packets.

Note that 0 is a valid number (IPv6 Hop-by-Hop Option).

I think it is not practical to encap HOPOPT in GUE, so once
someone starts to complain, we could pass down a resubmit
flag pointer to distinguish two zeros from the upper layer:

  * no error
  * resubmit HOPOPT

[0]
BUG: memory leak
unreferenced object 0xffff888109695a00 (size 240):
  comm "syz.0.17", pid 6088, jiffies 4294943096
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 40 c2 10 81 88 ff ff 00 00 00 00 00 00 00 00  .@..............
  backtrace (crc a84b336f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    kmem_cache_alloc_noprof+0x3b4/0x590 mm/slub.c:5270
    __build_skb+0x23/0x60 net/core/skbuff.c:474
    build_skb+0x20/0x190 net/core/skbuff.c:490
    __tun_build_skb drivers/net/tun.c:1541 [inline]
    tun_build_skb+0x4a1/0xa40 drivers/net/tun.c:1636
    tun_get_user+0xc12/0x2030 drivers/net/tun.c:1770
    tun_chr_write_iter+0x71/0x120 drivers/net/tun.c:1999
    new_sync_write fs/read_write.c:593 [inline]
    vfs_write+0x45d/0x710 fs/read_write.c:686
    ksys_write+0xa7/0x170 fs/read_write.c:738
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 37dd0247797b1 ("gue: Receive side for Generic UDP Encapsulation")
Reported-by: syzbot+4d8c7d16b0e95c0d0f0d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6965534b.050a0220.38aacd.0001.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260115172533.693652-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index b1a8e4eec3f6e..e63aa6b52460c 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -213,6 +213,9 @@ static int gue_udp_recv(struct sock *sk, struct sk_buff *skb)
 		return gue_control_message(skb, guehdr);
 
 	proto_ctype = guehdr->proto_ctype;
+	if (unlikely(!proto_ctype))
+		goto drop;
+
 	__skb_pull(skb, sizeof(struct udphdr) + hdrlen);
 	skb_reset_transport_header(skb);
 
-- 
2.51.0



