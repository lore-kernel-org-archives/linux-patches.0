Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8796C3CCFC3;
	Mon, 17 Aug 2026 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979227; cv=none; b=Gm2zh+drRUR46wC6nawvOcb+5cAzHO/Us/nB5hFvZ6SswI6MnRt0e8oaYn3qJrjTJMA0RFMvviakRy05xLVz+2zVSuga0kXfuK295m86Vai6RYyVoJK64G2vLgFAMx+3Ej2QXVzirVQ+oZj2EL7tZcxoywc4cV+AiF11DHP21cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979227; c=relaxed/simple;
	bh=EhPQ2CpVV1sLRi6KwHwyd8QqIh6pdWrLy339feWnQMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWb0p9CG3qQ/8mR4EM8XA3Tw4sXS4N/65XQ39k9DvKOh0EI4U37Dxuk7FMGeXCeiMHFr9UHbonANTzSSZNfLlG/fTRXtqYft+g6y0M0xepr+VAYdAyrRRN4LM2+gZrsQ3G6RGq7le5id6ruoq4tgyILpxMmifkwWsDRk8kuYlkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvvzaaJc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvvzaaJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56381F00A3A;
	Mon, 17 Aug 2026 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979226;
	bh=8hXg24E9bZDTu0H6evAKdbnfycGVxWdm46mY7GHoc80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvvzaaJcSOpxroGyLkbPTCirP2u8d8eId35VwXstRqdZAab0Y5gUKC0COQRthIFlz
	 gSlRfJApoA/RDLx2sd3cb4q3FZyPlSyL1cAvJ1zCJgNsMNkY+FBuSJoTUz7FfWmfev
	 eMGfR6KS27XTIx6hUCuR7UzCMv9tT8gmlaqhrU+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/609] btrfs: free mapping node on duplicate reloc root insert
Date: Mon, 17 Aug 2026 15:26:49 +0200
Message-ID: <20260817132547.534878548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 2e66a0672ba7fa..d37904a806d6a0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -645,6 +645,7 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.53.0



