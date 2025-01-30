Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838791E9906;
	Thu, 30 Jan 2025 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246876; cv=none; b=l+pLfJw0PAntQw/zSArWEq5SDI6sEiovS7vd9YTF6NN4zch0cWRguYfguo/VxH1UBiI4lPMzM1GBjJAco3rI5lhnWKIrlOHSqaq9Pn0AipdjS9hE7MocaSDQbc7ZLX740JdMsseGhdTMIUAmkV+yQn7yErbPfODNM9mLiA1j5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246876; c=relaxed/simple;
	bh=HLn8CzkK2huCnj6Z5pbv9Pgyaoh/k48rpceUKE2w9lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiBXvtUXuE0EbYiYBw/fsIGaAKJePa7xWMYqnjTdooLuwA7nhwS6tOuRhQlyxi+90XhDEaHPmj5bgnMBGYW84Pk1WxLUjO7d6nHinskKwTL7GxA0tDQOXyAuObLp3Y2p1Zc0zB+/TpEMvkwmxJtjYgyLHcqAeKTLNe/L8Ps0GP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8pl1sZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8pl1sZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBCBC4CED2;
	Thu, 30 Jan 2025 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246876;
	bh=HLn8CzkK2huCnj6Z5pbv9Pgyaoh/k48rpceUKE2w9lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8pl1sZC3YUxxvoBPl5EXO9Bj/G/va18gyxzbZltFLOQfRvMHuatJ2XjCVwfJXnti
	 cE6VxGj+OIoR6kyh0Ai1rXIKCZ+/8KExqey0GGiAzfvHlsdyLxcuzjMQeQRpb1OvKv
	 7+P0B0vENHctN2+bRLL+O486P9T5dqT8i+H/mKqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Hagar Hemdan <hagarhem@amazon.com>
Subject: [PATCH 5.4 83/91] net/xen-netback: prevent UAF in xenvif_flush_hash()
Date: Thu, 30 Jan 2025 15:01:42 +0100
Message-ID: <20250130140137.022524835@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit 0fa5e94a1811d68fbffa0725efe6d4ca62c03d12 upstream.

During the list_for_each_entry_rcu iteration call of xenvif_flush_hash,
kfree_rcu does not exist inside the rcu read critical section, so if
kfree_rcu is called when the rcu grace period ends during the iteration,
UAF occurs when accessing head->next after the entry becomes free.

Therefore, to solve this, you need to change it to list_for_each_entry_safe.

Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://patch.msgid.link/20240822181109.2577354-1-aha310510@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/hash.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netback/hash.c
+++ b/drivers/net/xen-netback/hash.c
@@ -95,7 +95,7 @@ static u32 xenvif_new_hash(struct xenvif
 
 static void xenvif_flush_hash(struct xenvif *vif)
 {
-	struct xenvif_hash_cache_entry *entry;
+	struct xenvif_hash_cache_entry *entry, *n;
 	unsigned long flags;
 
 	if (xenvif_hash_cache_size == 0)
@@ -103,8 +103,7 @@ static void xenvif_flush_hash(struct xen
 
 	spin_lock_irqsave(&vif->hash.cache.lock, flags);
 
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
-				lockdep_is_held(&vif->hash.cache.lock)) {
+	list_for_each_entry_safe(entry, n, &vif->hash.cache.list, link) {
 		list_del_rcu(&entry->link);
 		vif->hash.cache.count--;
 		kfree_rcu(entry, rcu);


