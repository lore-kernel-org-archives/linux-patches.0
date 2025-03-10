Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16318FDAB;
	Mon, 10 Mar 2025 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628870; cv=none; b=R0EXwPm8K7v7Mij5/BBYNcdI6yGTLc3PhTsXk98pUcV6fTiJVO3cSU+uNUk19X2lh72DGhcfQj79h8d4GcDEMJ7cJ1P0fAfUDVCdf0eU5LfvX5mpK0Ki2z1qIOJjNRz5vtpSzWLNcE45o6Y7CNIdUnB5kTlQHGEtunDe3F8UNKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628870; c=relaxed/simple;
	bh=jbxu27sSD5GlDpLZ8O+5BKP5GsvZbVDOIdi4HxP7Pew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYGL0O42WL8YT429I8ODhbKe2QBdjUW8gJiTEBw/+B+Q/8ddLiF8j7GcU5vwIkC66e7ZJQgyZUP21iU7U1piUE/GXu71toaSJTaMVgU/jRFSbeNCDscGzjY9wHJXxvAgjqafzQ7blxkdDFiAG5gKdmC+5wvRRSYOC4ZVyygwLQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJgn5OpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJgn5OpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A11AC4CEE5;
	Mon, 10 Mar 2025 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628869;
	bh=jbxu27sSD5GlDpLZ8O+5BKP5GsvZbVDOIdi4HxP7Pew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJgn5OpL8IR/wdn6IgNB0tI5blukzXBzrConDIio3BjvMyatBf8W405fv0upxiwaj
	 tP5tV20Nk+zLuvYMsFvp86RdOLueTTMRwEejQyh1IVf3BG5EGjVtF2/uIG0jqaCc8r
	 3LJgN3E0wqsXua1mGwsmpYFIYfGC/8W/Tv4V5lao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/620] padata: avoid UAF for reorder_work
Date: Mon, 10 Mar 2025 17:59:03 +0100
Message-ID: <20250310170549.409286295@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5a1a31ce6c11..db45af7728cb2 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -344,8 +344,14 @@ static void padata_reorder(struct parallel_data *pd)
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
@@ -356,6 +362,8 @@ static void invoke_padata_reorder(struct work_struct *work)
 	pd = container_of(work, struct parallel_data, reorder_work);
 	padata_reorder(pd);
 	local_bh_enable();
+	/* Pairs with putting the reorder_work in the serial_wq */
+	padata_put_pd(pd);
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
-- 
2.39.5



