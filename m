Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B0303C91;
	Wed,  3 Dec 2025 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776376; cv=none; b=rCacvbqAjZT+nZNqPlhV36yVQwAx1gEH6jHsByrrDiFW/7ePh+X6NOwJIATDoDJUsnHXcY+RpVY9t+c6b8/8Kz9yh3g1Muzub0XB/T8JoQ0A8uT3q8nh4/I7epKSTjrsZxocFBBUrVeKL2ZM6GkwVXuNcdO0hoTBbgdva1I06Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776376; c=relaxed/simple;
	bh=LacVSKRlina8GkFgBqGOzh49sQX3kAvMLWlbn42WQl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO3GcqMn8eOczJSyRYofEYC0vHU88YDmp+z/dDTAzW/91tjy6EKAn13w1HASHBQ7BC2DnSEa37udZ6oIHf9/Jin8P7Lc9t+vpmyOrmlJSJBhgfW5lBkDS8MHFMIu1IhF0EwKijW3k9aTdyjBeip8VNAr7eo0bjGmCmNQQgisNgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEkMXnPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEkMXnPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D134EC4CEF5;
	Wed,  3 Dec 2025 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776376;
	bh=LacVSKRlina8GkFgBqGOzh49sQX3kAvMLWlbn42WQl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEkMXnPNy5anVWUdem3fl2Ytpj1j0yztJB44OO4ZicZi9wCdt0xRRdd9FffLr2qHX
	 rYHs7AjkwMPX3AsoZ/LW5vtx3I+NDJeKUfShSiJfVXrX7R6hdzCZmwVAsOaeb0sYC1
	 j9vGKfg8iv8WxF6eajB3IBalIrSaWbdeRPbKA9S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/300] sctp: Hold RCU read lock while iterating over address list
Date: Wed,  3 Dec 2025 16:26:07 +0100
Message-ID: <20251203152406.656457132@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit 38f50242bf0f237cdc262308d624d333286ec3c5 ]

With CONFIG_PROVE_RCU_LIST=y and by executing

  $ netcat -l --sctp &
  $ netcat --sctp localhost &
  $ ss --sctp

one can trigger the following Lockdep-RCU splat(s):

  WARNING: suspicious RCU usage
  6.18.0-rc1-00093-g7f864458e9a6 #5 Not tainted
  -----------------------------
  net/sctp/diag.c:76 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  2 locks held by ss/215:
   #0: ffff9c740828bec0 (nlk_cb_mutex-SOCK_DIAG){+.+.}-{4:4}, at: __netlink_dump_start+0x84/0x2b0
   #1: ffff9c7401d72cd0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: sctp_sock_dump+0x38/0x200

  stack backtrace:
  CPU: 0 UID: 0 PID: 215 Comm: ss Not tainted 6.18.0-rc1-00093-g7f864458e9a6 #5 PREEMPT(voluntary)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x90
   lockdep_rcu_suspicious.cold+0x4e/0xa3
   inet_sctp_diag_fill.isra.0+0x4b1/0x5d0
   sctp_sock_dump+0x131/0x200
   sctp_transport_traverse_process+0x170/0x1b0
   ? __pfx_sctp_sock_filter+0x10/0x10
   ? __pfx_sctp_sock_dump+0x10/0x10
   sctp_diag_dump+0x103/0x140
   __inet_diag_dump+0x70/0xb0
   netlink_dump+0x148/0x490
   __netlink_dump_start+0x1f3/0x2b0
   inet_diag_handler_cmd+0xcd/0x100
   ? __pfx_inet_diag_dump_start+0x10/0x10
   ? __pfx_inet_diag_dump+0x10/0x10
   ? __pfx_inet_diag_dump_done+0x10/0x10
   sock_diag_rcv_msg+0x18e/0x320
   ? __pfx_sock_diag_rcv_msg+0x10/0x10
   netlink_rcv_skb+0x4d/0x100
   netlink_unicast+0x1d7/0x2b0
   netlink_sendmsg+0x203/0x450
   ____sys_sendmsg+0x30c/0x340
   ___sys_sendmsg+0x94/0xf0
   __sys_sendmsg+0x83/0xf0
   do_syscall_64+0xbb/0x390
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   ...
   </TASK>

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251028161506.3294376-2-stefan.wiehler@nokia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/diag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 07d0ada23bfd2..5f441a48e7aa3 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -73,19 +73,23 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 	struct nlattr *attr;
 	void *info = NULL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(laddr, address_list, list)
 		addrcnt++;
+	rcu_read_unlock();
 
 	attr = nla_reserve(skb, INET_DIAG_LOCALS, addrlen * addrcnt);
 	if (!attr)
 		return -EMSGSIZE;
 
 	info = nla_data(attr);
+	rcu_read_lock();
 	list_for_each_entry_rcu(laddr, address_list, list) {
 		memcpy(info, &laddr->a, sizeof(laddr->a));
 		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
 		info += addrlen;
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
2.51.0



