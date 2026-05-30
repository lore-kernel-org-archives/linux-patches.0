Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E4C33F8A4;
	Sat, 30 May 2026 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163020; cv=none; b=C3562uUnj2MqYe6xGO/dEtNFmQdqIhuwLPASKqhvvP9Ztmi3eRkxdtIHk1mJ0RNA4+DIQ346ZCceRvk5qywzTUDQMDgGBlbaYyV1ps7g1iU34IAeqRqi3ZrlU2u6bc/qUiLVD+qfdMiqRH+zPsSsBnyGlzD/mbURxJiiSwvsNys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163020; c=relaxed/simple;
	bh=52rnjJBW4zrC4lSH0ZNbR3BsC/FMQ5F+WUhGmNl4VFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6/09ZmyG2dfFzmUSHb+NbG8oCwq5UOLrtjwWlfbPgxvWmNOEyi/IkWtv142u0HLZPa+5iQI6Snx+Yw2f1zHhpUm1CHv3fGaKKPcSHJ6YoIcaeqSiK24j2ahZzDWf17R0td8+TuP53rNDl5B0qGr4tnNa+oxGTGRsVHdqmEH3vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2IElQUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2IElQUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63751F00893;
	Sat, 30 May 2026 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163019;
	bh=3XUnQKXkT3Z05RodphU4P3ZMT9KiM2YE8YtHyhpimDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2IElQUdSk2Y6ZBtCrU5CHnXPOICMErj2mR8zNDVFEF7FByPsWze7lvLpdrpH29aK
	 yxG4Tygp5XFU+lK2sHMOM+71eO9gsvN+quB38HeifWUruAn5euRDyJ7O2erBuBbcIt
	 JeRkQhcuChlSKnOkNFBmcEVk/qWy8hwqtfxKD41k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 132/776] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Sat, 30 May 2026 17:57:26 +0200
Message-ID: <20260530160243.812822630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5892,6 +5892,10 @@ static int range_is_hole_in_parent(struc
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


