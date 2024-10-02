Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5581D0F48;
	Wed,  2 Oct 2024 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880551; cv=none; b=PoPxG7ENuBO26BVFi3c6f7D7Z11uKj+RGyTW1/J336018pQUnKMQYZIF764UxKhbsSAgPDFtGjq34PssNl6sBM8ggQ2YiZNad3kQUNRWvEFRBAd3Vq/IG8XvuHwJMZjR47Sp3pSyJxPnuIKbDpjpIQjgT9W2ys3fzW0/+BFvIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880551; c=relaxed/simple;
	bh=MufoUWZoz4iwCqcpOvjlbCea8PIeSz42LMHXlBQh2Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlZ+GQapXlN30Rs/dqB2x9zOJdeHhUKmUryGtmtEl49qYWcBiwexy3kLsNOQsf8z7CFd/7mjfv7yb/s0PxaBWdZW7FvGN/j8EGX9tmqFXXR0lCGTJ36wuV5CWMibSNVknUy5tLvDtngfFomlWxTO8c0iT8i3kROLakiJ4q+LA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFhzq9GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFhzq9GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6942AC4CEC2;
	Wed,  2 Oct 2024 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880550;
	bh=MufoUWZoz4iwCqcpOvjlbCea8PIeSz42LMHXlBQh2Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFhzq9GWgOEllvGdJ61Q7cT79rplomtEL61f7gMaLZeBNFxE0L1gxghA81XODSZHJ
	 imHaD95L2uFxsUlXkXeDD0zC04Kq4D2U5N6CAYbM4L1R8tYQizbs7+dxTcGA84LveK
	 v3uhL6bd3ZWfsxC4upyiNyyH60ZAdjs9iSoDpfhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 496/538] btrfs: subpage: fix the bitmap dump which can cause bitmap corruption
Date: Wed,  2 Oct 2024 15:02:15 +0200
Message-ID: <20241002125812.017741445@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 77b0b98bb743f5d04d8f995ba1936e1143689d4a ]

In commit 75258f20fb70 ("btrfs: subpage: dump extra subpage bitmaps for
debug") an internal macro GET_SUBPAGE_BITMAP() is introduced to grab the
bitmap of each attribute.

But that commit is using bitmap_cut() which will do the left shift of
the larger bitmap, causing incorrect values.

Thankfully this bitmap_cut() is only called for debug usage, and so far
it's not yet causing problem.

Fix it to use bitmap_read() to only grab the desired sub-bitmap.

Fixes: 75258f20fb70 ("btrfs: subpage: dump extra subpage bitmaps for debug")
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/subpage.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 1b999c6e41930..b98d42ca55647 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -713,8 +713,14 @@ void btrfs_page_unlock_writer(struct btrfs_fs_info *fs_info, struct page *page,
 }
 
 #define GET_SUBPAGE_BITMAP(subpage, subpage_info, name, dst)		\
-	bitmap_cut(dst, subpage->bitmaps, 0,				\
-		   subpage_info->name##_offset, subpage_info->bitmap_nr_bits)
+{									\
+	const int bitmap_nr_bits = subpage_info->bitmap_nr_bits;	\
+									\
+	ASSERT(bitmap_nr_bits < BITS_PER_LONG);				\
+	*dst = bitmap_read(subpage->bitmaps,				\
+			   subpage_info->name##_offset,			\
+			   bitmap_nr_bits);				\
+}
 
 void __cold btrfs_subpage_dump_bitmap(const struct btrfs_fs_info *fs_info,
 				      struct page *page, u64 start, u32 len)
-- 
2.43.0



