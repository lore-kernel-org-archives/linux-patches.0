Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB84F3D5C07;
	Mon, 17 Aug 2026 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980562; cv=none; b=Btpf6Fk/iUv/Tha6H26mZ2xCJUOq5FML2bwWJsNWBP/UNifP38E/kgnKyET/v1wLcCYpfPuJydJKQFZbm+jdt9ITa7cTincKJlsAcrI8y6fp7RwqMa+bAyhs2o1PtfLSGqdZK9xnZhjqJtaWXdPgBdv3z4hDqRWvFa7dthNJ+NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980562; c=relaxed/simple;
	bh=C5X+ON7OQXdrdxU4X1RrviCWoRigUaMYa10oREnfhow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R07L21bR4eS3DYFvIz7QRPVHdA0P2FrAhtw0qFxP4npompeVg3vygfwmrisgzOMixeu7D8ETC8415VRpaID/69LHMT+5a4DFh87MoMcMIavXc//it3JxGQCvpgyRgkbjciXXrT+6rF9aWFzx2f6nxCfE51OLvD/wv21XEFMqCuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krhGOxRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krhGOxRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A11F000E9;
	Mon, 17 Aug 2026 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980561;
	bh=X8q7MTW1TsPb6CmFoJU+uu8M2UGYOTSEGhHy2tpCWeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krhGOxRZUAPZoS5Vf9/iYEq3XbKzS1x1awkR3mXkAf2zaSP7IVTEQkWmuLgqDPt61
	 4427p3DPh4CzGhkIWkiHnQx/1dpVwgB5lJ2/l8ioHt24L/Ofr59tCME8Rm/0otPK6q
	 Kk5HCb1djWtf2sq/Hj3p0ROffMgFAYHaP7wtRQXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wu <michael@allwinnertech.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 578/609] tracing: Fix race between update_event_fields and, event_define_fields
Date: Mon, 17 Aug 2026 15:34:34 +0200
Message-ID: <20260817132603.043413071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2904,6 +2904,7 @@ void trace_event_eval_update(struct trac
 	int last_i;
 	int i;
 
+	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		/* events are usually grouped together with systems */
@@ -2937,6 +2938,7 @@ void trace_event_eval_update(struct trac
 		cond_resched();
 	}
 	up_write(&trace_event_sem);
+	mutex_unlock(&event_mutex);
 }
 
 static struct trace_event_file *


