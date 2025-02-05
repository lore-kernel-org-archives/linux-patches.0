Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E618C93C;
	Wed,  5 Feb 2025 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766891; cv=none; b=YqE87BOIw27vic77tqIuPaRXfmWRKLfqaPLl8dvjNKcJxfUkMkS47XnzwXiaOiE54+gKVFW84FVOAlLb31WTrSn1XYpecs6w+KVvtBncRiMXicQUiHPtBwXY/o1OFwyLEqPjD/RihUYSA6oawu/fGo0A4apJfw/WOCthciBOoV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766891; c=relaxed/simple;
	bh=emk6SCh8LaolEEC0Tm+3el0gnCDTw+Po20CtaPfNhDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7ORVG3/4KYOyiwAJwhJQeM2ULzkugqBPY08zMxTkHq4aDsAFBmVAolQ7EySP/BtZnbA7E1sIILRvwvSSfCWP8T77rucYpwdqSA1SnlJDL6Gt2XRaW3H1cbXsR+oA0udLjq9dX5VYANwkeAFtJAm7aXTDBeHmtQPHh/7j4T+8a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3BLsTKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3BLsTKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D896FC4CED1;
	Wed,  5 Feb 2025 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766890;
	bh=emk6SCh8LaolEEC0Tm+3el0gnCDTw+Po20CtaPfNhDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3BLsTKpqZJfyRa8xISdB46zRjhTE21Q8YKOjXTfFJyrOMGODyo0XWlYsAsZJHRY0
	 aNwt5Dq547yBNibd45s01mcmSYC2L1MhmZLqR3wSKILrxp9/uOeKqlPK600GE7EwIq
	 0krVmjHpDOPVgbZmJ6vh8u02IPrg5Ytl3x6UUp40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 325/623] padata: avoid UAF for reorder_work
Date: Wed,  5 Feb 2025 14:41:07 +0100
Message-ID: <20250205134508.657553862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index de2c02a81469c..418987056340e 100644
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



