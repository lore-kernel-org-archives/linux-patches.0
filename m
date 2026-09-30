Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0014FD79A;
	Wed, 30 Sep 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782616; cv=none; b=gA3hPdL7jWoTXYiTBKb2Coro43mecxFwOplBHSTHbrAZCaBwHQSl64uln0RQITz6K8xXozphC875tpN+PPiAT6/PdmaeqjrvQzhwIeRaXyCd3FnOtNcPWkcVy3SDT0O7DFdTc/PRxs7zcE8110fuSbesKajtJ9OAkz7sCMF5Yo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782616; c=relaxed/simple;
	bh=79opAEbxPjKIZgvaFWpm/hlG+AW+BDHLeLY/yLOhMHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUjIF+N5b9jSSPewqBWsnX9o7NuutdneH27zvw1N54J91bUdCZBuQU811jrF1qe7xIyWxvNjTEE39VIoQyGlo6TkdM4kSMO3mQYPQ/VfgsjH6lcEyCvmk9y8lX+aiUGLpSNLFDMq9tTIvlBUx26FYkBrwV4UXyMm5R36Jqwd0ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNS+P5Pc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNS+P5Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D91A1F00893;
	Wed, 30 Sep 2026 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782604;
	bh=NBHlOFMMJTVEfFEwdKv8hIe917eqiXdhLimcW+tEG/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNS+P5Pcg2ZSSll2AI88eGGo6x+r1F6DyqNv+r9NmdbjyONilE+UG5zbxTBmTjOAY
	 E1/GWBm879q6L81tAvqATNhDjCDmJHExlDy7SPKvg3TA+EeqhZkS/Mou7/hjuRHp6H
	 n1O4XHGqK4o48LX4lYGdFjQbPOx0i2/4FHF81clY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/595] bpf: NUL-terminate replaced sysctl value
Date: Wed, 30 Sep 2026 17:19:56 +0200
Message-ID: <20260930152349.953490531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit a66e3b5bacf38d6ab29fa05a9754f7a114485605 ]

When writing to sysctls, proc_sys_call_handler() guarantees that the
buffer passed to proc handlers is NUL-terminated. If
bpf_sysctl_set_new_value() replaces the pending sysctl value, it can
hand a replacement buffer directly to proc handlers. However, the
helper currently copies only buf_len bytes into that buffer without
appending a NUL terminator, leaving downstream parsers vulnerable to
out-of-bounds access.

Fix this by appending a '\0' after the replaced value to restore the
expected sysctl semantics. Since the helper already rejects buf_len
greater than PAGE_SIZE - 1, there is always room for the extra byte.

Reproduced in a QEMU x86_64 guest booted with KASAN while exercising
the sysctl replacement path with a cgroup/sysctl BPF program. The
reproducer targets `/proc/sys/net/core/flow_limit_cpu_bitmap`, fills
the original user write buffer with non-zero bytes, and overrides the
sysctl value so the replacement buffer lacks a terminating NUL. Under
that setup, the pre-fix kernel reported:

  BUG: KASAN: slab-out-of-bounds in strnchrnul+0x72/0x90
  Read of size 1 at addr ffff88800de57000 by task repro_patch3/66
  CPU: 0 UID: 0 PID: 66 Comm: repro_patch3 Not tainted 7.1.0-rc3-00269-g8370ca1f87cc #6 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x68/0xa0
   print_report+0xcb/0x5e0
   ? __virt_addr_valid+0x21d/0x3f0
   ? strnchrnul+0x72/0x90
   ? strnchrnul+0x72/0x90
   kasan_report+0xca/0x100
   ? strnchrnul+0x72/0x90
   strnchrnul+0x72/0x90
   bitmap_parse+0x37/0x2e0
   flow_limit_cpu_sysctl+0xc6/0x840
   ? __pfx_flow_limit_cpu_sysctl+0x10/0x10
   ? __kvmalloc_node_noprof+0x5ba/0x870
   proc_sys_call_handler+0x31d/0x480
   ? __pfx_proc_sys_call_handler+0x10/0x10
   ? selinux_file_permission+0x39f/0x500
   ? lock_is_held_type+0x9e/0x120
   vfs_write+0x98e/0x1000
   ...
   </TASK>
  The buggy address is located 0 bytes to the right of
  allocated 4096-byte region [ffff88800de56000, ffff88800de57000)
With this fix applied, rerunning the same sysctl-targeted path yields
no corresponding KASAN reports.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260603105317.944304-2-dawei.feng@seu.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 72fc467b7397c..ee272477a460e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1727,6 +1727,7 @@ BPF_CALL_3(bpf_sysctl_set_new_value, struct bpf_sysctl_kern *, ctx,
 		return -E2BIG;
 
 	memcpy(ctx->new_val, buf, buf_len);
+	((char *)ctx->new_val)[buf_len] = '\0';
 	ctx->new_len = buf_len;
 	ctx->new_updated = 1;
 
-- 
2.53.0



