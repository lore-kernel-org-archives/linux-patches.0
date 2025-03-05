Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD4B2512D7;
	Wed,  5 Mar 2025 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197143; cv=none; b=LIFuwWbbm4qTdZMySDrR3ascsf3+q829ZuCBoezHo2MbMYkPTDjj3c4/+c6zHQASfVWz6Z8nrPNhAflRDcgA2HVD1NnCmB82fph0XZSzWIlV4C+UmOX3iV9FpdnxAFGx+GFLgGShzLwOGpAvXZgz8ucYjKrjC4rLo331mKek7ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197143; c=relaxed/simple;
	bh=yxYy90v5ghdsOiwxP6ElBXM/p1wrwbXZ1Ym8jV15ERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og6loFfZtw845h6xi/VZwj1rAFDTQpXzbddyLc+65f/pG2PMwHrUVcPdUNOYBw/unlDzv8/oc++3yjSPWvw9J8H7rqDHE0sNZ3RJZz3bZkRZSyVRpB7Zj8S+3fgYPrCmsmp6wsyv/2r12Z59MdK2BCsaxGZyTz4DcbA4Xs7aVLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrhsGljd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrhsGljd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368B3C4CED1;
	Wed,  5 Mar 2025 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197143;
	bh=yxYy90v5ghdsOiwxP6ElBXM/p1wrwbXZ1Ym8jV15ERg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrhsGljdSYszkAhzzkyM8F/ngnzp+L4kVcVb+zuLPsiekdgAdS4M1HSf0bnxkj0hw
	 bqDmc0U4QPBeVeOcmMYdD4rurebhueK3O4fupFMYe35ZhtkixHj7RqoZdslP15nGO8
	 Ih3EBQqxnitPgMLVUV74ffhHqqnLx1VhxWbSayxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/176] geneve: Suppress list corruption splat in geneve_destroy_tunnels().
Date: Wed,  5 Mar 2025 18:47:03 +0100
Message-ID: <20250305174507.628265424@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 15b85eb3daa19..3dd5c69b05cb7 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1965,14 +1965,7 @@ static void geneve_destroy_tunnels(struct net *net, struct list_head *head)
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



