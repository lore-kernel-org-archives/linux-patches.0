Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F446B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB69C433D2;
	Mon, 16 Jan 2023 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885693;
	bh=FvgJ0iFQ3HwhOCleODPanUCbxu7fanq/3CU+dxMyVeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjWQDGOICw0VimtwYARnm3h6zdgahMaZsgDxR8kdLYvMxpjVM5bSJm/0TlvxrR+nj
	 GKcnzv/8a086NfCEmSQyf6nGNE8S5rMhKr9Cod/yEJ6mBTCg218/SV3HTo0iJCnvUK
	 Pl2IKOFL3gRvDJacMOSDO+GgMzWDPXrX92aapL28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Toppins <jtoppins@redhat.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/658] bonding: fix link recovery in mode 2 when updelay is nonzero
Date: Mon, 16 Jan 2023 16:43:56 +0100
Message-Id: <20230116154916.229320055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Toppins <jtoppins@redhat.com>

[ Upstream commit f8a65ab2f3ff7410921ebbf0dc55453102c33c56 ]

Before this change when a bond in mode 2 lost link, all of its slaves
lost link, the bonding device would never recover even after the
expiration of updelay. This change removes the updelay when the bond
currently has no usable links. Conforming to bonding.txt section 13.1
paragraph 4.

Fixes: 41f891004063 ("bonding: ignore updelay param when there is no active slave")
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index dc351832b108..0b7994cb9380 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2107,7 +2107,16 @@ static int bond_miimon_inspect(struct bonding *bond)
 	struct slave *slave;
 	bool ignore_updelay;
 
-	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
+		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	} else {
+		struct bond_up_slave *usable_slaves;
+
+		usable_slaves = rcu_dereference(bond->usable_slaves);
+
+		if (usable_slaves && usable_slaves->count == 0)
+			ignore_updelay = true;
+	}
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
-- 
2.35.1



