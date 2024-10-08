Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05771DDC24;
	Tue,  8 Oct 2024 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391382; cv=none; b=IibKqQdSio/JsvxTTxKVHLSzP601iMg7DrzhQqNlVWMW0N5Ht/e+JwYtzegqzYxWU8f5AjF2r0swU+ohvnKfHT4I2nKUuRrQxxm4YNphh2o3P66CDHEpv2Oiuj+r9zbzDipJAeFAblnaJRnVNxauQbE54WaSeT0KHB8dHLLWIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391382; c=relaxed/simple;
	bh=Jb5xGI+KkqPNRnmGPSEFI2N04+mekhv5SWu1l5zUO0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mmfaq4ugAxs7FoDEHvtM6UBRPiHK4FJ+0T174PrBMkhFthkZlkvgJf3axzG9rFKY0gcKgZjjkL7kghmLp6Uor/f/OmwIblPCHX1kRitH8rzetkUooKSQ/d0bQN1EvPgPh1tzbw5YMcXD43xgsDbZ2byCm6Gk9kOJPgRSR51OuSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atVZ9AMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atVZ9AMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60245C4CEC7;
	Tue,  8 Oct 2024 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391381;
	bh=Jb5xGI+KkqPNRnmGPSEFI2N04+mekhv5SWu1l5zUO0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atVZ9AMyGQfaoytn2AaOQYzlhvsZSWMNm7zd+ZpdAIhUyx7UFBYxVUPodahOU5wE1
	 3OIDw+kcczM6OqtajDC7jE0+vXRjWpghlEuOuESM9lsprhowun4/LTmhpaKzcxhb8J
	 W0F+3Lwc3DPt2+7ls0NAb6T1OEw8XS/+FzqnZ0pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 096/558] net/xen-netback: prevent UAF in xenvif_flush_hash()
Date: Tue,  8 Oct 2024 14:02:06 +0200
Message-ID: <20241008115706.147818549@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



