Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7551A76A5;
	Tue, 30 Jul 2024 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360742; cv=none; b=pqkqZyIxfPyztWuhEqZom5XpNfyN7l8cgt/OdVbychBChQYw9yXADkEnZIdMYeV5OofWg/Bkxb3GblK22urIbC5TRHLKiXphI+bjsQDKh7kqarTy5/BGZ55bztbfQb8ItrXgeHlf1Ba1dM+HWOa6cvPlCUukpivBrac2WPot2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360742; c=relaxed/simple;
	bh=k/qQGen56E0Tv6t+JRI1/QRFeVvTHn6BHEco+PqueM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdSWvoCp72PI5E3No5n15n8JkitDjZ44aclBz7pNSvBhWIYB85JVUK1LGm0h29OAr/gkfCK/kTmi3hO5hbtj1mQ8GftyxmdnKk0IJ+KqjJAYIfEOwEu4WYFwCuwmB5RTbod4B9GH6fmaDhLoUyfyG+tjMyrHZcTAobilY6sPAHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtKDzHQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtKDzHQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5258DC32782;
	Tue, 30 Jul 2024 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360741;
	bh=k/qQGen56E0Tv6t+JRI1/QRFeVvTHn6BHEco+PqueM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtKDzHQ32DIhauQ2Mu/r5gSNVj1n71i+ysgDcN1dCES3XrlEUEA6S6UnooAM7xjav
	 2cX9Ix/9xSIlx963eoa7+uWRHGQERSnks/YY09XlCzxxGuUu/5nea28VAL2HTjfKGi
	 o4sJ7S+tIuD7h33Iy4Mf16uv9MrmVZUt45gSPSsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 762/809] net: bonding: correctly annotate RCU in bond_should_notify_peers()
Date: Tue, 30 Jul 2024 17:50:38 +0200
Message-ID: <20240730151755.060728009@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d19aabf5d4fba..2ed0da0684906 100644
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



