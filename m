Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062295;
	b=M7iGnLPf6PjG/c/VSF5zAzQ6wKlMOu1QzSpooXBHlIkkJu8iOM8fshY4crWzr+3GhX31
	 46pJQerX+bAUHlV54Trc7B+/KG+jXqrlNHb37dTRpuVHndf4/YtgAl080JJ9T+qSwFhkZ
	 rlQpDvKiBP5uw+AYn+wHmnw2t6Z8EOBASa4VVdItSyeB9F8oIY8ZHt/y6wn6DL5Toynm8
	 t4w2Vfv+swi5Cc1ATzYsXx4tDCUEWtTRL+RmoWNDfTNNNmrYIJVAr+fIDEkREbCIoErUF
	 VipmJR935Mh20EAtBXvPW7+2eIKr9MrUrJA1G0W+0WizH/Vk6aqO6Cx80cG81TrNw9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LVb1d+fFA21YOvZ4JkM4AGr7NhSHteJc2oNh8pS69Hw=;
	b=BvEt0PQ08/p/b1xK6WvXM9ttp+YXPfC45YYiiLcfQGvOfvM096YW8uADvCNEuJjMV6cX
	 eQim+CRqhbAs+7u2h/PuGwlbb7KddzWu4fsUt4doVbAuncSm153A5U8d98p7T6OKVVxSM
	 q1VqjiSK6aa9Se1IhLycP3LSJx1TUtqoeO4GjQEdeyRmdU6pXSXFT1mL5zF8wWeLXoNi0
	 FJM1RoQjqZglhV6KCItoTY1c47veT7tkiXFDl6d6Vq4eiF6klO2cHADxZFxOoh13gbo7w
	 3CNWN/jIMRQQOudpvxcte7TSAnOUgHjJJYvJ6REpIaNgM4sikU8GKLgBdja+QLcJ52g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJBZDtGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24630606D816;
	Sat,  7 Nov 2026 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJBZDtGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C439F1F0089F;
	Sat,  7 Nov 2026 14:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062295;
	bh=LVb1d+fFA21YOvZ4JkM4AGr7NhSHteJc2oNh8pS69Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJBZDtGotar2POBHPli0c76Iav4MjoJ7fLf4SN8xiG5rORxCJIyeFlUx11dnJsBQx
	 fDjwlCXB4bkOcTKgpJmqI/si6vDYRxR3trxR6/owveXvrm1yhpkGC7ninB7W83pKHW
	 UhSqhig/ceFrew19pct3PgUDRXTKExu+A7ts1YFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1231/1536] btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()
Date: Sat,  7 Nov 2026 08:54:07 -0500
Message-ID: <20261107135032.333396202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 6d9df90de9387..b6ed1190a63d7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8295,6 +8295,7 @@ static int relocating_repair_kthread(void *data)
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
+	struct task_struct *task;
 
 	if (!btrfs_is_zoned(fs_info))
 		return false;
@@ -8312,8 +8313,9 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
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



