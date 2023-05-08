Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92F8168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE19C433D2;
	Mon,  8 May 2023 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544334;
	bh=ee2Tf2PlDpqy3JmwMMzh4sGSIFeCaaBC7Nsyb0MvsTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6rnQu7a3aEG9I3bTaumSRDnYKjfsx4f4o6q517rq3/mVl6tlFwVqgodq1LFyuQCd
	 ofQQS0SWdVFdxxrOvBXX8HRmmxHHqfSJzWLIFy8CjGujRMBzLj9EhXMmVJXM1WJ8xl
	 Mrk4D6vs9yg1b9+2jpRt+6XL9U9av0L3chmOkuRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Vernet <void@manifault.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 349/694] bpf: Free struct bpf_cpumask in call_rcu handler
Date: Mon,  8 May 2023 11:43:04 +0200
Message-Id: <20230508094443.914625781@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Vernet <void@manifault.com>

[ Upstream commit 77473d1a962f3d4f7ba48324502b6d27b8ef2591 ]

The struct bpf_cpumask type uses the bpf_mem_cache_{alloc,free}() APIs
to allocate and free its cpumasks. The bpf_mem allocator may currently
immediately reuse some memory when its freed, without waiting for an RCU
read cycle to elapse. We want to be able to treat struct bpf_cpumask
objects as completely RCU safe.

This is necessary for two reasons:

1. bpf_cpumask_kptr_get() currently does an RCU-protected
   refcnt_inc_not_zero(). This of course assumes that the underlying
   memory is not reused, and is therefore unsafe in its current form.

2. We want to be able to get rid of bpf_cpumask_kptr_get() entirely, and
   intead use the superior kptr RCU semantics now afforded by the
   verifier.

This patch fixes (1), and enables (2), by making struct bpf_cpumask RCU
safe. A subsequent patch will update the verifier to allow struct
bpf_cpumask * pointers to be passed to KF_RCU kfuncs, and then a latter
patch will remove bpf_cpumask_kptr_get().

Fixes: 516f4d3397c9 ("bpf: Enable cpumasks to be queried and used as kptrs")
Signed-off-by: David Vernet <void@manifault.com>
Link: https://lore.kernel.org/r/20230316054028.88924-2-void@manifault.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumask.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/cpumask.c b/kernel/bpf/cpumask.c
index 2b3fbbfebdc5f..c08132caca33d 100644
--- a/kernel/bpf/cpumask.c
+++ b/kernel/bpf/cpumask.c
@@ -9,6 +9,7 @@
 /**
  * struct bpf_cpumask - refcounted BPF cpumask wrapper structure
  * @cpumask:	The actual cpumask embedded in the struct.
+ * @rcu:	The RCU head used to free the cpumask with RCU safety.
  * @usage:	Object reference counter. When the refcount goes to 0, the
  *		memory is released back to the BPF allocator, which provides
  *		RCU safety.
@@ -24,6 +25,7 @@
  */
 struct bpf_cpumask {
 	cpumask_t cpumask;
+	struct rcu_head rcu;
 	refcount_t usage;
 };
 
@@ -108,6 +110,16 @@ __bpf_kfunc struct bpf_cpumask *bpf_cpumask_kptr_get(struct bpf_cpumask **cpumas
 	return cpumask;
 }
 
+static void cpumask_free_cb(struct rcu_head *head)
+{
+	struct bpf_cpumask *cpumask;
+
+	cpumask = container_of(head, struct bpf_cpumask, rcu);
+	migrate_disable();
+	bpf_mem_cache_free(&bpf_cpumask_ma, cpumask);
+	migrate_enable();
+}
+
 /**
  * bpf_cpumask_release() - Release a previously acquired BPF cpumask.
  * @cpumask: The cpumask being released.
@@ -121,11 +133,8 @@ __bpf_kfunc void bpf_cpumask_release(struct bpf_cpumask *cpumask)
 	if (!cpumask)
 		return;
 
-	if (refcount_dec_and_test(&cpumask->usage)) {
-		migrate_disable();
-		bpf_mem_cache_free(&bpf_cpumask_ma, cpumask);
-		migrate_enable();
-	}
+	if (refcount_dec_and_test(&cpumask->usage))
+		call_rcu(&cpumask->rcu, cpumask_free_cb);
 }
 
 /**
-- 
2.39.2



