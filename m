Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052593;
	b=s1MBVQFlwBJ9kWEYYmBNkE4aFL4HoUjJCChQZyTRskhZY31XdNe4kRGZ9mLtBWVKjopY
	 lhUbKKscLOO5QigkS+rC9uxp5eOcvzHXN1sZh48Vg29Kv9UvBkSmYrIS3L1jmE4yxHjiP
	 igAxqbcstJylYSmfv0engDqHHwsu2OfoMh9zpK1YVRJ13fsCpnleIBYyqv/ID8DKbS4ir
	 Rw/kMoJUU1OwjyTgAcVlSHr1FpzQ8hY+2oWim1NJzRBAhqfpdTyXh01NyBxACK1PJg1hf
	 /r26BCUBO9YELSMUQtyFiW1SZk9Oq370hnOmw/Gno5kbdxtF3v/8pf+ucEnzAq/2bMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUYimyjW6eSf0Y9oos9CR+xE0+g1ZZk9A8VrCs/CdnU=;
	b=SdlQfEIpQbsxg4MakRY/deL5r2bcfBYuIT9a2OHFfed+x9dGJBmMYiCBtIXt6yiHutVu
	 2RMPe5Q8F03ENMX9QHNj+iOiQ+M8OXAzmx9yyXRnuE/DTvzoC5vUR3C4S2XjcAhzUjrSw
	 vZPIaBgF542vyQnwGpJAIvjkcx33JIL6sg1nADL5L/w+4q6uZyitBCki9S6UOx8sUl13G
	 bsPX8w92gHKiLAKrUAjXJcmWjCDhMQaTwZeP9EetTgLgI+KaY4pP+OvYZnPPcDf2Dli3s
	 SJoQN7FH2CfNPr16avaIfDmakUVLAStgQWZp7XogoE54h2APIDm90sPzfkvTmPD1anw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je0DcOqI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4AD606A31C;
	Thu, 19 Nov 2026 01:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je0DcOqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7161F000C4;
	Thu, 19 Nov 2026 01:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052593;
	bh=bUYimyjW6eSf0Y9oos9CR+xE0+g1ZZk9A8VrCs/CdnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Je0DcOqItkci/YCqAVTkJOttuOTxb5HqGRXdH20enB1VDRStwxO7V9XkJKplFLnrI
	 Vl7Bsxnd/8R+FEiDZWHyMikjv4CiSgk6dL9NqS5TyqF0fUbBPUQs1zBLN8me57AoJb
	 wgOV2S5r2A0XYEzxC48KvHPfjoQuLgDyKCMxcRtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0617/2214] btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()
Date: Wed, 18 Nov 2026 15:38:13 +0100
Message-ID: <20261118150036.071081056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 886f1aa6e6b30a02901aa7f140149d466e10a873 ]

btrfs_repair_one_zone() hands the block group reference taken by
btrfs_lookup_block_group() over to relocating_repair_kthread(), which
drops it.  However the return value of kthread_run() is not checked, so
when the kernel thread fails to spawn, nothing executes the put and the
block group reference is leaked.

Check kthread_run() and drop the reference if the thread failed to
start.

Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
CC: stable@vger.kernel.org
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fbf4e54ef9c57..681a4500f834f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8485,6 +8485,7 @@ static int relocating_repair_kthread(void *data)
 int btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
+	struct task_struct *task;
 
 	/* Do not attempt to repair in degraded state */
 	if (btrfs_test_opt(fs_info, DEGRADED))
@@ -8503,8 +8504,9 @@ int btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 	cache->relocating_repair = 1;
 	spin_unlock(&cache->lock);
 
-	kthread_run(relocating_repair_kthread, cache,
-		    "btrfs-relocating-repair");
+	task = kthread_run(relocating_repair_kthread, cache, "btrfs-relocating-repair");
+	if (IS_ERR(task))
+		btrfs_put_block_group(cache);
 
 	return 0;
 }
-- 
2.53.0



