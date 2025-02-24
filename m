Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA2318A6BD;
	Mon, 24 Feb 2025 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408319; cv=none; b=o3PAhmvBgikB+qbjwavxIPZIJiC3tfYTcILEbgmeBM4KWLBtMCLqo0VqimivUgKjysTh5WF7V5cazFeC/IzPqX3DZzETxBkFXZthm2ptfpeT6/lBsBC6FkC0u9KYBpImuoH0IWEzMb6cHYK3Jxys190t+h9rCQMczjHYUdzyGD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408319; c=relaxed/simple;
	bh=Dp/NMF08zO85APglQj+qwuckrckVc/mkgqZnQjw4UWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obw8siLxeYKqAfz+6h6gumjPYoEpj4qNQJG3I+bfeFvgScmENT0j+yDknRmmn0b/2F3QJy1QeM2TaN8tdvtNtjmm+XrVNA9Pgi4Li9B+hIitfGt1BRQNeMFOLPGCWUZDbY76ELM3f1rTH/mTpBQvEQJeVwl5wkSXyurbObnGUog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfT+Obaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfT+Obaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64893C4CED6;
	Mon, 24 Feb 2025 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408318;
	bh=Dp/NMF08zO85APglQj+qwuckrckVc/mkgqZnQjw4UWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfT+ObaqWEqNALredddpovFy/oaO/N5wqdGpmHPGMpUuph2ZIThVt6Tcbl6n5W/Is
	 u9/9bp9biE399c5q8+vTRgshzulsp5IDpzDuhRhWYkSGI3UnhGJKbmtxPDMMSgX9AS
	 0x3Xzg7qxm2sKzlDPdHnjFcyGmcZXA4PA5Xj4now=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/154] btrfs: do not assume the full page range is not dirty in extent_writepage_io()
Date: Mon, 24 Feb 2025 15:33:25 +0100
Message-ID: <20250224142607.318964825@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 928b4de66ed3b0d9a6f201ce41ab2eed6ea2e7ef ]

The function extent_writepage_io() will submit the dirty sectors inside
the page for the write.

But recently to co-operate with the incoming subpage compression
enhancement, a new bitmap is introduced to
btrfs_bio_ctrl::submit_bitmap, to only avoid a subset of the dirty
range.

This is because we can have the following cases with 64K page size:

    0      16K       32K       48K       64K
    |      |/////////|         |/|
                                 52K

For range [16K, 32K), we queue the dirty range for compression, which is
ran in a delayed workqueue.
Then for range [48K, 52K), we go through the regular submission path.

In that case, our btrfs_bio_ctrl::submit_bitmap will exclude the range
[16K, 32K).

The dirty flags for the range [16K, 32K) is only cleared when the
compression is done, by the extent_clear_unlock_delalloc() call inside
submit_one_async_extent().

This patch fix the false alert by removing the
btrfs_folio_assert_not_dirty() check, since it's no longer correct for
subpage compression cases.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe08c983d5bb4..9ff72a5a13eb3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1394,8 +1394,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			goto out;
 		submitted_io = true;
 	}
-
-	btrfs_folio_assert_not_dirty(fs_info, folio, start, len);
 out:
 	/*
 	 * If we didn't submitted any sector (>= i_size), folio dirty get
-- 
2.39.5



