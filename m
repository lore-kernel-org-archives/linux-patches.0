Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CFA2264DD;
	Tue, 17 Jun 2025 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179017; cv=none; b=Sk6nFz6sQ9plAGA320mczArMv/n7X7OvnDq9Q93lLh2qVL4FQHYn0ITVmwsRNHgySv7ZZvOC/mjEeuSBlv6Ygq2/1E/Z89H437U3TK/moq965TU4w8RAS5Ggo8FoKFokt5LaBegnHmc4Xxw5bOm1tCT6qZrKKJyNlF9MI5NL+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179017; c=relaxed/simple;
	bh=99PzaP/SA9cGpvi8PETLFxAF/tzV8R2XhvYqJLZ/B8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJuMXq+cVaaECehHOg+3lt89fI0GM302wN0x6BuUjRVIvIPF/A7wywq9MRRF7PD7UnklbISX9wyohd39GlZkFAYQm5IqFoBFr0IhzoMA8rCPgzrWYEodQZvK7Yl7F77BjqospYWKcg0+hDho47V/+qry9GrfXCbBp/M7W78nrho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcfuaKZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcfuaKZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB217C4CEE3;
	Tue, 17 Jun 2025 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179017;
	bh=99PzaP/SA9cGpvi8PETLFxAF/tzV8R2XhvYqJLZ/B8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcfuaKZUnMk5QsYQGRpA1facq5XUujEnubRKp0RBccKkzgLyjA0GF215XCr+uyA0p
	 TCv0QCaXUg+hWYYAADudyVtIVbCGGQIWaHxrde2orEyh01fRSV3YnQIsi5qs8qLW6A
	 rUjuD6Wj1Px/ZAKPIsE1HkG/XqCRTBJ7smKRZETE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 623/780] net: annotate data-races around cleanup_net_task
Date: Tue, 17 Jun 2025 17:25:31 +0200
Message-ID: <20250617152516.846460726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 535caaca921c653b1f9838fbd5c4e9494cafc3d9 ]

from_cleanup_net() reads cleanup_net_task locklessly.

Add READ_ONCE()/WRITE_ONCE() annotations to avoid
a potential KCSAN warning, even if the race is harmless.

Fixes: 0734d7c3d93c ("net: expedite synchronize_net() for cleanup_net()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20250604093928.1323333-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c           | 2 +-
 net/core/net_namespace.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0d891634c6927..2b20aadaf9268 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10393,7 +10393,7 @@ static void dev_index_release(struct net *net, int ifindex)
 static bool from_cleanup_net(void)
 {
 #ifdef CONFIG_NET_NS
-	return current == cleanup_net_task;
+	return current == READ_ONCE(cleanup_net_task);
 #else
 	return false;
 #endif
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b0dfdf791ece5..599f6a89ae581 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -600,7 +600,7 @@ static void cleanup_net(struct work_struct *work)
 	LIST_HEAD(net_exit_list);
 	LIST_HEAD(dev_kill_list);
 
-	cleanup_net_task = current;
+	WRITE_ONCE(cleanup_net_task, current);
 
 	/* Atomically snapshot the list of namespaces to cleanup */
 	net_kill_list = llist_del_all(&cleanup_list);
@@ -676,7 +676,7 @@ static void cleanup_net(struct work_struct *work)
 		put_user_ns(net->user_ns);
 		net_passive_dec(net);
 	}
-	cleanup_net_task = NULL;
+	WRITE_ONCE(cleanup_net_task, NULL);
 }
 
 /**
-- 
2.39.5



