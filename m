Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086191D14E4;
	Wed,  2 Oct 2024 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879344; cv=none; b=MqCcatzl7uWnMDgZH4HH+5xvgHkGu97mnnDRSyHLmt/FeJmAe8Uc1Yq8nucHogNGYvWD8GTQ90lO4/1h2nuSk0OtaBbgXIluWrsWbx1qc0cRxVdTz5EYytmzXb7ZahDqjVhgEM7o+SzkS2nndUnkwQU5Axk21gVF3n6ngVMyMso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879344; c=relaxed/simple;
	bh=FSYNh6cVQ0h90i9qc8DyKKOqqLBa4RNhOK7IAHItU04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jqy9zsVrg0/FJJzpuyugHTDorYAEXBtAIj3KO7K2n8hh0OI3Ofi8FhxmJH7mtq1/ZIJuImDctNLPZKCSDFXgOhhEylTw5SylsBqZc29s6Iqy+5kslDNswRIttdlI+LJBvr9cbRtwZ2/mmLtdj2S2RGujlt9i3J1z8jJkkRUFZ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3hclTdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3hclTdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83373C4CEC5;
	Wed,  2 Oct 2024 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879343;
	bh=FSYNh6cVQ0h90i9qc8DyKKOqqLBa4RNhOK7IAHItU04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3hclTdfy6nbY74mOmOeByBG+f5j7zZnhDIkpRFGM3BGY+eScITPJKWcZ7JcXasqG
	 LMeY2ed/TVz70PIDWSxh2JEVZNNfBw/rTSD+xmAWP/LDJdB98XbbbdZbsWJ5JgDV85
	 V8Uwn+1hQQLk+H++yM+p/Dl0aeZfMgTkACxVURSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/538] io_uring/io-wq: inherit cpuset of cgroup in io worker
Date: Wed,  2 Oct 2024 14:55:25 +0200
Message-ID: <20241002125755.618585433@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2df8d98738498..a1e31723c9ed6 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1170,7 +1170,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
-	cpumask_copy(wq->cpu_mask, cpu_possible_mask);
+	cpuset_cpus_allowed(data->task, wq->cpu_mask);
 	wq->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 	wq->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 				task_rlimit(current, RLIMIT_NPROC);
-- 
2.43.0



