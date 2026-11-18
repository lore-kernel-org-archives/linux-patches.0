Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038560;
	b=1oSXZDmQ8Qq0UU9vh5Tg1VsV1upOf2dJNmoL8vgrETLEjvn0y6+dwWE0bMghU9sf/eeb
	 e7unYTJ5bfCTt5vtn+HydXrb7IHiPw4/CzgPnu1Yw/HNNUIddrdume1KeL9G4h4Vo6Nq0
	 GoLYJc3zzGe8S0Q3o4JGCZrzNovjZd23g9MdtBsgxMe7nJEw2xZOhFG0/a7gmIJjbI0Cm
	 7c7NxxIckN2bDpdXCIzK/jJPpztR08g+EmBJZZ1U90IWXf5Pt7agxwh1q+y0JqiT4hO6F
	 wANC0yVMEbX6IRrdNIdt8osmx296zPSmzdaMQQK/M8zUoV7J3kCcn2htBcpR3fnWwwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+SuM3+eqAuEXHTsRLvfTGD/tszOO2Qfzr6eJ996+jOU=;
	b=PbGPZaw43uljvGHpEvFmmstgLpK9Dvq59c5B3CL+KWI28X4t1tG3Y08SaHxwRdJC2aWc
	 svnD7JbrQHJLju1is+/bk2CJo2QDQcV5X2PwDxu2v1LpwODr11U5h+IHZLQ/xwoTqPMpJ
	 dbq6UCXRY24vNWf5FxtGuUZ9tJZ0WfIZxANijGEKNp0Lhg7tD52EPnIwnLZG9LG0JPxp+
	 rtJHjsbwwFdRL4J1dyZv6o4h3tnndxmQEuDv5m+vTDyvQqeuO+8Lcjm2ks5Bozrz8s/8u
	 WqVq1UGGmsBarcLD8oa+kHcsvcsbMxLUIpr5Wn10DRhX4a68wiHEpkOtEUXUZnCq8/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhT7IErz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD0606A325;
	Wed, 18 Nov 2026 21:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhT7IErz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572F61F000C4;
	Wed, 18 Nov 2026 21:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038559;
	bh=+SuM3+eqAuEXHTsRLvfTGD/tszOO2Qfzr6eJ996+jOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhT7IErzpB2qzxUok0DteQ8CSBRCS1jfpvT/NVTOYuML5isi79n8aUp4Pjtq994IO
	 G1956l7QIuJg60hW2K5gCCns80ZsxafYIOsUy7Gew/ii7A5YHKCUmAsc85yw6esOst
	 dK1kGONmb8NaZURwLIjsBcG0+nYvMMOUKIEsiCBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1744/3318] f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()
Date: Wed, 18 Nov 2026 15:39:26 +0100
Message-ID: <20261118150414.180547560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a605d5d71a6d280c43c7ede9778dda63fb5c3f22 ]

f2fs_read_end_io() uses "in_task() && !irqs_disabled()" to decide
whether it is safe to sleep, the result is passed down as @in_task to:
- f2fs_put_dic() -> f2fs_free_dic() -> f2fs_release_decomp_mem()
  -> vm_unmap_ram(), which may sleep.
- f2fs_end_read_compressed_page() -> f2fs_cache_compressed_page()
  -> f2fs_grab_cache() -> f2fs_lock_cache(), which may sleep in
  wait_on_bit_lock().

However, the check still treats below task contexts as sleepable:
- with spinlock held via spin_lock(), i.e. preempt count != 0 while
  irqs are enabled.
- with BH disabled via local_bh_disable().
- inside an RCU read lock on kernels with CONFIG_PREEMPTION.
- with any spinlock held on kernels without CONFIG_PREEMPT_COUNT.

So the "sleeping function called from invalid context" issue fixed by
commit 08a7efc5b02a ("f2fs: vm_unmap_ram() may be called from an
invalid context") can still be triggered.

The block layer provides bio_in_atomic() for exactly this purpose, it
checks rcu_preempt_depth() and preemptible(), and conservatively returns
true if CONFIG_PREEMPT_COUNT is disabled, let's use it instead. The
difference is as below:

 old: intask = in_task() && !irqs_disabled()
 new: intask = !bio_in_atomic()

 Context                              | old intask     | new intask
 -------------------------------------+----------------+----------------
 Hard IRQ / softirq                   | false          | false
 IRQs disabled                        | false          | false
 spin_lock() held, IRQs enabled       | true (wrong)   | false
 BH disabled by local_bh_disable()    | true (wrong)   | false
 RCU read lock (CONFIG_PREEMPTION)    | true (wrong)   | false
 Spinlock held, w/o PREEMPT_COUNT     | true (wrong)   | false

Note that on kernels without CONFIG_PREEMPT_COUNT, bio_in_atomic()
always returns true, so dic freeing will always be offloaded to sbi->wq,
and compressed pages will not be cached in f2fs_read_end_io(); this is
the price of correctness, since there is no way to tell whether the
current context can sleep.

Cc: stable@kernel.org
Fixes: 08a7efc5b02a ("f2fs: vm_unmap_ram() may be called from an invalid context")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 28592d5267295..29c371a04b300 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -288,7 +288,7 @@ static void f2fs_read_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(bio_first_page_all(bio));
 	struct bio_post_read_ctx *ctx;
-	bool intask = in_task() && !irqs_disabled();
+	bool intask = !bio_in_atomic();
 
 	iostat_update_and_unbind_ctx(bio);
 	ctx = bio->bi_private;
-- 
2.53.0



