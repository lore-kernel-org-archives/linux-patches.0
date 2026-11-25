Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617924;
	b=D47Z2vm4TBll6+L0HRyY3Q01KPKLg20YHmDtrBIhJYOzLj4mPmfK+45e9vJ+m/VjUl3d
	 EnJ5XdqNbJbRDMxYsdXqOH36bKSFuCMaZnM1L+nNIMEJ+8XlCHB6D7S5RL1+/ubFWKD92
	 zIsX1MJPnQeq4d2E0S4Zy4TUrHjSaAG/GAnLSAYJzeUPmBS36/vEtHJRchJMNLnJhpm2C
	 HSIODxcs4eqtHQHZI/6y0rE/uzEZ9EfX3s9at/fkilacTbrniIvoXUX8iWUv9CxwIcTdn
	 vRZnZVUbdDE5oTXMHi6G1nD2y+kZGEYXfLfVZm4hsLXh//s84hcU0IaVGiN8MMAq9nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u4ZOalLTudERd9ZwTUzdjiavIppCJHxJz/VBOU8NyXU=;
	b=UNbstEyEL4yjAgeoBoKHtAipo0/5Bct5Avbj7yrEn9jY4ePJ9jvV8LL84SeJk1i32Tpu
	 +7A6yCni1TlhhiV9/nV23yjZqmLKwWYwphPfyplKDmZojsFBRuWqQTUHsjNXWYLR0Z7Ef
	 w+C5ItBkSSjTIPrOS7zzuEPD/ARCF6Xp56PL3CYwyqRXj5/UPOH0y9hS5j/w2Q/EXT64v
	 fPU+Ivo/c32Ybf1BVDZJb3LRI3R52zWFe14RcpZ/qAPX6QTpH4yTLVF09sr4U0Wj/onfn
	 AjLtxeOCEDwZtSzrdCJ0JC8mhtdhBl0K+mj2pRZpvxDg9dmv8ZQEId+kZZEZB62VRsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S59EeYno;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23933606A32C;
	Wed, 25 Nov 2026 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S59EeYno
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A5A1F000CA;
	Wed, 25 Nov 2026 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617923;
	bh=u4ZOalLTudERd9ZwTUzdjiavIppCJHxJz/VBOU8NyXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S59EeYnovaj7wgRrrKZGVl4eCoS7rBjTK9b8xV+6R8e4X0j+s9u50OQ+jgNLRsQGh
	 kKUkujVa9IIUzwkLNeITjKe/IPUemkotJeWOWydN978JiBkwgRxqAoRI34wH4tZ19m
	 BmnmD0Yc0UPAxK3MjZvuJwEL+zq07TRCnIAl074A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0073/1005] btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
Date: Wed, 25 Nov 2026 15:23:31 +0100
Message-ID: <20261125143823.451167895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit bda65e5115fe66ee0d8cf4ade11807f9fca4f0e1 ]

When scrub finishes, it does a wakeup on the fs_info->scrub_pause_wait
wait queue and then sets dev->scrub_sctx to NULL. On the other hand the
scrub cancel code (btrfs_scrub_cancel_dev()) waits on that wait queue
for dev->scrub_sctx to be NULL. So this means if btrfs_scrub_cancel_dev()
is called right when scrub is finishing and sees the wakeup before the
NULL is assigned to dev->scrub_sctx by btrfs_scrub_dev(), it hangs.

Fix this by doing the wakeup in btrfs_scrub_dev() after setting
dev->scrub_sctx to NULL.

Fixes: a2de733c78fa ("btrfs: scrub")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ba2e27cc53519..91e441d0ff3cb 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3171,7 +3171,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	memalloc_nofs_restore(nofs_flag);
 
 	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
 
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
@@ -3184,6 +3183,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	dev->scrub_ctx = NULL;
 	mutex_unlock(&fs_info->scrub_lock);
 
+	/*
+	 * We have set dev->scrub_ctx to NULL, now do the wakeup as a concurrent
+	 * scrub cancel (btrfs_scrub_cancel_dev()) waits for dev->scrub_ctx to
+	 * be set to NULL.
+	 */
+	wake_up(&fs_info->scrub_pause_wait);
+
 	scrub_workers_put(fs_info);
 	scrub_put_ctx(sctx);
 
-- 
2.53.0



