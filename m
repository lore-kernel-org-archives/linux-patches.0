Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D43B1EFC;
	Tue, 21 Jul 2026 20:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666204; cv=none; b=e4ykpojUPHpd9dfmXAQa5AvVMdmqmILE65e92AhzTSQyffXW72c4k3AzR14ysXRK/LFJmxhfTwIF95AhQ6vRaLs0H88hNY3ZkVanv76dEq8CjVPblXlTtoF5ezaFKGQTx2T1W8AkNllNcoecMxvhC7p3iJPjc74Bs1UEE5e9qOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666204; c=relaxed/simple;
	bh=ivORWIW1mM2NKyEucKdYfGUNoYldX2QlZyldPxpsWPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZclSNTgwkOOkTub9Osjz+k1ZleeQULbDV7e47rLdOXxLO4eCt+p6lgOy6QxeBCLgWI6RBR0GEiZI+KGXvksBybkqoMJLM/2Tuvup201J1E5/Bc+mqvdx3aWI+6bi27R48FnWLIswMWMwFx+RSUxPSVWlUR/D2QNCvo5ZZVNUnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSUz8ijP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSUz8ijP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB67D1F00A3A;
	Tue, 21 Jul 2026 20:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666201;
	bh=ZgQr/dkbjXtoTFt1eJ6dyxBTs3VQ72hZ5q8Az1LPd/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSUz8ijPKhDOoU+uaFZ0tlw6nFxrn10JELTj7PPZhMm1/CqFTZEejZUZxzny7V7UL
	 mrTtcmsELjBc83uTWO1+YlCyJiTea1OUHlsas1NtCSc1JcLdE7JQpS/p+HCbsc2E9+
	 2x1d4JS8YnhT60iMK9yPaXEci7DIwWAYs1rosd6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0591/1266] bpf, sockmap: fix integer overflow in bpf_msg_pop_data() bounds check
Date: Tue, 21 Jul 2026 17:17:08 +0200
Message-ID: <20260721152455.091569419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit a48802fb2cd2d1e23651989f8ff4d15e9d5dad54 ]

start and len are u32, so

	u64 last = start + len;

evaluates start + len in 32-bit and wraps before storing it in last.
The bounds check

	if (start >= offset + l || last > msg->sg.size)
		return -EINVAL;

can then be passed with an out-of-range start/len, after which the pop
loop runs off the end of the scatterlist and sk_msg_shift_left() calls
put_page() on the empty msg->sg.end slot:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:sk_msg_shift_left net/core/filter.c:2957 [inline]
  RIP: 0010:____bpf_msg_pop_data net/core/filter.c:3103 [inline]
  RIP: 0010:bpf_msg_pop_data+0x753/0x1a10 net/core/filter.c:2984
  Call Trace:
   <TASK>
   bpf_prog_4cc92c278f4d5d56+0x1b1/0x1e8
   bpf_prog_run_pin_on_cpu+0x107/0x320 include/linux/filter.h:746
   sk_psock_msg_verdict+0x357/0x7f0 net/core/skmsg.c:934
   tcp_bpf_send_verdict net/ipv4/tcp_bpf.c:420 [inline]
   tcp_bpf_sendmsg+0x766/0x1ae0 net/ipv4/tcp_bpf.c:583
   __sock_sendmsg+0x153/0x1c0 net/socket.c:802
   __sys_sendto+0x326/0x430 net/socket.c:2265
   __x64_sys_sendto+0xe3/0x100 net/socket.c:2268
   do_syscall_64+0x14c/0x480
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

Widen the addition with a (u64) cast so the bound is evaluated in
64-bit and a len near U32_MAX no longer wraps below msg->sg.size.

While here, change pop from int to u32. It counts bytes against the
unsigned scatterlist lengths and can never be negative, so the signed
type only invites sign-confusion in the pop loop.

Fixes: 7246d8ed4dcc ("bpf: helper to pop data from messages")
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260615021959.140010-6-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index be51e8281109ac..3e01ce9f01dfd0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2988,8 +2988,8 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	   u32, len, u64, flags)
 {
 	u32 i = 0, l = 0, space, offset = 0;
-	u64 last = start + len;
-	int pop;
+	u64 last = (u64)start + len;
+	u32 pop;
 
 	if (unlikely(flags))
 		return -EINVAL;
-- 
2.53.0



