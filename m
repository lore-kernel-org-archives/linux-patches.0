Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086F655896;
	Mon, 14 Oct 2024 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918274; cv=none; b=k3BcWP8+/eGOOkB80+WuQuJi6Gr4oRcvWhvN4Z4gE6pKVty0vW+usj7rAEVepX1BHwUcIiVo6E63WPQB5C4w8WzQSI9jFmmFkm/J1Bp7Kf5gQMHSoWC0AnobcjRi7gf9aoPv9+GEtEQyKfcFoobvWL81X2WT5t/OVuuBHXbtGho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918274; c=relaxed/simple;
	bh=IQjrxNXr9oRmzK/B1fPpe3isAfA7Vbb0P5yRcbeCo8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcli2UbEYmM3946XRAHwxkpThb/FfrA43QBVJ0WPPLkyuE543tmLHLen9RRw9aeMON8kdsEWC5x3e8hLCp6iG/6BXhMjTO+Ey0KPpRMsmiTKwdOvcGEwftWYkt7fvOD8B6YZh3o07ELxalwNgzhsw6LpFIWOQz8S/JzzGTBGSk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikS12Z8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikS12Z8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2B1C4CEC3;
	Mon, 14 Oct 2024 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918273;
	bh=IQjrxNXr9oRmzK/B1fPpe3isAfA7Vbb0P5yRcbeCo8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikS12Z8cl6q3z3pCJcDPCytzVuyaHpwmFOAlwIIwnpObu/1MN0uhxvNdpLFVr4s5T
	 TDhKu+GxBsszm7DKst5lIMnzvGMIO98OYudw5cux5im8CqQNS3BF5/GCAfw7UzOIbX
	 mXK/QcawhWn4+1eLfGXQ2HS4D4ASI/9OMT7jTNBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 275/798] io_uring/io-wq: inherit cpuset of cgroup in io worker
Date: Mon, 14 Oct 2024 16:13:49 +0200
Message-ID: <20241014141228.739018810@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Moessbauer <felix.moessbauer@siemens.com>

commit 84eacf177faa605853c58e5b1c0d9544b88c16fd upstream.

The io worker threads are userland threads that just never exit to the
userland. By that, they are also assigned to a cgroup (the group of the
creating task).

When creating a new io worker, this worker should inherit the cpuset
of the cgroup.

Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240910171157.166423-3-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1157,6 +1157,7 @@ struct io_wq *io_wq_create(unsigned boun
 {
 	int ret, node, i;
 	struct io_wq *wq;
+	cpumask_var_t allowed_mask;
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
@@ -1176,6 +1177,9 @@ struct io_wq *io_wq_create(unsigned boun
 	wq->do_work = data->do_work;
 
 	ret = -ENOMEM;
+	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+		goto err;
+	cpuset_cpus_allowed(current, allowed_mask);
 	for_each_node(node) {
 		struct io_wqe *wqe;
 		int alloc_node = node;
@@ -1188,7 +1192,8 @@ struct io_wq *io_wq_create(unsigned boun
 		wq->wqes[node] = wqe;
 		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
 			goto err;
-		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
+		if (!cpumask_and(wqe->cpu_mask, cpumask_of_node(node), allowed_mask))
+			cpumask_copy(wqe->cpu_mask, allowed_mask);
 		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
@@ -1222,6 +1227,7 @@ err:
 		free_cpumask_var(wq->wqes[node]->cpu_mask);
 		kfree(wq->wqes[node]);
 	}
+	free_cpumask_var(allowed_mask);
 err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);


