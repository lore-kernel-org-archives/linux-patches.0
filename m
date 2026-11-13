Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590861;
	b=xS3AxukYTlTv4Yp8TDam18U4pMtLPZhPOCg7eoCDvChE9bh6QVBAw3klVzbAOe7ZaRVy
	 Exl+9iOYhUi0hlJsQ+nnvhjhT0/N3A93GR9mhHBrizA+ivx+gSGS2Deq45SMFuLSY/wzX
	 bd38YvlFhorYiZXM9HewxgQlhIpwTHAG4xdfLcpGfja98kmPCasf1GzkQKFiTOTqP5HyC
	 ZtY71idlxU3dlFa+lEM8Ewm+G5cGsy286CTXwOCKM0As8/hT4uNNhIf5aphNpsT1U6IuU
	 YDE5cuOsOa56nT7jbiVsFIv8zJM52Zli1+u2qPFrlxlaYHxv5/tfVrNUylO4ISqNVpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQaGduhAGlldfCn+bHLunTknousT9EZxx/NPDVk4cE8=;
	b=tJrnTn6UWQ4y5sykbRMHGtB+WUDWhRf5vaG6aJ/sPnK43puHO0IKqkFsTjGqN211lHyf
	 vSkXy0uz+BvZasOOfht/JGeBM9jvy6OY/OeyVINBMWMOOtXZIyf2vShxvRiMnLE9QeuUW
	 9OZOxRDJA0xXt6jnmCWpT9Hb51+fNZdAtc63LgHw8eEJweFeyx6gd/Q2oYFUpkqxIDUC5
	 XEzvnJWdpv25x1HDXOUzlrmj/YOe7W478SIWhiSqnXAl8hcH5kEfhXhPPwA344Rey2nu2
	 svcRanSoMvy5qkIVz5cVZ3qvPWB2siLUlKVtlyfWzCjALO1Xr79Ldw0Kh81t79pna8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5o32eWw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4828606D49D;
	Fri, 13 Nov 2026 17:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5o32eWw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755101F000C4;
	Fri, 13 Nov 2026 17:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590861;
	bh=ZQaGduhAGlldfCn+bHLunTknousT9EZxx/NPDVk4cE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5o32eWwS5G4gHr9if7Kqll42Ttm4pf3wI07QO+peBBonNlnrq4/2gXak3qjqlKtF
	 +5Miw7s7chCYeNMydn/NiATnmlzDqeLpGX6OOvcHqnSUQeLYjNrZYqqx9YOvmJLurn
	 YMDAPqALMCRS3LBZwWg5xDX+ig7M1uCIJeTOrCKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/670] io_uring/sqpoll: do the return-to-userspace work in the SQPOLL thread
Date: Fri, 13 Nov 2026 10:43:37 -0500
Message-ID: <20261113153813.246445732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

Commit f013b695506491c5202a412a6568313549c81f50 upstream.

The SQPOLL thread never returns to userspace. io_sq_tw() runs its
task_work, but the rest of resume_user_mode_work(), like memory.high
reclaim and block cgroup throttling, only runs when the thread exits.
So memory.high reclaim only happens inside a charge, with sqd->lock and
ctx->uring_lock held, and not at all if the charges can't block.

This used to work. The loop called io_run_task_work(), which does this
work since commit b5d3ae202fbf ("io_uring: handle TIF_NOTIFY_RESUME
when checking for task_work"). Commit af5d68f8892f ("io_uring/sqpoll:
manage task_work privately") replaced that call with io_sq_tw().

Call resume_user_mode_work() at the top of the loop when
TIF_NOTIFY_RESUME is set, with sqd->lock dropped. It runs once per pass,
so a pass that charges two or more batches still reclaims inside the
charge, as before.

Tested in a VM with memory.high=64M and swap on zram. An SQPOLL ring
reads 256M from /dev/zero into untouched memory, 64K at a time. Before,
the thread made 337 calls to __mem_cgroup_handle_over_high(), all from
inside the charge. After, it makes 704, all from the top of the loop.
memory.peak stays at 64M. With 1M reads, 296 of its 385 calls still come
from inside the charge. Both runs take about 50% longer, and the extra
time is in the handler, which now runs more often. Without memory.high
pressure, the test never calls resume_user_mode_work() and the times
do not change. Lockdep showed no warnings, also with io_uring_register()
racing for sqd->lock.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20261101022146.309201-1-shakeel.butt@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 09cd74c4d0dd2..130da8f8f67b1 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -355,6 +355,18 @@ static int io_sq_thread(void *data)
 			timeout = jiffies + sqd->sq_thread_idle;
 		}
 
+		/*
+		 * The SQPOLL thread never returns to userspace, so do the
+		 * return-to-userspace work, like memory.high reclaim, here.
+		 * It can sleep for a long time, so drop sqd->lock.
+		 */
+		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
+			mutex_unlock(&sqd->lock);
+			resume_user_mode_work(NULL);
+			mutex_lock(&sqd->lock);
+			sqd->sq_cpu = raw_smp_processor_id();
+		}
+
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
-- 
2.53.0



