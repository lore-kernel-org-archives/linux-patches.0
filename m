Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704939;
	b=hRDOJS/EY7RxeTkrtd27x5/mZ26HS0RdhPfKGgIHi63dTAC5lXqY8f9UINi0nDToTvWv
	 UZ6GmFIFTa0IelosneE/fBZEfZ5W+AGEV3gUfHpXTsXCazCaXVnE2+ZAsDuoDxOXgBzkg
	 vo+08Vl3XBvPGchEFNLNmUXbe6cYKYwuTLdzOzc8L9N3TUmBQE720tG/16oruLfOO9Nb0
	 aT+jMT6KMfbf7GlM/KwPZgjeDSBmkgPe069mx8HINvobnZK6xtuKvkbZUbCB9IoMqC18u
	 eJeT/1ZdASvDT57LMGr3L4xmvRiuoRFMgzm/GgogSxCZX/AdCgV4duzEU5LfuFqgg5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e453hHu6dGJ2Ns6bBiVZL/uCYtISmQs/2R4Qtj3NUCQ=;
	b=LnhqiHV4MWjAkGhUfJrCRMCXtFwEvmkV+IbxOtyBdJ83UuGYQ4meP6KGu+yFdylWwGNr
	 JMrWOVCifxu5t02JRlwssIW0OqGxPdAKQd1zdeeGdM8/upps7xktG1GTqteWIS9Rh6iWk
	 E7tABdjizdM2CnLXII6YV+u7+EXJNxQ26qUPuerp4bQ0O0YRQ+Rx6ZMObJ8QtunKmVrkd
	 eZWdd5h34KvQ2SwD0io6NeYXMawWuSXQbP62l5XH2e0erfFn4usGli7wzGaNsDgjaklsW
	 g/rB7do0iRlcMb4Dru1VUqs3pqWVkXI69pBCGF4MbRE3I4Mkyj7r2tCBXk6/sbOB/+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2rz7EjAL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33FE606A329;
	Thu, 26 Nov 2026 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2rz7EjAL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CD51F000C4;
	Thu, 26 Nov 2026 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704938;
	bh=e453hHu6dGJ2Ns6bBiVZL/uCYtISmQs/2R4Qtj3NUCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rz7EjALYiElYMu5v62bIyzCl4G/rDMMsoFOC80+dWQ4Et/gFzd+on1TzuK+ri4P3
	 vn+bIHpqNZG/B9pojkGcFUr3730x/4+GGPKZYD8OLO4ZcvIWXcGEKiZfCH5XMuTDJW
	 W0hb5B+SkviqGlBytNjfB9Mb3k5WWjz2SmfqKNfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/319] mptcp: fix UAF of child socket on listener close
Date: Thu, 26 Nov 2026 15:36:12 +0100
Message-ID: <20261126144006.837696149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

mptcp_close() orphans the listener subflow before inet_csk_listen_stop()
runs on it. A child created in that window inherits SOCK_DEAD, so a
following RST frees it while it is still in the accept queue:

close(listen_fd):                            3-way handshake & rst (plain TCP client)

mptcp_close
  // mark ssk as SOCK_DEAD
  sock_orphan(ssk);
  __mptcp_destroy_sock
    // ssk in conn_list is listen sk
    __mptcp_close_ssk
                                             // in 3-way handshake
                                             tcp_v4_syn_recv_sock
                                               // inherit SOCK_DEAD state from listen ssk
                                               inet_csk_clone_lock
                                             // process RST
                                             tcp_reset
                                               tcp_done
                                               // sk is SOCK_DEAD
                                               inet_csk_destroy_sock
                                                   sock_put(sk); // freed
      __tcp_close(ssk, 0)
        // free child
        inet_csk_listen_stop()
            process child        <==== process freed sk

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 59 PID: 404175 at lib/refcount.c:25 refcount_warn_saturate+0x12e/0x150
RIP: 0010:refcount_warn_saturate+0x12e/0x150
Call Trace:
 <TASK>
 inet_csk_listen_stop+0x3e1/0x530
 __tcp_close+0x3bc/0x440
 __mptcp_close_ssk+0xb9/0x210
 __mptcp_destroy_sock+0x11c/0x280
 mptcp_close+0x25d/0x3b0
 inet_release+0x44/0x90
 __sock_release+0x42/0xb0
 __fput+0x98/0x270
 ____fput+0xe/0x20
 task_work_run+0x6d/0xb0
 do_exit+0x1e7/0x3c0
 do_group_exit+0x3b/0xb0
 get_signal+0x17a/0x940
 arch_do_signal_or_restart+0xba/0x130
 exit_to_user_mode_loop+0xae/0x160
 exit_to_user_mode_prepare+0xad/0xc0
 irqentry_exit_to_user_mode+0x9/0x20
 irqentry_exit+0x21/0x40
 exc_page_fault+0x93/0x190
 asm_exc_page_fault+0x27/0x30

Unhash the listener subflow and drain its accept queue before it is
orphaned. No new child can be queued after the unhash, and the ones
already queued are not SOCK_DEAD.

Upstream fixed this in commit 57fc0f1ceaa4 ("mptcp: ensure listener is
unhashed before updating the sk status"), which does not fit 5.15.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2f18dcb8d0345..f1122038d17cf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2834,6 +2834,16 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
+		struct sock *ssk = mptcp_sk(sk)->first;
+
+		if (ssk) {
+			lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
+			if (ssk->sk_state == TCP_LISTEN) {
+				tcp_set_state(ssk, TCP_CLOSE);
+				inet_csk_listen_stop(ssk);
+			}
+			release_sock(ssk);
+		}
 		inet_sk_state_store(sk, TCP_CLOSE);
 		goto cleanup;
 	}
-- 
2.53.0



