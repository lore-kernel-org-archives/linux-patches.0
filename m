Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047106;
	b=g6Wq/tLKtUUQ9G+nERx1THISVMydVTxQifGWVcc8LLCrD3LTpqYvkT5N9ZosgeOZU/iv
	 H7KJmPVl/93KRtg2lpBxMGgbbx+P8+fqRP2iu6biT+0CWL7fRmfCMxk3WHo2DgWxX+0rt
	 axveIa6mzGwAQhqQcSsolny5IKfuQbd25KOR7GppL4lDmFihRYYf5C2CFLb6CCL7ozaJD
	 qjQGt+7q+1lDS+J7Fefl+3rMJE4dMl8itexbnaMHyJYkTToa6FjPzeJvq2kzSjsX9dEWA
	 F9AuWuXYzsuMx4bESGLsmBz0Xg8ajTrk2VNhGjxymZZzFZRTYD5ldifECwXs9xs0FfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3GfxNDshZYQ337hr3iX4ZVBwaSkTXe7e8Afuoi8J8xE=;
	b=l5sua6rzp7qAsKTopVznlWPDAKz8IyRVKtcRcsNPPzBwoPt6FEmkzj+YQVixc+3Mm6xq
	 uPDESWFGouX4xQvM2JZ8naUtReGM80wnjFUQEOnrMiAs5zmhQFIzDkureZoFuMU3zmoxH
	 FEK7Zx/4S0Bw3ENE8UnwZ++DEZ++7UUbtNrl+d8P1/uwRaH0MlgfOvOjpmAHK1pUY9amd
	 PENfQEQY0TUugxc4akWcVfb9J0KibaGE6+a7hYrQ477jZwx8lZfQvq9bWeoWSrQbUERAm
	 iel22YO1+QbwJQ3SYcrtMqtA5fuy9O0FDIvjoXQdLIlRhmRrKSL+5vIb5SYItPPfZtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiONPODA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9648C606A31C;
	Thu, 19 Nov 2026 00:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiONPODA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E691E1F000C4;
	Thu, 19 Nov 2026 00:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047106;
	bh=3GfxNDshZYQ337hr3iX4ZVBwaSkTXe7e8Afuoi8J8xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiONPODAj2Wy5N7igurxEfFEHgbsH9FL9P7l7iKOZUfQRO7T6QO7CYdTEopFWZGff
	 mxi75LIXYPPZ4BkV8iDUrgd8aKk5FtcXFsDJJ1DDrLDXF630IQpn4fRwIrSTPLSps0
	 seRKWls7kWvX+96yTW1EPdQ1jcGS99+ZQZ08ip7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1521/2857] fs: rotate inodes whose page cache could not be dropped
Date: Wed, 18 Nov 2026 15:42:35 +0100
Message-ID: <20261118150256.092530438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced inode_state_set() with direct inode->i_state bit manipulation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 99e980ddbdceb..8e430ccb23c6e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -496,12 +496,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
 
 static void inode_unpin_lru_isolating(struct inode *inode)
 {
-	spin_lock(&inode->i_lock);
+	lockdep_assert_held(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_LRU_ISOLATING));
 	inode->i_state &= ~I_LRU_ISOLATING;
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_LRU_ISOLATING);
-	spin_unlock(&inode->i_lock);
 }
 
 static void inode_wait_for_lru_isolating(struct inode *inode)
@@ -909,7 +908,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 			if (current->reclaim_state)
 				current->reclaim_state->reclaimed_slab += reap;
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



