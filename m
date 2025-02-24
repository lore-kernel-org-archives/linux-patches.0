Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7ED13AD18;
	Mon, 24 Feb 2025 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409089; cv=none; b=emhWbwZJGqkw3nOoY8r9uVkWqmRBBL2kQVB3dAvwVO8yi8rmLeVI0xxhYolsw2gXVRWhzzO/yj9HHK5d1RzdO+xghp5wTNFzt/84Hh+HP/a1iFaFQBZSIRebLxbFfEWS4uqfq9JYizhScvCzERCjciq7/nf4o6xON8wBz/UVT4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409089; c=relaxed/simple;
	bh=L0/fgzXMnfG9wLfNPgXCEw4D7rPz6CHJrd1SJuEo214=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6bv/wR/xgoUBRZ8M6+WCryO0ueEYpfTSM8Lbkgj7o6tZSDYfBAMNk1O5RQm+wFKhPmTq9NI8B1/LEB8TiIFfsEJu8TaV9EFg0gBnMSJBZx72RrZj/40ceha/U649en6LjbL5gBwTQJwCi1zx9WysgZLs4wSv2ntMRyIdODulWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7k6BHdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7k6BHdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAF5C4CED6;
	Mon, 24 Feb 2025 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409088;
	bh=L0/fgzXMnfG9wLfNPgXCEw4D7rPz6CHJrd1SJuEo214=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7k6BHdzhitP1yT6MU0Eg7zkfJVAjJLe5L6VEu3IUyxgg2oev5c7i7zAi1oChDTKH
	 RcgQd2gi/QxIIGY857ESmr9+ge2esnR8SsLmYJohDF/ZcMIAMO1tro+EeEx+yBXmga
	 vO9kUN2ofSuN7mlyIE0p+NEiYw06UKlzbBIg4BuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhai <yan@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 061/138] net: Add rx_skb of kfree_skb to raw_tp_null_args[].
Date: Mon, 24 Feb 2025 15:34:51 +0100
Message-ID: <20250224142606.879823908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5da7e15fb5a12e78de974d8908f348e279922ce9 ]

Yan Zhai reported a BPF prog could trigger a null-ptr-deref [0]
in trace_kfree_skb if the prog does not check if rx_sk is NULL.

Commit c53795d48ee8 ("net: add rx_sk to trace_kfree_skb") added
rx_sk to trace_kfree_skb, but rx_sk is optional and could be NULL.

Let's add kfree_skb to raw_tp_null_args[] to let the BPF verifier
validate such a prog and prevent the issue.

Now we fail to load such a prog:

  libbpf: prog 'drop': -- BEGIN PROG LOAD LOG --
  0: R1=ctx() R10=fp0
  ; int BPF_PROG(drop, struct sk_buff *skb, void *location, @ kfree_skb_sk_null.bpf.c:21
  0: (79) r3 = *(u64 *)(r1 +24)
  func 'kfree_skb' arg3 has btf_id 5253 type STRUCT 'sock'
  1: R1=ctx() R3_w=trusted_ptr_or_null_sock(id=1)
  ; bpf_printk("sk: %d, %d\n", sk, sk->__sk_common.skc_family); @ kfree_skb_sk_null.bpf.c:24
  1: (69) r4 = *(u16 *)(r3 +16)
  R3 invalid mem access 'trusted_ptr_or_null_'
  processed 2 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
  -- END PROG LOAD LOG --

Note this fix requires commit 838a10bd2ebf ("bpf: Augment raw_tp
arguments with PTR_MAYBE_NULL").

[0]:
BUG: kernel NULL pointer dereference, address: 0000000000000010
 PF: supervisor read access in kernel mode
 PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
PREEMPT SMP
RIP: 0010:bpf_prog_5e21a6db8fcff1aa_drop+0x10/0x2d
Call Trace:
 <TASK>
 ? __die+0x1f/0x60
 ? page_fault_oops+0x148/0x420
 ? search_bpf_extables+0x5b/0x70
 ? fixup_exception+0x27/0x2c0
 ? exc_page_fault+0x75/0x170
 ? asm_exc_page_fault+0x22/0x30
 ? bpf_prog_5e21a6db8fcff1aa_drop+0x10/0x2d
 bpf_trace_run4+0x68/0xd0
 ? unix_stream_connect+0x1f4/0x6f0
 sk_skb_reason_drop+0x90/0x120
 unix_stream_connect+0x1f4/0x6f0
 __sys_connect+0x7f/0xb0
 __x64_sys_connect+0x14/0x20
 do_syscall_64+0x47/0xc30
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: c53795d48ee8 ("net: add rx_sk to trace_kfree_skb")
Reported-by: Yan Zhai <yan@cloudflare.com>
Closes: https://lore.kernel.org/netdev/Z50zebTRzI962e6X@debian.debian/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Tested-by: Yan Zhai <yan@cloudflare.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250201030142.62703-1-kuniyu@amazon.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 10d0975deadab..c89604e6b6aab 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6507,6 +6507,8 @@ static const struct bpf_raw_tp_null_args raw_tp_null_args[] = {
 	/* rxrpc */
 	{ "rxrpc_recvdata", 0x1 },
 	{ "rxrpc_resend", 0x10 },
+	/* skb */
+	{"kfree_skb", 0x1000},
 	/* sunrpc */
 	{ "xs_stream_read_data", 0x1 },
 	/* ... from xprt_cong_event event class */
-- 
2.39.5



