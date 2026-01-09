Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512BF35970A;
	Fri,  9 Jan 2026 11:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959868; cv=none; b=rWHPEcqpWMY2dpYbPVQ51ARknka5MDcflB7TXCcfjwFKSZBngw4CJhix3ornfe1sxWNkWh+nC52iME0ZrGlWa/PAKrwAfHJjecp1XGwS81U/l0SGbUzbUOTSV9nv3J1kGTrHqiaQe5jdF8lHJvf61hfogvlCNKsBMuJV6Tr0ibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959868; c=relaxed/simple;
	bh=spQehq4rM3khZ05vrSnf+l/cseA9GVDulkxkPD9fL4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8jgGGnH8f9+FYvt2UElnTz3wvR7ic5GPh3fUYd9r4PSDVGOy74+jC+7rEHt2KzBqUbnkl4MuqRaRydLk4Ff/pcbjzO4xdnNarzjZZ+DjMIaai3/GfHIz78w7ideHIJvw0SIgvoet/XzFnq1sSzbX/x5H0zk+X+Ba3h4Xr5tWFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJeXm0SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJeXm0SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2007C4CEF1;
	Fri,  9 Jan 2026 11:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959868;
	bh=spQehq4rM3khZ05vrSnf+l/cseA9GVDulkxkPD9fL4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJeXm0SHIAdNC7vf86pN8q6riNX6a2krdH9PUjZi0gHFzLO2gJQqLyUbbsi1GLj/h
	 hCWt5SbvG0QUSefAeTJBDOaDM3Xp+w6jAAuVPc7FbhDC49/tvlOJEo2whC0MuakXU4
	 gIqtVjJ2tdp22IUsgQjtjfoeOchSuuHb4RwTrWOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/737] btrfs: fix leaf leak in an error path in btrfs_del_items()
Date: Fri,  9 Jan 2026 12:35:42 +0100
Message-ID: <20260109112141.638068535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 31b1b448efc2e..a26c6e9d562d6 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4743,9 +4743,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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



