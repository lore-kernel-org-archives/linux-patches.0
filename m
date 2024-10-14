Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8E21798C;
	Mon, 14 Oct 2024 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919453; cv=none; b=TWYuPbxTMK5/PeghHBdrGGQdUUfgNjPyX2uIHmhnZdBQpu5kJXcu/F0/5RWkyMHuip0kyVZruRf3dTp+hfdq0KoEZAJpHjTdBrz8xH3jpHFKESfhCNuivk3jyPFQIpRAWUXSG+U2miR7c2eUWiZR7Fyl5HlLw20VLCKl5hv5AGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919453; c=relaxed/simple;
	bh=GDSGLhxgQpEytDzdcoIJoPCqPPsSyQQDAIaPOaW4H2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euGFBcajpOAu8nUmHX3z0d17elO2XamiKuJDDbSlFgWeFy6I9Up1ZY63kPbhBHAmjBRWULDRzqUQMfd+CBc9rv49FaGkCPhYCtiXmZX/Gx1bRIwh/TjPjHfbv8kEdcoY4dcq5woUZfmCVo54tYUBRfsDUZikCGC5FJKMFRhOXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Is/W38dD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Is/W38dD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E3EC4CEC3;
	Mon, 14 Oct 2024 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919453;
	bh=GDSGLhxgQpEytDzdcoIJoPCqPPsSyQQDAIaPOaW4H2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Is/W38dD0MuN2Lcjt0eK8hsJsnXTvjomn5FraFVNXlm2P5grk+jBQTMPxv5pxqhJk
	 IRjaPD67i/ILm6URsy0onIW7m9ERInRBfQDs1awKNS4I1WiAqi1G2Vq+WGvQVt7h2X
	 8VS6aQ6xEu1GVP+Qnwc8c6qGcnraIBlJUCNe4YE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 611/798] tracing/timerlat: Fix a race during cpuhp processing
Date: Mon, 14 Oct 2024 16:19:25 +0200
Message-ID: <20241014141242.028545539@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Wei Li <liwei391@huawei.com>

commit 829e0c9f0855f26b3ae830d17b24aec103f7e915 upstream.

There is another found exception that the "timerlat/1" thread was
scheduled on CPU0, and lead to timer corruption finally:

```
ODEBUG: init active (active state 0) object: ffff888237c2e108 object type: hrtimer hint: timerlat_irq+0x0/0x220
WARNING: CPU: 0 PID: 426 at lib/debugobjects.c:518 debug_print_object+0x7d/0xb0
Modules linked in:
CPU: 0 UID: 0 PID: 426 Comm: timerlat/1 Not tainted 6.11.0-rc7+ #45
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:debug_print_object+0x7d/0xb0
...
Call Trace:
 <TASK>
 ? __warn+0x7c/0x110
 ? debug_print_object+0x7d/0xb0
 ? report_bug+0xf1/0x1d0
 ? prb_read_valid+0x17/0x20
 ? handle_bug+0x3f/0x70
 ? exc_invalid_op+0x13/0x60
 ? asm_exc_invalid_op+0x16/0x20
 ? debug_print_object+0x7d/0xb0
 ? debug_print_object+0x7d/0xb0
 ? __pfx_timerlat_irq+0x10/0x10
 __debug_object_init+0x110/0x150
 hrtimer_init+0x1d/0x60
 timerlat_main+0xab/0x2d0
 ? __pfx_timerlat_main+0x10/0x10
 kthread+0xb7/0xe0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2d/0x40
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
```

After tracing the scheduling event, it was discovered that the migration
of the "timerlat/1" thread was performed during thread creation. Further
analysis confirmed that it is because the CPU online processing for
osnoise is implemented through workers, which is asynchronous with the
offline processing. When the worker was scheduled to create a thread, the
CPU may has already been removed from the cpu_online_mask during the offline
process, resulting in the inability to select the right CPU:

T1                       | T2
[CPUHP_ONLINE]           | cpu_device_down()
osnoise_hotplug_workfn() |
                         |     cpus_write_lock()
                         |     takedown_cpu(1)
                         |     cpus_write_unlock()
[CPUHP_OFFLINE]          |
    cpus_read_lock()     |
    start_kthread(1)     |
    cpus_read_unlock()   |

To fix this, skip online processing if the CPU is already offline.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240924094515.3561410-4-liwei391@huawei.com
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1813,6 +1813,8 @@ static void osnoise_hotplug_workfn(struc
 	mutex_lock(&interface_lock);
 	cpus_read_lock();
 
+	if (!cpu_online(cpu))
+		goto out_unlock;
 	if (!cpumask_test_cpu(cpu, &osnoise_cpumask))
 		goto out_unlock;
 


