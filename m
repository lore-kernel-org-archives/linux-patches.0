Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F019EED0;
	Thu, 15 Aug 2024 13:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728768; cv=none; b=YlyJGqoeRTNHmowkbRK3AOJo5rHeO1TH2ryJwlFTKu9Xf+t6M2GY+foEDvnsqwvGQ/qarmdPNjdFNWEtpqtfIduRlONCUGbqUora26EW8wUzmvbuRqwDLGHfGaSxDTmdbq+hhGJCUjp+CVMLxiesNLodmNjYEM4/O/xzTSmJiHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728768; c=relaxed/simple;
	bh=QhDdzTBZXkxsuRh5gHx0oj38R6GVA76EwrLyZOOmsl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbbxj4+gOaOmIsUqTdy9+aabOU9bJ0T8DMsjcEc3Y+1WA2+mS6bLkXNxUCGjM7rsAPtVy5/3w0UD3JZJ+/hadi9MRHdBYWG1wrYBVFJWLlAJDzNQaNS+E1dMq80mjd8V0dH6NcXWjPD0B5976tJQ2e26fVdNMqOo5fZFwxq3324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEwCT06h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEwCT06h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAF6C4AF0C;
	Thu, 15 Aug 2024 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728768;
	bh=QhDdzTBZXkxsuRh5gHx0oj38R6GVA76EwrLyZOOmsl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEwCT06h0JA6df77UZiT8TZ/swD1JegbvYvvUo+2W5qVoD0NdLKDdQIj4oqhYrMAP
	 qRlhmWRanuuTcLz3K05+Y6T2tTMmMlsU3WjIdTGyp4KRBUacGUUfcF5r3jMG/O1Qc1
	 xP90BtV8nMLAZkdrJRgeziJ773kPGLKG8gOWkW9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/196] net: bonding: correctly annotate RCU in bond_should_notify_peers()
Date: Thu, 15 Aug 2024 15:23:40 +0200
Message-ID: <20240815131856.023845579@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 79b36f1c50aec..f0c0da85ba4fc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -774,13 +774,10 @@ static struct slave *bond_find_best_slave(struct bonding *bond)
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
 	    !netif_carrier_ok(bond->dev) ||
-- 
2.43.0



