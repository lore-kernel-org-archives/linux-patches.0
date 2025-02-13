Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484C2222A9;
	Thu, 13 Feb 2025 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457110; cv=none; b=Us4L0OPTw3TdKSzFU9DlCwFLxLDRy5hblToOSmlWR6Ry1CDwo5Iw5ZYqMYnogecYQ0ge5sHzN8pSwcOVXnE3CZ+irQfHmHIyMXZzAQI1L3yZqD5YYL9g7P1pWxuZWFvNc1WiFmgVMKiPttHxSOZrtYkd8LftH8Kakyitd2iukEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457110; c=relaxed/simple;
	bh=CYGDHDqyzXUdvfxJ5lPo0Vxn+Dd7mtytRNjBu2qsO4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsOzV/hXIQH3LuiT61Flvq1wxIt54Nwv5mZKssyZTVSiozH9v1SFPEoMdtobtTYDuV6MMEFdKt3W6I4z/QB34PU90jBgrqFXere6os4sxFWRHczK3gNeuo8UJ0wopV36IWDAg0dsJWAmjutDUni6Zp9GcY0R53EwLZXDP1KDjwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdjB2o7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdjB2o7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FCBC4CED1;
	Thu, 13 Feb 2025 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457110;
	bh=CYGDHDqyzXUdvfxJ5lPo0Vxn+Dd7mtytRNjBu2qsO4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdjB2o7MJxJT7mBTFPJb6ERH/Z7tXJMAUIziFQXAXXzdGKCIXxbJwG2W8SO8oAZUE
	 lL3xR2fSOUtGJ1/9k+TBGEYB07GcBaxdR4M10iFmfMK8PVtG9tmJ6clIfvi6I6jdKZ
	 ZgVQcB1MhgcX3AoihfXyBCn+9kLqWRARegYhVL+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Shand <jshand2013@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/422] btrfs: do not output error message if a qgroup has been already cleaned up
Date: Thu, 13 Feb 2025 15:22:32 +0100
Message-ID: <20250213142436.550783337@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
index 4fcd6cd4c1c24..fa9025c05d4e2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1916,8 +1916,11 @@ int btrfs_qgroup_cleanup_dropped_subvolume(struct btrfs_fs_info *fs_info, u64 su
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



