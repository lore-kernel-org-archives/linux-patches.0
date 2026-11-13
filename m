Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591554;
	b=jZ6pLAWiuIZO5VGcpkLSn7Eq84jxMznTJTNEfU5wXYhpBY/s5U4P8V/Aqf29a2r4Py1l
	 2TEM39jRc98Rs3VhgxZ9VpEUqP+Sew/NYX61RUdTbvOZ3Dmaa6by/zllrs3MtO4HnF4ub
	 JT7miY60IR6eVzK9r0Qgkmvk10nK98Ylpd9BJ+/LOvAgp6f+60/LrXDoxK337oIUcmadA
	 zjMDbuyDz5Z1hZLMIUTixow67ZEnd6CQh3t+4fgI5dleZhwoyXm4TCpeO0tFtQsEOGdkn
	 iSPDFQl+eJHAosEyo9tRWZTZvxnb2W/tMVWSQfw93024EmKrShEDSp6sZNZBiaOuXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rLjajc9SdKaeCIxfSpRg9S+/cuLX2a5ZEhWHQYagb6Q=;
	b=OVnIsTUsso0hAyLTwEIZ0llw5B8raybMUBnpOP6kuxjWdLrtgmgHXe2ZYfM3tXMn143K
	 vqn0/G3L9vzRs4apRILqTZXUdjyJih10XWNYkov3xnwh+kmal+re0BYq7m8rcJLglaIYS
	 zBVk+6bp6etnmEvyTPaJRb/UIWxosK5TMsbd7ANt5mFZR09bG1CSKjMQx+5icN6KvW3vZ
	 F/GGTE8moCiXt+14PH9KK/Nd6v4iF7E3JcHGsTxesgJen9a6BAt0Wwg6uIReNsVfqUJuF
	 PiRePSEY5aJui7WkcQ2u+2M5yHMSJfCO03Ph6geqdBcnkwQZn9/z4sAjDxgDg40yP/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2twDlQo2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4569F606E21E;
	Fri, 13 Nov 2026 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2twDlQo2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B391F000C4;
	Fri, 13 Nov 2026 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591554;
	bh=rLjajc9SdKaeCIxfSpRg9S+/cuLX2a5ZEhWHQYagb6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2twDlQo2igh4kJ/YwXULcWlhjNMt6etIH0ZE/iPk0rmq/jnr/8cd7lx3Un1KEFmNf
	 UiiLjYtX3S89g9V3XgqCeFkW1XePOAY5mpwFLdjv0X8xByGGJ4H6olgUmvPuK4oUbZ
	 0r6b8FkSiqCqQzPIrFgJ24u8/PCDhv54gAonK6Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 604/670] fs: rotate inodes whose page cache could not be dropped
Date: Fri, 13 Nov 2026 10:52:48 -0500
Message-ID: <20261113153832.298127891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaos Karaolidis <nick@karaolidis.com>

[ Upstream commit 8ee09f597763acfd31c62a578ba88b792fc41b24 ]

When inode_lru_isolate() drops the page cache of an unused inode, it
has to unlock the list, so it returns LRU_RETRY and the walk restarts
at the head of the list, where the inode still is. If
invalidate_mapping_pages() could not empty the mapping, the restarted
walk strips the same inode again, and so on until nr_to_walk runs out.
Every walk of that list then ends on this inode, and nothing behind it
is reclaimed for as long as its cache stays.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode lru
traversing context") the walker pinned the inode with a reference, and
dropping it in iput_final() set I_REFERENCED, so the restarted walk
rotated the inode to the tail. Set I_REFERENCED again when the mapping
is still populated after the invalidation, in the same i_lock section
that clears I_LRU_ISOLATING. inode_unpin_lru_isolating() now expects
i_lock to be held, like inode_pin_lru_isolating().

On CONFIG_HIGHMEM kernels this can happen to any unused inode: a folio
is left behind if it is locked, under writeback, spliced into a pipe,
or still in another CPU's LRU-add batch after being read. Without
HIGHMEM it happens to DAX inodes whose only entry is at index 0, which
mapping_shrinkable() lets onto the LRU and invalidate_mapping_pages()
never removes.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
Link: https://patch.msgid.link/20261016102515.111285-1-nick@karaolidis.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: replaced inode_state_set(inode, I_REFERENCED) with inode->i_state |= I_REFERENCED ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 7942673f686fd..50f0a5d756bdc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -502,12 +502,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
 
 static void inode_unpin_lru_isolating(struct inode *inode)
 {
-	spin_lock(&inode->i_lock);
+	lockdep_assert_held(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_LRU_ISOLATING));
 	inode->i_state &= ~I_LRU_ISOLATING;
 	/* Called with inode->i_lock which ensures memory ordering. */
 	inode_wake_up_bit(inode, __I_LRU_ISOLATING);
-	spin_unlock(&inode->i_lock);
 }
 
 static void inode_wait_for_lru_isolating(struct inode *inode)
@@ -930,7 +929,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 				__count_vm_events(PGINODESTEAL, reap);
 			mm_account_reclaimed_pages(reap);
 		}
+
+		spin_lock(&inode->i_lock);
+		/* The walk restarts here: don't retry leftovers right away */
+		if (!mapping_empty(&inode->i_data))
+			inode->i_state |= I_REFERENCED;
 		inode_unpin_lru_isolating(inode);
+		spin_unlock(&inode->i_lock);
 		spin_lock(lru_lock);
 		return LRU_RETRY;
 	}
-- 
2.53.0



