Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6257145A14;
	Thu, 13 Jun 2024 12:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280097; cv=none; b=dS/Lds8N7CgrPoxI2ctVpqTh2AVYJbGtAkXcSEVwkYF4nhL3ItnbPA5S2oaiK29iJXaCQk4RsJkIgApiGv41d4ujzhZ+afSwQ8HDeGSrhrJ2DUNbsNNd8pso5jxK39fcR/E3EQm1+lco1FbOQJUdCcXgYJXTtT3r/1qLa+AizNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280097; c=relaxed/simple;
	bh=1rPTRgZFWgkbw1skHOEzzuomBICQ9d/JO15WOqTQw0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bozqmfCj6aa6Ov53CNTnaLDpKwJoDQ6shvRagvbewFm5UMqvv+nsQtdTL0y/XlMuZkcEGBOCjD++0FBgesw4o+2CgvqiSWneGf9GTXRr3XDZSUXkcnrMpmyYFnSBWHMNzt+ZPJbwh5ZMlqI/DKZk9SEwMRRiXi20j68E8kTYQ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbcsw5VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbcsw5VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517E2C2BBFC;
	Thu, 13 Jun 2024 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280097;
	bh=1rPTRgZFWgkbw1skHOEzzuomBICQ9d/JO15WOqTQw0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dbcsw5VMzx7bY/uePe1NwuZXw1y7ZOGaFESGPV1NtCpl5AE1oCgtYBEf8rinMhNtx
	 UTSOX0fRwXLqVv+eKBEvUQ3JRL1aevoXLaTzKshe6Hq5QHud3sGXcvNDViWgSdJrGw
	 doZBWwWyDZ84r2x753TD6BbskHDWBvPycjwNWQ4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Yue Sun <samsun1006219@gmail.com>,
	xingwei lee <xrivendell7@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/202] tcp: Fix shift-out-of-bounds in dctcp_update_alpha().
Date: Thu, 13 Jun 2024 13:33:59 +0200
Message-ID: <20240613113233.201774466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3ebc46ca8675de6378e3f8f40768e180bb8afa66 ]

In dctcp_update_alpha(), we use a module parameter dctcp_shift_g
as follows:

  alpha -= min_not_zero(alpha, alpha >> dctcp_shift_g);
  ...
  delivered_ce <<= (10 - dctcp_shift_g);

It seems syzkaller started fuzzing module parameters and triggered
shift-out-of-bounds [0] by setting 100 to dctcp_shift_g:

  memcpy((void*)0x20000080,
         "/sys/module/tcp_dctcp/parameters/dctcp_shift_g\000", 47);
  res = syscall(__NR_openat, /*fd=*/0xffffffffffffff9cul, /*file=*/0x20000080ul,
                /*flags=*/2ul, /*mode=*/0ul);
  memcpy((void*)0x20000000, "100\000", 4);
  syscall(__NR_write, /*fd=*/r[0], /*val=*/0x20000000ul, /*len=*/4ul);

Let's limit the max value of dctcp_shift_g by param_set_uint_minmax().

With this patch:

  # echo 10 > /sys/module/tcp_dctcp/parameters/dctcp_shift_g
  # cat /sys/module/tcp_dctcp/parameters/dctcp_shift_g
  10
  # echo 11 > /sys/module/tcp_dctcp/parameters/dctcp_shift_g
  -bash: echo: write error: Invalid argument

[0]:
UBSAN: shift-out-of-bounds in net/ipv4/tcp_dctcp.c:143:12
shift exponent 100 is too large for 32-bit type 'u32' (aka 'unsigned int')
CPU: 0 PID: 8083 Comm: syz-executor345 Not tainted 6.9.0-05151-g1b294a1f3561 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x201/0x300 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x346/0x3a0 lib/ubsan.c:468
 dctcp_update_alpha+0x540/0x570 net/ipv4/tcp_dctcp.c:143
 tcp_in_ack_event net/ipv4/tcp_input.c:3802 [inline]
 tcp_ack+0x17b1/0x3bc0 net/ipv4/tcp_input.c:3948
 tcp_rcv_state_process+0x57a/0x2290 net/ipv4/tcp_input.c:6711
 tcp_v4_do_rcv+0x764/0xc40 net/ipv4/tcp_ipv4.c:1937
 sk_backlog_rcv include/net/sock.h:1106 [inline]
 __release_sock+0x20f/0x350 net/core/sock.c:2983
 release_sock+0x61/0x1f0 net/core/sock.c:3549
 mptcp_subflow_shutdown+0x3d0/0x620 net/mptcp/protocol.c:2907
 mptcp_check_send_data_fin+0x225/0x410 net/mptcp/protocol.c:2976
 __mptcp_close+0x238/0xad0 net/mptcp/protocol.c:3072
 mptcp_close+0x2a/0x1a0 net/mptcp/protocol.c:3127
 inet_release+0x190/0x1f0 net/ipv4/af_inet.c:437
 __sock_release net/socket.c:659 [inline]
 sock_close+0xc0/0x240 net/socket.c:1421
 __fput+0x41b/0x890 fs/file_table.c:422
 task_work_run+0x23b/0x300 kernel/task_work.c:180
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x9c8/0x2540 kernel/exit.c:878
 do_group_exit+0x201/0x2b0 kernel/exit.c:1027
 __do_sys_exit_group kernel/exit.c:1038 [inline]
 __se_sys_exit_group kernel/exit.c:1036 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1036
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xe4/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x67/0x6f
RIP: 0033:0x7f6c2b5005b6
Code: Unable to access opcode bytes at 0x7f6c2b50058c.
RSP: 002b:00007ffe883eb948 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f6c2b5862f0 RCX: 00007f6c2b5005b6
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 0000000000000001 R08: 00000000000000e7 R09: ffffffffffffffc0
R10: 0000000000000006 R11: 0000000000000246 R12: 00007f6c2b5862f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Reported-by: syzkaller <syzkaller@googlegroups.com>
Reported-by: Yue Sun <samsun1006219@gmail.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Closes: https://lore.kernel.org/netdev/CAEkJfYNJM=cw-8x7_Vmj1J6uYVCWMbbvD=EFmDPVBGpTsqOxEA@mail.gmail.com/
Fixes: e3118e8359bb ("net: tcp: add DCTCP congestion control algorithm")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240517091626.32772-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_dctcp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 79f705450c162..be2c97e907ae2 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -55,7 +55,18 @@ struct dctcp {
 };
 
 static unsigned int dctcp_shift_g __read_mostly = 4; /* g = 1/2^4 */
-module_param(dctcp_shift_g, uint, 0644);
+
+static int dctcp_shift_g_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 0, 10);
+}
+
+static const struct kernel_param_ops dctcp_shift_g_ops = {
+	.set = dctcp_shift_g_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(dctcp_shift_g, &dctcp_shift_g_ops, &dctcp_shift_g, 0644);
 MODULE_PARM_DESC(dctcp_shift_g, "parameter g for updating dctcp_alpha");
 
 static unsigned int dctcp_alpha_on_init __read_mostly = DCTCP_MAX_ALPHA;
-- 
2.43.0



