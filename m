Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047009;
	b=HyuGWEyXBHDABJWo6B9d6AI8y+HKnUeKDZYsbeK5X79GDoWJH2/0rAF/B7vB4x7qMjzu
	 QZb+8Ix6KagBTO5MX993vfu08vRqbimgwft8+I3gZp7vzPsEfi4ORAzHmtNS/knUsTIbN
	 Zdwi9bFAUrBREkiMTSLK3iJ4UQIMupK0Ws0DoWjjtgHL4SLCxq2Dn2+uPNLVLQ+QA/3Ez
	 P969yf8fP5XII7nH0KdmxS33riBCKo2KTol3Tks01Szws4/2/sfYwbOdNnUq9nzkqHuCf
	 5lqkwn9HskQ5YGBJarV0sfI5Wc1bxUuxo1hktJz6gOnfS9C6KIrlHwkkJcmmkg0dztg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwErkstPhpZpoSKip50+8PvTuIiHHXJRA72ZtCj5TyM=;
	b=Ri0weACcWllCFm4m4F0bwHbrlFPDZ0AZAfcq3lrBotLLtoTjMT7bt2LfO1DxNNHtwnJp
	 o+8OnHqh1Pl++L5scjzYlkZr2THRaG5potFF6hFXGszlbAoIpTnt5g7VAxVlMFq+7yC9i
	 soZkMPQkCbA/sJPsFCNMkoYKsscYOL5iUUFKwtVzv7xUk0li//aI/6OqeRomItNrWYrGM
	 QK1Sm2NIwzOlHvNTMoxNbVJxC0FPUbVXdp3JMRVhuIe3JlCZy0xbq4cMXFnjvlUoisvnT
	 aOzgPatluQU2x/UXtlFaxv0vMaPrSXgzem5mcBvL4Aa5/KwvS7bYBchBg6mkuuvlF9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnYpjM+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2609606A332;
	Thu, 19 Nov 2026 00:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnYpjM+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F1A1F000C4;
	Thu, 19 Nov 2026 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047009;
	bh=WwErkstPhpZpoSKip50+8PvTuIiHHXJRA72ZtCj5TyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnYpjM+WdMbMpbhv70tB2C5NTFa/vBA0Il8i4ow/NDoUmT9uzc1opVXgJq5s0F2vy
	 jdfRXe3VlLIiV5iFC6f2Mql9ONvp1tpfMGLRRO3lvOjNFGXCq0nczVlAjxtIr5x/v7
	 VlBB/u4fe8GYCLu8nmvI/stOiBGgEexzlluZKLdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1485/2857] f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()
Date: Wed, 18 Nov 2026 15:41:59 +0100
Message-ID: <20261118150254.786637593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced !bio_in_atomic() with equivalent inline RCU and preemption checks because the helper is unavailable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 691f32c720a38..03265ae7f55c7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -273,7 +273,8 @@ static void f2fs_read_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(bio_first_page_all(bio));
 	struct bio_post_read_ctx *ctx;
-	bool intask = in_task() && !irqs_disabled();
+	bool intask = !(IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth()) &&
+		IS_ENABLED(CONFIG_PREEMPT_COUNT) && preemptible();
 
 	iostat_update_and_unbind_ctx(bio, 0);
 	ctx = bio->bi_private;
-- 
2.53.0



