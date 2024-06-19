Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8113E82495;
	Wed, 19 Jun 2024 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803096; cv=none; b=k+uh3J9g1+dlO6fxY3lZOjsFd14DK/k8NU+QNZsEc567HfqZcfGUBAD+ay6S2N2aGt/kksqdzkGbPq/kmOJ76s2MGddrncS0qNowudL7ZcBMu0ATOHvfLSoir9MXIwuEba5i/8xBp49qXCu/ATJu2Ix3xYtG14QMiC2TmZEAz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803096; c=relaxed/simple;
	bh=qewfXIV7g0wR6/vwU2qbXiRLk7PzWWIfffTSQTJev1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHugSRoPBgfh5RDZ5ocoqVqb2UlezCLeqX3QChElID79eprNkp1aYHhteRwmSBG/ZghYckTAZZdREMefmgX7WL47BRj4KQtsZ6zvbNR3MkGBaNUs18Iqr6JDJhNOQSZNVx2obnJSt36pfxz4xUtIyF+DRssNDocLNWV4f5ttXJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yezy66Cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yezy66Cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C2BC2BBFC;
	Wed, 19 Jun 2024 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803096;
	bh=qewfXIV7g0wR6/vwU2qbXiRLk7PzWWIfffTSQTJev1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yezy66ClUGb1JvwIfiA8v6P7DU8sYnowOUJOqYNq34MJHE+1D4fG0bobPJeksfSBf
	 A5xysiBwv/J3nc+4fqAD4gc1EFVUEmK4c3hH9d2oivcT2r/WaVm9LEPvMARBjEMTUV
	 CSzPTZjDB8LFjmtVL5+f4Kvnco1yoHeRcnNGvQD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Watanabe <watanabe.yu@gmail.com>,
	David Wei <dw@davidwei.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 152/281] netdevsim: fix backwards compatibility in nsim_get_iflink()
Date: Wed, 19 Jun 2024 14:55:11 +0200
Message-ID: <20240619125615.689274169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wei <dw@davidwei.uk>

[ Upstream commit 5add2f7288468f35a374620dabf126c13baaea9c ]

The default ndo_get_iflink() implementation returns the current ifindex
of the netdev. But the overridden nsim_get_iflink() returns 0 if the
current nsim is not linked, breaking backwards compatibility for
userspace that depend on this behaviour.

Fix the problem by returning the current ifindex if not linked to a
peer.

Fixes: 8debcf5832c3 ("netdevsim: add ndo_get_iflink() implementation")
Reported-by: Yu Watanabe <watanabe.yu@gmail.com>
Suggested-by: Yu Watanabe <watanabe.yu@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 8330bc0bcb7e5..d405809030aab 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -292,7 +292,8 @@ static int nsim_get_iflink(const struct net_device *dev)
 
 	rcu_read_lock();
 	peer = rcu_dereference(nsim->peer);
-	iflink = peer ? READ_ONCE(peer->netdev->ifindex) : 0;
+	iflink = peer ? READ_ONCE(peer->netdev->ifindex) :
+			READ_ONCE(dev->ifindex);
 	rcu_read_unlock();
 
 	return iflink;
-- 
2.43.0



