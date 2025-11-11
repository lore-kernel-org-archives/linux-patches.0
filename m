Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62C262FEC;
	Tue, 11 Nov 2025 01:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824818; cv=none; b=Daa5WqupcRzgHCVDR0mN7CjctrwXQNBoGcyy5ILd0bBfvnTF8bh5eHHG/aM+byZ7rGFdzMsFIqwiZ9ujJZGbwqHMUoBDmnh8jJGsex0TUB8WnxIQBbwCjuwSPcEEhz14kir/REkk/i33eQVnlgjCE06TAqeJcLabFprovjfZ9ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824818; c=relaxed/simple;
	bh=g51WjiLgq/74ywhUTnjQGj5VispdY27G/FZsRCCwEBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHl42CzWyyqTcKqdxIMKA90+8u7KIAYZgGH3oPCGA82atctaDgb8XiW1CR/Bi2r1dDTUujf5Sve7JRo6JX3P27jBhQ1hObP9+u4K9BhNg6rub6oqio5ezF7ZJ5EYjc9615I/0DueD9kuYowRFHUw/Lz3063W416+EgSIpIpiNug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yij2RlqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yij2RlqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A569C4CEF5;
	Tue, 11 Nov 2025 01:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824818;
	bh=g51WjiLgq/74ywhUTnjQGj5VispdY27G/FZsRCCwEBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yij2RlqM0xXP7wuz1GSSfEag+g1iWdvi7G3MmUyPUs6nWrribW3CqGSii23zLykTq
	 COraRBsOjv/Bbp1DHje6r4hPIkHdZScxRE1wQ65qpd8WeAOeXvRZ+I4l44STSn6Bsx
	 VKxa724wUxNopJU4hV4DueClmE+xEV9Bo/OFE5MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 523/565] sctp: Hold RCU read lock while iterating over address list
Date: Tue, 11 Nov 2025 09:46:19 +0900
Message-ID: <20251111004538.730023128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 23359e522273f..dadf8254b30fd 100644
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



