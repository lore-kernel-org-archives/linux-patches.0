Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704175;
	b=rkR6JXmmPTHP+hFXY23fAT5Dd8suc90ssYiIOLiox2zKcbpezmDlu9KQWa7xl404CwwW
	 +d0F8CFRxN+h1XhY21e3oW8KqSsht+WIMdG9ayh/MqnP4vqYqrZsxdI8gmfy4xJCjR0Ez
	 Mbw1NRk2qaPeqsDWcI+2HKjcaU5rSx6cGOVXdhs04EnoKAvpaiOiagvjKJc40+bzzmv+g
	 UQJhKVmRQexA98RPKBRMAbQmcVnEIimglhIoKU5iRbuddVDg3A5ASqAGh6yuiDddV6Y8F
	 XyXESx6GxBlVn38Tdam2D/2kirTpMzq81igJkdh5bM8Kq22EMX8tzOCKdujFvMGSqFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+BPYYzDbjoTFLOQXEiqfov4tGn3w19e6BwUwM8XtBgw=;
	b=t+W4OwfmbQ+ErEKIXqj0+YZmYl7N39iTa0LoDg8DMBnfFL5V9kV1BDeHDl5rJkAIOYDG
	 TPh9nAsJxIDcUEh7Msau5qFYTkYn4r0Ri/Y4veN3Rsgw/GgJQRkahVWWpSYxMOyNqZRHG
	 hGFDB2pC4TPTFuiDGDObYNykXHUmKddCyW6VVWs+w/vtFjQFsQmWuKKFO1hBfsnvliii5
	 pVsmWPzPMlSz6kIRIUE/TzTvVq8kA5gqLZ6uX8fahZbgTZxNiXjrrbKGXlDOCahsywwJW
	 jaS3vVJitjndOWt1XYOLXd/WI46P15RazmPKcl+/wc3h8b3vcihNK4mITMwwfsnpO/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muxqIqYf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CDE606A32A;
	Thu, 26 Nov 2026 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muxqIqYf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB851F00A03;
	Thu, 26 Nov 2026 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704175;
	bh=+BPYYzDbjoTFLOQXEiqfov4tGn3w19e6BwUwM8XtBgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muxqIqYf3g6f/JEGZ3XjJHgobxg6rA+X2Lf6TLuujTjT1SUmfPBkt02sDzq+knEbv
	 M6UK9Hws/hpJrW/tXCHvIW8GNk1jia1Cua8u1GzUfzgazD8LP/XzX0jcoCu10ng37D
	 iMNKavKpCAYzt/c6hBsqzkwE0+fsrRk633HzHqPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/265] btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
Date: Thu, 26 Nov 2026 15:36:01 +0100
Message-ID: <20261126143607.268406949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6dce695b8aedd..6383102413d4f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3971,7 +3971,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->workers_pending) == 0);
 
@@ -3986,6 +3985,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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



