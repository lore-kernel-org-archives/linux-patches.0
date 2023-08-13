Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389AB9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4283C433C8;
	Sun, 13 Aug 2023 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963074;
	bh=6rvGpatzJf0x/s1jkzkVD7adM8Q2VX3kXAf2tvDGYyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X906zFFKCjV+V5dGsaxCpLfefNEXA+zVaksJnNl5mAPmE797jNn5oVaZiaeD+PVDJ
	 q8FY8H/6H7+PeerC59NHoIqb/6c1O0OEe6KMehP6UJttJxQBQyNeoDpJHKtWsEfo2c
	 7+XqVvIP7RX+4UCi84/NQLULRGslYpvqI+15G2Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Kanner <andrew.kanner@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+f817490f5bd20541b90a@syzkaller.appspotmail.com
Subject: [PATCH 5.15 43/89] net: core: remove unnecessary frame_sz check in bpf_xdp_adjust_tail()
Date: Sun, 13 Aug 2023 23:19:34 +0200
Message-ID: <20230813211712.086724297@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Kanner <andrew.kanner@gmail.com>

commit d14eea09edf427fa36bd446f4a3271f99164202f upstream.

Syzkaller reported the following issue:
=======================================
Too BIG xdp->frame_sz = 131072
WARNING: CPU: 0 PID: 5020 at net/core/filter.c:4121
  ____bpf_xdp_adjust_tail net/core/filter.c:4121 [inline]
WARNING: CPU: 0 PID: 5020 at net/core/filter.c:4121
  bpf_xdp_adjust_tail+0x466/0xa10 net/core/filter.c:4103
...
Call Trace:
 <TASK>
 bpf_prog_4add87e5301a4105+0x1a/0x1c
 __bpf_prog_run include/linux/filter.h:600 [inline]
 bpf_prog_run_xdp include/linux/filter.h:775 [inline]
 bpf_prog_run_generic_xdp+0x57e/0x11e0 net/core/dev.c:4721
 netif_receive_generic_xdp net/core/dev.c:4807 [inline]
 do_xdp_generic+0x35c/0x770 net/core/dev.c:4866
 tun_get_user+0x2340/0x3ca0 drivers/net/tun.c:1919
 tun_chr_write_iter+0xe8/0x210 drivers/net/tun.c:2043
 call_write_iter include/linux/fs.h:1871 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x650/0xe40 fs/read_write.c:584
 ksys_write+0x12f/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

xdp->frame_sz > PAGE_SIZE check was introduced in commit c8741e2bfe87
("xdp: Allow bpf_xdp_adjust_tail() to grow packet size"). But Jesper
Dangaard Brouer <jbrouer@redhat.com> noted that after introducing the
xdp_init_buff() which all XDP driver use - it's safe to remove this
check. The original intend was to catch cases where XDP drivers have
not been updated to use xdp.frame_sz, but that is not longer a concern
(since xdp_init_buff).

Running the initial syzkaller repro it was discovered that the
contiguous physical memory allocation is used for both xdp paths in
tun_get_user(), e.g. tun_build_skb() and tun_alloc_skb(). It was also
stated by Jesper Dangaard Brouer <jbrouer@redhat.com> that XDP can
work on higher order pages, as long as this is contiguous physical
memory (e.g. a page).

Reported-and-tested-by: syzbot+f817490f5bd20541b90a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000774b9205f1d8a80d@google.com/T/
Link: https://syzkaller.appspot.com/bug?extid=f817490f5bd20541b90a
Link: https://lore.kernel.org/all/20230725155403.796-1-andrew.kanner@gmail.com/T/
Fixes: 43b5169d8355 ("net, xdp: Introduce xdp_init_buff utility routine")
Signed-off-by: Andrew Kanner <andrew.kanner@gmail.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20230803190316.2380231-1-andrew.kanner@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3843,12 +3843,6 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct x
 	if (unlikely(data_end > data_hard_end))
 		return -EINVAL;
 
-	/* ALL drivers MUST init xdp->frame_sz, chicken check below */
-	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
-		WARN_ONCE(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
-		return -EINVAL;
-	}
-
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
 


