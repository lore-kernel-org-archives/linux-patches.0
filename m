Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E782BAF9;
	Wed,  2 Oct 2024 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877550; cv=none; b=ovbC0z3XBLAGeQMrruwR7b71NuzD40G8J6IaTsJGF2pzK7JdZ7TzOEq3d9bA8c59BAIHvaXesnwLbFLix5oCsRzSu1qy8sQIuE4VL52tkysLP8P+RdZddf3eqSByKvfMXjP1f3ZGGMu4r6pyXsL5hhWBM/0U6kaflFLVTqA0nKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877550; c=relaxed/simple;
	bh=pdxB6Qng8osDVFLwjA2RWbeTtgKpNGZ41t9563qVmHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2p+UoxTPRbsdSB8UyvNCvROLMQMlKfoaBoajbquTquC2Wbjx7H26viXext/mBrljJMOQIrZYyf0a4lVQ0+dHhFbvtzVj84y9GZZNScHDToEAB26qocs5boh3j9D5wqSDMVKP5Vukpzg+2Yw3QhPiiBKnbHlXf0kxM0RYMOiCuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RjvITRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RjvITRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70287C4CEC2;
	Wed,  2 Oct 2024 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877549;
	bh=pdxB6Qng8osDVFLwjA2RWbeTtgKpNGZ41t9563qVmHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RjvITRbNZywpeeF4WVMiwhFCpujBsTk7mZFE72Km8Clgzn8i02nncgztfEPVcSFk
	 8QLtWJO2Xzudf5RaF1cvsdC4gGbU44bMwwtQyUEtImtZj/SE4CSCLcIlMCv8ma3WG4
	 YXNXSgeVlWEbPahJOK0HVHLxL7k+QdD8X1mebCo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 115/634] io_uring/io-wq: inherit cpuset of cgroup in io worker
Date: Wed,  2 Oct 2024 14:53:35 +0200
Message-ID: <20241002125815.651940765@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Moessbauer <felix.moessbauer@siemens.com>

[ Upstream commit 84eacf177faa605853c58e5b1c0d9544b88c16fd ]

The io worker threads are userland threads that just never exit to the
userland. By that, they are also assigned to a cgroup (the group of the
creating task).

When creating a new io worker, this worker should inherit the cpuset
of the cgroup.

Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240910171157.166423-3-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index e38bbd07563ee..b59a1bf844cf9 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1167,7 +1167,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
-	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
+	cpuset_cpus_allowed(data->task, wq->cpu_mask);
 	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
-- 
2.43.0



