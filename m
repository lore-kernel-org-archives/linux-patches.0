Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17F86347;
	Tue, 27 May 2025 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365890; cv=none; b=lNRYYP6TwhDCjjgs36W+1FvOfSXDTnEdkgc5jG5HHpnqvHeTWakQi8S7TLyXESiM4/GBnQ80IIzAX7d1q/jDLHGyfVaSF2k1edPuUIxV/zbk+jFPSkHpDUWu6OjlT1dEEQCNGskhXK+jB6q7y3NUmTsidtiqSyLPUs/be6tYLEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365890; c=relaxed/simple;
	bh=q7Rbhf+0enk60tsxpHpG8nQEJgeKF9mnbApCuFneW2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQvCYkGIXjetmhl4ENkqEQ0gpsqfcZDn8REMU5ZIINOcZMhD7gFscO9CNF1+0mv0GFVmkOSCQyffSEhGTCdLhWXesCsGgEP7KTbLCUYGRD393+oAbDM6D2FQlbXVnwaMbPsyz1bsUwrQnSPa4MOHNKwtENBVe9KhC/tGIENN1gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgIhW9Sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgIhW9Sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0929EC4CEE9;
	Tue, 27 May 2025 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365890;
	bh=q7Rbhf+0enk60tsxpHpG8nQEJgeKF9mnbApCuFneW2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgIhW9SmB+ycqfjmY3Ol5FHNZVcMh4fmiWYzHI3DEse+aT3snA9zG3yHaje8MfJXM
	 S3mIu593TJiHzbuBHqfyLUf9kz+9Xjgs4BfhT/Ha4xo2LyZUeyWys+BZ8RHUWdxgI6
	 S3pQ9KBl4FnTZJmklzjKITIkBePu2Gj59Nl0ZXEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kees Cook <kees@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 523/626] btrfs: compression: adjust cb->compressed_folios allocation type
Date: Tue, 27 May 2025 18:26:56 +0200
Message-ID: <20250527162506.240273522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6f9a8ab796c6528d22de3c504c81fce7dde63d8a ]

In preparation for making the kmalloc() family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct folio **" but the returned type will be
"struct page **". These are the same allocation size (pointer size), but
the types don't match. Adjust the allocation type to match the assignment.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 40332ab62f101..65d883da86c60 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -606,7 +606,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	free_extent_map(em);
 
 	cb->nr_folios = DIV_ROUND_UP(compressed_len, PAGE_SIZE);
-	cb->compressed_folios = kcalloc(cb->nr_folios, sizeof(struct page *), GFP_NOFS);
+	cb->compressed_folios = kcalloc(cb->nr_folios, sizeof(struct folio *), GFP_NOFS);
 	if (!cb->compressed_folios) {
 		ret = BLK_STS_RESOURCE;
 		goto out_free_bio;
-- 
2.39.5



