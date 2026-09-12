Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFC837FF60;
	Sat, 12 Sep 2026 09:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203900; cv=none; b=Zr865z2UwpDDskf3KXHtoH3Oatd66pKIb1o7qSTMQGKwDtL4Np2IH7e01Sh6UFRplfkG48Kd10D3CAoBaveagbl5rKvVREWbSJCxfdIvqwKy8iRHB7sTsFJzxKs1RKIL3LgLh9rQ4fH1vwIvcgfW6tyAcS1+Mx+Pd6A64QLfRQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203900; c=relaxed/simple;
	bh=Zon58yxZl8nM9LlUuoMjxSdvZzbZzbtaqMR3eFbqyuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP5ALnXcneZgTdlJg/v8hLBcSunIivX0v3HwQDtsBXGG2WrRQ7K/41hjGeEBdkNGdtYvQfWuhCXuGHLC6Eq9yKcHxCXQFC8fF5QE/Chj5u3fcPoZyg+4Hu2TbTerxgFgWfGPnJtIZ7PIpqa/LGgJJYKmk7Jro+g+Etl0b4+OsGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKqBL9rN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKqBL9rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB56D1F000FF;
	Sat, 12 Sep 2026 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203899;
	bh=xuv7PKpDMLDSIazPt3NZahidaX68L7nDEW6DL5tOsb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKqBL9rNENS07tK6cojU8TRi8aoyF0Xg9ETEU0P+n0eUO9nWUCXjBqe98O4TPzVM2
	 G1A/4wOOYuL0tGw1HCfGA3y8ffrdLed8a0gG36dJJRdgi9p9DbOYLql90aUng/9nXM
	 bpbx0dfTuCsw/+6dzsyU9MPazgjMc96ITvNIdt74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Blaszczyk <michalblk@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1465/1815] selftests/sched_ext: Fix flaky ddsp failure tests on busy systems
Date: Sat, 12 Sep 2026 08:53:35 +0200
Message-ID: <20260912065723.401735612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Blaszczyk <michalblk@google.com>

[ Upstream commit e72979d3264a87a6a2dfb44fe0f5723a17d2ef84 ]

The ddsp_vtimelocal_fail and ddsp_bogus_dsq_fail tests skip calling
scx_bpf_dsq_insert_vtime() if scx_bpf_pick_idle_cpu() fails to find an idle
CPU (returns a negative error code). On loaded systems, this results in the
tests skipping the very assertions they are meant to verify.

Eliminate this flakiness by falling back to prev_cpu if no idle CPU is
found, ensuring the illegal dispatch operations are unconditionally
attempted and tested.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Signed-off-by: Michal Blaszczyk <michalblk@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sched_ext/ddsp_bogus_dsq_fail.bpf.c       | 20 +++++++++----------
 .../sched_ext/ddsp_vtimelocal_fail.bpf.c      | 13 ++++++------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c b/tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c
index 6f4c3f5a1c5d9..7ef9de7b27ebf 100644
--- a/tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c
+++ b/tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c
@@ -14,18 +14,16 @@ s32 BPF_STRUCT_OPS(ddsp_bogus_dsq_fail_select_cpu, struct task_struct *p,
 		   s32 prev_cpu, u64 wake_flags)
 {
 	s32 cpu = scx_bpf_pick_idle_cpu(p->cpus_ptr, 0);
+	if (cpu < 0)
+		cpu = prev_cpu;
 
-	if (cpu >= 0) {
-		/*
-		 * If we dispatch to a bogus DSQ that will fall back to the
-		 * builtin global DSQ, we fail gracefully.
-		 */
-		scx_bpf_dsq_insert_vtime(p, 0xcafef00d, SCX_SLICE_DFL,
-				       p->scx.dsq_vtime, 0);
-		return cpu;
-	}
-
-	return prev_cpu;
+	/*
+	 * If we dispatch to a bogus DSQ that will fall back to the
+	 * builtin global DSQ, we fail gracefully.
+	 */
+	scx_bpf_dsq_insert_vtime(p, 0xcafef00d, SCX_SLICE_DFL,
+				 p->scx.dsq_vtime, 0);
+	return cpu;
 }
 
 void BPF_STRUCT_OPS(ddsp_bogus_dsq_fail_exit, struct scx_exit_info *ei)
diff --git a/tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c b/tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c
index e4a55027778fd..82dca4cdc0a6c 100644
--- a/tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c
+++ b/tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c
@@ -14,15 +14,14 @@ s32 BPF_STRUCT_OPS(ddsp_vtimelocal_fail_select_cpu, struct task_struct *p,
 		   s32 prev_cpu, u64 wake_flags)
 {
 	s32 cpu = scx_bpf_pick_idle_cpu(p->cpus_ptr, 0);
+	if (cpu < 0)
+		cpu = prev_cpu;
 
-	if (cpu >= 0) {
-		/* Shouldn't be allowed to vtime dispatch to a builtin DSQ. */
-		scx_bpf_dsq_insert_vtime(p, SCX_DSQ_LOCAL, SCX_SLICE_DFL,
-					 p->scx.dsq_vtime, 0);
-		return cpu;
-	}
+	/* Shouldn't be allowed to vtime dispatch to a builtin DSQ. */
+	scx_bpf_dsq_insert_vtime(p, SCX_DSQ_LOCAL, SCX_SLICE_DFL,
+				 p->scx.dsq_vtime, 0);
 
-	return prev_cpu;
+	return cpu;
 }
 
 void BPF_STRUCT_OPS(ddsp_vtimelocal_fail_exit, struct scx_exit_info *ei)
-- 
2.53.0



