Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94323ACF11;
	Wed,  8 Apr 2026 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672844; cv=none; b=Wa/5l7uCTNTC+LvukoyGDFXC9AqAVP9FPJZk9Sf4esItiSau25TS6RCu5nuZ+9QJzarBKiIHtFNFCqXzpYtGUHzOvbmu4cWW3BK1nznZNUj4X0w/nxU6hON/Dt0bE8POK8ld5lTVa+5SnIRrXk2kM+DK8BWcls5TgSMZpPFHReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672844; c=relaxed/simple;
	bh=gHa+A+OK07Q1qHkc9d5xIyZiuo4JnZQjQHlXml+HCaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEv8BLQLjFGTKM7JttEFR2QnnH7lSE2NzGdXI8HzhBoLcQvVmC6CZ6HWr0KCbb7g1aOZ/VMTaIeviJm9z8rhybqNKE4HAyt8hBOFVcsO+nJ2lOjHJvvvhRDqUOGsh/7EjmtExyjX/YzxSek18BxHFqKsrydK/nVRVyfbNIz/yBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ID60Vpql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ID60Vpql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA91C19425;
	Wed,  8 Apr 2026 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672844;
	bh=gHa+A+OK07Q1qHkc9d5xIyZiuo4JnZQjQHlXml+HCaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ID60VpqlA0FOsnvBtHughmLoGkKd3UEF13JDPQN4ZkkWMTYP4FAQmod9wH85pBmdf
	 q6UtYXikuHhu9DEywSLBqc+1VeBMFeo9skvOidTGFalj/2rOx5PBarclzwg/xrk23i
	 O+m1FvjLXn1CIBHKx0xj6s4f17FAWpM4DKn3Aw/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/160] btrfs: fix the qgroup data free range for inline data extents
Date: Wed,  8 Apr 2026 20:03:44 +0200
Message-ID: <20260408175918.303052443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
index cf39f52fc0484..28625e504972e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -692,7 +692,7 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
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



