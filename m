Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591038;
	b=s+fUTs43NVt5ofH3/rpjWUQFPYYKZbi9U4cnr65742gtp/VUnwf5TXnLDadN8JriImAX
	 5uCXxf4aYen5fH2cZNz02CAii1U6eILtBzNBmhlfpgbOJ1jUn3uvE1V+Zonq2YlpHir8w
	 lLK/P/vCOIs3pW30Po1n8KKCHrxOswmFVFmI9hfByPHzDJ7vConL8+oKX5d3ZII3DbFhL
	 vVGsomxQG0cikzH1r2akNva1wlF+gXJknVPN3oFUQoRq7L0r4MhGlnsWo+/hwLKxuictS
	 Gaajub++jlc1TVS+jOAWCaNwo8vHY+ROinnyZ2q3uf6iYZDC6uGcWGXABi+pp+IxVnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TEjeL8V0wMdnGvOlsdRIhzXU76OmmRbEGAJJ+jMRIgM=;
	b=5i3zc3VajAQqzzaZLrCodEUHgqQQSpbo+0Yuxo6hCPWxaWaeKBbcJx2oGL6uglDsOC5o
	 KVvIHAn257OYT5726MC2dohiGK3vIyT26M6ja+gsSFYI6xyNLDg3eK8ZvHulMWtROAEm9
	 vr1ZZoNOssSIWRP7q45yssk1a8RPCvp06tZnRpHbi2rt0IORcqJgd+LPqcvkZjqgBO8BQ
	 ZLCVzDBC091KvlmeZwvIDpXHvfB4wWQrL85PaK2cz5V0XkIEguou4u7gczK6/Ohg6icXN
	 a+68cwm75h69x2um+RsK3QMcxAuvhzE+BOOfThsaA9gg/OHCVW1TdYrwom6DEt4k6kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tA3loKNW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B26606A8A6;
	Fri, 13 Nov 2026 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tA3loKNW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9391F000C6;
	Fri, 13 Nov 2026 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591038;
	bh=TEjeL8V0wMdnGvOlsdRIhzXU76OmmRbEGAJJ+jMRIgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tA3loKNW8H35vs1dMOq3fUNSTQkseLoeWAAJSsrJagx9XerYlZAh3/RO9nkVOrD/8
	 6wg8AAai8e5lirRt2CmmPpKlIDLB8cv9hXjLr58a89O9xTvLhONONdqpMw9lIsli8U
	 HDRSWFFtLA7fksHtwkRj8fuT8XmhyH3rENYbKspA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/670] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Fri, 13 Nov 2026 10:46:08 -0500
Message-ID: <20261113153818.868330266@linuxfoundation.org>
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

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 4172be965c2ce887ebfb1117c634a68555be8c11 ]

btrfs_sysfs_add_block_group_type() sets up a NOFS context with
memalloc_nofs_save() because kobject_add() performs GFP_KERNEL
allocations deep in its call chain, and the function may be called
while holding a transaction handle or a lock required for a
transaction commit, where reclaim could deadlock.

Every other return path of this function calls memalloc_nofs_restore()
except the early return taken when another thread has already created
the kobject for the same raid index (this can happen when restriping).
Taking that path leaves PF_MEMALLOC_NOFS set on the calling task, so
all subsequent memory allocations performed by that task remain
restricted to the NOFS scope, which may lead to unexpected allocation
failures or deadlocks later on.

Restore the NOFS context before returning from that path.

Fixes: 49ea112da0e6 ("btrfs: do not create raid sysfs entries under any locks")
CC: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 8f195e769ecf0..70f5fd918ccef 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1750,6 +1750,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



