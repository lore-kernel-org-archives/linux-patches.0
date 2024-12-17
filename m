Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128021F7577;
	Tue, 17 Dec 2024 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456131; cv=none; b=AjRR/jlZ+osoHH2fNaWjqfWAxUo8aFlO2PshAUBuwG96NWnBgTeyY+T8nWevBWLlNaNKMq14s94YkJxDDOED4Fu9uGY8sC+imtJdKvizEupQCoxrtyoU1W4fO0/jPlIQyDBkp8rgwMcE10GGra6Na8JUT5VEYbO913wVlakN0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456131; c=relaxed/simple;
	bh=fgrEIEaD+pc1gI4uMU4Plb1IlqsHZ/bqzm5vR9oNDjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqoN6BEoesE8zO/kRqPVq87WKwk2ur3zQOXyLiJEpd7MDGQ4a+fItg1ARxPDZNO78Rw+AlzeS2TRxbrRJWBRADKIkTRAJcMHbfs3ZYutxPgRJ+1c04qezCOijOqC/HYm4ryqB5lOILJ9ZUpTbnx3yt53DNCoZ0pBlzWUlxWclg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Db4DpOyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Db4DpOyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE97C4CED3;
	Tue, 17 Dec 2024 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456130;
	bh=fgrEIEaD+pc1gI4uMU4Plb1IlqsHZ/bqzm5vR9oNDjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db4DpOyAJE06WK5BdDh9JzMun9DFgHbTvPFabksd1vz1hu0aJbSM7aRUjfG3dbFSr
	 LD6qcBqr6Lvbnw0pjKwrtbJhNcxeOgVdKGCjH5x+cJfSr681SraNuPih2e8N4SN7Cv
	 mpKEjfxCYMG5Bt7CBKBEWsijWKncjubQXryblDaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 030/109] bpf: Fix theoretical prog_array UAF in __uprobe_perf_func()
Date: Tue, 17 Dec 2024 18:07:14 +0100
Message-ID: <20241217170534.639987921@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 7d0d673627e20cfa3b21a829a896ce03b58a4f1c upstream.

Currently, the pointer stored in call->prog_array is loaded in
__uprobe_perf_func(), with no RCU annotation and no immediately visible
RCU protection, so it looks as if the loaded pointer can immediately be
dangling.
Later, bpf_prog_run_array_uprobe() starts a RCU-trace read-side critical
section, but this is too late. It then uses rcu_dereference_check(), but
this use of rcu_dereference_check() does not actually dereference anything.

Fix it by aligning the semantics to bpf_prog_run_array(): Let the caller
provide rcu_read_lock_trace() protection and then load call->prog_array
with rcu_dereference_check().

This issue seems to be theoretical: I don't know of any way to reach this
code without having handle_swbp() further up the stack, which is already
holding a rcu_read_lock_trace() lock, so where we take
rcu_read_lock_trace() in __uprobe_perf_func()/bpf_prog_run_array_uprobe()
doesn't actually have any effect.

Fixes: 8c7dcb84e3b7 ("bpf: implement sleepable uprobes by chaining gps")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241210-bpf-fix-uprobe-uaf-v4-1-5fc8959b2b74@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h         |   13 +++++--------
 kernel/trace/trace_uprobe.c |    6 +++++-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1988,26 +1988,25 @@ bpf_prog_run_array(const struct bpf_prog
  * rcu-protected dynamically sized maps.
  */
 static __always_inline u32
-bpf_prog_run_array_uprobe(const struct bpf_prog_array __rcu *array_rcu,
+bpf_prog_run_array_uprobe(const struct bpf_prog_array *array,
 			  const void *ctx, bpf_prog_run_fn run_prog)
 {
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
-	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_trace_run_ctx run_ctx;
 	u32 ret = 1;
 
 	might_fault();
+	RCU_LOCKDEP_WARN(!rcu_read_lock_trace_held(), "no rcu lock held");
+
+	if (unlikely(!array))
+		return ret;
 
-	rcu_read_lock_trace();
 	migrate_disable();
 
 	run_ctx.is_uprobe = true;
 
-	array = rcu_dereference_check(array_rcu, rcu_read_lock_trace_held());
-	if (unlikely(!array))
-		goto out;
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	item = &array->items[0];
 	while ((prog = READ_ONCE(item->prog))) {
@@ -2022,9 +2021,7 @@ bpf_prog_run_array_uprobe(const struct b
 			rcu_read_unlock();
 	}
 	bpf_reset_run_ctx(old_run_ctx);
-out:
 	migrate_enable();
-	rcu_read_unlock_trace();
 	return ret;
 }
 
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1383,9 +1383,13 @@ static void __uprobe_perf_func(struct tr
 
 #ifdef CONFIG_BPF_EVENTS
 	if (bpf_prog_array_valid(call)) {
+		const struct bpf_prog_array *array;
 		u32 ret;
 
-		ret = bpf_prog_run_array_uprobe(call->prog_array, regs, bpf_prog_run);
+		rcu_read_lock_trace();
+		array = rcu_dereference_check(call->prog_array, rcu_read_lock_trace_held());
+		ret = bpf_prog_run_array_uprobe(array, regs, bpf_prog_run);
+		rcu_read_unlock_trace();
 		if (!ret)
 			return;
 	}


