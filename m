Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F64A348C55;
	Wed, 20 May 2026 18:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301329; cv=none; b=jJuNRlzf9dtdbOwCfAeM5gtix+6gLhy2W6PPEGR0LZH0suUoq6qqs31HbW2jDKJqAeq8g9ky7JeV2jfQHp4OwRH6Ut531yBkjzcWdTUJOGNAk0RY/PFeqkCfxOV0EjbNqErjxwKQ2oy9RNxcOGI8dAdEiIe2BwDQSCaR+y0FUpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301329; c=relaxed/simple;
	bh=1YclACyca94zfpaWoKZvi2sZtQY1p0IGVrDHMvmACWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd0fG5Lk3WnygHcdkcS1EdyhOmKUJBRQlkqzGPlcVrrARtREFIQY3Mt+cQCb0M+uCjad+2+B/+jbSlfddOHK3Z1Y0tjhD1e4kHZLerOvzAKVZd+nn73FQs8Q1iP883Wez8d8NPMmdUSxPXOMp7WK/FlVOGkla5AS3Bxx/QrYmzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dF1ZTa+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dF1ZTa+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863A61F00894;
	Wed, 20 May 2026 18:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301328;
	bh=XCYQL8HiOW9gTEfcpSJ4pt7F5h+zNT4rVDz5l5DiAFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dF1ZTa+iLQ3uH7yJSkJqLobCGfTN43rhzK9hWZFY+1ClW1Ku7ZUhv2X6FNN///20i
	 sgPN2Njl5rIQETK0kw/V8Do6DNp+WpAjzU1n9JqgV+OenHnO8YkuJ2kcXzLP/2oQ8W
	 ObdkttE5Wbr/K25MaKFjikciN2cSvIh3YX6lJ2Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 512/666] btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()
Date: Wed, 20 May 2026 18:22:03 +0200
Message-ID: <20260520162122.360161404@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 82323b1a7088b7a5c3e528a5d634bff447fa286f ]

submit_one_async_extent() calls btrfs_reserve_extent(), which decrements
bytes_may_use. If the call btrfs_create_io_em() fails, we jump to
out_free_reserve, which calls extent_clear_unlock_delalloc().

Because we're specifying EXTENT_DO_ACCOUNTING, i.e.
EXTENT_CLEAR_META_RESV | EXTENT_CLEAR_DATA_RESV, this decreases
bytes_may_use again. This can lead to problems later on, as an initial
write can fail only for the writeback to silently ENOSPC.

Fix this by replacing EXTENT_DO_ACCOUNTING with EXTENT_CLEAR_META_RESV.
This parallels a4fe134fc1d8eb ("btrfs: fix a double release on reserved
extents in cow_one_range()"), which is the same fix in cow_one_range().

Fixes: 151a41bc46df ("Btrfs: fix what bits we clear when erroring out from delalloc")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 28024c827b756..3e39692e36913 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1288,7 +1288,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 				     NULL, &cached,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW |
-				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
+				     EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV,
 				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
 				     PAGE_END_WRITEBACK);
 	free_async_extent_pages(async_extent);
-- 
2.53.0



