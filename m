Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBD736607D;
	Thu, 30 Jul 2026 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425676; cv=none; b=KScTfiTg7MFH8i8uNBe7/rsLeuQ8QakWXmDyt4a4x4oYjoom0WT47SMd115yzW39vy5z/NUrzQLgfoAEuq5j4ZRHzCSxPlVNcjE7nFyts8/F/zpnvg2480QhJtndffeodFEGQHcIlOmJB01AZIhNUh3+8LaWiXSHpSE5fcKsmpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425676; c=relaxed/simple;
	bh=lvwb0cE1GXJzjLsvN/SV12E2WnyTSlNOG5ZtkrizJeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA0eQhIJHi6pnUzhVyBU5sDOLfrQfTl3sG6sU5x9SJ6ZaBxex71AM9VDlnokO0rxcJ5ocg2efO9KyEVQKeWy/jPMQS0tbm0+Q5e9su57P1qt1J0v39ezOOjzEh9EJEFEDYOese35PyMehaHKgUtJxtvLIWWqf0IsNmDAygD3ego=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2HxITUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2HxITUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D14E1F000E9;
	Thu, 30 Jul 2026 15:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425675;
	bh=oNeK8hssAoEnuHQz4w7mW1H6xruOBG+uFTKRjHAckeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2HxITUAkBAmvhSlyU0bOHtcovEx2ysDXuhcFIbHbboqSgZjz7li3QJIk5de2LE72
	 qfF1gPHvcCpudvXm2Ue/OzXi6YbkE593x3GCvzk1lYMYw2MznfgDLPJmskcN7jokCm
	 xlurXCvIUArkvWHzwkhcygiV2sn6ublAbKHaIoTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/602] btrfs: free mapping node on duplicate reloc root insert
Date: Thu, 30 Jul 2026 16:09:05 +0200
Message-ID: <20260730141439.191461781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d2a1323e8b1034..8130bfd1abbf2b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -580,6 +580,7 @@ static int __add_reloc_root(struct btrfs_root *root)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.53.0



