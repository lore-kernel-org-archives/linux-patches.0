Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737F25B691;
	Tue, 11 Mar 2025 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707286; cv=none; b=eUwhG8g8fXaUkq41MgEk1GovJGz4RxBj4oQRJGfym6QnBvaqmBAofieqW4QafNZd8Jh/mSH76q3QR56Zo6EEktLBQgCXJt9U+c0qfAI16UOFd8eAIY6TFurwtRBL8Ni9v8pbFUbUQhtMlMS+QTY783hmxHdXs9GloqWW6tUKQ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707286; c=relaxed/simple;
	bh=ZYJb63cEbOa3jL38MiCYcl87yyxm6n+RYNX7UqEohLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSqQGHHBXKE7inlPDSjQQcO9VttBWQFtbCbtLAeHLXNc+ZiIpxqTVhvfiRmdfLtn+63VuaG215ORjWPtBUQDvGa+exm7TZKEB5mmzUEFVYvYn9B1E+qRq0l4OMITC2xqYEn/5Dn5s/ORoPW/DHZjNJJ/PyEPBc60wJ1JzXzN84E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1pJwbnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1pJwbnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927EAC4CEE9;
	Tue, 11 Mar 2025 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707286;
	bh=ZYJb63cEbOa3jL38MiCYcl87yyxm6n+RYNX7UqEohLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1pJwbnv7O/b3TS+TS78YaKykmEZJ5uJBfWwRxTm6VagclvHNoVKdPb21E1RSxr5V
	 i8KALB7/dHxYYxlRH/bwiUtHzt1JcSdZKdS/TlT8ru8Dxv+WNks7xzveF1j5BJKjPH
	 PrMcUuZ7zU218DA53SUWNu3Gmv3WnggOpuzVyCCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/462] geneve: Suppress list corruption splat in geneve_destroy_tunnels().
Date: Tue, 11 Mar 2025 16:00:03 +0100
Message-ID: <20250311145811.680861287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a79cebd7041be..4dfe0dfb84e83 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1963,14 +1963,7 @@ static void geneve_destroy_tunnels(struct net *net, struct list_head *head)
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



