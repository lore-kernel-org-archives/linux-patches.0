Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649012F691F;
	Thu, 28 May 2026 20:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998840; cv=none; b=ArV2M8CXYs6cwZ5QwIvTJ09oALt/RuErXFQ3YTTNRf1TfqCbuZmHed3LqXbtwXVmjX6EPjQkTDBGrTdAhtFPYIhBNcwQWvr9mQEu8VPBuq0UA0lsvlo6i0whQFso8gp6HJRB8+LYm3yY67i8Htqi7OIF4yogJ5PyFAmFS0JAYYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998840; c=relaxed/simple;
	bh=Q/V2zIRYkfYyIKm47xsU6CPB3geEZLfT5Q9IFV8crCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/g0MQQZGAaYVHYljYvMwmZUaX0GJVnGriWRp1aHuu6xN3mJ27ziYGJ0Aja7KBnpL6kwIvLbJA5b+loDtTqwwNHcBYG9rqILlkYJAlBaV9pHPeaKUcM+eif1P4x7eVATeb8K34CUyMzfitu4XS+FaiX3WQnHx1/WGuT8hfKaIz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHNoWz5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHNoWz5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13CE1F000E9;
	Thu, 28 May 2026 20:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998839;
	bh=Ae+KGWxN22v0cV4RQOtt0VqjV0Pg5MhCZGTSkaILdak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHNoWz5so1z8ANyDt+/ktRaIzv9IOGo9+CaYtRtIYQjjxFd6SsMrT6qSS8HPOApQs
	 FMWgMld9GdWRRmRa7qckrOLDNBFQpNR/mZOxvX5daXfgyg8H0IqS2QKSlgKWeGStPv
	 9OswvDOK/9DD3QAgCy4EgpWAfQRn9IUWH4fg2kWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 280/461] net: shaper: fix trivial ordering issue in net_shaper_commit()
Date: Thu, 28 May 2026 21:46:49 +0200
Message-ID: <20260528194655.295107664@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 235fb5376139c3419f2218349f1fa2f06f24f7ad ]

We should update the entry before we mark it as valid.

Fixes: 93954b40f6a4 ("net-shapers: implement NL set and delete operations")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-3-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index d2b8f1f951b19..86319ddbf2905 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -295,6 +295,10 @@ net_shaper_lookup(struct net_shaper_binding *binding,
 				       NET_SHAPER_VALID))
 		return NULL;
 
+	/* Pairs with smp_wmb() in net_shaper_commit(): if the entry is
+	 * valid, its contents must be visible too.
+	 */
+	smp_rmb();
 	return xa_load(&hierarchy->shapers, index);
 }
 
@@ -412,8 +416,9 @@ static void net_shaper_commit(struct net_shaper_binding *binding,
 		/* Successful update: drop the tentative mark
 		 * and update the hierarchy container.
 		 */
-		__xa_set_mark(&hierarchy->shapers, index, NET_SHAPER_VALID);
 		*cur = shapers[i];
+		smp_wmb();
+		__xa_set_mark(&hierarchy->shapers, index, NET_SHAPER_VALID);
 	}
 	xa_unlock(&hierarchy->shapers);
 }
@@ -837,6 +842,10 @@ int net_shaper_nl_get_dumpit(struct sk_buff *skb,
 	for (; (shaper = xa_find(&hierarchy->shapers, &ctx->start_index,
 				 U32_MAX, NET_SHAPER_VALID));
 	     ctx->start_index++) {
+		/* Pairs with smp_wmb() in net_shaper_commit(): the entry
+		 * is marked VALID, so its contents must be visible too.
+		 */
+		smp_rmb();
 		ret = net_shaper_fill_one(skb, binding, shaper, info);
 		if (ret)
 			break;
-- 
2.53.0



