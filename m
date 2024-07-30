Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548461A76A4;
	Tue, 30 Jul 2024 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359796; cv=none; b=nQsSRIbUV5XgMp07NNaqF5w6Rq2EXjNBLywV8jPNv0ZU2mSmblZL724kc+gjfG+ppMl1ktVIA0RZEdLDVRGfAKIfJpE6Zlhaw/Hg4ZTSE7x7DFTCyUv/szwr3d908gtaHWxSG/TxVZ9mYB+vtz79ZYWkWncVVJ/C0bygyQ4LMTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359796; c=relaxed/simple;
	bh=ZOQZFea79a5kJlyxP2BMUZ7RdqZVwcUgdkKnqIRjeSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk8xWDejRMKr67e3sxS5bkGsBADUUUp/6alj8RTX6cYasrqOnl1IbksDLCzhBQXd9leEDZlcNA7ncnzJ1lcANBGj+WqD+Ksb/E4A212t1HOWDrTdxGAvb++mMRA3eFfudhAt6xRY9cddeQPD7fNOrmv2041IVcmcK85jvU8KRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRshA8lB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRshA8lB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7197C32782;
	Tue, 30 Jul 2024 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359796;
	bh=ZOQZFea79a5kJlyxP2BMUZ7RdqZVwcUgdkKnqIRjeSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRshA8lB7gTo1QF4YTqccBny5FlwwIyn8WDU/jyrYpSkXhGdKnE7b/gQbfPFAzyde
	 3laAvzKohw5Y5BKHAgXeFpBD0fJQijc4iwZU6B3CMstrtQLoddztpii7oCRLWPMuQc
	 aBEycveG+K1PnGTG4xUA8IOz07zX7a6cHEqKxz4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 537/568] net: bonding: correctly annotate RCU in bond_should_notify_peers()
Date: Tue, 30 Jul 2024 17:50:44 +0200
Message-ID: <20240730151701.142253257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3ba359c0cd6eb5ea772125a7aededb4a2d516684 ]

RCU use in bond_should_notify_peers() looks wrong, since it does
rcu_dereference(), leaves the critical section, and uses the
pointer after that.

Luckily, it's called either inside a nested RCU critical section
or with the RTNL held.

Annotate it with rcu_dereference_rtnl() instead, and remove the
inner RCU critical section.

Fixes: 4cb4f97b7e36 ("bonding: rebuild the lock use for bond_mii_monitor()")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20240719094119.35c62455087d.I68eb9c0f02545b364b79a59f2110f2cf5682a8e2@changeid
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 34880b2db8050..722ac5c4992c9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1121,13 +1121,10 @@ static struct slave *bond_find_best_slave(struct bonding *bond)
 	return bestslave;
 }
 
+/* must be called in RCU critical section or with RTNL held */
 static bool bond_should_notify_peers(struct bonding *bond)
 {
-	struct slave *slave;
-
-	rcu_read_lock();
-	slave = rcu_dereference(bond->curr_active_slave);
-	rcu_read_unlock();
+	struct slave *slave = rcu_dereference_rtnl(bond->curr_active_slave);
 
 	if (!slave || !bond->send_peer_notif ||
 	    bond->send_peer_notif %
-- 
2.43.0



