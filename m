Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5143A4E36D0;
	Wed, 30 Sep 2026 17:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788349; cv=none; b=WBFEAi83F7RAaNKV/aiCTzzMym36NTMR7wewY69MKO5O53KQTYYO9f0eCDR9Pa31VBDVB+rCH+tRMOQLsCm3p2g7nbXZYyMl/erOGbvXEUTrBIBhNtehSSDP65Pd81G6EVTpMtImM7kc4IKG4nu76La9Hk9XnjfLmYd8qHYYOMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788349; c=relaxed/simple;
	bh=Xkm8QGJw69vFdsW6Dm+WlVUa2LyxVRFYeGRdcA3trZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqrRgoxfHDTqBSYp8glVzmhHZ6bgMT3q0roMUOiK/pEmzW6jo7aeal86B11oA7DNvWKfv1a2o0hsPJIS4IOhqpgQNvlm3i2C3fahxvU81LNz6KSmhSGgCqMmRadTn4b13JMd0ueZQqbHRROOYi0oR4ILYnqLlMHJ6HKKgyQccmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+Nc8rVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+Nc8rVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A161F000FF;
	Wed, 30 Sep 2026 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788348;
	bh=5oVXEmyWVDxJqMvLHWD0BOP0Hgpg47KPctM0u/QUSTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+Nc8rVHjBUAFTiLHQL4wh7M9Iwqr4K9cpQwjuk1cBarnLJQpM98QULn+hRjrIYW/
	 KT/kjY8A2q2jJ+vIznfG46srIMtZK7xZThtyFL9E2Bpr+fGdJT8IVtGUFUL4Qsseol
	 V8PwiWsCcQLOgaI30NBXk/G9MJZq/A7VqiUlmdH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/877] neighbour: Use rtnl_register_many().
Date: Wed, 30 Sep 2026 17:16:43 +0200
Message-ID: <20260930152416.722458210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit d0d14aef50a6184426c5a05b9815fb2697d6d42c ]

We will remove rtnl_register() in favour of rtnl_register_many().

When it succeeds, rtnl_register_many() guarantees all rtnetlink types
in the passed array are supported, and there is no chance that a part
of message types is not supported.

Let's use rtnl_register_many() instead.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014201828.91221-4-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index bf07438d6dfa5..1dd9f85b74997 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3898,17 +3898,18 @@ EXPORT_SYMBOL(neigh_sysctl_unregister);
 
 #endif	/* CONFIG_SYSCTL */
 
+static const struct rtnl_msg_handler neigh_rtnl_msg_handlers[] __initconst = {
+	{.msgtype = RTM_NEWNEIGH, .doit = neigh_add},
+	{.msgtype = RTM_DELNEIGH, .doit = neigh_delete},
+	{.msgtype = RTM_GETNEIGH, .doit = neigh_get, .dumpit = neigh_dump_info,
+	 .flags = RTNL_FLAG_DUMP_UNLOCKED},
+	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info},
+	{.msgtype = RTM_SETNEIGHTBL, .doit = neightbl_set},
+};
+
 static int __init neigh_init(void)
 {
-	rtnl_register(PF_UNSPEC, RTM_NEWNEIGH, neigh_add, NULL, 0);
-	rtnl_register(PF_UNSPEC, RTM_DELNEIGH, neigh_delete, NULL, 0);
-	rtnl_register(PF_UNSPEC, RTM_GETNEIGH, neigh_get, neigh_dump_info,
-		      RTNL_FLAG_DUMP_UNLOCKED);
-
-	rtnl_register(PF_UNSPEC, RTM_GETNEIGHTBL, NULL, neightbl_dump_info,
-		      0);
-	rtnl_register(PF_UNSPEC, RTM_SETNEIGHTBL, neightbl_set, NULL, 0);
-
+	rtnl_register_many(neigh_rtnl_msg_handlers);
 	return 0;
 }
 
-- 
2.53.0



