Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04B918A6C5;
	Mon, 24 Feb 2025 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408906; cv=none; b=C53qoKGw9BNY7h10IWkdfZ8EvVM4RXe4uw32MnFiYNUvOVUsl8gHZUc6KbqnAImAhoVd85v68SYnM6jJRUt5LlMXYYSAoqgAZNR71OUk5k66opX0DM+O7ymqM5d5Dvu3QRtXd6Oq+CFu+eoVkB3iz1GqqcsoBQy2/8C/LNMK3xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408906; c=relaxed/simple;
	bh=ZyFjdeSNuAGQ2v0tO0YlH/RJM6d9lfAjveu6YCaP8gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOaKoZcPLNuYCx7PFq+fB2S33vBvRFxziWJXStqtr6GXf4dvH1Z7+G/9JPfKdFCGS1ZibDukjave9C0kqAWqaP8rhnWq1M4LUROGf+CZ6i8uNRJ59vH5zt56HWhbLVWxd3eL3ohBZdt5ybZTssBpJESK/8CD+NcScenP9KULmSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcU0Sx3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcU0Sx3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F018AC4CED6;
	Mon, 24 Feb 2025 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408906;
	bh=ZyFjdeSNuAGQ2v0tO0YlH/RJM6d9lfAjveu6YCaP8gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcU0Sx3kIsofUuu5SiUavEC23A0tCF6JCqwHk9oN1roLeqzHq5EcpURn8UEakRD13
	 Llb3lLC1HoMc8All577e56YeU+sCssQpSjsdg6EGQiFyd0fK9/B9kgTaBgvJ5ysJIm
	 doBhbVEieVqXmbAdWWLVwS/pscmPqkC99kU339Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 041/138] geneve: Suppress list corruption splat in geneve_destroy_tunnels().
Date: Mon, 24 Feb 2025 15:34:31 +0100
Message-ID: <20250224142606.084882576@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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
index 363fff28db737..eea0875e4e551 100644
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



