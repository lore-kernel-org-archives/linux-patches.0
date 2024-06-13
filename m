Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8193209;
	Thu, 13 Jun 2024 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280930; cv=none; b=LH+OFETt1CwAD1LNrH3TN/n7gALOc0cXKG8k92qrsoSxxWYoMjZFzTCZESR1ccDZANeLnbC/2g6XiKH8u9jsKTJ9maBrIQHU4i7mqMVu04puJzfhZNoP7NZbonC/kKOmpjMBgRpcOK99MznfZX3FDZoc4IbnxM7n9R3M3IaswhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280930; c=relaxed/simple;
	bh=fseM3rD6KBk1ijmsQiJdmCRYYibPZKGyMK/6QYPcjy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpBceaaRSK5ir24j7CHcQgE8XnFtGvSn3C71V780jJwJ+q7+MLF14MWUT1yJ0X39rd8jn3kkBBBnLNfycZ8dPtBGwdJ/85tePdUgmwbHqcThvodFc4tasaO97BBn4+JZlr2EzjTzoTpgV6INmFTWV8djAuuqzyi8CNGuuXpo8Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwGtmzUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwGtmzUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CD3C2BBFC;
	Thu, 13 Jun 2024 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280930;
	bh=fseM3rD6KBk1ijmsQiJdmCRYYibPZKGyMK/6QYPcjy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwGtmzUtpXPVdl3ZfBaTy+R17Zb4ecJ8X2GJAy8eBwEaY6vMNvB1CpQ8a2n8wzR0e
	 sSr0arnO6Y8T2KrpulcrVxbTIPBDpnqJoKgtnsrmsJ7KsUwCtCnJxmPnE+FJhQnGcK
	 zro2JnBqDK0+cC7BQ8Vmv1AIBuBRyO//NiAV9sEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/317] net: give more chances to rcu in netdev_wait_allrefs_any()
Date: Thu, 13 Jun 2024 13:31:23 +0200
Message-ID: <20240613113250.064618196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd42ba1c8ac9deb9032add6adf491110e7442040 ]

This came while reviewing commit c4e86b4363ac ("net: add two more
call_rcu_hurry()").

Paolo asked if adding one synchronize_rcu() would help.

While synchronize_rcu() does not help, making sure to call
rcu_barrier() before msleep(wait) is definitely helping
to make sure lazy call_rcu() are completed.

Instead of waiting ~100 seconds in my tests, the ref_tracker
splats occurs one time only, and netdev_wait_allrefs_any()
latency is reduced to the strict minimum.

Ideally we should audit our call_rcu() users to make sure
no refcount (or cascading call_rcu()) is held too long,
because rcu_barrier() is quite expensive.

Fixes: 0e4be9e57e8c ("net: use exponential backoff in netdev_wait_allrefs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/all/28bbf698-befb-42f6-b561-851c67f464aa@kernel.org/T/#m76d73ed6b03cd930778ac4d20a777f22a08d6824
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0e2c433bebcd4..5e91496fd3a36 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10217,8 +10217,9 @@ static void netdev_wait_allrefs(struct net_device *dev)
 			rebroadcast_time = jiffies;
 		}
 
+		rcu_barrier();
+
 		if (!wait) {
-			rcu_barrier();
 			wait = WAIT_REFS_MIN_MSECS;
 		} else {
 			msleep(wait);
-- 
2.43.0



