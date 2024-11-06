Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C671F4298;
	Wed,  6 Nov 2024 12:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897646; cv=none; b=DlZ1eJAmvAWB2RJtFv3BvxrSR/n7PP5TIjknLw1fnQWwNqqZIIxcE15GVHv4+aoMDHyb4bk+oJUtNDzbuyOgaiHRcGkLwdadboofCyM254KElRuXKo6NYD3sS4Sr11EjVYJmuZx8ziloYnp7Xusd6gKo1caJW/E/x5+Vrzdz7Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897646; c=relaxed/simple;
	bh=CmjDuqW+1mjFav0uaNyTroAZ95f2SO8NuA6jjf/ptKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClZs90KcrLd2BiMO3F6lCcpgWdfbJ4AXA0i6XTF68JvwZEzAqU5OV6veqRSBPM4hxRrNXYJgBRnHzR/0z1Ej6eCzq2+uL0/ep+qZ6A/KwZnef2B0NNAvHRfAxX1x0EO/AgkWCCrgLnEGpgXrzTnDDdvzdYqsFKhRXaOPpy1/Pxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvjdBtkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvjdBtkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E464C4CED4;
	Wed,  6 Nov 2024 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897646;
	bh=CmjDuqW+1mjFav0uaNyTroAZ95f2SO8NuA6jjf/ptKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvjdBtkV7f53oRR4/PY1tDFZBFZRb58/DdawU2ovPsai111JlL2xChVdwIjngMc97
	 BtGMqhy1KT0oX8ms6NEphCL7aaYOOSdkfL9tH5yTsJc8jm4WCIMCBy8rpBJ5TXwEJT
	 GOcykKlJbfKuQ7FvRS7/C92Nigz8ESkLGllwDejc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/151] mptcp: init: protect sched with rcu_read_lock
Date: Wed,  6 Nov 2024 13:05:12 +0100
Message-ID: <20241106120312.278947048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 3deb12c788c385e17142ce6ec50f769852fcec65 ]

Enabling CONFIG_PROVE_RCU_LIST with its dependence CONFIG_RCU_EXPERT
creates this splat when an MPTCP socket is created:

  =============================
  WARNING: suspicious RCU usage
  6.12.0-rc2+ #11 Not tainted
  -----------------------------
  net/mptcp/sched.c:44 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  no locks held by mptcp_connect/176.

  stack backtrace:
  CPU: 0 UID: 0 PID: 176 Comm: mptcp_connect Not tainted 6.12.0-rc2+ #11
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  Call Trace:
   <TASK>
   dump_stack_lvl (lib/dump_stack.c:123)
   lockdep_rcu_suspicious (kernel/locking/lockdep.c:6822)
   mptcp_sched_find (net/mptcp/sched.c:44 (discriminator 7))
   mptcp_init_sock (net/mptcp/protocol.c:2867 (discriminator 1))
   ? sock_init_data_uid (arch/x86/include/asm/atomic.h:28)
   inet_create.part.0.constprop.0 (net/ipv4/af_inet.c:386)
   ? __sock_create (include/linux/rcupdate.h:347 (discriminator 1))
   __sock_create (net/socket.c:1576)
   __sys_socket (net/socket.c:1671)
   ? __pfx___sys_socket (net/socket.c:1712)
   ? do_user_addr_fault (arch/x86/mm/fault.c:1419 (discriminator 1))
   __x64_sys_socket (net/socket.c:1728)
   do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1))
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

That's because when the socket is initialised, rcu_read_lock() is not
used despite the explicit comment written above the declaration of
mptcp_sched_find() in sched.c. Adding the missing lock/unlock avoids the
warning.

Fixes: 1730b2b2c5a5 ("mptcp: add sched in mptcp_sock")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/523
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241021-net-mptcp-sched-lock-v1-1-637759cf061c@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8cdd4ec152e7b..cd6f8d655c185 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2823,8 +2823,10 @@ static int mptcp_init_sock(struct sock *sk)
 	if (unlikely(!net->mib.mptcp_statistics) && !mptcp_mib_alloc(net))
 		return -ENOMEM;
 
+	rcu_read_lock();
 	ret = mptcp_init_sched(mptcp_sk(sk),
 			       mptcp_sched_find(mptcp_get_scheduler(net)));
+	rcu_read_unlock();
 	if (ret)
 		return ret;
 
-- 
2.43.0



