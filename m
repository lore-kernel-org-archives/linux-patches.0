Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA49F23776;
	Thu, 18 Jan 2024 11:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575643; cv=none; b=lE44cIB9hAP4JgQdxXc5hCOtPeEfZ9ojmNfnvf1Q7WYyAUWGvzm7kEC52UAsSX9ncglM/c58ZR3ePXZv7Zc+fvxof9FMtjrU788c1LHmcwDzmyjFSUPFEj2+4ksVzurBh8jQ4V7YlO0D2C611KCdvxNVkGXAGXZDpjeA2RxwC2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575643; c=relaxed/simple;
	bh=Qe63haLIztYebrMJyRogj1XXscLyWmVfN0QuK991bzE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=uZGnzcYf1DB+CXKvhEqmfaq/Tl9zug0JSCt7Y7koQo4GuzFHOOKGNRiOedKEo1/zpfcb7nDuv68j8fSuj0jG0WGTsVZX17Eod9ZV9rvg6H/M+DfwQyrC0UFh5vGLFwBA8qXR3av/x6cc8CTvwRAEXoH3r3tWCFMLENaXuNMgbTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpO1QLY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpO1QLY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FB4C433C7;
	Thu, 18 Jan 2024 11:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575643;
	bh=Qe63haLIztYebrMJyRogj1XXscLyWmVfN0QuK991bzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpO1QLY+lgGpq41DG0eS4sOg/OXlfBtwVoX3kFEZOZ9kVcXPHIWO+6o0tgCzNt06q
	 PpV8QRMuD2h2ikRYDSWVE67z4Au2xb6ArOmrddn8JHc+DSz2GDFwaVyOUbtQMbBQsq
	 KzKcqJkdUMqHGRmMztrR8TNQbkMEUUbNbSqkYt5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/100] tracing: Fix uaf issue when open the hist or hist_debug file
Date: Thu, 18 Jan 2024 11:49:02 +0100
Message-ID: <20240118104313.256364141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit 1cc111b9cddc71ce161cd388f11f0e9048edffdb ]

KASAN report following issue. The root cause is when opening 'hist'
file of an instance and accessing 'trace_event_file' in hist_show(),
but 'trace_event_file' has been freed due to the instance being removed.
'hist_debug' file has the same problem. To fix it, call
tracing_{open,release}_file_tr() in file_operations callback to have
the ref count and avoid 'trace_event_file' being freed.

  BUG: KASAN: slab-use-after-free in hist_show+0x11e0/0x1278
  Read of size 8 at addr ffff242541e336b8 by task head/190

  CPU: 4 PID: 190 Comm: head Not tainted 6.7.0-rc5-g26aff849438c #133
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   dump_backtrace+0x98/0xf8
   show_stack+0x1c/0x30
   dump_stack_lvl+0x44/0x58
   print_report+0xf0/0x5a0
   kasan_report+0x80/0xc0
   __asan_report_load8_noabort+0x1c/0x28
   hist_show+0x11e0/0x1278
   seq_read_iter+0x344/0xd78
   seq_read+0x128/0x1c0
   vfs_read+0x198/0x6c8
   ksys_read+0xf4/0x1e0
   __arm64_sys_read+0x70/0xa8
   invoke_syscall+0x70/0x260
   el0_svc_common.constprop.0+0xb0/0x280
   do_el0_svc+0x44/0x60
   el0_svc+0x34/0x68
   el0t_64_sync_handler+0xb8/0xc0
   el0t_64_sync+0x168/0x170

  Allocated by task 188:
   kasan_save_stack+0x28/0x50
   kasan_set_track+0x28/0x38
   kasan_save_alloc_info+0x20/0x30
   __kasan_slab_alloc+0x6c/0x80
   kmem_cache_alloc+0x15c/0x4a8
   trace_create_new_event+0x84/0x348
   __trace_add_new_event+0x18/0x88
   event_trace_add_tracer+0xc4/0x1a0
   trace_array_create_dir+0x6c/0x100
   trace_array_create+0x2e8/0x568
   instance_mkdir+0x48/0x80
   tracefs_syscall_mkdir+0x90/0xe8
   vfs_mkdir+0x3c4/0x610
   do_mkdirat+0x144/0x200
   __arm64_sys_mkdirat+0x8c/0xc0
   invoke_syscall+0x70/0x260
   el0_svc_common.constprop.0+0xb0/0x280
   do_el0_svc+0x44/0x60
   el0_svc+0x34/0x68
   el0t_64_sync_handler+0xb8/0xc0
   el0t_64_sync+0x168/0x170

  Freed by task 191:
   kasan_save_stack+0x28/0x50
   kasan_set_track+0x28/0x38
   kasan_save_free_info+0x34/0x58
   __kasan_slab_free+0xe4/0x158
   kmem_cache_free+0x19c/0x508
   event_file_put+0xa0/0x120
   remove_event_file_dir+0x180/0x320
   event_trace_del_tracer+0xb0/0x180
   __remove_instance+0x224/0x508
   instance_rmdir+0x44/0x78
   tracefs_syscall_rmdir+0xbc/0x140
   vfs_rmdir+0x1cc/0x4c8
   do_rmdir+0x220/0x2b8
   __arm64_sys_unlinkat+0xc0/0x100
   invoke_syscall+0x70/0x260
   el0_svc_common.constprop.0+0xb0/0x280
   do_el0_svc+0x44/0x60
   el0_svc+0x34/0x68
   el0t_64_sync_handler+0xb8/0xc0
   el0t_64_sync+0x168/0x170

Link: https://lore.kernel.org/linux-trace-kernel/20231214012153.676155-1-zhengyejian1@huawei.com

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c             |  6 ++++++
 kernel/trace/trace.h             |  1 +
 kernel/trace/trace_events_hist.c | 12 ++++++++----
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b751c2ce9a34..2b3c4cd8382b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4916,6 +4916,12 @@ int tracing_release_file_tr(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+int tracing_single_release_file_tr(struct inode *inode, struct file *filp)
+{
+	tracing_release_file_tr(inode, filp);
+	return single_release(inode, filp);
+}
+
 static int tracing_mark_open(struct inode *inode, struct file *filp)
 {
 	stream_open(inode, filp);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 10aaafa2936d..aad7fcd84617 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -592,6 +592,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp);
 int tracing_open_generic_tr(struct inode *inode, struct file *filp);
 int tracing_open_file_tr(struct inode *inode, struct file *filp);
 int tracing_release_file_tr(struct inode *inode, struct file *filp);
+int tracing_single_release_file_tr(struct inode *inode, struct file *filp);
 bool tracing_is_disabled(void);
 bool tracer_tracing_is_on(struct trace_array *tr);
 void tracer_tracing_on(struct trace_array *tr);
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 1470af219073..3b0da1bddf63 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5532,10 +5532,12 @@ static int event_hist_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	ret = tracing_open_file_tr(inode, file);
 	if (ret)
 		return ret;
 
+	/* Clear private_data to avoid warning in single_open() */
+	file->private_data = NULL;
 	return single_open(file, hist_show, file);
 }
 
@@ -5543,7 +5545,7 @@ const struct file_operations event_hist_fops = {
 	.open = event_hist_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = single_release,
+	.release = tracing_single_release_file_tr,
 };
 
 #ifdef CONFIG_HIST_TRIGGERS_DEBUG
@@ -5809,10 +5811,12 @@ static int event_hist_debug_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	ret = tracing_open_file_tr(inode, file);
 	if (ret)
 		return ret;
 
+	/* Clear private_data to avoid warning in single_open() */
+	file->private_data = NULL;
 	return single_open(file, hist_debug_show, file);
 }
 
@@ -5820,7 +5824,7 @@ const struct file_operations event_hist_debug_fops = {
 	.open = event_hist_debug_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = single_release,
+	.release = tracing_single_release_file_tr,
 };
 #endif
 
-- 
2.43.0



