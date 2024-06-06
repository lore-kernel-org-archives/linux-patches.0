Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395EF19AD8E;
	Thu,  6 Jun 2024 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683050; cv=none; b=NX8XdX5Uc6SJbPCvEnIw31/TSHkCuVr+9gdW/6BEhyrj6gxrS4tjQNc0evoH2j1fNWCuxR0LYVG7iu7/5v/lyrlRItv45dzLCWNwreagt5JpHCkpeadJBGmtageFpPWEHuCv3Ekq5WKqBL7YpNE2KO8kisa9YSnbKyBLNXXgKCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683050; c=relaxed/simple;
	bh=Gvkz6wPLm7qt+Bbd/wqv/T4NS4rQxPLs1+2GXTLlsqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0ySyGx7zd7kORxjwUMxIno7sEcpz2lr1HZ67mKQAjSE/E2AMH8E4gTy8HRSSdgrRCsTkEQcBIDvCncT5Aqi3jEOrJf0sVMjs4SbiqDHtGny1+38p+oPMixDSZ/KXDRq5SPUOKkkbtVhoc0E1KNTIen55hQgvgQsd9vCBOp3aeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BW3vEbl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BW3vEbl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB0DC4AF17;
	Thu,  6 Jun 2024 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683050;
	bh=Gvkz6wPLm7qt+Bbd/wqv/T4NS4rQxPLs1+2GXTLlsqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BW3vEbl3npYAlsq/2ZnWq3jZDblvTDY6ggSvX+I1xjdXhUBzJ8hLp8ZXhqowQGsmb
	 q0XRSPXCmb2Bu7H+Ud/nU5CQun8N7wTPTzQ22hqHPmvlfE7C1j0IShzDK2vlOdncXk
	 oxDVuCu0BJ5aLo3w8yNQTiahTIm9LuUeK9QIVv9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 289/374] dma-mapping: benchmark: fix node id validation
Date: Thu,  6 Jun 2024 16:04:28 +0200
Message-ID: <20240606131701.574688164@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 1ff05e723f7ca30644b8ec3fb093f16312e408ad ]

While validating node ids in map_benchmark_ioctl(), node_possible() may
be provided with invalid argument outside of [0,MAX_NUMNODES-1] range
leading to:

BUG: KASAN: wild-memory-access in map_benchmark_ioctl (kernel/dma/map_benchmark.c:214)
Read of size 8 at addr 1fffffff8ccb6398 by task dma_map_benchma/971
CPU: 7 PID: 971 Comm: dma_map_benchma Not tainted 6.9.0-rc6 #37
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
 <TASK>
dump_stack_lvl (lib/dump_stack.c:117)
kasan_report (mm/kasan/report.c:603)
kasan_check_range (mm/kasan/generic.c:189)
variable_test_bit (arch/x86/include/asm/bitops.h:227) [inline]
arch_test_bit (arch/x86/include/asm/bitops.h:239) [inline]
_test_bit at (include/asm-generic/bitops/instrumented-non-atomic.h:142) [inline]
node_state (include/linux/nodemask.h:423) [inline]
map_benchmark_ioctl (kernel/dma/map_benchmark.c:214)
full_proxy_unlocked_ioctl (fs/debugfs/file.c:333)
__x64_sys_ioctl (fs/ioctl.c:890)
do_syscall_64 (arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Compare node ids with sane bounds first. NUMA_NO_NODE is considered a
special valid case meaning that benchmarking kthreads won't be bound to a
cpuset of a given node.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 65789daa8087 ("dma-mapping: add benchmark support for streaming DMA APIs")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/map_benchmark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/map_benchmark.c b/kernel/dma/map_benchmark.c
index 2478957cf9f83..59fb3f849b351 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -212,7 +212,8 @@ static long map_benchmark_ioctl(struct file *file, unsigned int cmd,
 		}
 
 		if (map->bparam.node != NUMA_NO_NODE &&
-		    !node_possible(map->bparam.node)) {
+		    (map->bparam.node < 0 || map->bparam.node >= MAX_NUMNODES ||
+		     !node_possible(map->bparam.node))) {
 			pr_err("invalid numa node\n");
 			return -EINVAL;
 		}
-- 
2.43.0



