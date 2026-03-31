Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206D925D527;
	Tue, 31 Mar 2026 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975532; cv=none; b=PQ7I+0CwOwf+OGujJ/j52O09wgScSEe0cxo3zTPALFPi7Gadp6IRt62oGL38i6klYrH/gZpjXzYfJrcPRQpj/S77al4vQkpuQd2qy9Vm2hqzaSz5vvDuq7P/SjsIXEaLp50rpiW+xjRvqxj9aCsYrXKSyPHDg7m+wlbXjit/9vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975532; c=relaxed/simple;
	bh=GCOnJ4FUex5IWqgAkSYDXCQgO9tDXf+j7YqCe3OrLYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6Hnr4JuH6wAGf6QRGG8kdYcUfTjXdicpgPlDuniTvjym0A1sG0HiBxWfWQlN7jcR8rXSyAX4pMBnRV1Rg/iQHGhdAQuylkrO3kYtD4ZlkVR28PfBFMf4FkyVKi1pZF2HRQzJKeY8sFkDxMeivALRMgCBDtZqLS0VZray5quddI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRSUTj8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRSUTj8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99E4C19423;
	Tue, 31 Mar 2026 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975532;
	bh=GCOnJ4FUex5IWqgAkSYDXCQgO9tDXf+j7YqCe3OrLYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRSUTj8TBGwyJGEZ3yDvF0vw1xMNHaFdr9CnWkV5uBfcwExHqxaccTbp/UbpAeCom
	 B5YOPART1ha/iQFCdZMr7zlneQL5hARvIbsznXQ7r/5lzsOHzTn5qWl/J17CJ2ef0i
	 j9xDw54U+AcR7bk3j7P1EsOPjENtC55zlUD3uKNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 331/342] btrfs: fix super block offset in error message in btrfs_validate_super()
Date: Tue, 31 Mar 2026 18:22:44 +0200
Message-ID: <20260331161811.085655883@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit b52fe51f724385b3ed81e37e510a4a33107e8161 ]

Fix the superblock offset mismatch error message in
btrfs_validate_super(): we changed it so that it considers all the
superblocks, but the message still assumes we're only looking at the
first one.

The change from %u to %llu is because we're changing from a constant to
a u64.

Fixes: 069ec957c35e ("btrfs: Refactor btrfs_check_super_valid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d2dcd023cc6f..8df7eb7f01e90 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2503,8 +2503,8 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 
 	if (mirror_num >= 0 &&
 	    btrfs_super_bytenr(sb) != btrfs_sb_offset(mirror_num)) {
-		btrfs_err(fs_info, "super offset mismatch %llu != %u",
-			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
+		btrfs_err(fs_info, "super offset mismatch %llu != %llu",
+			  btrfs_super_bytenr(sb), btrfs_sb_offset(mirror_num));
 		ret = -EINVAL;
 	}
 
-- 
2.53.0



