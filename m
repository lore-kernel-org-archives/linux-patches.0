Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5E633D4E2;
	Thu, 30 Jul 2026 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421710; cv=none; b=XcR5vX4aJVLLnDbEWwtoWO0aN97xaicqF2+2B5wRReyz5Qa9MPMJPFjFlc469X8t1LHaQAaX09T7Eo7IRk9Hm/Ksrt9W7zul6zu6qANjnXSJvci8XD0pO534EJq0p9yXtxv3PPil8soOSmMWh4pYUAEngNN6v7GsIR8bLDNCcNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421710; c=relaxed/simple;
	bh=ipWRleEaGhi+T/K/zcvktTemg0uurV7yB3CCvg1UW6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIJBbYo8Nlmo3Pslb6hiRq5M+h6HjvJXzTv9AahbHz5udw1bvCgACwxAR0946LO270gPgx6JjXXFMVLgftbI4qNlDSuQcb2+sfoCp1xYcEUaVrNYjgZI2p4XK0Iq/Ybkx/MK2RfLwFls0el2JslzWD0hoZ016fiQ/Vm7ZbW5ZIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YELxibEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YELxibEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B05B1F000E9;
	Thu, 30 Jul 2026 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421708;
	bh=kJB5HNLgBa8OBCwN2/lt/bw4o+mgpPcLlGwzZUzg5AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YELxibEMuYiJG5ChBNEQZg5oI6dHn09fj4r/8AnKtbt7yc2H2yszBA7JNHagw17yw
	 MEuPq9UB1Fo6oho7HwvVORU5RRKD3bNiRCIZRaD4c7m9LVI00mY5oZ2i3jakVjzn9l
	 2QXFPjW7iYPXrMRPTIEa6amNrC8cMz83vHrQ/MV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 195/744] btrfs: free mapping node on duplicate reloc root insert
Date: Thu, 30 Jul 2026 16:07:48 +0200
Message-ID: <20260730141448.426040333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6c826be4174934..37dd9c8b352fbc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -497,6 +497,7 @@ static int __add_reloc_root(struct btrfs_root *root)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.53.0



