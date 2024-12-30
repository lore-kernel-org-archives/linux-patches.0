Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3E815E8B;
	Mon, 30 Dec 2024 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574332; cv=none; b=k3StvVP2Qg6BZQmlxp7f8y+LCNOGWNtyA3s+IBqFaXlDA4mY2U2mAUi+YLO258zk+Y/ahJavOJ1GlS5djwMEyk27+jaed7b073RzyAPuPYFLTk/m//wpxOOtOa5zZ1L1bM4FUvo0utL5Elk/HZ4x8ZZBh99WOy3tZcW/5AsPXc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574332; c=relaxed/simple;
	bh=g351FXyve8MjaYwDJ7M11rU5aAl3L52yKI0ducSuMYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiUr8xLcP8G+23Sybvw9FF3wgtOV2715LYvbrF6rwCoIAgF/0dkgAbMQK8L44XuQotxAPBAhu7X7TczencDzFeCHK9P1EZuYD1SUFAtuvkCR58Oi3IcYb1hyo0fDxPc+/jFJSZphBCJDNWT4JD8bBve9eeUP+b8Xcmy0D2wlL8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+CXjlv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+CXjlv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF57C4CED0;
	Mon, 30 Dec 2024 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574332;
	bh=g351FXyve8MjaYwDJ7M11rU5aAl3L52yKI0ducSuMYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+CXjlv+NBfFs/+kTuAQQ9Rgh1HIgtP3ToHCvP0yID11qbQ8EbUD4cwEy9z/IbpqF
	 +af1I5op4Jyfczxp+gfIEryif+DYh56ipzDW5jgtVnX/Eyb/Dt2r5jPuVFCoVvadxm
	 iqymL5JlnYbzXcb++6yf1er6HdVpLzLSwtLjjeAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 105/114] btrfs: sysfs: fix direct super block member reads
Date: Mon, 30 Dec 2024 16:43:42 +0100
Message-ID: <20241230154222.166670223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

commit fca432e73db2bec0fdbfbf6d98d3ebcd5388a977 upstream.

The following sysfs entries are reading super block member directly,
which can have a different endian and cause wrong values:

- sys/fs/btrfs/<uuid>/nodesize
- sys/fs/btrfs/<uuid>/sectorsize
- sys/fs/btrfs/<uuid>/clone_alignment

Thankfully those values (nodesize and sectorsize) are always aligned
inside the btrfs_super_block, so it won't trigger unaligned read errors,
just endian problems.

Fix them by using the native cached members instead.

Fixes: df93589a1737 ("btrfs: export more from FS_INFO to sysfs")
CC: stable@vger.kernel.org
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/sysfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1118,7 +1118,7 @@ static ssize_t btrfs_nodesize_show(struc
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->super_copy->nodesize);
+	return sysfs_emit(buf, "%u\n", fs_info->nodesize);
 }
 
 BTRFS_ATTR(, nodesize, btrfs_nodesize_show);
@@ -1128,7 +1128,7 @@ static ssize_t btrfs_sectorsize_show(str
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->super_copy->sectorsize);
+	return sysfs_emit(buf, "%u\n", fs_info->sectorsize);
 }
 
 BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
@@ -1180,7 +1180,7 @@ static ssize_t btrfs_clone_alignment_sho
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->super_copy->sectorsize);
+	return sysfs_emit(buf, "%u\n", fs_info->sectorsize);
 }
 
 BTRFS_ATTR(, clone_alignment, btrfs_clone_alignment_show);


