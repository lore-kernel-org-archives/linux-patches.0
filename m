Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354851DDC5;
	Thu, 13 Jun 2024 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281892; cv=none; b=N/AZhdfgW9BZREUbdCmAe6ec0DNSFMMgpE/ORARrIm449l0+Xo4RpIr7HsMC3suDBVlj364OCfHO03KeXG5v+QiCMN0DkDlvCTf2yV/+bJSPQk/zH76cZ52ThtYb4UMOicyaoAIR7cS6va9jkHGsw/FMje3kK+j8CZVqxoxySNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281892; c=relaxed/simple;
	bh=1obTltwYabfVr65LqJy5rwEUEFtMQHktkOx6Vshdb6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCbKdmm+zS7IgAaarzNqV8Id+NYU/hKZnVv6K54zsDiT0U6Tm4geLfukcMHLY/nOVyMm6isa/+Z9TBRywqzRHcCjAQJ6qe7yQzNyKhwpt5DqdOxcBRN9WyFc5APaaUSHe8+GklWRLnXoPxAGd8Zz0GxL7Es8h4dR226BrINodz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ug0ocvM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ug0ocvM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F77C2BBFC;
	Thu, 13 Jun 2024 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281892;
	bh=1obTltwYabfVr65LqJy5rwEUEFtMQHktkOx6Vshdb6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug0ocvM5pxx8KHBqOq/oKl60z4s/YeTPmPE6uYUjbpFRQEsGbxCeOKGWqb5fPdKdi
	 T+oU8aO6X1qEqcNllKObQlKX9uR/Ks2ALarB+dTc2WuDNQc/kvA8uZRbWzcOgkX2PE
	 BCiUdeJZAa8xdRTjUZROZx3JJVyGt9hcTFtdGoEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/402] net: give more chances to rcu in netdev_wait_allrefs_any()
Date: Thu, 13 Jun 2024 13:30:49 +0200
Message-ID: <20240613113305.727251453@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f80bc2ca888aa..e86ef1a1647ec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10549,8 +10549,9 @@ static void netdev_wait_allrefs(struct net_device *dev)
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



