Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957BA1519AA;
	Wed,  5 Feb 2025 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764658; cv=none; b=Wsmdpb6pJhY7+LoKoxT8AJudfZw5zyyt7SvlbbywqU7deN0O4Zm6XMEpuayDOzsBUuk6LsePP9Wd7x1pS4E+1jEB5yHjANPWrCnC4N7TG2ite/giLhOHU1HWNM4lbx4gSjOjQ8LEYY3PdK5egcI4kez0LLF2MSI1iwcYqCJ3Ct0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764658; c=relaxed/simple;
	bh=jWOhhwYRQ0Vfo1AkrBDnpUPjBIjKCzTbUtL5r+75xOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGduDXLXZXjVke6zOW+/FC7NkR0jXAgomi2taWuFtA/P638CvbhJHzG5YVpGbLI1ASrKXYxJLHTGfmUlciGA8WgxyhecmDZYcpGM1rtQM5Awlro+Nd0piVbIohLT4hAcLnYJ4tqA4j+HvJftn0rzBezS4TePqnfjBjenYwECqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2ISTlEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2ISTlEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DDCC4CED1;
	Wed,  5 Feb 2025 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764658;
	bh=jWOhhwYRQ0Vfo1AkrBDnpUPjBIjKCzTbUtL5r+75xOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2ISTlEgz+/uDpsDvIYU5kvnAsA52fi9zCfYeWi8sjK3WJ9bunznRb+HQEUbGEIJt
	 jmlJKyWI/XjLod5dCKQbryZnwYC0kSzZfXWJ96zt0+QObGdI6o6+iRUAYfq0CkaD6y
	 tUQZj+099H7G+lxY+GlCD1312pd4hJyC6dqKHTJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/393] padata: avoid UAF for reorder_work
Date: Wed,  5 Feb 2025 14:41:50 +0100
Message-ID: <20250205134427.604416825@linuxfoundation.org>
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

[ Upstream commit dd7d37ccf6b11f3d95e797ebe4e9e886d0332600 ]

Although the previous patch can avoid ps and ps UAF for _do_serial, it
can not avoid potential UAF issue for reorder_work. This issue can
happen just as below:

crypto_request			crypto_request		crypto_del_alg
padata_do_serial
  ...
  padata_reorder
    // processes all remaining
    // requests then breaks
    while (1) {
      if (!padata)
        break;
      ...
    }

				padata_do_serial
				  // new request added
				  list_add
    // sees the new request
    queue_work(reorder_work)
				  padata_reorder
				    queue_work_on(squeue->work)
...

				<kworker context>
				padata_serial_worker
				// completes new request,
				// no more outstanding
				// requests

							crypto_del_alg
							  // free pd

<kworker context>
invoke_padata_reorder
  // UAF of pd

To avoid UAF for 'reorder_work', get 'pd' ref before put 'reorder_work'
into the 'serial_wq' and put 'pd' ref until the 'serial_wq' finish.

Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6badcbc6d3cb7..071d8cad80787 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -352,8 +352,14 @@ static void padata_reorder(struct parallel_data *pd)
 	smp_mb();
 
 	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
-	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
+	if (!list_empty(&reorder->list) && padata_find_next(pd, false)) {
+		/*
+		 * Other context(eg. the padata_serial_worker) can finish the request.
+		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
+		 */
+		padata_get_pd(pd);
 		queue_work(pinst->serial_wq, &pd->reorder_work);
+	}
 }
 
 static void invoke_padata_reorder(struct work_struct *work)
@@ -364,6 +370,8 @@ static void invoke_padata_reorder(struct work_struct *work)
 	pd = container_of(work, struct parallel_data, reorder_work);
 	padata_reorder(pd);
 	local_bh_enable();
+	/* Pairs with putting the reorder_work in the serial_wq */
+	padata_put_pd(pd);
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
-- 
2.39.5



