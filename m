Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C624EF74;
	Mon, 24 Feb 2025 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408464; cv=none; b=V6pYxVXLKUG/bodKmeq3QeI89Q69wWwYZFRiA5hS0baWUiYjOWug9C7j9lzLPfS7VvFmY9akywWr52I8GCWTJeqALZ+a6rKy6NKQ8aceRFtNK4GIYNQFVtAFSoCoMu10qmPsFk57Qxwl1NwMSzgaXl2q8/qWVR0/WCanxVJZ6Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408464; c=relaxed/simple;
	bh=t1NfmhSYr/5XyB73FYo2uskaVyMNt4FRa7zYoWP9xeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2fvvYw7dceh8yunLQu+75MvYEfZDBQ6anhDr5ndgoyO9sLBCbo09VCnZG5noYFqTQd/KgZmHmujticTqXdybwQuLkrr7aic08q4qfMxPXgMvF2ICjntS/3Skoq8beXIlsvTyR9laihQ44e3oOCuwVAg3EEXfr81v9/bxAy6tx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyd452Se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyd452Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BE0C4CEE8;
	Mon, 24 Feb 2025 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408463;
	bh=t1NfmhSYr/5XyB73FYo2uskaVyMNt4FRa7zYoWP9xeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyd452SeP5P2k7y5BWHTb1hUnHyh0v9fe4Bnjv+I3Zu6zVmJYUtRH2b48xDFWB5PP
	 0WDwo09qi/RBvBTBgp5/siHZT27mvD6IrtkR72w5viUzw2+x08zI5Ncnpnemyp7/Za
	 zTp4cZYWboy4Z1u1I4xU3nhKrFKgX5PM40Zgz3pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/154] geneve: Suppress list corruption splat in geneve_destroy_tunnels().
Date: Mon, 24 Feb 2025 15:34:25 +0100
Message-ID: <20250224142609.669927205@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9c53b0bbb4c57..963fb9261f017 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1902,14 +1902,7 @@ static void geneve_destroy_tunnels(struct net *net, struct list_head *head)
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



