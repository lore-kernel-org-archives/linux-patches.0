Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E93318801A;
	Tue, 30 Jul 2024 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358675; cv=none; b=s1dfDao/kY6L/08QjbQIyEHpvXCmPSBflxZ6jCBBbcYUvNYX+HZRmK3/H67A3x2f+EnkUuqEPObn1eap38dP95243Y6CrfLjPH1r6lxbvkAHlFbj2OjRSpGUAvXWjxnsvz/MHcY3moKGQiywnSsXtjAzVEQKK4YxaikNEyy1/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358675; c=relaxed/simple;
	bh=gQZiK0tgtS3t3csMxc3I1zOErwobEjPNE1v+NxD5ZVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYJxBuQ3D/L63VLID99a3b3UO4waQDh1eHwd6A4devpxdOWulANQCtQHfH4FXQ+YKGgPLh4F7H8KcQQRmixd0dRgLHUA+Q7VGayQ5sB4uQwsVPL6eXt81sbx0SEbDrUdkPbxUTrgp/SD7Ek/83oj5JKX1Qlm2KErPGd/d4QFU5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyzxC7SZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyzxC7SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC76C32782;
	Tue, 30 Jul 2024 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358675;
	bh=gQZiK0tgtS3t3csMxc3I1zOErwobEjPNE1v+NxD5ZVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyzxC7SZpTr4+/FGFC49BySPIv39D770Q5AoTSOEoe1hX8Jgl22cwfzNDGz7yUDAf
	 DGr+3rUenv5IbwY8uf0GW6Ti4BqYlib4GpmthK9weuV8iXwYDqyEoo1d/VaepXpwbe
	 5kscSL/rUhOtdbGwMkZTvU1XeV4spLsnme6nqpB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 412/440] net: bonding: correctly annotate RCU in bond_should_notify_peers()
Date: Tue, 30 Jul 2024 17:50:45 +0200
Message-ID: <20240730151631.884080353@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 710734a5af9bf..be5348d0b22e5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1117,13 +1117,10 @@ static struct slave *bond_find_best_slave(struct bonding *bond)
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



