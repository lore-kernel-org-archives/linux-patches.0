Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75374563299;
	Wed,  9 Sep 2026 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961947; cv=none; b=dXgx+4Ui3KAnvcWvEoyR3sButZdHgGb6AA4m0tvek6VPbZyuxF79Mf59UCnGR9ThGAnM3ueGajJ4nbjYPWplBelN91/hMImIoQj7LF5hUtUHUpBJZ9GFEhLU1d4BwljTNzqbTUMGarHkiO9VScOhvfuUAEKrFl+rWRKPB4gP8y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961947; c=relaxed/simple;
	bh=7Owbne78Yu3lwzN5j3QRVutUCW9Pn5U7ldyL68Cyw00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCeaMAj7Vn/GE+51I1aezJbfutpLG/4dDyYJOOjfP9GRUhL7KW0ju2hQcyZZoPUzEaJ6hE8t8W0Dd51Q9rj1zOGEGvGZ0yqkq6K+F2hK9oOZkCILaNsqZhv9VDnCEsHoXBYzG+iY8m6GEcOCp3KNxJuFbwGb97jiaqFXgR7PC+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoErHX9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoErHX9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE931F00A3A;
	Wed,  9 Sep 2026 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961946;
	bh=u7W5ShmEsyFlzWxfbsnHeuFgnwDR9KbWnsW1oSKZFoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoErHX9iGEzGTbhvnMhy4e2KX9VGZD17GbNgFGkGAd+0Cf1HLzpAkUPo6Zfm3tXrI
	 gpVL5k3N0aZ2Y+9c/21R4iZbK+gKXBtcPMV0tzz7sPUAnvLLB7kJW0i964A5TWrOZO
	 CJicBEKoZZyNTKvg649TK8cRXRKj8miJ6pobqlyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 7.2 118/556] bpf: Fix infinite loop in pcpu_freelist push with one possible CPU
Date: Wed,  9 Sep 2026 15:36:38 +0200
Message-ID: <20260909134234.619577249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

commit efebf6496685c93150df5bb0794363ae70c5f58a upstream.

__pcpu_freelist_push() can loop forever when only one CPU is possible
and an NMI re-enters pcpu_freelist_push() while the interrupted context
holds that CPU's freelist lock.

After the current-CPU fast path fails, the fallback loop walks
cpu_possible_mask while skipping the current CPU. With CONFIG_SMP=n, or
when an SMP kernel is limited to one possible CPU with nr_cpus=1 or
possible_cpus=1, there are no other possible CPUs to examine. The loop
therefore makes no lock acquisition attempt and can never make progress.

The following stack was observed on a UP system:

  NMI context:
    pcpu_freelist_push
    free_htab_elem
    htab_map_delete_elem
    [perf-event BPF program]
    __perf_event_overflow
    perf_event_nmi_handler
    exc_nmi

  Interrupted context:
    __pcpu_freelist_push
    pcpu_freelist_push
    free_htab_elem
    htab_map_delete_elem
    [raw_tp/sys_enter BPF program]
    __bpf_trace_sys_enter
    do_syscall_64

raw_res_spin_lock() detects the same-CPU recursive acquisition and
returns -EDEADLK, but the subsequent fallback loop has no candidate head
on a system with one possible CPU.

Restore the extra fallback head that existed before the rqspinlock
conversion. Keep the current-CPU fast path, then try the other possible
CPUs and finally the extra head. The additional head lets a push, which
cannot fail without losing a preallocated element, make progress when the
only per-CPU head is held by the interrupted context.

Also check the extra head from the pop path so that nodes placed there
can be reused.

Fixes: f2ac0e5d1c4d ("bpf: Convert percpu_freelist.c to rqspinlock")
Signed-off-by: Hui Su <sh_def@163.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260806175600.1993595-1-sh_def@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/percpu_freelist.c |   35 +++++++++++++++++++++++++++--------
 kernel/bpf/percpu_freelist.h |    1 +
 2 files changed, 28 insertions(+), 8 deletions(-)

--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -17,6 +17,8 @@ int pcpu_freelist_init(struct pcpu_freel
 		raw_res_spin_lock_init(&head->lock);
 		head->first = NULL;
 	}
+	raw_res_spin_lock_init(&s->extralist.lock);
+	s->extralist.first = NULL;
 	return 0;
 }
 
@@ -46,22 +48,28 @@ void __pcpu_freelist_push(struct pcpu_fr
 			struct pcpu_freelist_node *node)
 {
 	struct pcpu_freelist_head *head;
-	int cpu;
+	int cpu, this_cpu;
 
 	if (___pcpu_freelist_push(this_cpu_ptr(s->freelist), node))
 		return;
 
+	this_cpu = raw_smp_processor_id();
 	while (true) {
-		for_each_cpu_wrap(cpu, cpu_possible_mask, raw_smp_processor_id()) {
-			if (cpu == raw_smp_processor_id())
+		for_each_cpu_wrap(cpu, cpu_possible_mask, this_cpu) {
+			if (cpu == this_cpu)
 				continue;
+
 			head = per_cpu_ptr(s->freelist, cpu);
-			if (raw_res_spin_lock(&head->lock))
-				continue;
-			pcpu_freelist_push_node(head, node);
-			raw_res_spin_unlock(&head->lock);
-			return;
+			if (___pcpu_freelist_push(head, node))
+				return;
 		}
+
+		/*
+		 * Push cannot fail. Use the extra list when none of the
+		 * per-CPU freelists can accept the node.
+		 */
+		if (___pcpu_freelist_push(&s->extralist, node))
+			return;
 	}
 }
 
@@ -117,6 +125,17 @@ static struct pcpu_freelist_node *___pcp
 		}
 		raw_res_spin_unlock(&head->lock);
 	}
+
+	/* Per-CPU lists are empty or unavailable, try the extra list. */
+	head = &s->extralist;
+	if (!READ_ONCE(head->first))
+		return NULL;
+	if (raw_res_spin_lock(&head->lock))
+		return NULL;
+	node = head->first;
+	if (node)
+		WRITE_ONCE(head->first, node->next);
+	raw_res_spin_unlock(&head->lock);
 	return node;
 }
 
--- a/kernel/bpf/percpu_freelist.h
+++ b/kernel/bpf/percpu_freelist.h
@@ -14,6 +14,7 @@ struct pcpu_freelist_head {
 
 struct pcpu_freelist {
 	struct pcpu_freelist_head __percpu *freelist;
+	struct pcpu_freelist_head extralist;
 };
 
 struct pcpu_freelist_node {


