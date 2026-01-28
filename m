Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09670280CF6;
	Wed, 28 Jan 2026 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613901; cv=none; b=RoQv3QGXWYBOMLAzOEfNUtlIXT0mazWGSQqq5gGQsNhZZmRI27lHe4iO7J8UW8S+IMpegisKNd4vljYxON98zU9NxDWms32rV4QrGLAP02nw0dP2WBFwyL7JOdegkOTBssW3lP5kV2oDtjY1JTXFaxw9wGn6+Yl3ip0kQV1DslM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613901; c=relaxed/simple;
	bh=bfdM8JsV9Yd6YhUgMTlZLRRaWuXgXrUwc6plDxpSqKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzqtEnPZPKNoNFTWEEMuRFMnFxC0BhTRwI+4EYY4O64kpEv+2ZdLZJmSYT/9HYMOud38rs80TD7g76qCwIEI6GghiuHMmTL93PI57C45Kq3lbha37l3dANAmVtHkDvKQrsecLHqi8jVxW7w7fSSPbTwqb7gBW0LglHMkZ/NJWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgXw9kE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgXw9kE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF9FC4CEF1;
	Wed, 28 Jan 2026 15:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769613900;
	bh=bfdM8JsV9Yd6YhUgMTlZLRRaWuXgXrUwc6plDxpSqKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgXw9kE6Gczm4xwDAWZZ1km2ccXfBUsvk5Br0XkKMqD/kChFoIAxer+lNyq1qLJvm
	 21QMKSbQMFBBxXdkVfg2IzbVV+TOH6pcYHeMPb79+oHPo+KULUNvKF49oAnGdRrm3+
	 ewMHHkHthnQdVDV8QBLyYPmtPMN06Rav9Fq/xn/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/254] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Wed, 28 Jan 2026 16:19:46 +0100
Message-ID: <20260128145345.076369354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

[ Upstream commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 ]

Before accessing the disk_bytenr field of a file extent item we need
to check if we are dealing with an inline extent.
This is because for inline extents their data starts at the offset of
the disk_bytenr field. So accessing the disk_bytenr
means we are accessing inline data or in case the inline data is less
than 8 bytes we can actually cause an invalid
memory access if this inline extent item is the first item in the leaf
or access metadata from other items.

Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole writes for sparse files")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c25eb4416a671..6768e2231d610 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6545,6 +6545,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
+			return 0;
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;
-- 
2.51.0



