Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21643BE623;
	Sat, 12 Sep 2026 20:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243584; cv=none; b=F8lm2kntdwfb8bfx3LhywfiUSIaRpHyZ7Ndm1oDF7oV9pZE3/tyAoGUnEMb7zS8IFruAnYImF9Gc/aD64vKZ0o8guS3drS5DCV2dG32mKaUemUclZfYRxZ355y8prVRsGC6YL2yEVlavDVNc069mqhs2hOqQI4PfIj1ObMwLHOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243584; c=relaxed/simple;
	bh=TBVnKIrclUdbJsoS+kSaNSCOSAJ+XzUtEZ8JE2g9ZBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz5L4XrfexODJUkdRsQ7MZdCphzERDDAlbbpTeoyZmG83GRO65csNBJeMyIeGFbAzjkl/W8rx1CtMSUv47zMA4XWBl8n8ClIHhAte+ySZtlPKJ90lVKjmH5OEt+G6g7pT3+iLROqS4GCdlMZwyqatoAe2QYxfcqCN8GqFn4VVWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtlTquWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtlTquWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114A31F00893;
	Sat, 12 Sep 2026 20:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243580;
	bh=35anX36BkwOM1FB/+8+0vEnOT+0yWU/aQDsXc3XInRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtlTquWQxT7i0aC6sjxPRprMWQDbmEVnVhZAc4ZtjDhQNITEOLs7tL1ToTuZM3CEc
	 BBPQv76wU9sMQPEsid89ldRg6B0gvMPpwJO3L5T7oynZQ88fceHOb5+A77NqCp7sZy
	 UvD1JpJUv4VWKsGzZrNIUFiwj0DIgtWTdsAw5VB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wu <michael@allwinnertech.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 795/798] tracing: Fix race between update_event_fields and, event_define_fields
Date: Sat, 12 Sep 2026 09:07:03 +0200
Message-ID: <20260912065535.282280548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Wu <michael@allwinnertech.com>

[ Upstream commit c3730b8373bb5059d735509b9e6a00d7eb337d7c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 889ec51171ce9..68078a4e046f3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2468,6 +2468,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 	int last_i;
 	int i;
 
+	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		/* events are usually grouped together with systems */
@@ -2501,6 +2502,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 		cond_resched();
 	}
 	up_write(&trace_event_sem);
+	mutex_unlock(&event_mutex);
 }
 
 static struct trace_event_file *
-- 
2.53.0



