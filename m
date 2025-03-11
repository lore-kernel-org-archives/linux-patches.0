Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223B025EF94;
	Tue, 11 Mar 2025 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706108; cv=none; b=PssmFyKHgZ7IuAFHjEJmZ4yKZBWpnHKQutq5dCIUd61uxBtLbYilLRElRewA/BaR9xTo16SsIZrX4vhbCL66WcNhqSaAhmegBADem7Eu2PJbcOpeE2nCUMLxh23NQ8a+63frwcS360WfTSlIykR1Gxfur+Q2fVbnUnml2vESPoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706108; c=relaxed/simple;
	bh=Dg15uky77J6+3RSNddxbNdAgo2ZQQPoAbs7GgdOSoys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYHGphWAKBFqjCwvTqf2KXbPdP33z4Y3qNUQxsR82zf/xYOIWxvWeb/hLahTR9eSkmA8cSP1sVzVfW5TPk1jOJ6uL8kCQ0fcQ7B+ujawKPEM+oi5ThteNgb6SRWz7Tmbu9ObLLbHC5kJqHfs91s0qKWQGdrGvpvn3RXh7cKkJHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ofpnR2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ofpnR2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97821C4CEEA;
	Tue, 11 Mar 2025 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706108;
	bh=Dg15uky77J6+3RSNddxbNdAgo2ZQQPoAbs7GgdOSoys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ofpnR2Q0all0pfZBH+S8ivUAVuD+u4FZRGMeRXhP5U0W5lE+T6dx/Sdbp/SYFa1u
	 /2oM4tS27jTnWMm+K4SPUPRefK+qhWL39mxUFu8TkmCuIIIQcn8iJKbdhUpfYvnp8S
	 yUZ+SbR1tZTHDNDDQBohVsX/EW/9//CzKai8Rmoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 247/328] geneve: Suppress list corruption splat in geneve_destroy_tunnels().
Date: Tue, 11 Mar 2025 16:00:17 +0100
Message-ID: <20250311145724.726719474@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 62fab6eef61f245dc8797e3a6a5b890ef40e8628 ]

As explained in the previous patch, iterating for_each_netdev() and
gn->geneve_list during ->exit_batch_rtnl() could trigger ->dellink()
twice for the same device.

If CONFIG_DEBUG_LIST is enabled, we will see a list_del() corruption
splat in the 2nd call of geneve_dellink().

Let's remove for_each_netdev() in geneve_destroy_tunnels() and delegate
that part to default_device_exit_batch().

Fixes: 9593172d93b9 ("geneve: Fix use-after-free in geneve_find_dev().")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250217203705.40342-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 3e8b96de72a74..8fa466b879384 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1867,14 +1867,7 @@ static void geneve_destroy_tunnels(struct net *net, struct list_head *head)
 {
 	struct geneve_net *gn = net_generic(net, geneve_net_id);
 	struct geneve_dev *geneve, *next;
-	struct net_device *dev, *aux;
 
-	/* gather any geneve devices that were moved into this ns */
-	for_each_netdev_safe(net, dev, aux)
-		if (dev->rtnl_link_ops == &geneve_link_ops)
-			geneve_dellink(dev, head);
-
-	/* now gather any other geneve devices that were created in this ns */
 	list_for_each_entry_safe(geneve, next, &gn->geneve_list, next)
 		geneve_dellink(geneve->dev, head);
 }
-- 
2.39.5



