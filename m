Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09DEA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC5DC433D2;
	Tue, 10 Jan 2023 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374078;
	bh=Vj/bRQ4ROumaivanE63tInVjiVtlLFOmjJZkvvriBI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNU5Z+lJywjOQ1IKd6QSGJh5WqxVFRLU+nUIccWNv2y1hxO4RjjDkt6L9ifzjDI98
	 V/8btnDf9TAMZ5yOnl4wMAD2MmGg6d96PFgleh/MjkoilZtSh4uPqXrSZTzjZAfo8e
	 hju97KtUnSEBzFq6mpVuaE8xYmK3llBwZK+Ojv/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Veaceslav Falico <vfalico@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 024/148] bonding: fix lockdep splat in bond_miimon_commit()
Date: Tue, 10 Jan 2023 19:02:08 +0100
Message-Id: <20230110180017.972363621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit 42c7ded0eeacd2ba5db599205c71c279dc715de7 ]

bond_miimon_commit() is run while RTNL is held, not RCU.

WARNING: suspicious RCU usage
6.1.0-syzkaller-09671-g89529367293c #0 Not tainted
-----------------------------
drivers/net/bonding/bond_main.c:2704 suspicious rcu_dereference_check() usage!

Fixes: e95cc44763a4 ("bonding: do failover when high prio link up")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Link: https://lore.kernel.org/r/20221220130831.1480888-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 771f2a533d3f..7807113e0910 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2653,10 +2653,12 @@ static void bond_miimon_link_change(struct bonding *bond,
 
 static void bond_miimon_commit(struct bonding *bond)
 {
-	struct slave *slave, *primary;
+	struct slave *slave, *primary, *active;
 	bool do_failover = false;
 	struct list_head *iter;
 
+	ASSERT_RTNL();
+
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
@@ -2699,8 +2701,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary ||
-			    slave->prio > rcu_dereference(bond->curr_active_slave)->prio)
+			active = rtnl_dereference(bond->curr_active_slave);
+			if (!active || slave == primary || slave->prio > active->prio)
 				do_failover = true;
 
 			continue;
-- 
2.35.1



