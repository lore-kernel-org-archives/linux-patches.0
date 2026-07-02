Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED823491E1;
	Thu,  2 Jul 2026 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010688; cv=none; b=cgCzmcqjQN6VUNog5rSPFrFfM4m1blufHJwGXV0q+9Fbx4mshbZhUAJBbWqmo+1zAHDY54pdxpyFqw5pDgWgFfz68Xg04aNDbh74eu+Yaf8D51PNl1el5HYSK5ORDY+Upde1fB/SHfK6xgcafENH3Y8wGHfhveweHKV2zEobyaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010688; c=relaxed/simple;
	bh=SJIwSsotUKEOj41pk1O+XlRvHb8pRf3MnE9Hkes4wOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzE6/FLo5qGM+EpIjUdu9URbFmEFPXlBZKkibacq3qfC7SxGmrljfC+/dPfWeYmw4ildKUFt79kLG2QHX3R18dVsmVBW9dHBxRV8ctDs4nDqmmFOFMdxtyEeUsuH76Eiv9SFH2xVyfsnj+9WpEDoezGA+1gIYBKLDAJllICgwcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AHBUJwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AHBUJwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDBE1F000E9;
	Thu,  2 Jul 2026 16:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010687;
	bh=sgQeBKyBW6t8S1+ka4g6YSs6HcXrwBlc6uAgW87i9FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AHBUJwLTxLZDHCujr4tRDD7FObwiy65pNqvE5wzAp95nhypiDfQx5A/E5DDTtSaK
	 OOSejmYKJJSX2X+/zVeDGIkBg2lQyWrquO//uZ8NugvkmPYk+02+dbGiG8aiBOi3FK
	 4Qubfop5EBI5QnDBTg3VA7zwK8/wTsq2JB6mZG1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 160/204] bpf: use kvfree() for replaced sysctl write buffer
Date: Thu,  2 Jul 2026 18:20:17 +0200
Message-ID: <20260702155122.011236344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 4c21b5927d4364bfe7365f2700da5fea0ed0d004 upstream.

proc_sys_call_handler() allocates its temporary sysctl buffer with
kvzalloc() and passes it to __cgroup_bpf_run_filter_sysctl(). Since
kvzalloc() may fall back to vmalloc() for large allocations, freeing
that buffer with kfree() is wrong and can corrupt memory.

Use kvfree() to safely handle both kmalloc and kvzalloc()/vmalloc
allocations.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc5.

Reproduced the bug based on v7.1-rc4 in a QEMU x86_64 guest booted with
KASAN and CONFIG_FAILSLAB enabled. To exercise the replacement path, the
test tree also included the accompanying fix for the stale ret == 1
check in __cgroup_bpf_run_filter_sysctl(). The reproducer confines
failslab injections to the proc_sys_call_handler() range, uses
stacktrace-depth=32, and injects fail-nth=1 while writing 8191 bytes to
/proc/sys/kernel/domainname from a task in the target cgroup. Under
that setup, fail-nth=1 triggered the fault:

  BUG: unable to handle page fault for address: ffffeb0200024d48
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000  SMP KASAN NOPTI
  CPU: 2 UID: 0 PID: 209 Comm: repro_proc_sys_ Not tainted 7.1.0-rc4-00686-g97625979a5d4  PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
  RIP: 0010:kfree+0x6e/0x510
  ...
  Call Trace:
   <TASK>
   ? __cgroup_bpf_run_filter_sysctl+0x626/0xc30
   __cgroup_bpf_run_filter_sysctl+0x74d/0xc30
   ? __pfx___cgroup_bpf_run_filter_sysctl+0x10/0x10
   ? srso_return_thunk+0x5/0x5f
   ? __kvmalloc_node_noprof+0x345/0x870
   ? proc_sys_call_handler+0x250/0x480
   ? srso_return_thunk+0x5/0x5f
   proc_sys_call_handler+0x3a2/0x480
   ? __pfx_proc_sys_call_handler+0x10/0x10
   ? srso_return_thunk+0x5/0x5f
   ? selinux_file_permission+0x39f/0x500
   ? srso_return_thunk+0x5/0x5f
   ? lock_is_held_type+0x9e/0x120
   vfs_write+0x98e/0x1000
   ...
   </TASK>

With this fix applied on top of the same test setup, rerunning the
reproducer with fail-nth=1 yields no corresponding Oops reports.

Fixes: 4508943794ef ("proc: use kvzalloc for our kernel buffer")
Cc: stable@vger.kernel.org

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://lore.kernel.org/r/20260603105317.944304-3-dawei.feng@seu.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1774,7 +1774,7 @@ int __cgroup_bpf_run_filter_sysctl(struc
 	kfree(ctx.cur_val);
 
 	if (ret == 1 && ctx.new_updated) {
-		kfree(*buf);
+		kvfree(*buf);
 		*buf = ctx.new_val;
 		*pcount = ctx.new_len;
 	} else {


