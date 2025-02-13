Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B14F26B095;
	Thu, 13 Feb 2025 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458619; cv=none; b=eMugeRcx9h8BjH8QPVxGcVgj8ZJJXFRg9hreFnILbkanbwdPFYsoq4OMk9AwtakPmPbrQiUs6bRufH26N70kZOXd3DNktptPWdBdsd357XAbubo1Xbv0gjicEt9dojka8nmPDbtFY3mKSeGyVZJZXsWbsIUt0lL64t6zG++r5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458619; c=relaxed/simple;
	bh=mWDeOZ2b8QlRFEBnxLSILHPc8kZtRm1yXPqlzCbmCaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1T/SvzM/KWuldvV/duyh4cs7bJ1YCUF616R9x2cX+ghRTG8qvu9Itt6o686pl9r3i70Io+49uw6w+qtE2alJsdO+SwqjJb0AvMGPPwSpzN2Dikh7mApOX4hu/B7NHbVo/ZwA4z1CPK8XMap9nIxsvbBlA+J9MkuBEyVIksTm4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqaGt5W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqaGt5W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CED3C4CED1;
	Thu, 13 Feb 2025 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458619;
	bh=mWDeOZ2b8QlRFEBnxLSILHPc8kZtRm1yXPqlzCbmCaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqaGt5W4SfT6aw1dgA+/3JZYSsKppYzWRleFq+nlQsIb/4ypLFIzUoMTmUUznHrAb
	 rY/0nDvIHwJ4W6CtmrolG5ul6uaShnImu67xjcW1vbMwQt0HNS28LCR4lYJa+FB8Z4
	 nvY74y3dlaIMRbgP6TG2kudNd5uT6OcDG9R2aoYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Shand <jshand2013@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 004/443] btrfs: do not output error message if a qgroup has been already cleaned up
Date: Thu, 13 Feb 2025 15:22:49 +0100
Message-ID: <20250213142440.786555573@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit c9c863793395cf0a66c2778a29d72c48c02fbb66 ]

[BUG]
There is a bug report that btrfs outputs the following error message:

  BTRFS info (device nvme0n1p2): qgroup scan completed (inconsistency flag cleared)
  BTRFS warning (device nvme0n1p2): failed to cleanup qgroup 0/1179: -2

[CAUSE]
The error itself is pretty harmless, and the end user should ignore it.

When a subvolume is fully dropped, btrfs will call
btrfs_qgroup_cleanup_dropped_subvolume() to delete the qgroup.

However if a qgroup rescan happened before a subvolume fully dropped,
qgroup for that subvolume will not be re-created, as rescan will only
create new qgroup if there is a BTRFS_ROOT_REF_KEY found.

But before we drop a subvolume, the subvolume is unlinked thus there is no
BTRFS_ROOT_REF_KEY.

In that case, btrfs_remove_qgroup() will fail with -ENOENT and trigger
the above error message.

[FIX]
Just ignore -ENOENT error from btrfs_remove_qgroup() inside
btrfs_qgroup_cleanup_dropped_subvolume().

Reported-by: John Shand <jshand2013@gmail.com>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1236056
Fixes: 839d6ea4f86d ("btrfs: automatically remove the subvolume qgroup")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 993b5e803699e..5ab51781d0e4f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1915,8 +1915,11 @@ int btrfs_qgroup_cleanup_dropped_subvolume(struct btrfs_fs_info *fs_info, u64 su
 	/*
 	 * It's squota and the subvolume still has numbers needed for future
 	 * accounting, in this case we can not delete it.  Just skip it.
+	 *
+	 * Or the qgroup is already removed by a qgroup rescan. For both cases we're
+	 * safe to ignore them.
 	 */
-	if (ret == -EBUSY)
+	if (ret == -EBUSY || ret == -ENOENT)
 		ret = 0;
 	return ret;
 }
-- 
2.39.5



