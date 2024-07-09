Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE5627713;
	Tue,  9 Jul 2024 11:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524299; cv=none; b=Jq+48ypgk+nG6OdqTqxVoP0df2X7NPY+QexE0nPii/wjY2r+wo7x08+D/haKFYXNeBsJRWoC9ps4xPacUXclNbJaffIV0PNY+onxSSZDGZDKC7AMg/yGrz5m7nsjDcho/c8t1tMyCSxKvZgZBVTAhlxzSRQoKeUrZ1Gclh/VueQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524299; c=relaxed/simple;
	bh=Ab8hYruwmfrRfNBPWtwx5CLOlayPvvtc7h90BDK0vzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfDsvGeUSrrxt0XQhOO1HeacAZQzpf5R95IKOGZHv6mWzcxSS0myn0XbdgmjRn/HowD9Y+WtF1AdWrusfZj5IRB7f9HFqaLIevxnUFuJZnR75MzXYPw2EpGj6xUi/C83awNZXsBvTBht2gRMmCjVvpbJVeLluZdHtrNa0A09nsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpFw40zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpFw40zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895C1C3277B;
	Tue,  9 Jul 2024 11:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524298;
	bh=Ab8hYruwmfrRfNBPWtwx5CLOlayPvvtc7h90BDK0vzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpFw40ztsup/ddMU0iOK6zIcIH/jg2UTd7N7tHfafvlPtFHvzf1XQDrZeMVQInmP5
	 6Km2RcG03S45wagsnqAElDH4I9RG1r20rtsY1ZFqJf8GzN/oqBQgMpUed0TeUIdPXj
	 XDqxF3XX+EhhTEtVzuAuuSlygQTfKHcqBcII0zyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 138/197] btrfs: zoned: fix calc_available_free_space() for zoned mode
Date: Tue,  9 Jul 2024 13:09:52 +0200
Message-ID: <20240709110714.290423106@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 64d2c847ba380e07b9072d65a50aa6469d2aa43f upstream.

calc_available_free_space() returns the total size of metadata (or
system) block groups, which can be allocated from unallocated disk
space. The logic is wrong on zoned mode in two places.

First, the calculation of data_chunk_size is wrong. We always allocate
one zone as one chunk, and no partial allocation of a zone. So, we
should use zone_size (= data_sinfo->chunk_size) as it is.

Second, the result "avail" may not be zone aligned. Since we always
allocate one zone as one chunk on zoned mode, returning non-zone size
aligned bytes will result in less pressure on the async metadata reclaim
process.

This is serious for the nearly full state with a large zone size device.
Allowing over-commit too much will result in less async reclaim work and
end up in ENOSPC. We can align down to the zone size to avoid that.

Fixes: cb6cbab79055 ("btrfs: adjust overcommit logic when very close to full")
CC: stable@vger.kernel.org # 6.9
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index d620323d08ea..ae8c56442549 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -373,11 +373,18 @@ static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
 	 * "optimal" chunk size based on the fs size.  However when we actually
 	 * allocate the chunk we will strip this down further, making it no more
 	 * than 10% of the disk or 1G, whichever is smaller.
+	 *
+	 * On the zoned mode, we need to use zone_size (=
+	 * data_sinfo->chunk_size) as it is.
 	 */
 	data_sinfo = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
-	data_chunk_size = min(data_sinfo->chunk_size,
-			      mult_perc(fs_info->fs_devices->total_rw_bytes, 10));
-	data_chunk_size = min_t(u64, data_chunk_size, SZ_1G);
+	if (!btrfs_is_zoned(fs_info)) {
+		data_chunk_size = min(data_sinfo->chunk_size,
+				      mult_perc(fs_info->fs_devices->total_rw_bytes, 10));
+		data_chunk_size = min_t(u64, data_chunk_size, SZ_1G);
+	} else {
+		data_chunk_size = data_sinfo->chunk_size;
+	}
 
 	/*
 	 * Since data allocations immediately use block groups as part of the
@@ -405,6 +412,17 @@ static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
 		avail >>= 3;
 	else
 		avail >>= 1;
+
+	/*
+	 * On the zoned mode, we always allocate one zone as one chunk.
+	 * Returning non-zone size alingned bytes here will result in
+	 * less pressure for the async metadata reclaim process, and it
+	 * will over-commit too much leading to ENOSPC. Align down to the
+	 * zone size to avoid that.
+	 */
+	if (btrfs_is_zoned(fs_info))
+		avail = ALIGN_DOWN(avail, fs_info->zone_size);
+
 	return avail;
 }
 
-- 
2.45.2



