Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779616FE1A;
	Mon,  8 Apr 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583218; cv=none; b=IH36FuVemeezUD/bCY025f09F0R/HHi9+/pxNv8V7G33cVelLBGmKyk3Y3ziPBqXWkXPzr4Q32lt5cwzayR7NuA4pFKr5LsvRp/YsgY5jlobFESHcrzoh4HqT3IbQWaQ31UWRMOImVFBFNcTwatmrleihpzKHRHZ8DOcqssikM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583218; c=relaxed/simple;
	bh=qAoxYwKr4GsEx3di/arZ8PDf743F4KIYJnRVKv6Ot+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdJbP9Uh02+bjlwF3a06gfmJi3ubHtTEFXFRjWRV/D3qND6gD7dZZL+xanB6mqDj7nt6k0t/sXJOgoufkOfSM4l3W/xd9PGNx24wFxKnXC1FvLo60EFimde0W8/nPrLttCW5+XI9B4ZNPaqCUGrD3OjdknhSs7Con0PGcIXEd5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8+ZLFZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8+ZLFZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF69AC433F1;
	Mon,  8 Apr 2024 13:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583218;
	bh=qAoxYwKr4GsEx3di/arZ8PDf743F4KIYJnRVKv6Ot+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8+ZLFZTkwOsKtWZbY1Egh5p6w8nj4eZ83KW14vQx1tkdlB4l6vbQCs9Iwv4f6AHc
	 UV4IBTiqAG/LVthYZDC5lWVCKX+e3IU+FqXLwKIefHi3DNssh799ayhtxfA87NEg/c
	 hOByYzpr+0A+vIt1o9FKZxuByVzoSJtBs2hVdMww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 153/273] regmap: maple: Fix cache corruption in regcache_maple_drop()
Date: Mon,  8 Apr 2024 14:57:08 +0200
Message-ID: <20240408125314.031276564@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 00bb549d7d63a21532e76e4a334d7807a54d9f31 ]

When keeping the upper end of a cache block entry, the entry[] array
must be indexed by the offset from the base register of the block,
i.e. max - mas.index.

The code was indexing entry[] by only the register address, leading
to an out-of-bounds access that copied some part of the kernel
memory over the cache contents.

This bug was not detected by the regmap KUnit test because it only
tests with a block of registers starting at 0, so mas.index == 0.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f033c26de5a5 ("regmap: Add maple tree based register cache")
Link: https://msgid.link/r/20240327114406.976986-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 41edd6a430eb4..c1776127a5724 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -145,7 +145,7 @@ static int regcache_maple_drop(struct regmap *map, unsigned int min,
 			upper_index = max + 1;
 			upper_last = mas.last;
 
-			upper = kmemdup(&entry[max + 1],
+			upper = kmemdup(&entry[max - mas.index + 1],
 					((mas.last - max) *
 					 sizeof(unsigned long)),
 					map->alloc_flags);
-- 
2.43.0



