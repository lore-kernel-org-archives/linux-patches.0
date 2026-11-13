Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591490;
	b=FMgLJJhVJR4RKjMkqgASC7fhaaJCxG49rn5pgzeq+iZQikZshjk8YDZcFliX46/baLeW
	 k9bmjFSY2OMsYjDsIoj+AgGl1bRYgF3+VyjBcCiFuXfhJmJ3SE1zjPvz9uu9mds9svkwJ
	 k7n48x+7dt/lJAGO7u+MZztKRIAo5Lf4uWdDj5n7Shh0Bq0hnno2LiXyBROLyFq32AgMY
	 OrVihthof+O+cWanmZ9JWH4VIxcUj9lZzNvyIcA9PJn33rH2n8nSE+uirJo6hay0Xi6fw
	 i/FseVsJ9zWLOgbAhfIrWJCTmPj13k0vxmHSeSmc+5ELOIEQp079T38Wc3I/usT+tQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E7YuEO+y4u+3Z+nkjzHCUVyua1cjBoypAwhvuOUSfB0=;
	b=nwmrAUtbGtvNCFzsZaq7bvUlqHZmK8GYH/7pe88rk7TnAPxLmI8opTm6BBu6l9XFsz7D
	 mky9oHd9bycPiRcKFKwQmOCgYMYwZF027QQKP5IF12+s2i3lzyTq1bowXxxn9dtHmyFEy
	 nEY+BdXCo68k+bgXg0XuR9OMOzeWqe+wsSRyl8U05y+I4s2/Y38lJ8oxEifl5qUaZuIHp
	 Ar2UrKRqsNayr7+bqeX4hWnweAFhdAhcw4nce9LJ+9jNkWCJBvnNHZXmH+WCfYZfYnFVo
	 A/2s2T5NUnepo962cgF/k4RkOD08g0RgxKqUp0q1XGo1EscqByss3sOx8BpePnn97Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxDlbxcj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9152607E069;
	Fri, 13 Nov 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxDlbxcj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EA91F000C6;
	Fri, 13 Nov 2026 17:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591490;
	bh=E7YuEO+y4u+3Z+nkjzHCUVyua1cjBoypAwhvuOUSfB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxDlbxcjJt4/aBVUhP7nJu6wrAlavB6KmJyOYFIs5dsK+F/Lt1NcDgy++QgZEVS9L
	 pHaAddeg1r1W7R3UR78PWlBtxavtjs3GKXFb64AozgkPviFuL8GeQDd6TsWHrRdBMO
	 MllA1HyWYp3JDOSe5Vx5o1ovGBDKyxJPQNqNRpIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 572/670] f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()
Date: Fri, 13 Nov 2026 10:52:16 -0500
Message-ID: <20261113153831.244252644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f0d77bcefcd31..b56e6a98e7f4b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -287,7 +287,7 @@ static void f2fs_read_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(bio_first_page_all(bio));
 	struct bio_post_read_ctx *ctx;
-	bool intask = in_task() && !irqs_disabled();
+	bool intask = !bio_in_atomic();
 
 	iostat_update_and_unbind_ctx(bio);
 	ctx = bio->bi_private;
-- 
2.53.0



