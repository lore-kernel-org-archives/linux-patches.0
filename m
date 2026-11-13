Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590697;
	b=LjUQbcSGcCAGnvGbC7Z+G7KhLy1f/4qBC+i19jvqkViklkhLb+I/fZyqSYSHr5b6n7EW
	 Wh71VXCKaP6iTfCFo5W52uciFINKfEynAVNHRNs01RuZ1e8TVMGvx+ic7LRQgF475P9MG
	 SyaI/CbaWnBglJfCgtqZrgLzhxGEBTUbA2Uh8ScDaKk9Bt5aMzGgfks8V8Xmm0vIezt7T
	 7fwf1SCyGhXs4mT+6Jq2DVRAlHhd45Pb0YIIITtLpeTKQNpxV1WDGeEqxBEBQ8CCUpSWu
	 DjPqv272quFiONNgcB6mUJ/q4/r6znuWOLP4H304gvgzoRn5YlCl9MxKn8g/z8DzJ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xO7ZXeyqeUp1MYZzy9+pWAZBwVVdniRvKPJ7lKoCtQs=;
	b=DZiBCzn1yhDAjpe12erLTzcVF7wV/qJ4aADA9BtWpGSOdRSfJKnkjR+xgFRdLm2khFge
	 gduyslGSEXRbKIg227R9WPmytgBH7x9a/i06+jfYTMfRbMvEwS+xL1bfrAJRXzq1bjJPX
	 1ZG8WsEKflwt20HiICNMfP7brIpp/n/Suf5xK4luK8TvNwpFw3ViyWF4aZ9OWhVqpLrzg
	 ViGVmXzvzTJ0/OfGVUTpsjmj+4aeCou9nWB3EZBe8guBtEznT4T2L11JddQ+2kXcj28s2
	 jekPnNaqCVd3zKKMDCllemNK8XwtE77BOdbl+KdsdCeNbsxd59u2PRknHmce4gpgAdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMe70OIP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8F606B22B;
	Fri, 13 Nov 2026 17:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMe70OIP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD8F1F000C4;
	Fri, 13 Nov 2026 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590697;
	bh=xO7ZXeyqeUp1MYZzy9+pWAZBwVVdniRvKPJ7lKoCtQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMe70OIPVjDHmwfmGbYvUqfO1Az6ui2X2QaCOjzTElPUO3a7pgbHUJqn2vbfRQ4Be
	 AjMe1J8iVCUBysdxnwgbNLzllvArfHl4FFdh1LG3YyYb6PTIRqYEGXPpx0FXz1lAAp
	 imB36l2igDANG9TRZOPCYQ7uOH83twd9uO3K0CVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 601/686] f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()
Date: Fri, 13 Nov 2026 10:52:14 -0500
Message-ID: <20261113153842.288583951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ab58d3d2235bb..868af16755109 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -288,7 +288,7 @@ static void f2fs_read_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = F2FS_F_SB(bio_first_folio_all(bio));
 	struct bio_post_read_ctx *ctx;
-	bool intask = in_task() && !irqs_disabled();
+	bool intask = !bio_in_atomic();
 
 	iostat_update_and_unbind_ctx(bio);
 	ctx = bio->bi_private;
-- 
2.53.0



