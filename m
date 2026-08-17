Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070D113C9C4;
	Mon, 17 Aug 2026 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976749; cv=none; b=YMxrepC6gBtP/NLGJ6dyX7qN/ZzUXLKFwEZMm1hOpOJX3K+mCM6ECCG1/fWBjCYAu/2NOyLm3MeaI+ppkgqYxkPrIwjaN0gfq+GRor/WGKdO2Mvtoc/EjNWbU1hJVEHpZwOfa6rBl/3lZ8fF3+xgDKi0zkqkD78R9R1/GZgRLcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976749; c=relaxed/simple;
	bh=I0t802ttoa5ym1QDVEDYViVuea1uJSe3OVD4JOFWz0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qe4dTl8i9Sa5lXEOeQWlyIVte+Y3AlaMTCiMx5XJk83x61SEyNWbe59hGal1OWv2b0xPcOciJuZYkymH134Z8Qxt0SmsDLXR4HVNePqCJf9kR41gNnXiEP6CwgWnhMw0t/89vVnMBHU96fhq1Bq6ckJN7IC62GyAc5vA8Onc5K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdWCL2pi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdWCL2pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605881F000E9;
	Mon, 17 Aug 2026 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976747;
	bh=tXPc2gK3G1Yc6Eu8lC45iJCnktZJ7fe0VUt9o0GhrY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdWCL2piry8VFIa9xknVbpv1+0H1iQhVwK1Sx1Yt59ttO5hXVIUg5pcGvgxSPg8+X
	 RvYLgjGdqiJIAJMyYKP477LfrKtO+x7LZ+qNFB8mivjVb3xj1NMOuMeSVZnwWPL2/b
	 r44a/edcz0dl6jCgFaKj/XgJxCYfnEYsCBjcQngY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/456] btrfs: free mapping node on duplicate reloc root insert
Date: Mon, 17 Aug 2026 15:27:59 +0200
Message-ID: <20260817132543.600611946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 2c4130c3120175..06cf9468340176 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -642,6 +642,7 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.53.0



