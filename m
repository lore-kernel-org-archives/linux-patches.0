Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C5A3BB9F0;
	Mon, 23 Mar 2026 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283071; cv=none; b=MvEr4Vlxae4qLZztRG9LyuJm253A1yIcok1KobNA9jB+OvwBCIdCQgIcLGHuaUG8D3SNW8N2S+cqKpLUVjHckQfw6nbtjZXVG4DLXlkByrNxXuUhWwYdEkAPryTMV7AxrbsPOIAxxqRv7SMw8sAFn0emcVO761ljfuXRuBK8P7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283071; c=relaxed/simple;
	bh=SUe4/9PxBy4UVjbMwkXe8gqVrA4+TdmZVttARDyzz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKQhHFPi3oZ7/AHUJJ2ZKjdS7UNCokBMRSCr4iLTL/xSsEKfcbYWpHhIRKDzvcQCySuXlU6k8i2Ly2ECXA2yacj7uoeIw/uDaUYjHj7sp/uGq6TvEvDU+0JgnvovUmwE+QgM+wMs+oJjn6k0E0YwNFsbAI0sb4njEi/E4SkM4oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJZ2a2K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJZ2a2K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB802C2BC9E;
	Mon, 23 Mar 2026 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283071;
	bh=SUe4/9PxBy4UVjbMwkXe8gqVrA4+TdmZVttARDyzz38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJZ2a2K7qFz8UxE3OBjYXjTMZczHvDbocsroBssmkzsxi5WNKoRV/Z9HmXBshfh7J
	 Kp7nTCcUaUQfBq3cvMGU7GUt5QYYF66kpcy9JHs4My+Wy4rXhXnqVDWR2Ai2X6NK4D
	 dQzdJlcz4HMJYBFadxOpu+yv9CiIwS6IEvuaoCcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 391/481] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Mon, 23 Mar 2026 14:46:13 +0100
Message-ID: <20260323134534.685668846@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
[ Avoid leaking the path by using { ret = 0; goto out; } instead of
returning directly. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6289,6 +6289,10 @@ static int range_is_hole_in_parent(struc
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+			ret = 0;
+			goto out;
+		}
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;


