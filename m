Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6567E25228D;
	Thu, 15 Jan 2026 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496327; cv=none; b=O3zkALWt1HY1+rzV2GUYsMwsPcuTNbiU3TY7jjVQrDHTpt8wTvVVm5wjQmHKDKGvtqTqGBR84y7bvMQ0V8CENTfeL8a7W5XLhdU3MXAJJEROTf8pbKNAKmKqmuB7Gykhs/KEGmlbKbOIB9AF+mR+id5mAfIxRpK2M6FDiInV+5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496327; c=relaxed/simple;
	bh=zBkEQkJd240ZNLNy744ZbMVsW0XLiOU7BDPmUccJ1V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9NT6ZbROD7vcjqOMEoognuoGnlJaEzhM/dt/daxS29nUakBW35Z39ZMhsBXM1gZWTrhFTzF6s4nkKPMxJdGyMfRTimenW2xmJhAnE9LmeQ0acpdNocMQc43V1hxn4DnxFyYOGrYtzQ/xi5ySr+dgoRCffYAHlyTsFIqh7KRwt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTyT5Y5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTyT5Y5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EC2C116D0;
	Thu, 15 Jan 2026 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496327;
	bh=zBkEQkJd240ZNLNy744ZbMVsW0XLiOU7BDPmUccJ1V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTyT5Y5ysQ7JfK/vTWAO5zSFjDtbVv7ZRtb9gl810vNQev+NUC1rWVIH66uez428t
	 gxhSmKpDCwrjhPA/FMehvgDLfAEQEIGPqD6LghIWmKjsAKHsF5FgXg1tpBzdHV6rnI
	 ieSt2LbBLSBK+Xz79WzHQYen7sb7fDgPYrHME/U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/181] btrfs: use variable for end offset in extent_writepage_io()
Date: Thu, 15 Jan 2026 17:48:15 +0100
Message-ID: <20260115164208.015677151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

[ Upstream commit 46a23908598f4b8e61483f04ea9f471b2affc58a ]

Instead of repeating the expression "start + len" multiple times, store it
in a variable and use it where needed.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: e9e3b22ddfa7 ("btrfs: fix beyond-EOF write handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1691,6 +1691,7 @@ static noinline_for_stack int extent_wri
 	unsigned long range_bitmap = 0;
 	bool submitted_io = false;
 	int found_error = 0;
+	const u64 end = start + len;
 	const u64 folio_start = folio_pos(folio);
 	const u64 folio_end = folio_start + folio_size(folio);
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
@@ -1698,7 +1699,7 @@ static noinline_for_stack int extent_wri
 	int bit;
 	int ret = 0;
 
-	ASSERT(start >= folio_start && start + len <= folio_end);
+	ASSERT(start >= folio_start && end <= folio_end);
 
 	ret = btrfs_writepage_cow_fixup(folio);
 	if (ret == -EAGAIN) {
@@ -1714,7 +1715,7 @@ static noinline_for_stack int extent_wri
 		return ret;
 	}
 
-	for (cur = start; cur < start + len; cur += fs_info->sectorsize)
+	for (cur = start; cur < end; cur += fs_info->sectorsize)
 		set_bit((cur - folio_start) >> fs_info->sectorsize_bits, &range_bitmap);
 	bitmap_and(&bio_ctrl->submit_bitmap, &bio_ctrl->submit_bitmap, &range_bitmap,
 		   blocks_per_folio);
@@ -1743,7 +1744,7 @@ static noinline_for_stack int extent_wri
 			btrfs_put_ordered_extent(ordered);
 
 			btrfs_mark_ordered_io_finished(inode, folio, cur,
-						       start + len - cur, true);
+						       end - cur, true);
 			/*
 			 * This range is beyond i_size, thus we don't need to
 			 * bother writing back.
@@ -1752,8 +1753,7 @@ static noinline_for_stack int extent_wri
 			 * writeback the sectors with subpage dirty bits,
 			 * causing writeback without ordered extent.
 			 */
-			btrfs_folio_clear_dirty(fs_info, folio, cur,
-						start + len - cur);
+			btrfs_folio_clear_dirty(fs_info, folio, cur, end - cur);
 			break;
 		}
 		ret = submit_one_sector(inode, folio, cur, bio_ctrl, i_size);


