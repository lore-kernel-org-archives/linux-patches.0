Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6A4DDB5A;
	Fri,  9 Oct 2026 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555325; cv=none; b=BBUvcblhYsk3cpObyXIjstG+BPaK9vvdncoxFX9ZoxRaSG8RKAl5LXpMPYRtASnksv5Zyr2hjRaBYF2BI1g/LIW5co+pJ3fpriHv4hjftsodvdX5bPPxr86oSlqtBTzbuWutUb8+Tt4WkGgWu0tnLWF3xbqQy92GpIBxkom0hF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555325; c=relaxed/simple;
	bh=kB5w2wo3Xlm13EP0i7BavlXSxND9fd5MFru2y/CVJLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPcjUkUAqIiNgQmZKPPX+VWBnBmXClYcW18SGeTlzS9wPm3jCj0ElLZAjK32QG+S6fksV/r446FHAfUuiaszIHyvo9081opAV5O0vvR2R5AwEWhpAxZkVhYDUufdh3rWz7A6W3wz56RJFIs8hsfJvOhJuiqLADx3n68ica5zY2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXL4Ehf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXL4Ehf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70E11F0089B;
	Fri,  9 Oct 2026 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555319;
	bh=Ueqfc71IjLgrlHgE2jWGX9JZSJivgXvAmeZBLNd9O7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXL4Ehf2C9Kl9WympysjCItSYF0CcyY62kwup4d00i72vOepe2bpbIJR+uCkx3piR
	 A+G1UV2P6KeqHF8n3UA747pZfiaXdlhxS/Uot4i93S3tp+QZKAcJCOSsfLLG2eg5Yn
	 cCmyPogn0v7C1eQVSIsZka62WebzxwbJvwtbe3+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/403] neighbour: Use RCU list helpers for neigh_parms.list writers.
Date: Fri,  9 Oct 2026 16:06:10 +0200
Message-ID: <20261009140952.339739465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 06d6322280d95757cef1e3ee0fc62c644629523e ]

We will convert RTM_GETNEIGHTBL to RCU soon, where we traverse
tbl->parms_list under RCU in neightbl_dump_info().

Let's use RCU list helper for neigh_parms in neigh_parms_alloc()
and neigh_parms_release().

neigh_table_init() uses the plain list_add() for the default
neigh_parm that is embedded in the table and not yet published.

Note that neigh_parms_release() already uses call_rcu() to free
neigh_parms.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251022054004.2514876-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 862867874e121..6afd6490d7847 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1765,7 +1765,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 		}
 
 		write_lock_bh(&tbl->lock);
-		list_add(&p->list, &tbl->parms.list);
+		list_add_rcu(&p->list, &tbl->parms.list);
 		write_unlock_bh(&tbl->lock);
 
 		neigh_parms_data_state_cleanall(p);
@@ -1787,7 +1787,7 @@ void neigh_parms_release(struct neigh_table *tbl, struct neigh_parms *parms)
 	if (!parms || parms == &tbl->parms)
 		return;
 	write_lock_bh(&tbl->lock);
-	list_del(&parms->list);
+	list_del_rcu(&parms->list);
 	parms->dead = 1;
 	write_unlock_bh(&tbl->lock);
 	netdev_put(parms->dev, &parms->dev_tracker);
-- 
2.53.0



