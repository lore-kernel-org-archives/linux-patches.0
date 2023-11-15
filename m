Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C9F249E2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEakrOz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EA6C4E777;
	Wed, 15 Nov 2023 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081769;
	bh=diiLGakvJQhpMnYtYO9oAdQGrepP6gcF/jskHcV4QSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEakrOz8ALkRA1LT75GyCs5UBd+Px3yDAlEQB1/lN0MOvy62G/opsFyR9cGm8lHND
	 fX1blKy/bnFh3EDTfW1f+MBcMjbxAY6+oN9SXyggwExmPKgbwdFWMofWwjpo+/TwHJ
	 MJRLW1SWnM/iWKa9oKKS+S/zFs+2ut7124xeQAao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiyu Yang <xiyuyang19@fudan.edu.cn>,
	Xin Tan <tanxin.ctf@gmail.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/191] padata: Convert from atomic_t to refcount_t on parallel_data->refcnt
Date: Wed, 15 Nov 2023 15:46:29 -0500
Message-ID: <20231115204651.398347831@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit d5ee8e750c9449e9849a09ce6fb6b8adeaa66adc ]

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 7ddc21e317b3 ("padata: Fix refcnt handling in padata_free_shell()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/padata.h | 3 ++-
 kernel/padata.c        | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index a433f13fc4bf7..495b16b6b4d72 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -12,6 +12,7 @@
 #ifndef PADATA_H
 #define PADATA_H
 
+#include <linux/refcount.h>
 #include <linux/compiler_types.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
@@ -96,7 +97,7 @@ struct parallel_data {
 	struct padata_shell		*ps;
 	struct padata_list		__percpu *reorder_list;
 	struct padata_serial_queue	__percpu *squeue;
-	atomic_t			refcnt;
+	refcount_t			refcnt;
 	unsigned int			seq_nr;
 	unsigned int			processed;
 	int				cpu;
diff --git a/kernel/padata.c b/kernel/padata.c
index 11ca3ebd8b123..dc81c756da3d9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -211,7 +211,7 @@ int padata_do_parallel(struct padata_shell *ps,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	atomic_inc(&pd->refcnt);
+	refcount_inc(&pd->refcnt);
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
@@ -385,7 +385,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	}
 	local_bh_enable();
 
-	if (atomic_sub_and_test(cnt, &pd->refcnt))
+	if (refcount_sub_and_test(cnt, &pd->refcnt))
 		padata_free_pd(pd);
 }
 
@@ -598,7 +598,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	padata_init_reorder_list(pd);
 	padata_init_squeues(pd);
 	pd->seq_nr = -1;
-	atomic_set(&pd->refcnt, 1);
+	refcount_set(&pd->refcnt, 1);
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
@@ -672,7 +672,7 @@ static int padata_replace(struct padata_instance *pinst)
 	synchronize_rcu();
 
 	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		if (atomic_dec_and_test(&ps->opd->refcnt))
+		if (refcount_dec_and_test(&ps->opd->refcnt))
 			padata_free_pd(ps->opd);
 
 	pinst->flags &= ~PADATA_RESET;
-- 
2.42.0



