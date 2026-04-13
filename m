Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E115B3264CA;
	Mon, 13 Apr 2026 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099368; cv=none; b=XlxEOQ2Xhol9YfQQNInqITzFmam3m0z0klAyQhCJUHS5Lin75uXy9J6rToaY617BAgs60Ew8EeWKk/btRqau6L6/kZFcVR9Rst9xqF+Eo/PU+Azht08dJKa87YnvXFhBN3U6ZvH/yf1+JgOD9feD6Av9DDSVAufiGcI/IY67320=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099368; c=relaxed/simple;
	bh=305UQ1hAdei7bs41zKhp5ZmHL3znHUpHeuKsFA06cZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/Y3R3is6jTcCjmzz+m1gOkVA7f+B59Mg4nPVo/CdyM05b9lJCcQQia4kwyfJIywJR0gYj0DunaNy5SDfGOQqYz2c4f3Bp6pMyV+XWo+sh+zUXj6sQ30GkrGBwRNSinXKRnM9B7peXcRG1qEp1LflUXCyMmmOV0mBfLJ/YiHXsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdPwGoDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdPwGoDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77012C2BCAF;
	Mon, 13 Apr 2026 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099367;
	bh=305UQ1hAdei7bs41zKhp5ZmHL3znHUpHeuKsFA06cZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdPwGoDFzihdssGcBhd9oUBCqQR0e8yoR3qwuKIYVWjq8FA79C6DVvS1qPSbTXvBc
	 IsbQbmfUUfgT/shKYFf+osUCAG3la2t1eg5zArwY92yU+s3mU48PxkMBGzlDkflJ0Q
	 RNAIBHbp0IwzQcNmzF/b1QlyRqYED7KXtgZ5JbGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/491] btrfs: fix super block offset in error message in btrfs_validate_super()
Date: Mon, 13 Apr 2026 17:59:17 +0200
Message-ID: <20260413155830.721312228@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 29f0ba4adfbce..7a2b91f6cf14e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2548,8 +2548,8 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 
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



