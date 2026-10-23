Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774948;
	b=eAUmhWSyopeDe1id8tJXywCb17FnPw7xFGCkdHGHGAyrZwH1WL3KN38Nq9WkzaTUAa0j
	 h7NYngf+QowXoQfpDS0d2nPEnrS3QE8rN+Ta+u3kni03BURCiGWaFYcDBmLuizlTeELf1
	 FqCwjyRhD3OohnZhxCJNoB+6HqXJNS2gkAb3JmZZMy7vziFrTN5IOcEh6tiN9fegRmh7j
	 z0UHf/MDkklBtmZryui43o0n0gNpZixxnl3FwcahFZ8dWZKHLPElXoSAqPx1HpIsMi5LJ
	 86aJ9s4WNrtqBEd8trfc/SRGRCdG7zaoyN1S1Q5D0O3g5JSGQCMjZHT9SCuk5k1uLLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VM7FCC/ovNePJwV257e/EzzP+dcwhSBwaeo9BzPR4Ww=;
	b=ru9mkq80fLYzfPqtSbSiczL1fxosuj3WY4jUknXz6qMWz60ynUcvfDMacR5hnCMNZfC3
	 Mcr5xHx/SK0JQ6NDEmNblNPBtiI9dTj3+NoK6PY6t4xczeYs/XL/m1o/Lc7fUBj2/h8EP
	 xdLSkapQPaoJZ5ikSvinRu7hWVY4nB2mfEkkkxDYyA6HFNp6pZlHCv4T7dX0lu+c3a43u
	 G4Lye62k3inudvcO1UusxeuQlY3n8FFZPVcFJjqROXxHo1jpgunmPp2FWqkIJeuqSfedi
	 En1B49noENqqASYIxINKJ475PEE5qxm8i9MyQQ+3sWURKM9gc8t2NH4GGGQSAWIsC2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ir8cBt3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E85E606A31A;
	Fri, 23 Oct 2026 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ir8cBt3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC0C1F01825;
	Fri, 23 Oct 2026 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774947;
	bh=VM7FCC/ovNePJwV257e/EzzP+dcwhSBwaeo9BzPR4Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir8cBt3o+viYkMsYit/LGEZHq3U2mmsZ6GRpxoplozcINZqhIltjRV6ffvknyt/HD
	 HIxS3hgghO90uDJvCX95wntOZDsqtkNq9J+lx1uUY6/MPFgVuP+p4kRfDrxyZjNKcZ
	 +6xBgtNhpfEFviv2qJFbF7n0YefnvCeRUjJuUuk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH 7.2 173/242] tracing: Fix crash in print_graph_function_event()
Date: Fri, 23 Oct 2026 18:40:15 +0200
Message-ID: <20261023163717.877548426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

commit 3cc117514d69067a94d6c7479730dce41e678f50 upstream.

tracing_set_tracer() assigns the flags of the newly selected tracer
with:

	tr->current_trace_flags = t->flags ? : t->tracer->flags;

If the new tracer defines neither static flags nor default flags, like
hwlat, irqsoff or wakeup, add_tracer() has no per instance flags copy
for it, and both operands are NULL, so tr->current_trace_flags ends up
being NULL as well.

The ring buffer is not cleared when switching tracers: it is reset
inside tracer_init(), after current_trace_flags was already assigned.
If the buffer still holds function_graph entries of the previous
tracer, printing one of them dereferences the NULL pointer. This was
hit by cat trace during an ftrace stress test:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  RIP: 0010:print_graph_function_event+0xe/0x20
  Call Trace:
   s_show+0x4d/0x110
   seq_read_iter+0x2d4/0x490
   seq_read+0x130/0x170
   vfs_read+0xb5/0x370
   ksys_read+0x6d/0xe0
   do_syscall_64+0xbc/0x450

The snapshot buffer is not reset at all, so this can be reproduced
without a race:

  echo function_graph > /sys/kernel/tracing/current_tracer
  echo 1 > /sys/kernel/tracing/snapshot
  echo hwlat > /sys/kernel/tracing/current_tracer
  cat /sys/kernel/tracing/snapshot

Rather than teaching every user of tr->current_trace_flags about this
corner case, make sure it is never NULL: when the newly selected
tracer has no flags at all, tracing_set_tracer() falls back to a
static empty no_tracer_flags. run_tracer_selftest() can hit the same
case, so the same fallback is added there too. The existing users
already handle opts == NULL, so these tracers keep behaving as before.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015130658.221198-1-hao.ge@linux.dev
Fixes: e29aa918a928 ("tracing: Have function graph tracer define options per instance")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -100,6 +100,12 @@ struct tracers {
 };
 
 /*
+ * Tracers that do not define their own flags use these empty flags,
+ * as tr->current_trace_flags must never be NULL.
+ */
+static struct tracer_flags no_tracer_flags;
+
+/*
  * To prevent the comm cache from being overwritten when no
  * tracing is active, only save the comm when a trace event
  * occurred.
@@ -1318,7 +1324,12 @@ static int run_tracer_selftest(struct tr
 	tracing_reset_online_cpus(&tr->array_buffer);
 
 	tr->current_trace = type;
-	tr->current_trace_flags = type->flags ? : type->default_flags;
+	if (type->flags)
+		tr->current_trace_flags = type->flags;
+	else if (type->default_flags)
+		tr->current_trace_flags = type->default_flags;
+	else
+		tr->current_trace_flags = &no_tracer_flags;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (tracer_uses_snapshot(type)) {
@@ -5087,7 +5098,12 @@ int tracing_set_tracer(struct trace_arra
 			return ret;
 	}
 
-	tr->current_trace_flags = t->flags ? : t->tracer->flags;
+	if (t->flags)
+		tr->current_trace_flags = t->flags;
+	else if (t->tracer->flags)
+		tr->current_trace_flags = t->tracer->flags;
+	else
+		tr->current_trace_flags = &no_tracer_flags;
 
 	if (trace->init) {
 		ret = tracer_init(trace, tr);


