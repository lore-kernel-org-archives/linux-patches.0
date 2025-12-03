Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA573370F2;
	Wed,  3 Dec 2025 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777393; cv=none; b=anPHsgWwks/es4Adgug2+BMdeDieDBXsZuqsMR5jaV+pYEqL/1RtayTVqAJGyl3aJYl3FGiXVA+cyz57YG1rkJcKz6D5nuULngwvtS7mhyXymPO2Nqx6/lxuRK3CyMpxhRjYMf/xRt9y7iDM34lmCu/KH0UUByW4+GUfwzq7kKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777393; c=relaxed/simple;
	bh=Hlg6uobXwlRJ5HzA2Ohk08pVpNx7CURTLJsPXcWFEXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAVk2C/Yd1RWUD32puDTGdWjwuAlGf/8RiiAP88p+6v48zQjTitH1zVNbn2bMUSeJT9MO0OTzCZmKLl5YxMibWVNhPz1JBYFTUx+3AbJChH3rtSPnaRRwriQuBe8Hd5O73yTwj/IoEGq4UrCWqFdia5sfRgvz8SHlbJeX+QToAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2W7JkF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2W7JkF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C3EC4CEF5;
	Wed,  3 Dec 2025 15:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777392;
	bh=Hlg6uobXwlRJ5HzA2Ohk08pVpNx7CURTLJsPXcWFEXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2W7JkF2R5B97UpeZsvYhF3azk+tyHBhl3IiAcPnke0cyzGoAXkS9HaiDQhgcHc6f
	 ak87Fbm+CcChUlCik5zMjDp4YN8ijNR/OnD111b7Z6hWc+7wL4+07SUobDf4UEikpR
	 +8kRQnd/KfWAjKLLi1kf3osbdkZSZpo7fcb1Z0Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/392] btrfs: scrub: replace max_t()/min_t() with clamp() in scrub_throttle_dev_io()
Date: Wed,  3 Dec 2025 16:22:33 +0100
Message-ID: <20251203152414.217056429@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit a7f3dfb8293c4cee99743132d69863a92e8f4875 ]

Replace max_t() followed by min_t() with a single clamp().

As was pointed by David Laight in
https://lore.kernel.org/linux-btrfs/20250906122458.75dfc8f0@pumpkin/
the calculation may overflow u32 when the input value is too large, so
clamp_t() is not used.  In practice the expected values are in range of
megabytes to gigabytes (throughput limit) so the bug would not happen.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: David Sterba <dsterba@suse.com>
[ Use clamp() and add explanation. ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6ffd34d39e992..aac4ee5880952 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2017,8 +2017,7 @@ static void scrub_throttle(struct scrub_ctx *sctx)
 	 * Slice is divided into intervals when the IO is submitted, adjust by
 	 * bwlimit and maximum of 64 intervals.
 	 */
-	div = max_t(u32, 1, (u32)(bwlimit / (16 * 1024 * 1024)));
-	div = min_t(u32, 64, div);
+	div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
 
 	/* Start new epoch, set deadline */
 	now = ktime_get();
-- 
2.51.0



