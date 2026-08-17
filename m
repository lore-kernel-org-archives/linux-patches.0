Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19373C3C08;
	Mon, 17 Aug 2026 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975184; cv=none; b=DaIpqtW1/UFtvJnKH82i43IbjngaIOK9t6p/npld7+5uyhNOmMa0slxK/65Sst++4vUJIcfz+ookB0xXTKmcVSGTaNUAfVdseKS36x8LURx+dylm5uRo8I+gqEpx2ZNv2LBYwIVf8KqKVTKBntCgNctbzO94qEiGZ3xwyaBHYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975184; c=relaxed/simple;
	bh=/a7jRMGjPlhHYm8M7p6ZDqZZ06NzAzGZZ8rnzf5abQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t62x8zaP6G6NJyvVOME9uVY3xopWKKg9sU2OEL3TfDhnTz5PtyIN9R8gIsYwsFpZGDi9f8tX5/VPR01aTYfsxMgIpwPAuI+FUvW4XTW/C3m+DfvuE3FlRQzNRtv7fqw8IfaAepkr4cZL7HR7jmR6M6yehSD2zqYh//OA85sBSS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lz1MaQKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lz1MaQKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF841F000E9;
	Mon, 17 Aug 2026 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975182;
	bh=Y1/EkkaaH5TkJz4Ggi6AkPnSIqRfalFvELYnkOvjU6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lz1MaQKQINz82xLxcyyLHSA2OjaNA3ieWLQ+FV68XcCTWjc+xkOP9UIAZ4grSkWL0
	 KwzkoKhjLK84Up00HrzlUf4xmA/LkeeulM1dbaCobKm+48l4m23Z+zyZqc+KzKjb7q
	 hoIz5vjjtekEMYxsCUrukzWqmbqLc/a01r8Yos90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wu <michael@allwinnertech.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 190/250] tracing: Fix race between update_event_fields and, event_define_fields
Date: Mon, 17 Aug 2026 15:32:31 +0200
Message-ID: <20260817132544.327348892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Michael Wu <michael@allwinnertech.com>

commit c3730b8373bb5059d735509b9e6a00d7eb337d7c upstream.

The following sequence may leads race between event_define_fields()
and update_event_fields():

 CPU0 (loads module A)                      CPU1 (loads module B)
 ===============================            ===============================
 load_module(A)                             load_module(B)
   notifier_call_chain                        notifier_call_chain
     trace_module_notify                        trace_module_notify
       mutex_lock(&event_mutex)                   trace_event_update_all()
         trace_module_add_events(A)                 down_write(&trace_event_sem)
            __register_event(call_A)
              __add_event_to_tracers(call_A)
                event_define_fields(call_A)
                  for each f:                         list_for_each_entry(field,
                    list_add(&f->link,                                    &class->fields, link)
                             &class->fields)            field = class->fields->next;

Where access to the class->fields is not protected by the event_mutex in
trace_event_update_all().

This produces the following panic:
   Unable to handle kernel access ... at virtual address 0000000000000018
   pc : update_event_fields+0xf8/0x368
   Call trace:
    update_event_fields+0xf8/0x368
    trace_event_update_all+0x7c/0x2b4
    trace_module_notify+0x4c/0x1dc
    notifier_call_chain+0x84/0x168
    blocking_notifier_call_chain_robust+0x64/0xd4
    load_module+0x10c8/0x123c
    __arm64_sys_finit_module+0x230/0x31c

Fix by taking event_mutex in trace_event_update_all() before
trace_event_sem.

Cc: stable@vger.kernel.org
Fixes: b3bc8547d3be ("tracing: Have TRACE_DEFINE_ENUM affect trace event types as well")
Link: https://patch.msgid.link/2e5730d2-c631-da41-3a3a-ae35bb4895f3@allwinnertech.com
Signed-off-by: Michael Wu <michael@allwinnertech.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3411,6 +3411,7 @@ void trace_event_update_all(struct trace
 	int last_i;
 	int i;
 
+	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		/* events are usually grouped together with systems */
@@ -3449,6 +3450,7 @@ void trace_event_update_all(struct trace
 		cond_resched();
 	}
 	up_write(&trace_event_sem);
+	mutex_unlock(&event_mutex);
 }
 
 static bool event_in_systems(struct trace_event_call *call,


