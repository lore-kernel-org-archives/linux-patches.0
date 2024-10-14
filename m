Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D1555896;
	Mon, 14 Oct 2024 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918270; cv=none; b=RAGLLG7GkIOnlq/29w3YGfmyTYd9AbCXDB8vwdhxHsc54auPe8dHSYPy2ADOsdrNdJZyIhsdpCdDhOko/M7EXNszFDeXQuDAKOdiQH6PscVER7ZXgmAx9vFSizQqXm/C/n4kG+Hgw5QmxYa71Zpf1rQat1f2w11IWYK6Omb5ZU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918270; c=relaxed/simple;
	bh=8+YEurWKpDY30iQVR1muE+BEk2f0+VHpn32CePZ7Htk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KonVVhSzDBICis6VJgW8Xco7MRLm8kY0cTpWfxdkk7oxU1SphpBQBIUBqXjYHYyLE5YrguffsBKwXg7KRcGsypsYQVV7EtMuTBvLv4dUHjkwQeVykJSP57ssl+8w58rx45tIqfkqqYBj7O1HQmW4w2674wyJ0k77u6pxMAzn4Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/djmyff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/djmyff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998EC4CEC3;
	Mon, 14 Oct 2024 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918270;
	bh=8+YEurWKpDY30iQVR1muE+BEk2f0+VHpn32CePZ7Htk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/djmyff3B06FLIz7Y+fvV6uIKHUvvpfNDX+qTxTC5JyGO7/1cGQxVyZd6ko4U9ht
	 iicd4arwWT7SMylOvnf+HpaCYGm/SPI0Q+dvaG3WMsQR9MR6MO+DQLwv4xKQOUME0W
	 +bY5fXj+Xxn/ajr7yEvGUhBXxT6g8VPmoxu5IJIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 274/798] io_uring/io-wq: do not allow pinning outside of cpuset
Date: Mon, 14 Oct 2024 16:13:48 +0200
Message-ID: <20241014141228.698499647@linuxfoundation.org>
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

commit 0997aa5497c714edbb349ca366d28bd550ba3408 upstream.

The io worker threads are userland threads that just never exit to the
userland. By that, they are also assigned to a cgroup (the group of the
creating task).

When changing the affinity of the io_wq thread via syscall, we must only
allow cpumasks within the limits defined by the cpuset controller of the
cgroup (if enabled).

Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240910171157.166423-2-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/task_work.h>
 #include <linux/audit.h>
 #include <uapi/linux/io_uring.h>
@@ -1362,22 +1363,34 @@ static int io_wq_cpu_offline(unsigned in
 
 int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 {
+	cpumask_var_t allowed_mask;
+	int ret = 0;
 	int i;
 
 	if (!tctx || !tctx->io_wq)
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+		return -ENOMEM;
+	cpuset_cpus_allowed(tctx->io_wq->task, allowed_mask);
+
 	rcu_read_lock();
 	for_each_node(i) {
 		struct io_wqe *wqe = tctx->io_wq->wqes[i];
-
-		if (mask)
-			cpumask_copy(wqe->cpu_mask, mask);
-		else
-			cpumask_copy(wqe->cpu_mask, cpumask_of_node(i));
+		if (mask) {
+			if (cpumask_subset(mask, allowed_mask))
+				cpumask_copy(wqe->cpu_mask, mask);
+			else
+				ret = -EINVAL;
+		} else {
+			if (!cpumask_and(wqe->cpu_mask, cpumask_of_node(i), allowed_mask))
+				cpumask_copy(wqe->cpu_mask, allowed_mask);
+		}
 	}
 	rcu_read_unlock();
-	return 0;
+
+	free_cpumask_var(allowed_mask);
+	return ret;
 }
 
 /*


