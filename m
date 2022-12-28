Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A47A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD0C433EF;
	Wed, 28 Dec 2022 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245609;
	bh=kjAbANO2oQ9HRWy1w5jZAbLseyqeRUG7KDXrkkxEhu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ced8PlZyLvnLq2xRaIFFsfJNiKq21JfF8Wvn7SEkI12IngK1LBsf0A6+YJ3x1ydvL
	 kn5hN+o3tp1FGXDhIkntE75W9zm9PlYpw62hoGDb09Vp2JLgBaj2/rArKNju9YFZrN
	 UyYexQsDDOY1BXmuwtUlgXN3fbzuKf2Y6yi7QvQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0889/1146] bonding: add missed __rcu annotation for curr_active_slave
Date: Wed, 28 Dec 2022 15:40:28 +0100
Message-Id: <20221228144354.327608151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3d0b738fc5adf9f380702ac1424672e4b32c3781 ]

There is one direct accesses to bond->curr_active_slave in
bond_miimon_commit(). Protected it by rcu_access_pointer()
since the later of this function also use this one.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e95cc44763a4 ("bonding: do failover when high prio link up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 29d0a6493b1b..af35a46994cc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2698,7 +2698,7 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!bond->curr_active_slave || slave == primary)
+			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary)
 				goto do_failover;
 
 			continue;
-- 
2.35.1



