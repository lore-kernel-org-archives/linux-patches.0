Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EEF2727F3;
	Wed,  8 Apr 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674074; cv=none; b=tyGx9LoqTQxrLEDWMUxaZVXM1gzqLTWNqg05Jt8ou2w0ZdApTK23knWjZXbR9iEa3eW9UKk46WpVdJrd1xjfYWYswvGAjYaa5AzPhbKlho0Z50/nE5AgS+gZSX4iGaiKxBe8UoQUaHxVgKeEa8I76ghTkrY4KsH52aVqSyBHw1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674074; c=relaxed/simple;
	bh=8sQ14zUiRUGuhOAdxqFWC3NAYo88q6gBy0zq7glpEMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZHJ+RVTgd57tsI4ZDH15S75ugE+maJ5Lph1Qj+8idpFN/TA9KECrJbdSbqL7940dkJ8KUBOS8GPr+fiiP6I1EXn3DRjV/GCKN5DW5Qjdtit1p70QdiJKgwoDOi7xXK4w08+0wP9NAgU1XhQg6ZLn4lqwwdr5GCrok6YKZHMTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PF+kAHKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PF+kAHKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96F8C19421;
	Wed,  8 Apr 2026 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674074;
	bh=8sQ14zUiRUGuhOAdxqFWC3NAYo88q6gBy0zq7glpEMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PF+kAHKv4m+AFJc5AvuwLDO2FhyX8SmYxzHWgU9np5OK1TR1I/iLQ3HqAJwxXmpim
	 kor/WSWuLLnUvEwNdyfhawizh9Kj3uj+Pns1+0MxbwX7c+sx/6Ms2Yb9nZyAfZFSOo
	 9PQVmt36y3Ku/F/S/F2IYqCSDBNB4mUOBPazfaM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/242] btrfs: fix the qgroup data free range for inline data extents
Date: Wed,  8 Apr 2026 20:03:59 +0200
Message-ID: <20260408175934.531026011@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
index 4bff5d5953ed8..fae4e8ac33844 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -718,7 +718,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode, u64 offse
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



