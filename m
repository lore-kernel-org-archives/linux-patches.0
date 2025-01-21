Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F21F3FFE;
	Tue, 21 Jan 2025 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482504; cv=none; b=ByGFYXMJpOxwNyl3m6oY5OtLFjpYE1NCMDwDM9lxqzJTV34TQ5vrQ5UXjIBKceD51iLG+bu6m0G/lc8xEy0dwPTosZPbt9XsTJ0aGklB4UhTKwSxYa/comkxe/Fn1GbZpoXQmN3YsS13BlnUAQ2UhjGEzc75um8ZuCbwCa/nFgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482504; c=relaxed/simple;
	bh=Z53k8x7MxsYN9nQ2n1EIe6pWVqvH+otrwKTzxFs4ZfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHJprdgd7auBD+4gGdabcAPFc+NDOHhRqqJyuvjFumJYgP8Cc7l/bktYSXVnmjKHGN0DCiQBzaO6dDIxyvcbcf0of6qVyMtQSLetb/uj2O61UEcHkIakLvaO0E6sS74yXm1p32txxq4rv4TH+7AvsSoDNHS2Di5JApJzDT4ZSiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDaHRVgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDaHRVgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A64C4CEDF;
	Tue, 21 Jan 2025 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482504;
	bh=Z53k8x7MxsYN9nQ2n1EIe6pWVqvH+otrwKTzxFs4ZfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDaHRVgC0aWp0abc5L5FF41t5CYSU6uhkkVXx2thE0epSFsuAhGXnmgJZwRr1x7hh
	 U0XcNppdwsQS59iEsV1asm8daORWheLpT5EW8sVc7GSuOyfkHfdS8fCDg4IlxBmMuc
	 0qMW4xDBt7wDVLBkZc+ysb/Gg3iQ2BoNQ2a3c5FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Ihor Solodrai <ihor.solodrai@pm.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/122] sched_ext: Fix dsq_local_on selftest
Date: Tue, 21 Jan 2025 18:51:58 +0100
Message-ID: <20250121174535.690648958@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit ce2b93fc1dfa1c82f2576aa571731c4e5dcc8dd7 ]

The dsp_local_on selftest expects the scheduler to fail by trying to
schedule an e.g. CPU-affine task to the wrong CPU. However, this isn't
guaranteed to happen in the 1 second window that the test is running.
Besides, it's odd to have this particular exception path tested when there
are no other tests that verify that the interface is working at all - e.g.
the test would pass if dsp_local_on interface is completely broken and fails
on any attempt.

Flip the test so that it verifies that the feature works. While at it, fix a
typo in the info message.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ihor Solodrai <ihor.solodrai@pm.me>
Link: http://lkml.kernel.org/r/Z1n9v7Z6iNJ-wKmq@slm.duckdns.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/dsp_local_on.bpf.c | 5 ++++-
 tools/testing/selftests/sched_ext/dsp_local_on.c     | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c b/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
index 6325bf76f47ee..fbda6bf546712 100644
--- a/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
+++ b/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
@@ -43,7 +43,10 @@ void BPF_STRUCT_OPS(dsp_local_on_dispatch, s32 cpu, struct task_struct *prev)
 	if (!p)
 		return;
 
-	target = bpf_get_prandom_u32() % nr_cpus;
+	if (p->nr_cpus_allowed == nr_cpus)
+		target = bpf_get_prandom_u32() % nr_cpus;
+	else
+		target = scx_bpf_task_cpu(p);
 
 	scx_bpf_dsq_insert(p, SCX_DSQ_LOCAL_ON | target, SCX_SLICE_DFL, 0);
 	bpf_task_release(p);
diff --git a/tools/testing/selftests/sched_ext/dsp_local_on.c b/tools/testing/selftests/sched_ext/dsp_local_on.c
index 472851b568548..0ff27e57fe430 100644
--- a/tools/testing/selftests/sched_ext/dsp_local_on.c
+++ b/tools/testing/selftests/sched_ext/dsp_local_on.c
@@ -34,9 +34,10 @@ static enum scx_test_status run(void *ctx)
 	/* Just sleeping is fine, plenty of scheduling events happening */
 	sleep(1);
 
-	SCX_EQ(skel->data->uei.kind, EXIT_KIND(SCX_EXIT_ERROR));
 	bpf_link__destroy(link);
 
+	SCX_EQ(skel->data->uei.kind, EXIT_KIND(SCX_EXIT_UNREG));
+
 	return SCX_TEST_PASS;
 }
 
@@ -50,7 +51,7 @@ static void cleanup(void *ctx)
 struct scx_test dsp_local_on = {
 	.name = "dsp_local_on",
 	.description = "Verify we can directly dispatch tasks to a local DSQs "
-		       "from osp.dispatch()",
+		       "from ops.dispatch()",
 	.setup = setup,
 	.run = run,
 	.cleanup = cleanup,
-- 
2.39.5



