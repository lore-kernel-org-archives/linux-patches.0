Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB852590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A97C433D2;
	Sun, 22 Jan 2023 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401109;
	bh=QWCDJGeSuUhItXpy6atRhtbdBh6Co6DYu7nr+j6obvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFmVIqqCP8pYInJnPXYiILa3FHrZXUdOi6T16h4AUzuW/In49Ubpyr4HH78Eo09FI
	 sRB4b4x7Kz/lm0OkvWzZ+KiP5zCOcgMo1yTUVpmOQ4kJsQHFb0eM1rkNq7fExnUnGA
	 xgLErD0fm38RzW7sz6pIk4u1Y0McAQs4DhPK445g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Burn Alting <burn.alting@iinet.net.au>,
	Jiri Olsa <olsajiri@gmail.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 096/193] bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD
Date: Sun, 22 Jan 2023 16:03:45 +0100
Message-Id: <20230122150250.725207078@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Moore <paul@paul-moore.com>

commit ef01f4e25c1760920e2c94f1c232350277ace69b upstream.

When changing the ebpf program put() routines to support being called
from within IRQ context the program ID was reset to zero prior to
calling the perf event and audit UNLOAD record generators, which
resulted in problems as the ebpf program ID was bogus (always zero).
This patch addresses this problem by removing an unnecessary call to
bpf_prog_free_id() in __bpf_prog_offload_destroy() and adjusting
__bpf_prog_put() to only call bpf_prog_free_id() after audit and perf
have finished their bpf program unload tasks in
bpf_prog_put_deferred().  For the record, no one can determine, or
remember, why it was necessary to free the program ID, and remove it
from the IDR, prior to executing bpf_prog_put_deferred();
regardless, both Stanislav and Alexei agree that the approach in this
patch should be safe.

It is worth noting that when moving the bpf_prog_free_id() call, the
do_idr_lock parameter was forced to true as the ebpf devs determined
this was the correct as the do_idr_lock should always be true.  The
do_idr_lock parameter will be removed in a follow-up patch, but it
was kept here to keep the patch small in an effort to ease any stable
backports.

I also modified the bpf_audit_prog() logic used to associate the
AUDIT_BPF record with other associated records, e.g. @ctx != NULL.
Instead of keying off the operation, it now keys off the execution
context, e.g. '!in_irg && !irqs_disabled()', which is much more
appropriate and should help better connect the UNLOAD operations with
the associated audit state (other audit records).

Cc: stable@vger.kernel.org
Fixes: d809e134be7a ("bpf: Prepare bpf_prog_put() to be called from irq context.")
Reported-by: Burn Alting <burn.alting@iinet.net.au>
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Suggested-by: Stanislav Fomichev <sdf@google.com>
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20230106154400.74211-1-paul@paul-moore.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/offload.c |    3 ---
 kernel/bpf/syscall.c |    6 ++----
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -216,9 +216,6 @@ static void __bpf_prog_offload_destroy(s
 	if (offload->dev_state)
 		offload->offdev->ops->destroy(prog);
 
-	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
-	bpf_prog_free_id(prog, true);
-
 	list_del_init(&offload->offloads);
 	kfree(offload);
 	prog->aux->offload = NULL;
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1958,7 +1958,7 @@ static void bpf_audit_prog(const struct
 		return;
 	if (audit_enabled == AUDIT_OFF)
 		return;
-	if (op == BPF_AUDIT_LOAD)
+	if (!in_irq() && !irqs_disabled())
 		ctx = audit_context();
 	ab = audit_log_start(ctx, GFP_ATOMIC, AUDIT_BPF);
 	if (unlikely(!ab))
@@ -2053,6 +2053,7 @@ static void bpf_prog_put_deferred(struct
 	prog = aux->prog;
 	perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
 	bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
+	bpf_prog_free_id(prog, true);
 	__bpf_prog_put_noref(prog, true);
 }
 
@@ -2061,9 +2062,6 @@ static void __bpf_prog_put(struct bpf_pr
 	struct bpf_prog_aux *aux = prog->aux;
 
 	if (atomic64_dec_and_test(&aux->refcnt)) {
-		/* bpf_prog_free_id() must be called first */
-		bpf_prog_free_id(prog, do_idr_lock);
-
 		if (in_irq() || irqs_disabled()) {
 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
 			schedule_work(&aux->work);


