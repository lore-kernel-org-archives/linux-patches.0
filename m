Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A931DFFB;
	Thu, 15 Aug 2024 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732494; cv=none; b=goaZVuy1N4jSsZjeUvFz88CUb9QwnxnuIAGPd+J8JN4/HlUsRer/e4BlzEsqGkRKDh+bRVchODH6CwZLmIuzFjK5AjIkUUHKzFuFVTmscFWIbJjgnGL6bUNw3P+KbdbETdtHmvsSnUhzyPBc9byOVJmE9tD51EakSbKczRZDfnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732494; c=relaxed/simple;
	bh=SvFodh5QtVJNV4C8No1bXIiWbvlqVynv4Kiu1V7h92I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrvd+bAtqRRJzmbLdMt03CGVl88DaID5xxV+uJfQFuWdTweRNkWVGzdq1OA089fQJ/zN5zhTGbDoc0iJWU/BJIDJqKNU9lsAFlyFHg1tm7WlNnprixYYtvxioLPwbf8K7YNZgjt0exp5Kfjc3o8VpafsV7gtOndm2XJi1EylxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTtcE55N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTtcE55N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACB7C32786;
	Thu, 15 Aug 2024 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732494;
	bh=SvFodh5QtVJNV4C8No1bXIiWbvlqVynv4Kiu1V7h92I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTtcE55Nc6T793IFl66CwW3dpuGbK1+YbVI3FiyAsT3FJ9lnCMUSKwTgB0+dwx30X
	 5B9yKBXYh0ux9eRgj4ATJpb/NrdB9R73DeDiFuq7lAdyn3ec35GN85/ylJlVVWJZfO
	 5dZNvLJVtyCtZ2rRaI+3hM/6HRfzS1VrS0MWkuqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/352] net: bonding: correctly annotate RCU in bond_should_notify_peers()
Date: Thu, 15 Aug 2024 15:24:23 +0200
Message-ID: <20240815131926.893644815@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 50fabba042488..c07b9bac1a6a0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1052,13 +1052,10 @@ static struct slave *bond_find_best_slave(struct bonding *bond)
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



