Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDA53DC4BD;
	Mon, 17 Aug 2026 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974451; cv=none; b=Cz0T+0zUw534pxAbh0BtKugnka20Ob5Jzo+Sgmo6ceYGe8X1Q3CxEJ/Dgsqgl87I4Yt2CWSIwFjYcP0xLLbeqhDgJO7mACSjKNZoY+cn29vglBfdgbs3ZX0Ufl86bLaAvXWEYn1Kydh6a7dCzlEl8ugnnrcVMKgmXM3sdQvc3s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974451; c=relaxed/simple;
	bh=9KMABDQnDN0fZG9deN4f+mgoJektVysT2Usg+zFF3po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwg6Scb1OW4+bd1aUSm4ZLS45WNMz/DW9aEnYBcJASsKzdeXthJAACD4qtK4NgAkFZI9mW30nGfuyQIw/EKzy6LUIfcE7JWgEW046jbtVZu20AQprrkcdOFzpZUpfvti6DjQRvTFCWPJg9UZt0KfCkPpAGaG5TK1EG3cZ6Uslb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYzrA0wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYzrA0wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAA51F00A3F;
	Mon, 17 Aug 2026 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974443;
	bh=szAuBwBfYRDh/miBHXZUlrdpGuV0s3rxk2nKdJin6LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYzrA0wgbw/m6NZ++/Fg/DggPo6IATSivkf7VCgpYmVvG7HDxpnSTi/bcNZYn931L
	 YYbeCLr60m+E2VQqFgFuvYpJz/vokLkKYOG2eRunt19t4eSqaWXNKQYgHYQ64UESJc
	 tUHfErgrxIBfJT6bkGV+PJ37PvZLmgvRhfmHcSrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wu <michael@allwinnertech.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 205/271] tracing: Fix race between update_event_fields and, event_define_fields
Date: Mon, 17 Aug 2026 15:32:10 +0200
Message-ID: <20260817132545.252796025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3566,6 +3566,7 @@ void trace_event_update_all(struct trace
 	int last_i;
 	int i;
 
+	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		/* events are usually grouped together with systems */
@@ -3604,6 +3605,7 @@ void trace_event_update_all(struct trace
 		cond_resched();
 	}
 	up_write(&trace_event_sem);
+	mutex_unlock(&event_mutex);
 }
 
 static bool event_in_systems(struct trace_event_call *call,


