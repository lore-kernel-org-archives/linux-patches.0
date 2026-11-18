Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045442;
	b=1HSOpn2jk4kawZi2LyeRBB/2kpqUlcAg8oL2MgYrlOwqn0O8iBBTDhoZ+OBZG7BZ1eAF
	 mmvZOD09W+RDc4FlpieUQskdxCFh4GYDA+vi33qN1dFgbOmIf8Sr/9QcUaLoro/Ud1Knz
	 QTRK/rw736Feibc06FMInI07QV1779wikMwwU5IqIxQjqA2db2/cuznvarzPQVkxYMJ8M
	 7o407cp4nMtZmO1U1LaKt2YtUg39fZ6ipgX2CeuIqVyIsqw75QNyKl4J7ly0Ww1l07kPI
	 +EJDFXNDo4Akeiz/0U02LXFm4S+zChOHEdDf7q+kKOxEuGNNjMJq5Vun5E54amiIm0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3pIuaPLGmIKZHkPbZ+BRqYJ9M+ZPxgNXEjvE1+2REBI=;
	b=E1OeILxnTVOfMJFie7ZUUU7IdtfzADkg97ASx85SkiwXPTPY5RudHp0etFQzWEcyIe1e
	 R8WEqYquhj98kGo4G46syNk/gY1BKDJJCfmg6geYjnI9BPClbw8ZqF1bSoqjhqKStNR/b
	 Dn8KNs/iTvIbdPx24TELouNGMpSe6Zi5971PrDk1rhBZ5u4/5PpkTJ/M0It3rgjDI6DjW
	 G64q6FB5//MftTPS4TvfhQgeQunFD6cIy9qWpNg3tNir1lUmDxL7dP3chUUyoUB10KuK6
	 RZcHtrUieaa8yoCFxIBUvUpekkjHR3HpYNgpm/LUCKTwHJxAaqrX0sj7/4EOEDGPXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y04dHblz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A05606A31C;
	Wed, 18 Nov 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y04dHblz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C021F000C9;
	Wed, 18 Nov 2026 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045442;
	bh=3pIuaPLGmIKZHkPbZ+BRqYJ9M+ZPxgNXEjvE1+2REBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y04dHblzyQ4iHOqnj6tB2GoJtwAejSAnS2Crqiip9Qln9YFyoSG7dFG82MP4KDoRT
	 FULwVGjL3kz2TxK3U4ZRDO2RL8+BNIjOLDplo+GPSUtniyr61f5BRHDg+ln/n8OfyR
	 rCo7pDzTlFHu6NF60VTnSz0miYLuMZGJXzPpca8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0924/2857] btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()
Date: Wed, 18 Nov 2026 15:32:38 +0100
Message-ID: <20261118150234.855621583@linuxfoundation.org>
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
index a2f3b57a070aa..04283d3497e5a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8654,6 +8654,7 @@ static int relocating_repair_kthread(void *data)
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
 {
 	struct btrfs_block_group *cache;
+	struct task_struct *task;
 
 	if (!btrfs_is_zoned(fs_info))
 		return false;
@@ -8671,8 +8672,9 @@ bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical)
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



