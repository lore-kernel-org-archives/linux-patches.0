Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0C1DFE2C;
	Wed, 19 Feb 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956289; cv=none; b=VacidBFklcZz2nBVVnKr2Xrf8Nx/udns0U3XmcC1BWlw3bYJZPhi/p0NNRNLaRruyvAZLAMSEg2WHgUJq13b9YTmqJZRZIxWiXL08r5NSuphflcTLfhhpVPFQGuKTr0cyLJFDuSjq6PAO6yRIurZbRdrFgDoxds5A/1uMrZOJvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956289; c=relaxed/simple;
	bh=27SlilzsyX8nJnz/sTqeaLEACo1HdZZunDJbINjz2T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfYCPO93zFuwzLLhL3gmtJocZ1GfWku5U0Cz5/6+UkpOqvqjIT0d+g5rYEwPjavzPlKSqh/PzpDNjT+Gtfvy3u+1WrzLcgYBs55/jgPmTwQGWI3i7sY96C9cjoMkhVi8M9A4j0BsCPslc3UC16ifj5SBS/3FElNnS7cYhL9/nS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPQf68Xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPQf68Xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E73C4CED1;
	Wed, 19 Feb 2025 09:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956289;
	bh=27SlilzsyX8nJnz/sTqeaLEACo1HdZZunDJbINjz2T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPQf68XphsqNVZOcA23JY7BkbNo5Sp/15UO0uQ4y21AQT4Eyvf8lrZU0jgngVIIDF
	 /oz7DcKr3ov69PJGSAh0itmDZ62khD0Warp8KpgNCWp8y9Qp6o8PcOnvV1F3YLYFJU
	 YfG/k9/WLznHkl3PoocRtD0sAHxGccImP7xmruN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/578] padata: add pd get/put refcnt helper
Date: Wed, 19 Feb 2025 09:22:13 +0100
Message-ID: <20250219082658.061362555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f3069907d497..b3f9ecb3b6711 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -47,6 +47,22 @@ struct padata_mt_job_state {
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
@@ -198,7 +214,7 @@ int padata_do_parallel(struct padata_shell *ps,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	refcount_inc(&pd->refcnt);
+	padata_get_pd(pd);
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
@@ -372,8 +388,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	}
 	local_bh_enable();
 
-	if (refcount_sub_and_test(cnt, &pd->refcnt))
-		padata_free_pd(pd);
+	padata_put_pd_cnt(pd, cnt);
 }
 
 /**
@@ -670,8 +685,7 @@ static int padata_replace(struct padata_instance *pinst)
 	synchronize_rcu();
 
 	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		if (refcount_dec_and_test(&ps->opd->refcnt))
-			padata_free_pd(ps->opd);
+		padata_put_pd(ps->opd);
 
 	pinst->flags &= ~PADATA_RESET;
 
@@ -1119,8 +1133,7 @@ void padata_free_shell(struct padata_shell *ps)
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



