Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0090A4F68C6;
	Tue, 13 Oct 2026 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896105; cv=none; b=hPBAtMwVQDLOEM3C+jnecapEEaf5WYBsEH8n+a/Hs2QoqTAJ2v83Wn5j8rRpbjPiyvMm+DVFTVf2x7wgu2ZQZJVpPd5Hde+TOn8oO20gwAly+fpBF3MYoyRE1X5MxgPBsLR8Zd9v65l53Kp0nqlhix7iABGVjYrizKIff7wnhSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896105; c=relaxed/simple;
	bh=mczouYsllOdimNj2tI95kZja3qC7OXDCOVh6ir3nAxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmzs7SFdZq3sfu6hUv3nZOjG5EoyMntIsDehkUFiSCN2I9BwwvryQ3ugpqzeuWSXJdKkbhQiV+Xe5WPqL/83SJoWb+N+uJDRbUCsh2V/wv5/WVxlZUk5Pd/J2wNMEBUuiPxqzCsSC5Rxm218uC9aJcHC98KfAPb1JNI4qCAPB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY1+rkX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY1+rkX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510191F000FF;
	Tue, 13 Oct 2026 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896104;
	bh=DoTVWy0+T3lBvYCoF3FfnPOtwj0ZQ3bZd/LQ0phx/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY1+rkX0vF3CG3r67fCOIDO+R2lctpGp4N6xgSsG2WqlDrP0FqYYgoVVnnAWLJNig
	 xHgN72TG0pzkunsOt6lcLYzzkIk3ggUyybfrhfpPni6/F0B6D/2AFQ5nfSClyHdX2c
	 85E+8FQmfVhLHpEKr6U8ddKJxJSBqGQrFOrjFjW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 464/497] btrfs: fix lost error return value in btrfs_listxattr()
Date: Tue, 13 Oct 2026 13:40:31 +0200
Message-ID: <20261013112918.894044198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 41c8899d59898f6fa51ceebd2b6e55257191a8ee ]

If the input buffer does not have enough space to store the current xattr,
we set 'iter_ret' to -ERANGE and then do "break", but that only exits the
while loop over the xattrs in the current btrfs_dir_item, and then we
continue the btrfs_for_each_slot() iteration, which overwrites the value
of 'iter_ret' causing us to lose the error return value and proceed as if
the buffer has enough space.

Fix this by returning -ERANGE directly (the path is automatically freed)
instead of breaking from the while loop.

Fixes: 184b3d190087 ("btrfs: use btrfs_for_each_slot in btrfs_listxattr")
Assisted-by: LLM (found the bug)
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/xattr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index a7700083bdbd3..ff218e8ec0ca4 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -344,10 +344,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			if (!size)
 				goto next;
 
-			if (!buffer || (name_len + 1) > size_left) {
-			        iter_ret = -ERANGE;
-				break;
-			}
+			if (!buffer || (name_len + 1) > size_left)
+				return -ERANGE;
 
 			read_extent_buffer(leaf, buffer, name_ptr, name_len);
 			buffer[name_len] = '\0';
-- 
2.53.0



