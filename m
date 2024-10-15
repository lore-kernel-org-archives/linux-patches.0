Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4D91C07ED;
	Tue, 15 Oct 2024 13:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997826; cv=none; b=rvGVJw5c86WnJYJ3gWkaI8ymiAUUtGQJwUdFn/pG+90eHc7EejAoc9IgWbiaQyVSgYw+LbRfmN/C+URvT9Bm0ICdwO69zqfeG/33hgYxVYPgDizTENLp95u1ePlVOeIAZyIkbyVIme1goi09knzNCs20VmovqwTsIDcteRSAJbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997826; c=relaxed/simple;
	bh=o21/pLBlPkK6/uRaNrCuU9yy/M4gXD5+cUVY7I6wu2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnyJJcDs0B9IeJuLm1N62yL1aL86dMrBRRgJVrKi0brmqPCjOSDOnXoJu12ju7J5H4haIxwGVcXBcCgQFaisLKLpFtu/hDbMt3+nORCax9kcuOrg2i79QZepQpzsi/F4R7TcuEJQBxR2+kFjMl1PgIQa+UG+1oaQbjNF+yAapfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXty/Srx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXty/Srx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7A5C4CEC6;
	Tue, 15 Oct 2024 13:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997826;
	bh=o21/pLBlPkK6/uRaNrCuU9yy/M4gXD5+cUVY7I6wu2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXty/SrxLPSWYFQ44LUXDM/20Zu2BNkIiRfJqpt93Jk+VesGzZpZi35uwHV5n4671
	 EWi6bGQ+I4z/r7ZWSK0UIj+10xFzv4CNOgNZ2mBfOIJXTHg4gAtiWqwZ/IlW6DpjMd
	 O1ZUJJfxL719ivJndyNhC+mhG/KYR7Kq6NYnNrf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/518] net/xen-netback: prevent UAF in xenvif_flush_hash()
Date: Tue, 15 Oct 2024 14:43:21 +0200
Message-ID: <20241015123928.453024597@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 0fa5e94a1811d68fbffa0725efe6d4ca62c03d12 ]

During the list_for_each_entry_rcu iteration call of xenvif_flush_hash,
kfree_rcu does not exist inside the rcu read critical section, so if
kfree_rcu is called when the rcu grace period ends during the iteration,
UAF occurs when accessing head->next after the entry becomes free.

Therefore, to solve this, you need to change it to list_for_each_entry_safe.

Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://patch.msgid.link/20240822181109.2577354-1-aha310510@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/hash.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netback/hash.c b/drivers/net/xen-netback/hash.c
index ff96f22648efd..45ddce35f6d2c 100644
--- a/drivers/net/xen-netback/hash.c
+++ b/drivers/net/xen-netback/hash.c
@@ -95,7 +95,7 @@ static u32 xenvif_new_hash(struct xenvif *vif, const u8 *data,
 
 static void xenvif_flush_hash(struct xenvif *vif)
 {
-	struct xenvif_hash_cache_entry *entry;
+	struct xenvif_hash_cache_entry *entry, *n;
 	unsigned long flags;
 
 	if (xenvif_hash_cache_size == 0)
@@ -103,8 +103,7 @@ static void xenvif_flush_hash(struct xenvif *vif)
 
 	spin_lock_irqsave(&vif->hash.cache.lock, flags);
 
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
-				lockdep_is_held(&vif->hash.cache.lock)) {
+	list_for_each_entry_safe(entry, n, &vif->hash.cache.list, link) {
 		list_del_rcu(&entry->link);
 		vif->hash.cache.count--;
 		kfree_rcu(entry, rcu);
-- 
2.43.0



