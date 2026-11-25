Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624060;
	b=kAemGpWXfYRIyglEZ1dWefp3KkArBN0xV1f7qGQbD5M8Iw1ob/K2qWF8k2qUFUFqgn4J
	 Die/3fShM1Uyq3MWo9K/QyvfsNVB84cF2gz8NkJaTlupFcr8RpNAI9TgJ1sUkFaJAQqen
	 LZqFXXX+Uvf0Al9dRiYtyDm8G9IGV/XA2/42E6NlUvXzHQGyC16yTyCatkeFAsPtLyTFV
	 FPOFjFP/jp72OYz5InGlb3TuDpnNr7cswzslYkXOr+VlWshdGAeUuFT9wCELwXGBZ1CIZ
	 GHstPiNoeXiG0d+67nb4BAgklT/jW1S3tDwDiPDIOtDdOJMcG45mkUeMnb56qM7AK7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yx8bh+n5CSco4aUhhfTvQHTyhYNfBtnHR2ukueQLPU=;
	b=MYNrvFdZMi+c5vneRufvPKVPjBmyGQyPO2fMQPcEcjSm6PomWW9f4jZ8QIQxRtGpghTx
	 6lA76KKeNI1ef6uQZWHrrU84clAinlJBFqQ1aholYLcx0V8kje36qP6B4M/T3NjJzoRq8
	 ZYl8nR5vLUagN7IrEzuDE6WP60pKlkr0LEqO3jmJdjBuQq3crQ5j5HmNfwFG0fW5U3WYB
	 IT/ymAdJhtimjQifbRhcN1PfgoRbk+6sU4bX76Ve+nwRa53Wwff8FBv/flEQ04wme1KJD
	 k1oVPSiqE7Oztt6dGt8Om4h7L0uqbdq1Ax+mVsvBEnPFqCdoVhxQGGZDa2SIDX/4m7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFk5d4D0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C04D606A323;
	Wed, 25 Nov 2026 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFk5d4D0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC99F1F000C4;
	Wed, 25 Nov 2026 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624060;
	bh=6yx8bh+n5CSco4aUhhfTvQHTyhYNfBtnHR2ukueQLPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFk5d4D04rV3MjFpouhbY4OGaUV9MzgiPeyZaeuTSx6SfS5eiypFRrASW6c/XfE/i
	 Auxr/mBIe4ixlKheavlocznMOp11e70kdUYaHU0NHreMt+voXWVbmKgzOP7SWnDNMU
	 pb6XiZLsw4yK9d3MgfhtmUpezzktGg5UZO32ZfUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/816] btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
Date: Wed, 25 Nov 2026 15:26:59 +0100
Message-ID: <20261125143850.865105963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 9afe36341d8a3..fc01ae2dcb69d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3067,7 +3067,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	memalloc_nofs_restore(nofs_flag);
 
 	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
 
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
@@ -3080,6 +3079,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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



