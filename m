Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9681DF74E;
	Wed, 19 Feb 2025 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954476; cv=none; b=q/n8R50mGwrs9G2yt7t5JBp21DU2db1DnyVot2aZj2Gubqq3pyilr+0aORzqybF5UmNg9QcZLWHxfBZLFVfOZWhviAGa5u4+lDHIQU2r69NnFROOL4WOjh/n5qnlACTnjVTzyToZpdN3aJOUwpFsW4xCJ0Rv46BKDMBfpGxnSls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954476; c=relaxed/simple;
	bh=XtS60sWXSpS3B2nV6PKEa54TwkvdO80qNHTe/YBBz2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k93dz9Ix+PlMy9zB1PidXGRRLa6/P6ShasPbbya3C7OgJgBjYR6aWJ0kq7T/ztX/33vHc8rjeD4yxKxWLRwvVtoHNFrBkExIz/DJw0BexB9DUry+YO/SFCCgNY7HCfu8BF3Uj+D51GbvunFNYVeFnYgoI6JUBVMC+8dq++sf8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAhe+D0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAhe+D0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF87C4CED1;
	Wed, 19 Feb 2025 08:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954476;
	bh=XtS60sWXSpS3B2nV6PKEa54TwkvdO80qNHTe/YBBz2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAhe+D0l0RX5Bqp4c+yPr4Bnb/UY+tywisGVJINlbbA7mzurerax3iQfV7RSNsdU7
	 /Eetiqm6CaxuqoiUqcbFskXgWH/MsGmgCUEKhC3/WKdMbFxmRosztmq/zl3PU136ox
	 ylxSl1rkWAirMTE1Wsju4mx8Uu7mP87/5+vS5hG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 216/274] net: add dev_net_rcu() helper
Date: Wed, 19 Feb 2025 09:27:50 +0100
Message-ID: <20250219082618.030614794@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 482ad2a4ace2740ca0ff1cbc8f3c7f862f3ab507 ]

dev->nd_net can change, readers should either
use rcu_read_lock() or RTNL.

We currently use a generic helper, dev_net() with
no debugging support. We probably have many hidden bugs.

Add dev_net_rcu() helper for callers using rcu_read_lock()
protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 71b8471c93fa ("ipv4: use RCU protection in ipv4_default_advmss()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h   | 6 ++++++
 include/net/net_namespace.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3928e91bb5905..8268be0723eee 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2635,6 +2635,12 @@ struct net *dev_net(const struct net_device *dev)
 	return read_pnet(&dev->nd_net);
 }
 
+static inline
+struct net *dev_net_rcu(const struct net_device *dev)
+{
+	return read_pnet_rcu(&dev->nd_net);
+}
+
 static inline
 void dev_net_set(struct net_device *dev, struct net *net)
 {
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5a2a0df8ad91b..44be742cf4d60 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -396,7 +396,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 }
 
-static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+static inline struct net *read_pnet_rcu(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
 	return rcu_dereference(pnet->net);
-- 
2.39.5



