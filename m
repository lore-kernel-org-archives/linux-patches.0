Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036580;
	b=LzLuyBQi0nu4E1nPogIsghhuWpM5ddA8XA+xFO7v+fPJvy4EyzBuRFDQUAKrdVSmRZAM
	 9vludFNciqLqM9rmsBV5iY4rQaBuVp3uvUfddUa63SCycgiMvtUK3IyKUasK2n6+0P+Oh
	 iisCUBCIA60P6qeuk2F+DYXvRlJqtPY0m3oMk2E9AbGwCbkBSGfO0aHjwR94UydMcb4DH
	 H9Kq0gekj2p3FCPpkQji2gh1Q+x6pseIMOSyBvj4O33oPuaqkOp1aR7G++7n+EGkPffXY
	 7GROjUrGPSsTHR1xVUornyqtlG89ii9iAgkKLp2go5Qrpl30Zu86nzmZF9ELT2YzdTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MvWbJHz/cGW8yfmWw+/TUf2FDY9FkREfu8NRRXlIiaI=;
	b=wX6oabtbETbmJ+3+eYoqEu+pveveAQHhRSA00ayep0oNb1Ddfa33r4BpJz1g6KAka9nu
	 OsYs0wzdDGV63PnZpFIXJ50epjA1/Uy0r5vKEnwEIQFuu/4GANjOWTuLCvwQt/9e6NbmC
	 faKrUGOcuIbWyk7Pq7JDcH+dKqkBrT7N7wkKstqCQLC3+qU+uRNCbPFUnVwnyaKd+iJO8
	 vfxkeOWRU1hyWHaLFR/TxkaZeZm3hEweaT/hclXSQsnoVQ2CJ9Fbi/I5XJXAp60xAR4Lc
	 +ijGm39mTL6DpO/hjJqFxuIKYG8Fg14XGw1RLuIGBsC94ZWMbSAuhwWtVCAHxCIFHwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upn9BVXG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC5606A339;
	Wed, 18 Nov 2026 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upn9BVXG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D241F000C4;
	Wed, 18 Nov 2026 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036579;
	bh=MvWbJHz/cGW8yfmWw+/TUf2FDY9FkREfu8NRRXlIiaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upn9BVXGZgKg3XJz5KKzurrtyy0GNQuyqdNBZFolTAB3y7gLaYOH0rnl69MzClF4o
	 Ogemuiwp3x9zPsH6LwqmtbfBOWOhup/4z819cfpbjZ5SL7+lvCP/S41zr87+VBnMSV
	 F71YXVnak+QG0+bqo2iBqSP9hfZ76vqUwPcJR1Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1067/3318] btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()
Date: Wed, 18 Nov 2026 15:28:09 +0100
Message-ID: <20261118150351.974230523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e371bcd14e8cf..626f6aa5ef2f3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8206,6 +8206,7 @@ static int relocating_repair_kthread(void *data)
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
+	struct task_struct *task;
 
 	if (!btrfs_is_zoned(fs_info))
 		return false;
@@ -8223,8 +8224,9 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 		return true;
 	}
 
-	kthread_run(relocating_repair_kthread, cache,
-		    "btrfs-relocating-repair");
+	task = kthread_run(relocating_repair_kthread, cache, "btrfs-relocating-repair");
+	if (IS_ERR(task))
+		btrfs_put_block_group(cache);
 
 	return true;
 }
-- 
2.53.0



