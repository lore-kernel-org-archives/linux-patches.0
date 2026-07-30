Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81324052DC;
	Thu, 30 Jul 2026 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423845; cv=none; b=s6QABbplA8JgL++IiRBiB40IwzWRzoYrUGwaiXTDboIPFl3i6KarTeVBfLdO1n4mjhgGyK1YF2pPxquWEsLU3IFT1OlirOARKiunC2DYTFA/1oWR+eIoEYVVFi6D4XovIMvNVyhtOaGPbrwWrCoT32OW1V4smoEWCOAcfGgWX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423845; c=relaxed/simple;
	bh=B0M6UTfEmbUtgn/DZdGOWYgoUioN/VPsPAl0yOVtdWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0HetwJrGbEas/RUrVQ8msE9hLnkrF6ahltbYp7HnwxhWwqvVHVYewI3aLVF6lTYIHWvz51j7aOnW0AoBVCin1/E/CBsOaxV2wWC4kDE9GtuqcPJlwOyxWT8Y5pSeEqMeRlFrQys5FW/kM57BiQfQ32DKiPtTbFKkKt0IVZ+eLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfS3V3bx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfS3V3bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3CD1F000E9;
	Thu, 30 Jul 2026 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423844;
	bh=/nE0zmvrT3VUtYU6315lmxHA9tmAKSyfIi6Ad3N/9G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfS3V3bxwem41l5oWTwR0+9PH/F4FMCklKoqP1EiVqtddELuTfhASnIIEp2UYo9ne
	 6HhPZQlRdborjEc8KHoUb+09EqgM+NwtPUWsiMa7PO6VnUXk9C53UFgLMdzB7ZL6od
	 7cmeD1sNZKsbBvYHsPA7IKlApvKH/gJjiKrbvrZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/675] btrfs: free mapping node on duplicate reloc root insert
Date: Thu, 30 Jul 2026 16:08:37 +0200
Message-ID: <20260730141449.118350130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit 6a8269b6459ed870a8156c106a0f597383907872 ]

__add_reloc_root() allocates a mapping_node before inserting it into
rc->reloc_root_tree.  If rb_simple_insert() finds an existing entry, it
returns the existing rb_node and leaves the newly allocated node unlinked.

The error path then returns -EEXIST without freeing the new node.  Since
the node was never inserted into reloc_root_tree, the later cleanup in
put_reloc_control() cannot find it either.

Free the newly allocated node before returning -EEXIST.

The callers currently assert that -EEXIST should not happen, so this is a
defensive cleanup for an unexpected duplicate insert path.  If the path is
ever reached, the local allocation should still be released.

Fixes: 57a304cfd43b ("btrfs: do not panic in __add_reloc_root")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 86430435d3acc7..80e5de6736e829 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -496,6 +496,7 @@ static int __add_reloc_root(struct btrfs_root *root)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.53.0



