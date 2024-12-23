Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E5B13BC0C;
	Mon, 23 Dec 2024 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969840; cv=none; b=Aj8ZJmbgk4tNfXgsri7fUDVf5J/WEnffsNR29Yt9cAbusio9wAA2pP72dtF2ZZYDzdIcUrXPLl5kW4S/c9EyMGwee8Qs1alfYFGdIhDrDUUHag7JxNHWLguiZgSdJQ97e0JlONTwJHx9tT4O6EpM2I1UNMeTSatguW2BW2BtxLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969840; c=relaxed/simple;
	bh=loOyEvHO5L8u9eCpP/fp9Up7y1s90M3zyQh4/vIH2nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7KKjrQl7nD7McJ/SiyedxaVT0QfsYEMlSNndMLYPXFAFMMdw8EttOPWOSU3tT+w0Zm7qSBxGt07c8Rtb1SgkV0dsZrZ2/9UR7c9tk53zsbQQZ+hdgdsLSA1yocCAm0MNbSqmz69t5hSn7tRsDDdn5GTZyT+qZyrxG6VTcGmuog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuTjr0iF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuTjr0iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84EBC4CED3;
	Mon, 23 Dec 2024 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969840;
	bh=loOyEvHO5L8u9eCpP/fp9Up7y1s90M3zyQh4/vIH2nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuTjr0iFoXBA9Ip00M50FkRDy4xTOvl8k7F1c0gwHd8xPr1MSYOAwQjmd+Kced4OC
	 n/XCcK+9JSGtGGZGciF/Yfy8QV/9WD/gj4YatqDo3EGBgGotxk2Vrl4SmVbHgAlBh2
	 fIAt2M1z3QicLd+0EsJxHSgXyXn6zAAZ3PCFupH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4f66250f6663c0c1d67e@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Jens Axboe <axboe@kernel.dk>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 069/160] net: tun: fix tun_napi_alloc_frags()
Date: Mon, 23 Dec 2024 16:58:00 +0100
Message-ID: <20241223155411.342176205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 429fde2d81bcef0ebab002215358955704586457 upstream.

syzbot reported the following crash [1]

Issue came with the blamed commit. Instead of going through
all the iov components, we keep using the first one
and end up with a malformed skb.

[1]

kernel BUG at net/core/skbuff.c:2849 !
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 6230 Comm: syz-executor132 Not tainted 6.13.0-rc1-syzkaller-00407-g96b6fcc0ee41 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
 RIP: 0010:__pskb_pull_tail+0x1568/0x1570 net/core/skbuff.c:2848
Code: 38 c1 0f 8c 32 f1 ff ff 4c 89 f7 e8 92 96 74 f8 e9 25 f1 ff ff e8 e8 ae 09 f8 48 8b 5c 24 08 e9 eb fb ff ff e8 d9 ae 09 f8 90 <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90004cbef30 EFLAGS: 00010293
RAX: ffffffff8995c347 RBX: 00000000fffffff2 RCX: ffff88802cf45a00
RDX: 0000000000000000 RSI: 00000000fffffff2 RDI: 0000000000000000
RBP: ffff88807df0c06a R08: ffffffff8995b084 R09: 1ffff1100fbe185c
R10: dffffc0000000000 R11: ffffed100fbe185d R12: ffff888076e85d50
R13: ffff888076e85c80 R14: ffff888076e85cf4 R15: ffff888076e85c80
FS:  00007f0dca6ea6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0dca6ead58 CR3: 00000000119da000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  skb_cow_data+0x2da/0xcb0 net/core/skbuff.c:5284
  tipc_aead_decrypt net/tipc/crypto.c:894 [inline]
  tipc_crypto_rcv+0x402/0x24e0 net/tipc/crypto.c:1844
  tipc_rcv+0x57e/0x12a0 net/tipc/node.c:2109
  tipc_l2_rcv_msg+0x2bd/0x450 net/tipc/bearer.c:668
  __netif_receive_skb_list_ptype net/core/dev.c:5720 [inline]
  __netif_receive_skb_list_core+0x8b7/0x980 net/core/dev.c:5762
  __netif_receive_skb_list net/core/dev.c:5814 [inline]
  netif_receive_skb_list_internal+0xa51/0xe30 net/core/dev.c:5905
  gro_normal_list include/net/gro.h:515 [inline]
  napi_complete_done+0x2b5/0x870 net/core/dev.c:6256
  napi_complete include/linux/netdevice.h:567 [inline]
  tun_get_user+0x2ea0/0x4890 drivers/net/tun.c:1982
  tun_chr_write_iter+0x10d/0x1f0 drivers/net/tun.c:2057
 do_iter_readv_writev+0x600/0x880
  vfs_writev+0x376/0xba0 fs/read_write.c:1050
  do_writev+0x1b6/0x360 fs/read_write.c:1096
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: de4f5fed3f23 ("iov_iter: add iter_iovec() helper")
Reported-by: syzbot+4f66250f6663c0c1d67e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/675b61aa.050a0220.599f4.00bb.GAE@google.com/T/#u
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20241212222247.724674-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1481,7 +1481,7 @@ static struct sk_buff *tun_napi_alloc_fr
 	skb->truesize += skb->data_len;
 
 	for (i = 1; i < it->nr_segs; i++) {
-		const struct iovec *iov = iter_iov(it);
+		const struct iovec *iov = iter_iov(it) + i;
 		size_t fragsz = iov->iov_len;
 		struct page *page;
 		void *frag;


