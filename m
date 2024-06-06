Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA148197537;
	Thu,  6 Jun 2024 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683297; cv=none; b=lkSch5xLDretFhg7kVs9ksiS7mED8DcEoZmwEfv6vsIjoWCAiZAHJrATs+BRsL4nSVEwNi3+N2MhxM0YdZ9j1Uxs5GEUuuQbzqtgczqzaLwxNKyRqrNyWlFcVAvzLNNbk13iyJI/H7w1Dx49mbSadwPhDyAwBUhdjqeCDRD0gFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683297; c=relaxed/simple;
	bh=EFpBHNmvFDjRkMQOlaT+kDKy2PaKbzg7VSNCuXtfKO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fITQYG5CPRH3XrUkyjVW4sLewXL7QV7fVjzzoDDZJ8e4wZKGQXhAgymJjejQiL+yVsCfQeNmHZl8fa/8beHQ/v7y4czn7Lf5/CKG5CYQ9ecwop7o19JYs7g0nAwXfglZVulR7+oCfVDxdClIa6L1e2RiTv4ysd926twOiFcCvHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM25DfSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM25DfSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB3DC2BD10;
	Thu,  6 Jun 2024 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683297;
	bh=EFpBHNmvFDjRkMQOlaT+kDKy2PaKbzg7VSNCuXtfKO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM25DfSRKHwA5tUn7SJwjz1lWVAGhqHrHNxQ1w+JJqwRl9Ml8/I4nXAu7P6M5qMCi
	 gScdBgxHUIJZKFhhbwyyntMich81ytJYrpq8nvu02AMfbqu7oSpsD6XzJvaLWYaVSD
	 uch0NPpUybUlDOtaVCk5BYbxHvXc4STO5fZRuxzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/473] net: give more chances to rcu in netdev_wait_allrefs_any()
Date: Thu,  6 Jun 2024 16:01:13 +0200
Message-ID: <20240606131704.699134428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 65284eeec7de5..20d8b9195ef60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10300,8 +10300,9 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
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



