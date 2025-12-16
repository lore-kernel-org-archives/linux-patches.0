Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3B936D504;
	Tue, 16 Dec 2025 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888035; cv=none; b=tmgaZ3/F3UyfFACir7VCldW1qlHuzlBtKA2EvmjMTpEXZLnz4ThBf3swRBso5JN5J0WnLeCL5rWGRL61RbkUBFuhlJy8KrlD6lhAiOshNa+h3mx8Vf3fM5N+6HDraPDJOtbZw2bfONqV6SdrgxIDn+2/HdxK4XIyBNAVEYntn1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888035; c=relaxed/simple;
	bh=ChvpdK++fEJkqoXoEcgLO1TOzCi8NCZfPa7zS+xsbLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8VZibkdpv2vILzczZquVr49NtfVim+YaHsdYO1gdbJqlfQaAwke0RicmURd6ViRsk647syvxU+I3/G+e92TFhfOMOo3gn7CbItuUFOBQorPdQXI3yVJqM5K3lkIE0+tR0NuHKPkyoj29qs8CJ3Xi21AuuOv/6MerTo/9bkucek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwO9+aQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwO9+aQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5288C4CEF1;
	Tue, 16 Dec 2025 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888035;
	bh=ChvpdK++fEJkqoXoEcgLO1TOzCi8NCZfPa7zS+xsbLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwO9+aQbYU8PiTo6am7NikraqzAmPdHS3QGa6E7HxgKSArrZgkJRbBHIIQC/CWQ8B
	 2+1D/PIIg/LgHbLMAQyZ5N79sSXC8Qw84vZwObKYi3Z0X/svs4Li12VF5znTgy22UL
	 OzHPhbZnc7UzEtNDovoIw6ZrJ8PChANg9Gpaz7pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 411/614] btrfs: fix leaf leak in an error path in btrfs_del_items()
Date: Tue, 16 Dec 2025 12:12:58 +0100
Message-ID: <20251216111416.263591464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e7dd1182fcedee7c6097c9f49eba8de94a4364e3 ]

If the call to btrfs_del_leaf() fails we return without decrementing the
extra ref we took on the leaf, therefore leaking it. Fix this by ensuring
we drop the ref count before returning the error.

Fixes: 751a27615dda ("btrfs: do not BUG_ON() on tree mod log failures at btrfs_del_ptr()")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 561658aca018b..6e053caa6e101 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4566,9 +4566,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
 				ret = btrfs_del_leaf(trans, root, path, leaf);
+				free_extent_buffer(leaf);
 				if (ret < 0)
 					return ret;
-				free_extent_buffer(leaf);
 				ret = 0;
 			} else {
 				/* if we're still in the path, make sure
-- 
2.51.0



