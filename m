Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB993570C5;
	Wed,  3 Dec 2025 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778701; cv=none; b=pU7D/+oRxa9broEvcSXAY4hW8wdgKkyuZWFxDR6A9VMU8fqu48WlEeCXfIlU/mcnGdG0umPfbxralzu3pUe/aSQDE28FOdQghEp0FvLRsoZ2NFb7ujkgRrICF/4Qh70YU+gZrP4p9/KWmUy8qusAk/SG+B3NAgE1k7eFHpGAjP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778701; c=relaxed/simple;
	bh=WT8VyvEt42mXj7EUsEfujaC9AJiBQtUWNQSFKBl2BAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpeOp78BIlkSZi7G42Yxlgnr4P9vm1GJSDryoHFu4DNXE8gxI0yy/49h1Ypy4OcLG8nMn7uobySkmf+HZlyTcg0XBguatKGhmMoJHaB6xvDOvA4PFFIzZTZyoA/W/1s66hKENV7mCUDoMfYL9Db5mFrjgNWgqxKx/u2wJEE60mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqkfxVR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqkfxVR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC69C4CEF5;
	Wed,  3 Dec 2025 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778701;
	bh=WT8VyvEt42mXj7EUsEfujaC9AJiBQtUWNQSFKBl2BAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqkfxVR4uQIMg/cyHPv8dCyaqiuTAxTPpYFfamYbxOh/o0fk/hzRsoMfFsX3wPEZf
	 KtCgRKN2pVGxSl+TPrHN3d6RhH3nJqJreMovf5cE5iB/CuWShBAGacLViEfM/zl9/Y
	 vcvTQE7U4jn9NcMpSmYOdopqAyoQVKEf0A1vrVN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/568] btrfs: scrub: replace max_t()/min_t() with clamp() in scrub_throttle_dev_io()
Date: Wed,  3 Dec 2025 16:20:08 +0100
Message-ID: <20251203152440.890094742@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f48895a9b165e..ce8a9c226534f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2191,8 +2191,7 @@ static void scrub_throttle(struct scrub_ctx *sctx)
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



