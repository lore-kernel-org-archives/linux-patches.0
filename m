Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F249215C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74012C433D7;
	Mon,  5 Dec 2022 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268374;
	bh=OfJ0yH/uYV+aWqzoUpcA/UzEc56Gw4fnLstOqpCCTsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJrvWGpelDhgUSlTwS8iMdQDnTl5XirbnPncJ15yZw9pEQ29uArlFN0LiCa30yHAh
	 vLTYqxTkZqOVSWs5y4uycSmSuk2+cFX12UJ4V86M28UVoQx+mguBPjPOyQjXxv/9gC
	 FTL8Z4dl3/JNGKN7G99QaabH6dtsbiaT6ie4F8MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 061/124] mptcp: fix sleep in atomic at close time
Date: Mon,  5 Dec 2022 20:09:27 +0100
Message-Id: <20221205190810.154628939@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b4f166651d03b5484fa179817ba8ad4899a5a6ac ]

Matt reported a splat at msk close time:

    BUG: sleeping function called from invalid context at net/mptcp/protocol.c:2877
    in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 155, name: packetdrill
    preempt_count: 201, expected: 0
    RCU nest depth: 0, expected: 0
    4 locks held by packetdrill/155:
    #0: ffff888001536990 (&sb->s_type->i_mutex_key#6){+.+.}-{3:3}, at: __sock_release (net/socket.c:650)
    #1: ffff88800b498130 (sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close (net/mptcp/protocol.c:2973)
    #2: ffff88800b49a130 (sk_lock-AF_INET/1){+.+.}-{0:0}, at: __mptcp_close_ssk (net/mptcp/protocol.c:2363)
    #3: ffff88800b49a0b0 (slock-AF_INET){+...}-{2:2}, at: __lock_sock_fast (include/net/sock.h:1820)
    Preemption disabled at:
    0x0
    CPU: 1 PID: 155 Comm: packetdrill Not tainted 6.1.0-rc5 #365
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
    Call Trace:
    <TASK>
    dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
    __might_resched.cold (kernel/sched/core.c:9891)
    __mptcp_destroy_sock (include/linux/kernel.h:110)
    __mptcp_close (net/mptcp/protocol.c:2959)
    mptcp_subflow_queue_clean (include/net/sock.h:1777)
    __mptcp_close_ssk (net/mptcp/protocol.c:2363)
    mptcp_destroy_common (net/mptcp/protocol.c:3170)
    mptcp_destroy (include/net/sock.h:1495)
    __mptcp_destroy_sock (net/mptcp/protocol.c:2886)
    __mptcp_close (net/mptcp/protocol.c:2959)
    mptcp_close (net/mptcp/protocol.c:2974)
    inet_release (net/ipv4/af_inet.c:432)
    __sock_release (net/socket.c:651)
    sock_close (net/socket.c:1367)
    __fput (fs/file_table.c:320)
    task_work_run (kernel/task_work.c:181 (discriminator 1))
    exit_to_user_mode_prepare (include/linux/resume_user_mode.h:49)
    syscall_exit_to_user_mode (kernel/entry/common.c:130)
    do_syscall_64 (arch/x86/entry/common.c:87)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

We can't call mptcp_close under the 'fast' socket lock variant, replace
it with a sock_lock_nested() as the relevant code is already under the
listening msk socket lock protection.

Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/316
Fixes: 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 02a54d59697b..2159b5f9988f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1745,16 +1745,16 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
 
 	for (msk = head; msk; msk = next) {
 		struct sock *sk = (struct sock *)msk;
-		bool slow, do_cancel_work;
+		bool do_cancel_work;
 
 		sock_hold(sk);
-		slow = lock_sock_fast_nested(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		next = msk->dl_next;
 		msk->first = NULL;
 		msk->dl_next = NULL;
 
 		do_cancel_work = __mptcp_close(sk, 0);
-		unlock_sock_fast(sk, slow);
+		release_sock(sk);
 		if (do_cancel_work)
 			mptcp_cancel_work(sk);
 		sock_put(sk);
-- 
2.35.1



