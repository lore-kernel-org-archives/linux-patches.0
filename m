Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1B53365;
	Thu, 12 Dec 2024 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023136; cv=none; b=fpbB5V/IHhkbCh1x7V5nEsGQ1THQ0sKvuGKhuUMiIrn2taBBVjYWv+36FN1vz/9QPF1F613v/W5B359m5hQHkP99ZD6LAELjDCSm+97dkWl8cY9rEFCpsRYhOWjqpd3HzYyu3guMPf7ubeZcME7E2sNq//rXfkedsroJFLoyMEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023136; c=relaxed/simple;
	bh=X7UQEH5saVLA1AfVc/AOKdPdKQEuYEyt5X/Cf7avozA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjuJ2jS0KMQgKDRR4EzA6xBVcXeky6WeQcI8oQss+5bMyPI5DkY1Pe0az3Efp/CmEY7YnE7APelgMtYFl4gOSRhfs3XtEI0yWl0IdadnW7e+f5Lkq5z8aHdShPiGX6AtvIwxe81n1rrCbDQu8XJbCK8bq8miFkJNmT5TLGDWi50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqZkwJpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqZkwJpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6D9C4CECE;
	Thu, 12 Dec 2024 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023136;
	bh=X7UQEH5saVLA1AfVc/AOKdPdKQEuYEyt5X/Cf7avozA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqZkwJpPyPGFtPJte0AiPvi4uF+FBWpCOGFQ8Nm5fd3QNKSPWbv59Mu/FdSm6E7Xm
	 xYSMpLjma1+6blyr0Yl3L7lBZiuLPILwRRYRSpC5C2yKaStFTBkCHVCbWmoi4BvyEe
	 eaxlxPfXB66Idieynuu6s8okqTFntOuGyalY+z1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/565] tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg
Date: Thu, 12 Dec 2024 16:00:30 +0100
Message-ID: <20241212144328.879707564@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit ca70b8baf2bd125b2a4d96e76db79375c07d7ff2 ]

The current sk memory accounting logic in __SK_REDIRECT is pre-uncharging
tosend bytes, which is either msg->sg.size or a smaller value apply_bytes.

Potential problems with this strategy are as follows:

- If the actual sent bytes are smaller than tosend, we need to charge some
  bytes back, as in line 487, which is okay but seems not clean.

- When tosend is set to apply_bytes, as in line 417, and (ret < 0), we may
  miss uncharging (msg->sg.size - apply_bytes) bytes.

[...]
415 tosend = msg->sg.size;
416 if (psock->apply_bytes && psock->apply_bytes < tosend)
417   tosend = psock->apply_bytes;
[...]
443 sk_msg_return(sk, msg, tosend);
444 release_sock(sk);
446 origsize = msg->sg.size;
447 ret = tcp_bpf_sendmsg_redir(sk_redir, redir_ingress,
448                             msg, tosend, flags);
449 sent = origsize - msg->sg.size;
[...]
454 lock_sock(sk);
455 if (unlikely(ret < 0)) {
456   int free = sk_msg_free_nocharge(sk, msg);
458   if (!cork)
459     *copied -= free;
460 }
[...]
487 if (eval == __SK_REDIRECT)
488   sk_mem_charge(sk, tosend - sent);
[...]

When running the selftest test_txmsg_redir_wait_sndmem with txmsg_apply,
the following warning will be reported:

------------[ cut here ]------------
WARNING: CPU: 6 PID: 57 at net/ipv4/af_inet.c:156 inet_sock_destruct+0x190/0x1a0
Modules linked in:
CPU: 6 UID: 0 PID: 57 Comm: kworker/6:0 Not tainted 6.12.0-rc1.bm.1-amd64+ #43
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: events sk_psock_destroy
RIP: 0010:inet_sock_destruct+0x190/0x1a0
RSP: 0018:ffffad0a8021fe08 EFLAGS: 00010206
RAX: 0000000000000011 RBX: ffff9aab4475b900 RCX: ffff9aab481a0800
RDX: 0000000000000303 RSI: 0000000000000011 RDI: ffff9aab4475b900
RBP: ffff9aab4475b990 R08: 0000000000000000 R09: ffff9aab40050ec0
R10: 0000000000000000 R11: ffff9aae6fdb1d01 R12: ffff9aab49c60400
R13: ffff9aab49c60598 R14: ffff9aab49c60598 R15: dead000000000100
FS:  0000000000000000(0000) GS:ffff9aae6fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffec7e47bd8 CR3: 00000001a1a1c004 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
<TASK>
? __warn+0x89/0x130
? inet_sock_destruct+0x190/0x1a0
? report_bug+0xfc/0x1e0
? handle_bug+0x5c/0xa0
? exc_invalid_op+0x17/0x70
? asm_exc_invalid_op+0x1a/0x20
? inet_sock_destruct+0x190/0x1a0
__sk_destruct+0x25/0x220
sk_psock_destroy+0x2b2/0x310
process_scheduled_works+0xa3/0x3e0
worker_thread+0x117/0x240
? __pfx_worker_thread+0x10/0x10
kthread+0xcf/0x100
? __pfx_kthread+0x10/0x10
ret_from_fork+0x31/0x40
? __pfx_kthread+0x10/0x10
ret_from_fork_asm+0x1a/0x30
</TASK>
---[ end trace 0000000000000000 ]---

In __SK_REDIRECT, a more concise way is delaying the uncharging after sent
bytes are finalized, and uncharge this value. When (ret < 0), we shall
invoke sk_msg_free.

Same thing happens in case __SK_DROP, when tosend is set to apply_bytes,
we may miss uncharging (msg->sg.size - apply_bytes) bytes. The same
warning will be reported in selftest.

[...]
468 case __SK_DROP:
469 default:
470 sk_msg_free_partial(sk, msg, tosend);
471 sk_msg_apply_bytes(psock, tosend);
472 *copied -= (tosend + delta);
473 return -EACCES;
[...]

So instead of sk_msg_free_partial we can do sk_msg_free here.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Fixes: 8ec95b94716a ("bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241016234838.3167769-3-zijianzhang@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 93f6a20f51520..f2ae1e51e59ff 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -396,7 +396,6 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			cork = true;
 			psock->cork = NULL;
 		}
-		sk_msg_return(sk, msg, tosend);
 		release_sock(sk);
 
 		origsize = msg->sg.size;
@@ -408,8 +407,9 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			sock_put(sk_redir);
 
 		lock_sock(sk);
+		sk_mem_uncharge(sk, sent);
 		if (unlikely(ret < 0)) {
-			int free = sk_msg_free_nocharge(sk, msg);
+			int free = sk_msg_free(sk, msg);
 
 			if (!cork)
 				*copied -= free;
@@ -423,7 +423,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		break;
 	case __SK_DROP:
 	default:
-		sk_msg_free_partial(sk, msg, tosend);
+		sk_msg_free(sk, msg);
 		sk_msg_apply_bytes(psock, tosend);
 		*copied -= (tosend + delta);
 		return -EACCES;
@@ -439,11 +439,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		}
 		if (msg &&
 		    msg->sg.data[msg->sg.start].page_link &&
-		    msg->sg.data[msg->sg.start].length) {
-			if (eval == __SK_REDIRECT)
-				sk_mem_charge(sk, tosend - sent);
+		    msg->sg.data[msg->sg.start].length)
 			goto more_data;
-		}
 	}
 	return ret;
 }
-- 
2.43.0



