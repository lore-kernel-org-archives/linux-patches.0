Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413A9183CC7;
	Fri, 15 Nov 2024 07:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654009; cv=none; b=ahMOoR0ICLhA8navq61eXnZzZkha37OaM4Z/4g0L9CnbaBHkhMwbVij9hTspp6uvg875QOlql8mr8cLwN8D6vLRrWnSk+f4jwKmqmWRb4VHDxy2dEuFIFKybzoxHaaWUO313tbBq4EHFuKtakzhQVpVJKYQb1mDIKuNsz2iRLjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654009; c=relaxed/simple;
	bh=Ex1j5Mdetjsd4XeZhSN79IB9dAN1VsyqbTm5jnig4WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0Wf/bfWAnE3wHq3BTdAc0lAjtfRcDlKQ/EZZbtgYM+EQkFpFZFGdVf0a3aq4yQFp8b3SAtK7iD1ud65wbpAfCFQdNCvfuDShJyBzmqM2sPiU4RwSLizWQQ1JWBhBWXRWIrwFfGG8Onq9/pbRlPVdDG7fexLJk+88Ao4r3iRzd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vai4Wm9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vai4Wm9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB1DC4CECF;
	Fri, 15 Nov 2024 07:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654009;
	bh=Ex1j5Mdetjsd4XeZhSN79IB9dAN1VsyqbTm5jnig4WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vai4Wm9mzl6PrjZEWvqsyoZA4/+yzZFvC7DtpJGoz9n/BjHao4qEZHUo6ZL1cLj61
	 J/sx6qWAstwyMhDTTIY7LVyx8bRxG0tYESkNEHSsKAeCT8V+cRQnQ2WpZvsA+YGwW4
	 HyhiI8/vWZaHG7jBvYqROFBrmb0/joMPgHwkA9L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qun-Wei Lin <qun-wei.lin@mediatek.com>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.15 18/22] mm: krealloc: Fix MTE false alarm in __do_krealloc
Date: Fri, 15 Nov 2024 07:39:04 +0100
Message-ID: <20241115063721.833984688@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qun-Wei Lin <qun-wei.lin@mediatek.com>

commit 704573851b51808b45dae2d62059d1d8189138a2 upstream.

This patch addresses an issue introduced by commit 1a83a716ec233 ("mm:
krealloc: consider spare memory for __GFP_ZERO") which causes MTE
(Memory Tagging Extension) to falsely report a slab-out-of-bounds error.

The problem occurs when zeroing out spare memory in __do_krealloc. The
original code only considered software-based KASAN and did not account
for MTE. It does not reset the KASAN tag before calling memset, leading
to a mismatch between the pointer tag and the memory tag, resulting
in a false positive.

Example of the error:
==================================================================
swapper/0: BUG: KASAN: slab-out-of-bounds in __memset+0x84/0x188
swapper/0: Write at addr f4ffff8005f0fdf0 by task swapper/0/1
swapper/0: Pointer tag: [f4], memory tag: [fe]
swapper/0:
swapper/0: CPU: 4 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.
swapper/0: Hardware name: MT6991(ENG) (DT)
swapper/0: Call trace:
swapper/0:  dump_backtrace+0xfc/0x17c
swapper/0:  show_stack+0x18/0x28
swapper/0:  dump_stack_lvl+0x40/0xa0
swapper/0:  print_report+0x1b8/0x71c
swapper/0:  kasan_report+0xec/0x14c
swapper/0:  __do_kernel_fault+0x60/0x29c
swapper/0:  do_bad_area+0x30/0xdc
swapper/0:  do_tag_check_fault+0x20/0x34
swapper/0:  do_mem_abort+0x58/0x104
swapper/0:  el1_abort+0x3c/0x5c
swapper/0:  el1h_64_sync_handler+0x80/0xcc
swapper/0:  el1h_64_sync+0x68/0x6c
swapper/0:  __memset+0x84/0x188
swapper/0:  btf_populate_kfunc_set+0x280/0x3d8
swapper/0:  __register_btf_kfunc_id_set+0x43c/0x468
swapper/0:  register_btf_kfunc_id_set+0x48/0x60
swapper/0:  register_nf_nat_bpf+0x1c/0x40
swapper/0:  nf_nat_init+0xc0/0x128
swapper/0:  do_one_initcall+0x184/0x464
swapper/0:  do_initcall_level+0xdc/0x1b0
swapper/0:  do_initcalls+0x70/0xc0
swapper/0:  do_basic_setup+0x1c/0x28
swapper/0:  kernel_init_freeable+0x144/0x1b8
swapper/0:  kernel_init+0x20/0x1a8
swapper/0:  ret_from_fork+0x10/0x20
==================================================================

Fixes: 1a83a716ec233 ("mm: krealloc: consider spare memory for __GFP_ZERO")
Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1213,7 +1213,7 @@ static __always_inline void *__do_kreall
 		/* Zero out spare memory. */
 		if (want_init_on_alloc(flags)) {
 			kasan_disable_current();
-			memset((void *)p + new_size, 0, ks - new_size);
+			memset(kasan_reset_tag(p) + new_size, 0, ks - new_size);
 			kasan_enable_current();
 		}
 


