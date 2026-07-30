Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106F637A494;
	Thu, 30 Jul 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427347; cv=none; b=pQWhbhICe4K2j9t+T6lFEH+aYOFnBV/1oLTaQBFrNIrQnORCuP4Q/JiCScOUntgYGpxJLpl68PWUMYTNXDRVu7+dpxAv+6BULsaTQuCj5RIA3rQdxhpIKyjFHuBa4ZMBdjrX2CN/5eEEWMV7x8FCpVR8TbM2e9KGntrw+SCqh44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427347; c=relaxed/simple;
	bh=Bx/UWb1BIs1SmN6MEsvG9u5uLTrP35rGitGmau5riTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I04/mcNu6K9I/sbqhr88A8go2Hvzb5uQK3/Vcee0wJ9QJYV0aHkdUT7F9ICykekNt6+bPGbPFbEY0bqWqJ0KT2sfu0uWCYXfSM4mE0FuE85zwKFPzBZPtF6hBQe5Tb92mzUkWWh4QJAUxNnPTHtoubvcqsRtDiVWAJ8+VgjI1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sa/DdIiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sa/DdIiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1321F000E9;
	Thu, 30 Jul 2026 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427346;
	bh=m/q3k/J1WJJoFV9yr08V0LH6YoFBbvo2pyftPvl+UuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sa/DdIiH0YsweWWTrnhbVoKlJ6XK95O9I3VwfnpP9n70RVS5iaBYfRKegbUqrJGPv
	 k7vTDNCge4z1608J8QlZ2IL+XB7BBPFyyS+kao/mBLJA4YxXKAzPKEYvYBKoCVVD4X
	 cFwNcWmwTo5yPAWfCKU5eofulcNjc8pgxwSXrfnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/484] btrfs: free mapping node on duplicate reloc root insert
Date: Thu, 30 Jul 2026 16:10:28 +0200
Message-ID: <20260730141426.305519677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90aacda2523eb5..0b7a4b90053692 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -586,6 +586,7 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.53.0



