Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528847CA85;
	Sat, 12 Sep 2026 13:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219723; cv=none; b=tpr8lAJ39yto49JzWROIpBT3apnvxFdKVkyUePBMaui/H3XAGY1HJDWc46ii6svH/vKBOytHI7YwsQjdJUUox5qejEax2dgEOQNv37TaHxfy7SdI8Fc5qz4prOrZKaad2G0UqN+BdB4+8sqSWaeHNFTQVkK1ecd9oaqYyl9z+Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219723; c=relaxed/simple;
	bh=y1596Ja+ULeBZtjqwX+KxKd7MeSKSfokJ2Ztq64yzaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEL5OW+ozgY/JhlhO83fL5OUcMbCoUj4T2q0cR7tQVVk0KSMkf5nxScmhVMkwh3WmdJ31lP++atMddq2NTmG0wxsOS9XJ0SxeJT8h3kNQNowfDeUCxt2FSBlllooPjOMBmr2kQe2HnTWqRH9vS+6tuus3TiD05ixCv5bZSMFX70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um2daVBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um2daVBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB53E1F00893;
	Sat, 12 Sep 2026 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219722;
	bh=AGU9u6oBvon3tiBMSR9FnZZRoHY8j+bXSnqR/xR5LwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=um2daVBjXaqEjm9OaNb8llDB8cCkVjjw2QmT3TQ3wuBDKpLkkkZ5sgRGqbhmm271r
	 Y40Vsp7UPSvX6w0HrYdbvUInF4RHl5qLCZjkxZudTJRX8FDfYn31zzLB7kIhGC6bMx
	 TV2aC3ARlCarAiRvOLwyn7lyyNgQCASiDVP+a878=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 0024/1424] tracing: Fix use-after-free with same-name named triggers
Date: Sat, 12 Sep 2026 08:40:56 +0200
Message-ID: <20260912065607.846007324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit a7318172aa332a161fb9618286e64454c827f8fd upstream.

When two hist triggers on different events are registered with the same
name=, the second one reuses the first as named_data.  Both are added to
tr->hist_vars by save_hist_vars() during event_hist_trigger_parse(),
because save_hist_vars() is called before event_trigger_register() while
the named reuse is only detected later, in hist_register_trigger().

In the named-data branch hist_register_trigger() then frees the second
histogram's hist_data via destroy_hist_data(), but never removes its
tr->hist_vars list entry, leaving a dangling pointer and leaking the
trace_array reference it holds.

A later hist trigger that references a variable makes find_var_file()
walk tr->hist_vars and dereference the freed hist_data.  The bug is
reproducible from userspace by writing three hist triggers to tracefs:

  cd /sys/kernel/tracing
  echo 'hist:keys=common_pid:x=common_pid:name=mh' > events/sched/sched_switch/trigger
  echo 'hist:keys=common_pid:x=common_pid:name=mh' > events/sched/sched_process_fork/trigger
  echo 'hist:keys=common_pid:vals=$x' > events/sched/sched_process_exit/trigger

The third write panics the kernel:

  BUG: KASAN: slab-use-after-free in find_var_file.part.0+0x272/0x290
  Read of size 8 at addr ffff888001f8a0e0 by task sh/1
  CPU: 1 UID: 0 PID: 1 Comm: sh Tainted: G      D          N
  Call Trace:
    find_var_file.part.0
    find_event_var
    parse_atom
    parse_expr
    __create_val_field
    event_hist_trigger_parse
    trigger_process_regex
    event_trigger_write
    vfs_write
    ksys_write
    do_syscall_64
    entry_SYSCALL_64_after_hwframe
  Allocated by task 1:
    event_hist_trigger_parse
  Freed by task 1:
    hist_register_trigger+0x618/0xa30
    event_hist_trigger_parse
  The buggy address belongs to freed 2048-byte region
  Oops: general protection fault ... RIP: find_var_file.part.0
  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Fix by removing the hist_data from tr->hist_vars and releasing the
trace_array reference in the named-data branch of hist_register_trigger()
before freeing the hist_data.

Cc: stable@vger.kernel.org
Fixes: 6f86bdeab633 ("tracing: Fix bad hist from corrupting named_triggers list")
Link: https://patch.msgid.link/20260816100427.33642-3-sh_def@163.com
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6593,8 +6593,10 @@ static int hist_register_trigger(char *g
 		tracing_set_filter_buffering(file->tr, true);
 	}
 
-	if (named_data)
+	if (named_data) {
+		remove_hist_vars(hist_data);
 		destroy_hist_data(hist_data);
+	}
  out:
 	return ret;
 }


