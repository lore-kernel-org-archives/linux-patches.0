Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70EF225A38;
	Fri,  9 Oct 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555473; cv=none; b=mDR6LiuxsBWZUIj0IFsXwiC3W5qmPaA/GPhXmeRAzTCGIo4YZmWTUwZcSYna1FAFwBy5y0c7D4XIaI9mtIKOTgsDh9kau4DuQmXV/VhtRwRAxoGjyVDVfwnqucQUnumRiLkUQ3nQeTgKGQXD+jyC3q0ozYrmhy1l7HLtXBdDKKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555473; c=relaxed/simple;
	bh=w1IPyMAKWBTpvtLVi8y1ZSAR10Wym+4cP6hMYQq+eeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiVkceefc1Q7M6M3bYqXPngZuduNvn8Bys+WwW19ReN8m2tQkTyeMoK550yfjPcDlM3psdXdcbTcOy0FZo5s0UEBI3ybeQ1w5W9fZSlzQPZQEfWNZ82hb5TSysR7JdDa/2qdbIURRaZrdhKN67e9cPqx8E/l0hqxajMZgPqzC2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoAfeJ2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoAfeJ2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E316E1F000FF;
	Fri,  9 Oct 2026 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555471;
	bh=U/Ox9moZlsFvVSfqWXOVj7gZWfzq2XdZv6SAPFiC0RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoAfeJ2YAOD4sMrafNxhiaxb+dq+tFD2Rm+vXfAAtAlUK8mPELwfof0pYLkEnlbPN
	 PfoBTEB+L7kVrZcp+3Cx78cd7gZItlYgNHWiySe3hq1tqxklfpHNQUhRBKixTEzF+C
	 OlKPrYHkHHyEBJ/RKhqmHYn6nL9dnAbPRwOvcPbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 011/428] sched_ext: Add a size argument to scx_bpf_cid_topo() so struct scx_cid_topo can grow
Date: Fri,  9 Oct 2026 16:05:48 +0200
Message-ID: <20261009140946.287837729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 94480606a677deb68d5622cf0ded88626514b3f2 ]

scx_bpf_cid_topo() copies struct scx_cid_topo into a buffer the BPF program
sized from its own vmlinux.h while the verifier sizes the write from the
running kernel's BTF. The struct may grow and each growth then breaks every
scheduler built against the older layout, rejected at load or written past
its buffer. This is the usual hole for a struct handed to BPF, closed
elsewhere with a size argument, and it was missed here.

Take the buffer size, copy the smaller of it and the kernel's struct and set
the rest to -1. Accesses to the copy are CO-RE relocated, so the struct can
grow by appending fields, which its comment now states. The kfunc changes in
place: the cid interface is still being finalized and no released scheduler
uses the current form.

Fixes: e9b55af47edf ("sched_ext: Add topological CPU IDs (cids)")
Cc: stable@vger.kernel.org # v7.2+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/cid.c                   | 26 +++++++++++++++---------
 kernel/sched/ext/types.h                 |  4 ++++
 tools/sched_ext/include/scx/common.bpf.h |  2 +-
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/ext/cid.c b/kernel/sched/ext/cid.c
index 347fee8d88890..dfbc8d04f4cb1 100644
--- a/kernel/sched/ext/cid.c
+++ b/kernel/sched/ext/cid.c
@@ -674,30 +674,36 @@ bool scx_cmask_empty(const struct scx_cmask *m)
 /**
  * scx_bpf_cid_topo - Copy out per-cid topology info
  * @cid: cid to look up
- * @out__uninit: where to copy the topology info; fully written by this call
+ * @out: where to copy the topology info
+ * @out__sz: size of @out, the program's sizeof(struct scx_cid_topo)
  * @aux: implicit BPF argument to access bpf_prog_aux hidden from BPF progs
  *
- * Fill @out__uninit with the topology info for @cid. Trigger scx_error() if
- * @cid is out of range. If @cid is valid but in the no-topo section, all fields
- * are set to -1. All fields are also set to -1 when no cid tables have been
- * published yet, which a program may observe while racing the root enable.
+ * Fill @out with the topology info for @cid. Trigger scx_error() if @cid is out
+ * of range. If @cid is valid but in the no-topo section, all fields are set to
+ * -1. All fields are also set to -1 when no cid tables have been published yet,
+ * which a program may observe while racing the root enable.
+ *
+ * The program's struct may be older or newer than the kernel's. The smaller of
+ * @out__sz and the kernel's size is copied and the rest of @out is set to -1.
  */
-__bpf_kfunc void scx_bpf_cid_topo(s32 cid, struct scx_cid_topo *out__uninit,
+__bpf_kfunc void scx_bpf_cid_topo(s32 cid, struct scx_cid_topo *out, size_t out__sz,
 				  const struct bpf_prog_aux *aux)
 {
+	size_t len = min(out__sz, sizeof(*out));
 	struct scx_cid_topo *topo;
 	struct scx_sched *sch;
 
+	/* the error cases and fields the kernel lacks read as -1 */
+	memset(out, 0xff, out__sz);
+
 	guard(rcu)();
 
 	sch = scx_prog_sched(aux);
 	topo = rcu_dereference(scx_cid_topo);
-	if (unlikely(!sch) || !cid_valid(sch, cid) || unlikely(!topo)) {
-		*out__uninit = SCX_CID_TOPO_NEG;
+	if (unlikely(!sch) || !cid_valid(sch, cid) || unlikely(!topo))
 		return;
-	}
 
-	*out__uninit = topo[cid];
+	memcpy(out, &topo[cid], len);
 }
 
 __bpf_kfunc_end_defs();
diff --git a/kernel/sched/ext/types.h b/kernel/sched/ext/types.h
index bc74eafd43f12..0b80e40436e1c 100644
--- a/kernel/sched/ext/types.h
+++ b/kernel/sched/ext/types.h
@@ -53,6 +53,10 @@ enum scx_consts {
  * over [0, nr_cores_at_init) with no gaps. No-topo cids have all fields set
  * to -1.
  *
+ * New fields are appended, never inserted: scx_bpf_cid_topo() copies this
+ * struct out sized by the program's own layout, and an older program's copy
+ * must stay a prefix of the kernel's.
+ *
  * @core_cid: first cid of this cid's core (smt-sibling group)
  * @core_idx: global index of that core, in [0, nr_cores_at_init)
  * @llc_cid: first cid of this cid's LLC
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 5f715d69cde6d..7b19e76ebb529 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -104,7 +104,7 @@ u64 scx_bpf_now(void) __ksym __weak;
 void scx_bpf_events(struct scx_event_stats *events, size_t events__sz) __ksym __weak;
 s32 scx_bpf_cpu_to_cid(s32 cpu) __ksym __weak;
 s32 scx_bpf_cid_to_cpu(s32 cid) __ksym __weak;
-void scx_bpf_cid_topo(s32 cid, struct scx_cid_topo *out) __ksym __weak;
+void scx_bpf_cid_topo(s32 cid, struct scx_cid_topo *out, size_t out__sz) __ksym __weak;
 void scx_bpf_kick_cid(s32 cid, u64 flags) __ksym __weak;
 s32 scx_bpf_task_cid(const struct task_struct *p) __ksym __weak;
 s32 scx_bpf_this_cid(void) __ksym __weak;
-- 
2.53.0



