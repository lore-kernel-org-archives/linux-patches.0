Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CC547208D;
	Sat, 12 Sep 2026 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211494; cv=none; b=eFwYcX24ybgf9CWQUiLP/rCPVgwgS+PEyk+YJkBa+oWnr7LIMvqjoZOWDz3Z9bP7iLqgkUH9tDHdqBRNNJCV/AI4B+oK1FLZKjfE0bKPnw6ctRUQ3dpG21bvWkhBdJduQT3AvegttVYQKPDA2ZqLXuYZh5E3gibTfYuWt7hBcL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211494; c=relaxed/simple;
	bh=+bCZyYQcNnzdKeg+d4G+LGflvBbv5kDcYAOI8vrpbTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAqDM68yN5KiOVyh8HSdDw+HPQLfyKdlNOf4npUSWTXNRLKlqQKTDcNqUxqTQXoUl9Zg+o+LvtklO6oEaZFOcqVPPbD5iw2ZOB4JcRbsIt4HiNUCKl0DKwe/dNmCP4x53mKXlpAMeN4jdfNhSbouBY+IJIP9mxsCjzRNg8gf6Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Jwch+wN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Jwch+wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F9A1F000FF;
	Sat, 12 Sep 2026 11:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211493;
	bh=tqC5XI0RRc2W2STWlvh72jFLiCiWsHRnQxmXbt9ScII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Jwch+wNhyZUcIRrSq80++B4j+f45X7LMz+fDW7eP7waFjEnizoeIAUjr9GSMAN+2
	 jA3VLDonwqxxnjSaPFRVNRE9uIdsuNi6VCTC/Ju0oQJydeD7l897Kc31qK4vEVI4rc
	 EaKBtHL6NEWkTNu9Okop/v1unk72Zp00dqyt+HEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Blaszczyk <michalblk@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1199/1518] selftests/sched_ext: Fix flaky ddsp failure tests on busy systems
Date: Sat, 12 Sep 2026 08:56:08 +0200
Message-ID: <20260912065650.606555069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



