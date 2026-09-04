Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1058F3AE198;
	Fri,  4 Sep 2026 05:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499164; cv=none; b=GRjmKMGtD5O45Aha8FdgDlPMiMOGtA0zBCa6MHE4rczgBZ+2DQL6q4VM82zxeqXvtbklstpNEa6JgtrHlTnB3GMMlhsYNwcVFc8s0+BsZheYGOHJJvUpveFRc2EQslLYLO7fyXHZb36k7QMTLlY94PRFMYE7WAP3QcKaF9Zx5CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499164; c=relaxed/simple;
	bh=jnXhT+kMM690hxrXrTW98WmZaMMxH3ZTprENuhITX6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Weva3svXaGvY1ZscVLUiTp6UtiW0qlqZFp1iA8+WCARXQJnVAnqdF+OrhV1AQRMdK58YHv0ofWCC9SgTQu87WhSADqLAqgYNXoZSsNHuFqIDkNKym/YGPpPfGgRM8pNrmBBX+Ntfg2UWI4Q/vEdi6+bFS0jxTa5HdUf48XjMJE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRQRLh1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRQRLh1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2351F00A3D;
	Fri,  4 Sep 2026 05:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499163;
	bh=M/SB/TGfLRLoSKf9T/E6zE3PZ7pnH8xv3OVrY7Of3P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRQRLh1I4bQLnXSCtteBxJQ5htpLGuD/wdvyaSgzm8TKIzw924Yj23YV4RFCREOTu
	 J/tdYResjJxLNYtJ4lydSMwHGEHjuwtyrL1VrN8ydlseMHzHCcjw3CUIQBZA7pmJsc
	 0LSmB8GITWi1j/tIU+nHzsUhPcEahl3FNHy0p4/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <borkmann@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 7.2 321/713] bpf: Disable preemption in __bpf_get_stack
Date: Fri,  4 Sep 2026 06:54:49 +0200
Message-ID: <20260904045811.025238838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Daniel Borkmann <borkmann@iogearbox.net>

commit b1a47b2708d4e95dbd23aee2ec83752190897b3f upstream.

get_perf_callchain() returns a per-CPU perf_callchain_entry buffer and
releases its recursion slot via put_callchain_entry() before returning,
so nothing keeps the entry reserved while __bpf_get_stack() consumes
it below.

A preemptible BPF program (e.g. a non-sleepable raw tracepoint program
on a PREEMPT kernel, which runs under migrate_disable() but not
preempt_disable()) can be scheduled out between obtaining the entry
and the copy. Another task scheduled on the same CPU then reuses the
same per-CPU buffer and overwrites trace->nr with a larger value.
copy_len is then computed from the inflated trace->nr and can exceed
the caller's buffer, causing an out-of-bounds write in the memcpy()
and in the build_id path.

The rcu_read_lock() taken here alone does not prevent this. It is
only taken on the may_fault path, and under CONFIG_PREEMPT_RCU it does
not disable preemption; it merely keeps perf's callchain buffer array
alive (freed via call_rcu()) and does nothing to stop another task
from reusing the entry.

Disable preemption around obtaining the callchain entry and copying
it into the caller's buffer, so the entry cannot be reused underneath
us and trace->nr stays bounded by max_depth. Build ID resolution may
fault and is therefore deferred until after preemption is re-enabled;
by then the instruction pointers have already been copied into buf,
so it operates only on that private copy. Note, preempt_disable() also
subsumes the buffer-lifetime guarantee the rcu_read_lock() provided,
since a preempt-disabled section is an RCU read-side critical section
for the callchain buffers' call_rcu() reclaim.

Fixes: c195651e565a ("bpf: add bpf_get_stack helper")
Reported-by: Tao Chen <chen.dylane@linux.dev>
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <borkmann@iogearbox.net>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803210149.296496-11-jolsa@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Closes: https://lore.kernel.org/bpf/20260206090653.1336687-1-chen.dylane@linux.dev/
[ changed Fixes: commit ]
---
 kernel/bpf/stackmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -718,6 +718,7 @@ static long __bpf_get_stack(struct pt_re
 
 	max_depth = stack_map_calculate_max_depth(size, elem_size, flags);
 
+	preempt_disable();
 	if (may_fault)
 		rcu_read_lock(); /* need RCU for perf's callchain below */
 
@@ -734,6 +735,7 @@ static long __bpf_get_stack(struct pt_re
 	if (unlikely(!trace) || trace->nr < skip) {
 		if (may_fault)
 			rcu_read_unlock();
+		preempt_enable();
 		goto err_fault;
 	}
 
@@ -754,6 +756,7 @@ static long __bpf_get_stack(struct pt_re
 	/* trace/ips should not be dereferenced after this point */
 	if (may_fault)
 		rcu_read_unlock();
+	preempt_enable();
 
 	if (user_build_id)
 		stack_map_get_build_id_offset(buf, trace_nr, user, may_fault);


