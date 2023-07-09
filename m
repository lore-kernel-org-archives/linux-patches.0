Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41371522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9287C433C7;
	Sun,  9 Jul 2023 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901782;
	bh=Lo4oaKexKf4b/Ta72ARzYejc/3Oi7U7AAuJL20nLHNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsuMmo75UPp1yFqrSZh+W/gnz2ROrHKN6E+R28YQp1ez1QCdIPHD+FJV/usycWKzQ
	 JcfDWZavPqTtxszbgOcW1ztjHEgLX6t99VLOjsxySivj2Mdjm7kESBh9to7QOp2QY6
	 waR1UTq2B+jWKQ1hIhJCcQWHGuyOGUglbPT/1rNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7d200a347f912723e5c@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 142/431] netlink: fix potential deadlock in netlink_set_err()
Date: Sun,  9 Jul 2023 13:11:30 +0200
Message-ID: <20230709111454.493049015@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8d61f926d42045961e6b65191c09e3678d86a9cf ]

syzbot reported a possible deadlock in netlink_set_err() [1]

A similar issue was fixed in commit 1d482e666b8e ("netlink: disable IRQs
for netlink_lock_table()") in netlink_lock_table()

This patch adds IRQ safety to netlink_set_err() and __netlink_diag_dump()
which were not covered by cited commit.

[1]

WARNING: possible irq lock inversion dependency detected
6.4.0-rc6-syzkaller-00240-g4e9f0ec38852 #0 Not tainted

syz-executor.2/23011 just changed the state of lock:
ffffffff8e1a7a58 (nl_table_lock){.+.?}-{2:2}, at: netlink_set_err+0x2e/0x3a0 net/netlink/af_netlink.c:1612
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (&local->queue_stop_reason_lock){..-.}-{2:2}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(nl_table_lock);
                               local_irq_disable();
                               lock(&local->queue_stop_reason_lock);
                               lock(nl_table_lock);
  <Interrupt>
    lock(&local->queue_stop_reason_lock);

 *** DEADLOCK ***

Fixes: 1d482e666b8e ("netlink: disable IRQs for netlink_lock_table()")
Reported-by: syzbot+a7d200a347f912723e5c@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a7d200a347f912723e5c
Link: https://lore.kernel.org/netdev/000000000000e38d1605fea5747e@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20230621154337.1668594-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 5 +++--
 net/netlink/diag.c       | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 717e27a4b66a0..f4adccb8d49a2 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1600,6 +1600,7 @@ static int do_one_set_err(struct sock *sk, struct netlink_set_err_data *p)
 int netlink_set_err(struct sock *ssk, u32 portid, u32 group, int code)
 {
 	struct netlink_set_err_data info;
+	unsigned long flags;
 	struct sock *sk;
 	int ret = 0;
 
@@ -1609,12 +1610,12 @@ int netlink_set_err(struct sock *ssk, u32 portid, u32 group, int code)
 	/* sk->sk_err wants a positive error value */
 	info.code = -code;
 
-	read_lock(&nl_table_lock);
+	read_lock_irqsave(&nl_table_lock, flags);
 
 	sk_for_each_bound(sk, &nl_table[ssk->sk_protocol].mc_list)
 		ret += do_one_set_err(sk, &info);
 
-	read_unlock(&nl_table_lock);
+	read_unlock_irqrestore(&nl_table_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(netlink_set_err);
diff --git a/net/netlink/diag.c b/net/netlink/diag.c
index c6255eac305c7..4143b2ea4195a 100644
--- a/net/netlink/diag.c
+++ b/net/netlink/diag.c
@@ -94,6 +94,7 @@ static int __netlink_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	struct net *net = sock_net(skb->sk);
 	struct netlink_diag_req *req;
 	struct netlink_sock *nlsk;
+	unsigned long flags;
 	struct sock *sk;
 	int num = 2;
 	int ret = 0;
@@ -152,7 +153,7 @@ static int __netlink_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	num++;
 
 mc_list:
-	read_lock(&nl_table_lock);
+	read_lock_irqsave(&nl_table_lock, flags);
 	sk_for_each_bound(sk, &tbl->mc_list) {
 		if (sk_hashed(sk))
 			continue;
@@ -173,7 +174,7 @@ static int __netlink_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		}
 		num++;
 	}
-	read_unlock(&nl_table_lock);
+	read_unlock_irqrestore(&nl_table_lock, flags);
 
 done:
 	cb->args[0] = num;
-- 
2.39.2



