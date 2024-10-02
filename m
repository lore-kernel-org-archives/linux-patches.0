Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F7B1D079E;
	Wed,  2 Oct 2024 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875524; cv=none; b=QpbEZ+j6vF/rNDTLFaDGV1iMIwN1aUs51GofX5wKCY/t8aloX5orybveN5TbAmyB8qEmrsHuT/VX8sExeJEfnSkDTa0R4G1UQH4U3Vf+Jqg0r35yEFCCG7+rBm73OahCKngK0SGJVik77OGuwNtfej0Rcb1PTgjsvyEv0wPJGfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875524; c=relaxed/simple;
	bh=LBMcDDnHFTW8sRyfYP4yOzxXBWKVQOidWNhGRNkR/UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq4GTPaLi4Jmh/bh/t47w/7W/Ha4d3SAOqfFKZ3hXO+bebKZs6LsLX0/+sZB7bgkYoM/B0hBJGjiYQGXJ1g2FKWTDe1eZJd6ENNZZUbKRRZjXi84FG0lCDMX0fgH6zQCXwbSpFoBdasz3E+LrHLjiOVjdqPWbV8iVXv/aymdim0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOqhdGxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOqhdGxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E05C4CECD;
	Wed,  2 Oct 2024 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875523;
	bh=LBMcDDnHFTW8sRyfYP4yOzxXBWKVQOidWNhGRNkR/UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOqhdGxgX6R57Oo+i461BnxlEaC50EishiZw14bu47yXEk8crMDCLCKm2DdFwdwtZ
	 ncJtySFojatll5ioi9rbOE1aPWcHnlY5EBVspBp92FsB0f2YAv+iGybyc5MPBL3luz
	 kTApgmxMv4ErQ6zHDE1R08lXw9QhfKaM52Q/zqUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 131/695] io_uring/io-wq: inherit cpuset of cgroup in io worker
Date: Wed,  2 Oct 2024 14:52:09 +0200
Message-ID: <20241002125827.710258244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c7055a8895d7e..a38f36b680604 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1168,7 +1168,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
-	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
+	cpuset_cpus_allowed(data->task, wq->cpu_mask);
 	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
-- 
2.43.0



