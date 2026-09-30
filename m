Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A515B515967;
	Wed, 30 Sep 2026 16:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784453; cv=none; b=hTq8TwksA2452cXXv8xjKSfTKuSdhLUwPd2uBnENEj/aOcpKxa2J9WN5KCkpplGg/dmcscJf9hkTQtqI8dLU3NpYPHCbt3AdfAgcV+yf6U5XfuAdltyRuzm94zvLTH4FFN0UeunnmarPLjv3LZnwRm8ylcT68hwwMRgYRxMaswE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784453; c=relaxed/simple;
	bh=eNsJV5gxkyuLH1MCqUjdevFOvRjIywXkjeMKeuERCFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgS415WuvLeL3BgqcBf1doKqOxuiMGYUxhErRiS/0k4+XtUeIr98V4nBP1RzJP7+7prhdE76FMZIO21WKvEayEMDt7Q+HEcwXUk1ojb0IuV5oKmyccNNOuJrH5NAkVN3XYjhOlBi2ihAG2y80o2AVXLM5LiprpcEFVRJD8KD4Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edTtfG0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edTtfG0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB99A1F00898;
	Wed, 30 Sep 2026 16:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784448;
	bh=qPMe8e2g5nSM1+8EFxNFBpEZf0OxLeEEH0RoC25+YtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edTtfG0dtuTod8ysvXx+jxCcsx5d2xE3rCkFnOhbd1bsRrUQ4V4zQ1GI6QSNhqFCK
	 /66P2BkIkJSdl7gUVD8cz7XDo+AAKKmK3mw42jr5qQ7qdbH6FbNpQcCgM51GsdoCbZ
	 563nRpTtFV1hBFzNYvazxSdG99c4Ms+PCAPlNz5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/982] bpf: NUL-terminate replaced sysctl value
Date: Wed, 30 Sep 2026 17:14:53 +0200
Message-ID: <20260930152420.182844786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 3929c7548e6ff..6158b021f617f 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -2148,6 +2148,7 @@ BPF_CALL_3(bpf_sysctl_set_new_value, struct bpf_sysctl_kern *, ctx,
 		return -E2BIG;
 
 	memcpy(ctx->new_val, buf, buf_len);
+	((char *)ctx->new_val)[buf_len] = '\0';
 	ctx->new_len = buf_len;
 	ctx->new_updated = 1;
 
-- 
2.53.0



