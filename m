Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8A1B67E;
	Wed,  8 Apr 2026 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672281; cv=none; b=KLmFgL5M2yZydpJsknwTjd0ODs6p4hjs2I2HQruthYmux1fPqBf6AUW2dHdr/SmKSUZsKUJDKIoQNp4D2XMr84X5h0hTHYz4p3meQpbdvG5qutBnHuOHRnjh94iDSs3O5BRERkmIHBLxKNjsJB+kZeqGuD+AvODG6WkyeTKx7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672281; c=relaxed/simple;
	bh=2UEgRN233IXVRHyED9tqrttCGAdB0ZdS9CmlMTo99VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvfdoE8qGxwZJp/UTr3IftrC9Vum/5PY0B0r+TwWIYzetB7Ys4nIk+FNDAr9iow06G/RJ6vprKQDNH5T/+fqTDcuvriSV+MShgsrHv15SN+lS9SRrXpmlm8It8YfQWun8STzMzIL14S1PWa26iGFFvcS1KKx4o1nyl77f4u9pC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9Pz0Ax0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9Pz0Ax0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9222C19421;
	Wed,  8 Apr 2026 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672281;
	bh=2UEgRN233IXVRHyED9tqrttCGAdB0ZdS9CmlMTo99VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9Pz0Ax08fUJHC17B1XZBMz3Ayowt5dpezlR2wgMGdigl4ZZRHBEINkCHfMGCI+pX
	 rkiNy67uw2zD1RFKsY2EDN54s9Fgq1uZNEdtplOanz2Z8WZcDVKhmoszDPjJdu93qa
	 tZ5IfeW1xsy3t0TjyB0Q6+KBym0Tn8ZOcAPEX3So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/312] btrfs: fix the qgroup data free range for inline data extents
Date: Wed,  8 Apr 2026 20:02:55 +0200
Message-ID: <20260408175943.381755163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 0bb067ca64e35536f1f5d9ef6aaafc40f4833623 ]

Inside function __cow_file_range_inline() since the inlined data no
longer take any data space, we need to free up the reserved space.

However the code is still using the old page size == sector size
assumption, and will not handle subpage case well.

Thankfully it is not going to cause any problems because we have two extra
safe nets:

- Inline data extents creation is disabled for sector size < page size
  cases for now
  But it won't stay that for long.

- btrfs_qgroup_free_data() will only clear ranges which have been already
  reserved
  So even if we pass a range larger than what we need, it should still
  be fine, especially there is only reserved space for a single block at
  file offset 0 of an inline data extent.

But just for the sake of consistency, fix the call site to use
sectorsize instead of page size.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: f8da41de0bff ("btrfs: do not free data reservation in fallback from inline due to -ENOSPC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2b4a667367225..45c6cbbd686fd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -469,7 +469,7 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	 * And at reserve time, it's always aligned to page size, so
 	 * just free one page here.
 	 */
-	btrfs_qgroup_free_data(inode, NULL, 0, PAGE_SIZE, NULL);
+	btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
 	btrfs_free_path(path);
 	if (trans)
 		btrfs_end_transaction(trans);
-- 
2.53.0



