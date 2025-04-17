Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC42254B1F;
	Thu, 17 Apr 2025 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916031; cv=none; b=pQil+ofgIYeUHx98+bK6g4Ge8vpkxdCXtYm2RVUJtXgLS82MBWhHZrgVHiM8CthBrXGaF8lBIfPuDsCrR86ANiQYiH4xQ+wvyUEWvm0I57n1NVY6NjBo8UzEnJwdXKbvPX8QUx96/2rFEbObVCOnhJgaRu33rfs6y2hnnbuoOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916031; c=relaxed/simple;
	bh=vFXE0dQ3gcXYbXJp07c8Gia6W8W/RNnLt8PjBIznn4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N742AFQRx/Fd2v3xTbuFiwh5BBMnNCejBEiZrvQy1nsIUsXn5e86tjdGNQUOfPSYSU+6ltUe5ZaRz4yHqD5bXSnGtsnbdLhnRRgiswjEdbBBvedK0KJoy+UYy4HiRGhP/kxgMMPYUmAEQ4mjmAo334HEgTzICzcc015Olf4sNyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtnMiW4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtnMiW4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA16BC4CEE4;
	Thu, 17 Apr 2025 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916031;
	bh=vFXE0dQ3gcXYbXJp07c8Gia6W8W/RNnLt8PjBIznn4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtnMiW4xNd4fIgnHbm3CCu0v/y0YkuonKW7akCSP90ttTiaixeicN81hWeVCjZQ3k
	 kX4Mu5lwCOLOEyo3T06T69df5CJZxp2kBe/dimwCvOu8Ah4DZWw0pJjxOjh+hCxkLa
	 nSzO7wsLzZ6SeUXsNu3ojgrVQdM/+DpYG/UQ+X7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 291/393] btrfs: tests: fix chunk map leak after failure to add it to the tree
Date: Thu, 17 Apr 2025 19:51:40 +0200
Message-ID: <20250417175119.319092602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 009ca358486ded9b4822eddb924009b6848d7271 upstream.

If we fail to add the chunk map to the fs mapping tree we exit
test_rmap_block() without freeing the chunk map. Fix this by adding a
call to btrfs_free_chunk_map() before exiting the test function if the
call to btrfs_add_chunk_map() failed.

Fixes: 7dc66abb5a47 ("btrfs: use a dedicated data structure for chunk maps")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tests/extent-map-tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 56e61ac1cc64..609bb6c9c087 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -1045,6 +1045,7 @@ static int test_rmap_block(struct btrfs_fs_info *fs_info,
 	ret = btrfs_add_chunk_map(fs_info, map);
 	if (ret) {
 		test_err("error adding chunk map to mapping tree");
+		btrfs_free_chunk_map(map);
 		goto out_free;
 	}
 
-- 
2.49.0



