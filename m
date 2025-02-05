Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838D11494DF;
	Wed,  5 Feb 2025 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764648; cv=none; b=EUXCfDK4Ku1UJvFAhtSI3DacBK1asYH0RPiP4LF/wnZy3UaPQVYdoX+lPlGquy0HC9QrUSGapuXI3jw5/Scph2aaf7w6waV7e5lUE2YB+3yX4mxtRZHKnxnqCnhd3kysXnG0+i0AH0G+aWJIvfs55tdQW9+NmQywpGsa4YIS5iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764648; c=relaxed/simple;
	bh=ZYG5Aw7etZ1lx1QQ2gLgHtMcUw7Ql8Lebf9ogNoLm90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1+ReErXo+vPc1N138m2M9EG21gST2RD2+DULJqJk7RgZ7KUjkSK3Xoe6qT8+hctavvEQN6b+EHRC2gR0zUKbsL+yzC+kjrnEOL9ELj3Zist6iWSIw4qWbwDX26uYrzyTCl9Fj+AcXJDIwiPugcVr4aPfkfligF4bY88N7CoLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPYoE1Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPYoE1Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D6AC4CED1;
	Wed,  5 Feb 2025 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764648;
	bh=ZYG5Aw7etZ1lx1QQ2gLgHtMcUw7Ql8Lebf9ogNoLm90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPYoE1NuslWjYP0JxIqvhZ13ftDxpNzX0sajkbPa/zb1IfeKN2uaFnK3L9IJoIPZe
	 /qBcy/cj9r2TbBfGUBrnswgV3RYOiFphqkmJaY/MtL9ezfSrHt8y2s3h3OJhqo2kmO
	 VBeTOPMDsWX72NEeeifioHeCS0y7Ary5XHgYIcjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/393] padata: add pd get/put refcnt helper
Date: Wed,  5 Feb 2025 14:41:49 +0100
Message-ID: <20250205134427.566505951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 85ac7cfe87446..6badcbc6d3cb7 100644
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
@@ -206,7 +222,7 @@ int padata_do_parallel(struct padata_shell *ps,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	refcount_inc(&pd->refcnt);
+	padata_get_pd(pd);
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
@@ -380,8 +396,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	}
 	local_bh_enable();
 
-	if (refcount_sub_and_test(cnt, &pd->refcnt))
-		padata_free_pd(pd);
+	padata_put_pd_cnt(pd, cnt);
 }
 
 /**
@@ -678,8 +693,7 @@ static int padata_replace(struct padata_instance *pinst)
 	synchronize_rcu();
 
 	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		if (refcount_dec_and_test(&ps->opd->refcnt))
-			padata_free_pd(ps->opd);
+		padata_put_pd(ps->opd);
 
 	pinst->flags &= ~PADATA_RESET;
 
@@ -1127,8 +1141,7 @@ void padata_free_shell(struct padata_shell *ps)
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



