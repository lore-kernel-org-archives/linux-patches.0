Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661A71C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5251C433C1;
	Wed, 23 Nov 2022 09:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195103;
	bh=yasaxJeOM67mU9VOff4Oun016c6zZlMpuzANz25Yr/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zC4gH46i18BbysE6GlBDCvadNnJMXFzrrq+xCLZZSKb6KwHATZt6OdUyeh9/b5sMW
	 71lBfBv1pNAkyv2hTOhO3VFcsl0eEgY9soDUHi2bCY7ubq+b4FQ0fpojPLKgyyFqOC
	 lHte9mQxc/VEtGkYLI5UtXpWC2ju5vcwEDDkNMFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baisong Zhong <zhongbaisong@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 5.4 147/156] bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()
Date: Wed, 23 Nov 2022 09:51:44 +0100
Message-Id: <20221123084603.165066528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baisong Zhong <zhongbaisong@huawei.com>

commit d3fd203f36d46aa29600a72d57a1b61af80e4a25 upstream.

We got a syzkaller problem because of aarch64 alignment fault
if KFENCE enabled. When the size from user bpf program is an odd
number, like 399, 407, etc, it will cause the struct skb_shared_info's
unaligned access. As seen below:

  BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032

  Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
   __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
   arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
   arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
   atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
   __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
   skb_clone+0xf4/0x214 net/core/skbuff.c:1481
   ____bpf_clone_redirect net/core/filter.c:2433 [inline]
   bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
   bpf_prog_d3839dd9068ceb51+0x80/0x330
   bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
   bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
   bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381

  kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=407, cache=kmalloc-512

  allocated by task 15074 on cpu 0 at 1342.585390s:
   kmalloc include/linux/slab.h:568 [inline]
   kzalloc include/linux/slab.h:675 [inline]
   bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
   bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
   __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381

To fix the problem, we adjust @size so that (@size + @hearoom) is a
multiple of SMP_CACHE_BYTES. So we make sure the struct skb_shared_info
is aligned to a cache line.

Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/bpf/20221102081620.1465154-1-zhongbaisong@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -114,6 +114,7 @@ static void *bpf_test_init(const union b
 	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
 		return ERR_PTR(-EINVAL);
 
+	size = SKB_DATA_ALIGN(size);
 	data = kzalloc(size + headroom + tailroom, GFP_USER);
 	if (!data)
 		return ERR_PTR(-ENOMEM);


