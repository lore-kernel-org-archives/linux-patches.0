Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C5725E804;
	Tue, 11 Mar 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706477; cv=none; b=DHrM+WzsWebRNywXQ3sT3//X0LaVMhY+k3sAV6dOsRAuzCDy5Dp6ggEdjp1waVMrk3lJWNuDN8gHU7PWfLMhfoUSvyRoASDYpprnrtZrMEJqHH4Zb0m0u9M+muXD42dQAds2eiEGNXVNftjF/7b5GEuQUDiH+0odtdI8DtXXFEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706477; c=relaxed/simple;
	bh=3vkRaXB0WU7x3no64YwTaeQnsIlNHgfnjWkPFZAQEjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEpSvzS0ai/uyX76tLQw7G7q+m+KmBmDDY1Bk4iLBLb9mlGh9oFsl6yHH9htpqUw4xTFezRR5DQWuFwdKhUQkVbJsVU+3GW2JD7et/CHY7XJ2AeDoqx0lf+suOqENdn80GUFzo2ZSLxaC7NyD4GaNWawc/uEMiDsrSEVjh64BNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsHk/aIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsHk/aIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E0DC4CEE9;
	Tue, 11 Mar 2025 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706476;
	bh=3vkRaXB0WU7x3no64YwTaeQnsIlNHgfnjWkPFZAQEjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsHk/aIXkD0MuPAlMbCs1znWYDORKUvpXKkcsMavcjQatMoNUB4F9FWViSDVz8BTM
	 O17htR8dM7qkVh/+DW0SXXh2naAXNxnTEpyiSBbLO13TJtQRXmHu+aAgl6R/vDlovH
	 p5cILR8LYGzOFD1O6huEPJ5NEIt+vdpzrtgykJLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/462] padata: add pd get/put refcnt helper
Date: Tue, 11 Mar 2025 15:55:27 +0100
Message-ID: <20250311145800.761119230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit ae154202cc6a189b035359f3c4e143d5c24d5352 ]

Add helpers for pd to get/put refcnt to make code consice.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: dd7d37ccf6b1 ("padata: avoid UAF for reorder_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index e4e0121ef3da2..02bb06a2c797d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -60,6 +60,22 @@ struct padata_mt_job_state {
 static void padata_free_pd(struct parallel_data *pd);
 static void __init padata_mt_helper(struct work_struct *work);
 
+static inline void padata_get_pd(struct parallel_data *pd)
+{
+	refcount_inc(&pd->refcnt);
+}
+
+static inline void padata_put_pd_cnt(struct parallel_data *pd, int cnt)
+{
+	if (refcount_sub_and_test(cnt, &pd->refcnt))
+		padata_free_pd(pd);
+}
+
+static inline void padata_put_pd(struct parallel_data *pd)
+{
+	padata_put_pd_cnt(pd, 1);
+}
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -211,7 +227,7 @@ int padata_do_parallel(struct padata_shell *ps,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	refcount_inc(&pd->refcnt);
+	padata_get_pd(pd);
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
@@ -385,8 +401,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	}
 	local_bh_enable();
 
-	if (refcount_sub_and_test(cnt, &pd->refcnt))
-		padata_free_pd(pd);
+	padata_put_pd_cnt(pd, cnt);
 }
 
 /**
@@ -683,8 +698,7 @@ static int padata_replace(struct padata_instance *pinst)
 	synchronize_rcu();
 
 	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		if (refcount_dec_and_test(&ps->opd->refcnt))
-			padata_free_pd(ps->opd);
+		padata_put_pd(ps->opd);
 
 	pinst->flags &= ~PADATA_RESET;
 
@@ -1132,8 +1146,7 @@ void padata_free_shell(struct padata_shell *ps)
 	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
 	pd = rcu_dereference_protected(ps->pd, 1);
-	if (refcount_dec_and_test(&pd->refcnt))
-		padata_free_pd(pd);
+	padata_put_pd(pd);
 	mutex_unlock(&ps->pinst->lock);
 
 	kfree(ps);
-- 
2.39.5



