Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458E81F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC411C433C7;
	Tue,  1 Aug 2023 09:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881987;
	bh=5+q7U4Oe+Pe9PLvo+QTpPoTFNBRt4dwi/TM0h/nuzok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QViPoBYDmEyJ7T1pjhKuDTbs+NBqi8miBTyLDejaOouxkkMrBvGH1rArz7JT4ng+3
	 BC35vYtRMXPOYwhm4JXbo9LODPVa6UK4fSmS7eWIvaiNuc6DQb3FfxKNpFiJulOlI+
	 OfNBBce/9bocUOHHb8dVRz1ZHq8Dv6kkJFXL1Y2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/155] tracing: Fix warning in trace_buffered_event_disable()
Date: Tue,  1 Aug 2023 11:20:12 +0200
Message-ID: <20230801091913.795445654@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit dea499781a1150d285c62b26659f62fb00824fce ]

Warning happened in trace_buffered_event_disable() at
  WARN_ON_ONCE(!trace_buffered_event_ref)

  Call Trace:
   ? __warn+0xa5/0x1b0
   ? trace_buffered_event_disable+0x189/0x1b0
   __ftrace_event_enable_disable+0x19e/0x3e0
   free_probe_data+0x3b/0xa0
   unregister_ftrace_function_probe_func+0x6b8/0x800
   event_enable_func+0x2f0/0x3d0
   ftrace_process_regex.isra.0+0x12d/0x1b0
   ftrace_filter_write+0xe6/0x140
   vfs_write+0x1c9/0x6f0
   [...]

The cause of the warning is in __ftrace_event_enable_disable(),
trace_buffered_event_enable() was called once while
trace_buffered_event_disable() was called twice.
Reproduction script show as below, for analysis, see the comments:
 ```
 #!/bin/bash

 cd /sys/kernel/tracing/

 # 1. Register a 'disable_event' command, then:
 #    1) SOFT_DISABLED_BIT was set;
 #    2) trace_buffered_event_enable() was called first time;
 echo 'cmdline_proc_show:disable_event:initcall:initcall_finish' > \
     set_ftrace_filter

 # 2. Enable the event registered, then:
 #    1) SOFT_DISABLED_BIT was cleared;
 #    2) trace_buffered_event_disable() was called first time;
 echo 1 > events/initcall/initcall_finish/enable

 # 3. Try to call into cmdline_proc_show(), then SOFT_DISABLED_BIT was
 #    set again!!!
 cat /proc/cmdline

 # 4. Unregister the 'disable_event' command, then:
 #    1) SOFT_DISABLED_BIT was cleared again;
 #    2) trace_buffered_event_disable() was called second time!!!
 echo '!cmdline_proc_show:disable_event:initcall:initcall_finish' > \
     set_ftrace_filter
 ```

To fix it, IIUC, we can change to call trace_buffered_event_enable() at
fist time soft-mode enabled, and call trace_buffered_event_disable() at
last time soft-mode disabled.

Link: https://lore.kernel.org/linux-trace-kernel/20230726095804.920457-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Fixes: 0fc1b09ff1ff ("tracing: Use temp buffer when filtering events")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 160298d285c0b..2a2a599997671 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -594,7 +594,6 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 {
 	struct trace_event_call *call = file->event_call;
 	struct trace_array *tr = file->tr;
-	unsigned long file_flags = file->flags;
 	int ret = 0;
 	int disable;
 
@@ -618,6 +617,8 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 				break;
 			disable = file->flags & EVENT_FILE_FL_SOFT_DISABLED;
 			clear_bit(EVENT_FILE_FL_SOFT_MODE_BIT, &file->flags);
+			/* Disable use of trace_buffered_event */
+			trace_buffered_event_disable();
 		} else
 			disable = !(file->flags & EVENT_FILE_FL_SOFT_MODE);
 
@@ -656,6 +657,8 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 			if (atomic_inc_return(&file->sm_ref) > 1)
 				break;
 			set_bit(EVENT_FILE_FL_SOFT_MODE_BIT, &file->flags);
+			/* Enable use of trace_buffered_event */
+			trace_buffered_event_enable();
 		}
 
 		if (!(file->flags & EVENT_FILE_FL_ENABLED)) {
@@ -695,15 +698,6 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 		break;
 	}
 
-	/* Enable or disable use of trace_buffered_event */
-	if ((file_flags & EVENT_FILE_FL_SOFT_DISABLED) !=
-	    (file->flags & EVENT_FILE_FL_SOFT_DISABLED)) {
-		if (file->flags & EVENT_FILE_FL_SOFT_DISABLED)
-			trace_buffered_event_enable();
-		else
-			trace_buffered_event_disable();
-	}
-
 	return ret;
 }
 
-- 
2.40.1



