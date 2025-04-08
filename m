Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29F22424C;
	Tue,  8 Apr 2025 11:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111970; cv=none; b=poLZfG6pkqhUCL3HUVRAk8tkKTQbLZdC8SDV6drGJl1QbscYSXs/BAF2spZLa/cWbfHg8gu6zvwV1Cr9HVPzZmoG8POO5SznY87Yi3beZf/Z8r9unNpRGwFXY+USMNz9X8rpPgQmeQEj0lRfr4gNteixqIT58dsBx0P2NAHsIlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111970; c=relaxed/simple;
	bh=Fahz+PAOdAXiJBJE4SfWhZ9SVbcniyMZBhB3TKqSwec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdi8IuH3FNCJNKGOre3hdBDz2TcE/zQCnAKcwiZlvTC+8xaaS+PWgoJyY/6sqsFP+qIKo8Kggpl8+/iWlVbIrRWXCmBdx4KwfpLAjwB40DA5gzfoe5SeK9EgNkE7TdIuGabw8Hl+eII8SYftPyHAXCbbjitIqDE47WLrRey9ioU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dL3zo4L7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dL3zo4L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB9AC4CEE5;
	Tue,  8 Apr 2025 11:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111969;
	bh=Fahz+PAOdAXiJBJE4SfWhZ9SVbcniyMZBhB3TKqSwec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dL3zo4L7LRtQB6Kp9FGrztyc9IPjochJr5WLv+J0LHjRdFsGw7WlEfnzDJ98b7iBQ
	 nJIEgOJrhhtuVvUkpWuulWk395XX8z47QVyy7yk76SxmS6T6yPcKmN3k6DKGq1WhwI
	 dH6No81RlHT77jELfUBzKZ0FZ6lMqWCJx1cnma6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 626/731] rtnetlink: Use register_pernet_subsys() in rtnl_net_debug_init().
Date: Tue,  8 Apr 2025 12:48:43 +0200
Message-ID: <20250408104928.833975765@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 1b7fdc702c031134c619b74c4f311c590e50ca3d ]

rtnl_net_debug_init() registers rtnl_net_debug_net_ops by
register_pernet_device() but calls unregister_pernet_subsys()
in case register_netdevice_notifier() fails.

It corrupts pernet_list because first_device is updated in
register_pernet_device() but not unregister_pernet_subsys().

Let's fix it by calling register_pernet_subsys() instead.

The _subsys() one fits better for the use case because it keeps
the notifier alive until default_device_exit_net(), giving it
more chance to test NETDEV_UNREGISTER.

Fixes: 03fa53485659 ("rtnetlink: Add ASSERT_RTNL_NET() placeholder for netdev notifier.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250401190716.70437-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnl_net_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnl_net_debug.c b/net/core/rtnl_net_debug.c
index 7ecd28cc1c225..f3272b09c2556 100644
--- a/net/core/rtnl_net_debug.c
+++ b/net/core/rtnl_net_debug.c
@@ -102,7 +102,7 @@ static int __init rtnl_net_debug_init(void)
 {
 	int ret;
 
-	ret = register_pernet_device(&rtnl_net_debug_net_ops);
+	ret = register_pernet_subsys(&rtnl_net_debug_net_ops);
 	if (ret)
 		return ret;
 
-- 
2.39.5



