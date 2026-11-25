Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621003;
	b=ONA8N1DlcGeaimBXqQqQHA8Cq/l2BLUBWWCO2P+SEoLfc30KOFhxKgaIfz4179DBEFFv
	 p02KjH5W2DawyfFmbPkhoVS3Khf+kSfgeh3beYoB7peO1eUmVa/d74JzJpvxyfDRYDCde
	 JZesLhuJpC9wLjWtIBHyBSvDJQEQiLbIIga24ju74eP2ILclP0Rom0CjqlW/4wYHrrOrQ
	 xfdCtcfwUYhh/ZKOHYAN21HXH5OnVtDRb0UVknePKkGqYfsy3if3f6H3iJuJvXGI/L/lv
	 BYP/xTWdKk50bHUDen14ZPozWZvyL9/MSnZJ6j7m1OxbFoyedDEVmVpwJ/PI+vJPFGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvu0Sv10bZQEPSFJwYjt5+O18Mxc+to6v/h6KoigtVE=;
	b=FQISu0m6gcTMGgPtvqo4CMv349fx+ivFrFbYKperMInGONHN/7AmoAfwBJ9Bb8/6DY8Y
	 CA1Qu8NmWNEhOCU5t9MYn7QiADgyqwrpNcP/ysCuY8ijy0QxbPCCEb0OnNSo9J1XUiF+X
	 v2shQfWPj0YP7CP0MSxNyCrHoyTtkK81ERfmixFqu5Vo7uIKU/sxAyjGF6EnPIgvvXJIN
	 hRu6lC78mO+t//tinsSBCdZeSKl5Ac7DuWUd7OuGb4QD1utbfdfz+RNIR7PyL8FvbFuJM
	 PtHizwvI9/wpHENlsz9p19H/QdBjgz8p9MkQxos22xGjNHdG0natyuduSfZLvD4yMGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QlBftai1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C69607DE78;
	Wed, 25 Nov 2026 15:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QlBftai1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033EE1F000C6;
	Wed, 25 Nov 2026 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621002;
	bh=kvu0Sv10bZQEPSFJwYjt5+O18Mxc+to6v/h6KoigtVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlBftai1a86hFYIJdME76G+VjuBnuHdPhWkIS1n3iuGc8EICojW2WsMRdBd2XWRrQ
	 IJ7DZPpfgeaFAHw/VSs4XnOKjAbv9TV/yQMUzSYoc1IChZcZLDq9n6mY50rS2QHEld
	 UuQJoWB4o1l8XyoTCYnkbo+xHmXI6AJyIXobU++M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/990] btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
Date: Wed, 25 Nov 2026 15:24:17 +0100
Message-ID: <20261125143824.199582568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index fdf37653907c7..a924eeb7a6618 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3174,7 +3174,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	memalloc_nofs_restore(nofs_flag);
 
 	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
 
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
@@ -3187,6 +3186,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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



