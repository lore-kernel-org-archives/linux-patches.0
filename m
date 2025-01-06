Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C987200A3;
	Mon,  6 Jan 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177962; cv=none; b=hvYRbBNgSad8vsYCjV8O+Dw1G4RJzM1VjI3s4jfd4/iEJRwGT07+o6mYoXAx7wcbSRqLSme+H1F2XNJ+mbQ5YnX4o78ti53zE8JhNHmyGNiT8H2JxerfWsaLkAMO+L8ZW/uzyM6od4MI2d42yQocMe2U/4UM4MS6W42PtSNcg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177962; c=relaxed/simple;
	bh=Gz3i3OaE2C+aeX/dcL/Gkv/2B1nwjXaDSkZ2J5+Ey6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWovLfSEGI9cgeX4GeJsoLhvp8h9wYs0OSuaTZrHxQ2WG7A3WPldV9K+WilCSK8FYWtM69MmxpS6o6E3MvyGIQTPBX3d11T91ggAspB4PwWbHRI2QJSHgbtO2R/DLhuGormmqJp0GeQEMztyLp3hhMImrErPERTQwe6SlsnTtEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptqy+80a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptqy+80a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AD1C4CED2;
	Mon,  6 Jan 2025 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177962;
	bh=Gz3i3OaE2C+aeX/dcL/Gkv/2B1nwjXaDSkZ2J5+Ey6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptqy+80aNFjwrnhwReTNWIJm1PFL0tKgUgtt7IbSv5Dcn2XHz1aK9DsW57vZo/6yS
	 GNd/zajMrqv/O4MQLUPXagcTBVdPOPm9Vp2PTu5zzrzObg0cXdX5Lgo/tEp/ng3FxB
	 WsF1GOhPNkhe3CPZ2AMn/aeEbQeOepZEdS9FxO0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 114/156] ftrace: Fix function profilers filtering functionality
Date: Mon,  6 Jan 2025 16:16:40 +0100
Message-ID: <20250106151146.020538634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enjuk@amazon.com>

commit 789a8cff8d2dbe4b5c617c3004b5eb63fa7a3b35 upstream.

Commit c132be2c4fcc ("function_graph: Have the instances use their own
ftrace_ops for filtering"), function profiler (enabled via
function_profile_enabled) has been showing statistics for all functions,
ignoring set_ftrace_filter settings.

While tracers are instantiated, the function profiler is not. Therefore, it
should use the global set_ftrace_filter for consistency.  This patch
modifies the function profiler to use the global filter, fixing the
filtering functionality.

Before (filtering not working):
```
root@localhost:~# echo 'vfs*' > /sys/kernel/tracing/set_ftrace_filter
root@localhost:~# echo 1 > /sys/kernel/tracing/function_profile_enabled
root@localhost:~# sleep 1
root@localhost:~# echo 0 > /sys/kernel/tracing/function_profile_enabled
root@localhost:~# head /sys/kernel/tracing/trace_stat/*
  Function                               Hit    Time            Avg
     s^2
  --------                               ---    ----            ---
     ---
  schedule                               314    22290594 us     70989.15 us
     40372231 us
  x64_sys_call                          1527    8762510 us      5738.382 us
     3414354 us
  schedule_hrtimeout_range               176    8665356 us      49234.98 us
     405618876 us
  __x64_sys_ppoll                        324    5656635 us      17458.75 us
     19203976 us
  do_sys_poll                            324    5653747 us      17449.83 us
     19214945 us
  schedule_timeout                        67    5531396 us      82558.15 us
     2136740827 us
  __x64_sys_pselect6                      12    3029540 us      252461.7 us
     63296940171 us
  do_pselect.constprop.0                  12    3029532 us      252461.0 us
     63296952931 us
```

After (filtering working):
```
root@localhost:~# echo 'vfs*' > /sys/kernel/tracing/set_ftrace_filter
root@localhost:~# echo 1 > /sys/kernel/tracing/function_profile_enabled
root@localhost:~# sleep 1
root@localhost:~# echo 0 > /sys/kernel/tracing/function_profile_enabled
root@localhost:~# head /sys/kernel/tracing/trace_stat/*
  Function                               Hit    Time            Avg
     s^2
  --------                               ---    ----            ---
     ---
  vfs_write                              462    68476.43 us     148.217 us
     25874.48 us
  vfs_read                               641    9611.356 us     14.994 us
     28868.07 us
  vfs_fstat                              890    878.094 us      0.986 us
     1.667 us
  vfs_fstatat                            227    757.176 us      3.335 us
     18.928 us
  vfs_statx                              226    610.610 us      2.701 us
     17.749 us
  vfs_getattr_nosec                     1187    460.919 us      0.388 us
     0.326 us
  vfs_statx_path                         297    343.287 us      1.155 us
     11.116 us
  vfs_rename                               6    291.575 us      48.595 us
     9889.236 us
```

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250101190820.72534-1-enjuk@amazon.com
Fixes: c132be2c4fcc ("function_graph: Have the instances use their own ftrace_ops for filtering")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -883,16 +883,13 @@ static void profile_graph_return(struct
 }
 
 static struct fgraph_ops fprofiler_ops = {
-	.ops = {
-		.flags = FTRACE_OPS_FL_INITIALIZED,
-		INIT_OPS_HASH(fprofiler_ops.ops)
-	},
 	.entryfunc = &profile_graph_entry,
 	.retfunc = &profile_graph_return,
 };
 
 static int register_ftrace_profiler(void)
 {
+	ftrace_ops_set_global_filter(&fprofiler_ops.ops);
 	return register_ftrace_graph(&fprofiler_ops);
 }
 
@@ -903,12 +900,11 @@ static void unregister_ftrace_profiler(v
 #else
 static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
-	.flags		= FTRACE_OPS_FL_INITIALIZED,
-	INIT_OPS_HASH(ftrace_profile_ops)
 };
 
 static int register_ftrace_profiler(void)
 {
+	ftrace_ops_set_global_filter(&ftrace_profile_ops);
 	return register_ftrace_function(&ftrace_profile_ops);
 }
 


