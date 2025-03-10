Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2D32356AB;
	Mon, 10 Mar 2025 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630589; cv=none; b=IlJYg7z9fupJcfSjcaeI6BWRZVEuz8cA7OznwDtkU43kYYGLg2fpVQlEhLvsJSeZcpHOvpDRNA6UBOmRdKaavoRMJZIWQ7x9w/SLvhaubOD3UqCTJXFClJddkFwWihjx3XALxcDA1iTPqW2INhKJEii57G1JbArwaE4kKXzxY6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630589; c=relaxed/simple;
	bh=Z8ypCqY88m5hm8Pv9gs4+XOxdBR0iBSiGLi5wBJabdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK0x/xeubpoc4iHV/taDTH+/aV2gtHiLZ6UXTDY8wpgvlbEg/RteVIwaP0YuUWrXYWGzs8ursQicYVNX7XHGqDo0eQoHbEg4Ui22PDY1l6Fvio33vTdErfMXDSXQBIdI/174vBmBWGszy29baMotSF+mQwaXX6yO+1VaG8d1p/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soEbJyo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soEbJyo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675D0C4CEEE;
	Mon, 10 Mar 2025 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630588;
	bh=Z8ypCqY88m5hm8Pv9gs4+XOxdBR0iBSiGLi5wBJabdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soEbJyo7L2ey7X8yjPTbVKWtjc00voW9xPHQE7ocpxkkyr+RqQ29aSUi0/bwGbh11
	 /74aUlmcG4FoZ07s9oxZwpW4UnyIEc4gYRZkgidfn8s9Pzm/3sM2JvHoZCnzCm8XPF
	 XuyOvGvYWjrjedqEht62Gr/TVV2WktY2qwTDr1Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 467/620] geneve: Suppress list corruption splat in geneve_destroy_tunnels().
Date: Mon, 10 Mar 2025 18:05:13 +0100
Message-ID: <20250310170604.013516931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e270cb0d8cb4..c51b39390c015 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1960,14 +1960,7 @@ static void geneve_destroy_tunnels(struct net *net, struct list_head *head)
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



