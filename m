Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979F381728;
	Mon,  6 Jan 2025 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178957; cv=none; b=IqoIAfygIwoWGPZx/e8Awx3vbivBffcf2LTjNLHzWAjIkgaeG92LF/aRTBaJNcfx+cREvnRnXCJCkFJdAQ1ZeVgxx4zVH3M8ZL3I15eCXmYTOSWOg/wjyOB9kOvnApo+2bAdSQM+scWQ7I43+q1P5i0QUO71izFaDPD9KGx8Ikg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178957; c=relaxed/simple;
	bh=+oaG/P8PasBUYcAFQuKIMHA8VpJ6bj+ZE2IowJvyaTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACfrokGKq3GptpHzjGh2/N30OjpCnuMx3tfy+TO+540cmUQqRWkVMR2PWwYhN1XDZjTQ+Lx9yFbYTq2/TrOImrs+tcRNiSTPdqwFKKl7BMI1i332xu1gfZve21skV6+aX5niCbjNC0dnRM/pTmUOuhL44Wj2n4P94L4eH9D0HNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1Na9BPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1Na9BPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211E6C4CED2;
	Mon,  6 Jan 2025 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178957;
	bh=+oaG/P8PasBUYcAFQuKIMHA8VpJ6bj+ZE2IowJvyaTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1Na9BPoAACoNbbFjq/NVCfmhq9p7PwIpDTfNsrckzaqE6xONqEkb+LUA99iI6Pq2
	 xcl5GYCcI/j0TwkiOs+GHLsBYnwfpPjEJF1+lH77Ys/FtFNWHdb85H56w24BkfhxOi
	 iDtF91POGaIy2fLnIiivFFblf/dwyv5e7eV5/Dzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/168] btrfs: sysfs: fix direct super block member reads
Date: Mon,  6 Jan 2025 16:17:36 +0100
Message-ID: <20250106151144.026621568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit fca432e73db2bec0fdbfbf6d98d3ebcd5388a977 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index bc8d5b4c279e..6f7f7231e34a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -821,7 +821,7 @@ static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->super_copy->nodesize);
+	return sysfs_emit(buf, "%u\n", fs_info->nodesize);
 }
 
 BTRFS_ATTR(, nodesize, btrfs_nodesize_show);
@@ -831,7 +831,7 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->super_copy->sectorsize);
+	return sysfs_emit(buf, "%u\n", fs_info->sectorsize);
 }
 
 BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
@@ -841,7 +841,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->super_copy->sectorsize);
+	return sysfs_emit(buf, "%u\n", fs_info->sectorsize);
 }
 
 BTRFS_ATTR(, clone_alignment, btrfs_clone_alignment_show);
-- 
2.39.5



