Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063275;
	b=dB9sDLpUZDD8+GAmoyhfZe1s+FtaoBS82tKCK+vExc/FN6E8ktKYftQHwwbpDbcJwkBz
	 2nyjZ5VjxGC9606rNl3BVwrDCubDpDoSQf8HsuBFyExhTVE99VCsLiDZ8pXphW8kWP6wV
	 cNaXCP5yDUwVOQ5wnM1krY6+7TK2GNGD7PGo2qMcWHyvqop7RGxROG4GIChCVPadDRe6U
	 4pXTLdZhbrz1ezKzZ1iWugs0cumToeymWBAWfnv84g6D6XBXmVPq+ZSHuJeiVNNmAcgWT
	 gZSn82W8EVv52CFNDfID9sVvTGjnM+pDy6xLtKAKu3kitH4SyZW/79RrH50pS6Op3KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8m+bmVCh46wLxERWJptDk+wOLDCZy9gc+7Y5XieFayQ=;
	b=v/mAdr3HDCXR0q2gqQItoB/1tgnu9fP9RuXHryG3QopLrrqjNUvPHY+TUGQxxq2pPb6k
	 kMn372IpLtVABJResBYDfr3LMy7DdzEIj5Ix+O4Uw+YJ85MwnUmXb3IVMQN6uwdvxLWTT
	 t4WcR8P8/3Bq2JkhUuHMG3e1xUjUwMb5bsawnhAyZY69RMS/8XOj9TvP67N0CHe3v0IFr
	 1a6pPzPdMBbIq3LFWfVpxuL04N56VwQ+3oDusysQ9OjUf4Tm0hU93VCTO9oyvjtCZAQi2
	 IdsWrYFDKGZR3DcKIYTcGtipD2ZJ9xWlczjdri9lkB2xPJrvxzV8uamL06tnqiVLVeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKX+Rv9q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49333606A326;
	Sat,  7 Nov 2026 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKX+Rv9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC0D1F0089F;
	Sat,  7 Nov 2026 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063275;
	bh=8m+bmVCh46wLxERWJptDk+wOLDCZy9gc+7Y5XieFayQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKX+Rv9qxPyOIDok38Lee9sKhOLAEbH6C2uNSMaUyPbN4DLGMHix74AardK5fRb5M
	 SmkZTSjqd4jaTGlE2OwlNLcu2lb6HDnCNI5H7VHdsObO8y8pEe2IlhB8KdxorB/Tl8
	 4mRWFQWbp1tfV8xqxEpKn9NlIUltiFCY2iYYTkzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 471/869] btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()
Date: Sat,  7 Nov 2026 08:52:33 -0500
Message-ID: <20261107134909.599823639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 200b4e4a07994..a07b5a4d6e4df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8302,6 +8302,7 @@ static int relocating_repair_kthread(void *data)
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
+	struct task_struct *task;
 
 	if (!btrfs_is_zoned(fs_info))
 		return false;
@@ -8319,8 +8320,9 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
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



