Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DC91EE02F;
	Tue, 30 Sep 2025 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245071; cv=none; b=XRgCsKmhNdRpoN6xPWmugi0QewSdwFrP57X1pdeVCr8FDstRunGx1WgoaaV+nGvfNh/52SzcUmJf8G+Ay3U/IrQQCeC3aOfJahE7KmfbiDnJxvq5YHP7kElTdsbMsV6t1+VfVxzP5bvKGifJ2uyZXa/z4NITI6aWaVDqPCy94cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245071; c=relaxed/simple;
	bh=0IRF/TqRhegeGpGnvURowcEOoRFyXW3nvHJicufFIHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDzWNZMNCglaqlJ+wif1e3clKTQxpkiMz6JPiC4rrvKE9p1ymVy0nrrz3fb09z5hihpiylFGjh5nctZzjmtBknwsZC6xno7PoL9jWQzHkpTe5Ed9tlfLID2PtuKSq6XyO7oGaJygSEgwcDcc7nL3Y7TbFVbJycj1+JSaL00FTFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3WbPQ1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3WbPQ1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67F3C4CEF0;
	Tue, 30 Sep 2025 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245071;
	bh=0IRF/TqRhegeGpGnvURowcEOoRFyXW3nvHJicufFIHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3WbPQ1pmVT3cnTjX1jISnE9FauuBAUj8En2PmhSdJBKrQM465Vv31BpknEu0U0hu
	 r/DgGT3WR+RHcOqvvdzrBztLrEpCt9HliOlxa7EbDAhSNIAQNoFYiOQlhIDksk4iyg
	 AQrQvm5TdrVQZp1qOJkPD9L7h/aZCwz6jbLqAXlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4cabd1d2fa917a456db8@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/151] tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.
Date: Tue, 30 Sep 2025 16:45:46 +0200
Message-ID: <20250930143828.252614226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit a3967baad4d533dc254c31e0d221e51c8d223d58 ]

syzbot reported the splat below. [0]

The repro does the following:

  1. Load a sk_msg prog that calls bpf_msg_cork_bytes(msg, cork_bytes)
  2. Attach the prog to a SOCKMAP
  3. Add a socket to the SOCKMAP
  4. Activate fault injection
  5. Send data less than cork_bytes

At 5., the data is carried over to the next sendmsg() as it is
smaller than the cork_bytes specified by bpf_msg_cork_bytes().

Then, tcp_bpf_send_verdict() tries to allocate psock->cork to hold
the data, but this fails silently due to fault injection + __GFP_NOWARN.

If the allocation fails, we need to revert the sk->sk_forward_alloc
change done by sk_msg_alloc().

Let's call sk_msg_free() when tcp_bpf_send_verdict fails to allocate
psock->cork.

The "*copied" also needs to be updated such that a proper error can
be returned to the caller, sendmsg. It fails to allocate psock->cork.
Nothing has been corked so far, so this patch simply sets "*copied"
to 0.

[0]:
WARNING: net/ipv4/af_inet.c:156 at inet_sock_destruct+0x623/0x730 net/ipv4/af_inet.c:156, CPU#1: syz-executor/5983
Modules linked in:
CPU: 1 UID: 0 PID: 5983 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:inet_sock_destruct+0x623/0x730 net/ipv4/af_inet.c:156
Code: 0f 0b 90 e9 62 fe ff ff e8 7a db b5 f7 90 0f 0b 90 e9 95 fe ff ff e8 6c db b5 f7 90 0f 0b 90 e9 bb fe ff ff e8 5e db b5 f7 90 <0f> 0b 90 e9 e1 fe ff ff 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 9f fc
RSP: 0018:ffffc90000a08b48 EFLAGS: 00010246
RAX: ffffffff8a09d0b2 RBX: dffffc0000000000 RCX: ffff888024a23c80
RDX: 0000000000000100 RSI: 0000000000000fff RDI: 0000000000000000
RBP: 0000000000000fff R08: ffff88807e07c627 R09: 1ffff1100fc0f8c4
R10: dffffc0000000000 R11: ffffed100fc0f8c5 R12: ffff88807e07c380
R13: dffffc0000000000 R14: ffff88807e07c60c R15: 1ffff1100fc0f872
FS:  00005555604c4500(0000) GS:ffff888125af1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555604df5c8 CR3: 0000000032b06000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __sk_destruct+0x86/0x660 net/core/sock.c:2339
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xca8/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>

Fixes: 4f738adba30a ("bpf: create tcp_bpf_ulp allowing BPF to monitor socket TX/RX data")
Reported-by: syzbot+4cabd1d2fa917a456db8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68c0b6b5.050a0220.3c6139.0013.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250909232623.4151337-1-kuniyu@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9e24542251b1c..11cb3a353cc6d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -363,8 +363,11 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		if (!psock->cork) {
 			psock->cork = kzalloc(sizeof(*psock->cork),
 					      GFP_ATOMIC | __GFP_NOWARN);
-			if (!psock->cork)
+			if (!psock->cork) {
+				sk_msg_free(sk, msg);
+				*copied = 0;
 				return -ENOMEM;
+			}
 		}
 		memcpy(psock->cork, msg, sizeof(*msg));
 		return 0;
-- 
2.51.0



