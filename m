Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2B81AA1F4;
	Fri,  4 Sep 2026 05:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498898; cv=none; b=dPl2Oy5Yfw3IC+0qmRueRcPgKCOqMZN3ypyapdhLty5yUund1brG5w6IErU42lT9tGGnSnNP444N//xGcmfYaRMczq8Y7aIKXod9x6BSssbPVOdMNvgjK05HqsJY+txDJSK2c43kZyFI1Up3BLmQBtv6PgMzgS3DpLXf164UurQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498898; c=relaxed/simple;
	bh=utaD6PvfdhneOQfp0AXK1lQWnfAZYw7ILByc+gd/yG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3h0MXnEnVqWzGF3tw9oIgSI5mSC4mb4WuvQpXbg1SKG/hF3CqovVsARN0xnYxps/p/RVZ+wQ96IT2d3Um57kbIAA80CVCxsEr5SmECft36J6imEqWfSuEJuSleiTK68MQis62vwMJu/jGZX8WyRcd8UmnGKgBbYqWKiSdYB6tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khYdamlo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khYdamlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1131F00A3D;
	Fri,  4 Sep 2026 05:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498897;
	bh=MpvUZld9brctCdxVBQGzUHWRneHgIDSHa7KrOLjT1jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khYdamloYb6mJXi0cmqnxKRXztWxHlRdTvfqynMijBhcAjhHhKLz7quQ49N6XkBWZ
	 Ctrx1OJxDJnZXv/2YpJINbl9tr4IJQS+8LrkcnfPyngcmuJd2GQedkR+mt4RQD3fOy
	 T/5iGsOPiKUeosivUr6evGBCHsjBfk/6qCbxtYf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 227/713] btrfs: fix extent map leak in NOCOW direct I/O write
Date: Fri,  4 Sep 2026 06:53:15 +0200
Message-ID: <20260904045808.909889822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 3f950867c307c5413d628a153ac44915bd117ffd upstream.

btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
extent map reference that must be dropped on all exit paths.

For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
keeps using that extent map and asks btrfs_create_dio_extent() to
allocate the ordered extent. If that fails, for example because
btrfs_alloc_ordered_extent() fails, the function returns the error
without dropping the input extent map. The PREALLOC path avoided this by
dropping the input extent map before replacing it with the newly created
one.

Check the error from btrfs_create_dio_extent() before replacing the
map and drop the input extent map on failure.

Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO writes with fsync")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/direct-io.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -281,17 +281,24 @@ static int btrfs_get_blocks_direct_write
 		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start,
 					      &file_extent, type);
 		btrfs_dec_nocow_writers(bg);
-		if (type == BTRFS_ORDERED_PREALLOC) {
-			btrfs_free_extent_map(em);
-			*map = em2;
-			em = em2;
-		}
-
 		if (IS_ERR(em2)) {
 			ret = PTR_ERR(em2);
+			btrfs_free_extent_map(em);
+			*map = NULL;
 			goto out;
 		}
 
+		/*
+		 * True NOCOW writes don't need to create a new extent map,
+		 * while PREALLOC writes must replace the existing one.
+		 */
+		if (em2) {
+			ASSERT(type == BTRFS_ORDERED_PREALLOC);
+			btrfs_free_extent_map(em);
+			*map = em2;
+			em = em2;
+		}
+
 		dio_data->nocow_done = true;
 	} else {
 		/* Our caller expects us to free the input extent map. */


