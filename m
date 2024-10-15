Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABCA1EB9E8;
	Tue, 15 Oct 2024 11:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993437; cv=none; b=XbFTdjA7kIhRp+VgwdGPAz9cDYCSgQJwM8fMWKY6/xs0E9m2WwZ7qCADZYFTxO/R8fApGVpM6bhKbTC+1UZVKuTcYVzeB603B7HQeb2ouCPDW3Ta5CuVfcDclW2h6J9AjOx0LnqtaorgS4iFvf5t3O9qQwm7a5tXhAQSpkldRQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993437; c=relaxed/simple;
	bh=00oYVZm12vByY8oaOSqa2yOyif5h5JaFepzeMSDcwiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upTELX9oKSniY9SVgV8QSktWOLtI2R0fEUw+GKYpB0dnSGSHKp1eyCkchHnDGnyoCJIBirLYPFJ+qXEUIh4ofFc9WVq1tX98yuA8axnnyhWTNKn9OIpCl9KMZwcL3MqOEB4dfn0iW7bz1HNrQinxBij4XXqnQH+SPR9tu4UfXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c50uGZqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c50uGZqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CD5C4CEC6;
	Tue, 15 Oct 2024 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993437;
	bh=00oYVZm12vByY8oaOSqa2yOyif5h5JaFepzeMSDcwiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c50uGZqtDQtltRvdIn+qvFvcZ3ve50JLXY0uoI72na4dEQNbHZqzqt+3OOS99KeyI
	 80oC9e+Tmz3w02LlJEWXxZ2CJ02a2mDmEScbQQ8uPbg1vvwdAX+pAuzfSbM/bBFI2u
	 n2GkXg2GC437laGAT71A3EpuJqYXj+hv9P/O0KQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/691] net/xen-netback: prevent UAF in xenvif_flush_hash()
Date: Tue, 15 Oct 2024 13:25:58 +0200
Message-ID: <20241015112456.617712623@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



