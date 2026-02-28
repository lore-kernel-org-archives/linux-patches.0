Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CAE371449;
	Sat, 28 Feb 2026 17:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301470; cv=none; b=b89MD9oAeIWlBzGZRYZnw0WAuA/f9FJOWVIP/6AYYvEqiYxdaZ6W9k6IUdT9L7CBmc+vjgzVW4pxaKtBGWtlTQP8ZwymK3jTbIPYApUSk/1/l5NnQteJHLbx0jSzq+letdjyYxrNj3mZksYJpyObDfSvkivwNdpEdU1T72msRs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301470; c=relaxed/simple;
	bh=BtSpHfQMzoFDLttl9VVIBoTEmBefOt+s2VRPaJJlC2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoFmEM9icv/x33f4kJJHuqW4xRlJleU3JAbQBhjyZ6bZSYeLIlU9vm7x1e2Rwob8aYJzk5MvKu3vJsUI4z8y1Ms6G3DwsCWNDXFZKkGy3DEYQpORoy0b315yFq3BR22n/BAhL8eySTaHEyl4TTs941kGDUmp2zvgTqPZBnlMqqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBbGdHAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBbGdHAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E26CC116D0;
	Sat, 28 Feb 2026 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301470;
	bh=BtSpHfQMzoFDLttl9VVIBoTEmBefOt+s2VRPaJJlC2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBbGdHACi3S5HM0NSFXVdf8QE5sgP4CX3/NzpmFH/1uefL9yoKljjWQZI+SdUBiSn
	 Q2dxus4FgbxY3yf0I1n+oPMkbqxY3+kjgsi2UZVtVYJEu0cbm7htA3UqHHQjOzSEtN
	 hgzO0whPBioG46DlWSx/nruz5c5igy+hlvC0Md//+fcB9VHytfC7jUNNOaiCpkpspI
	 3/ghdZcLuWiuYCWQYgVblVuI65k2pvUym32qgnNZciFxgzmsFb26OcIFIKn9HrdmQ5
	 7apVJHALvYdNduYw5xrI6zKMsBHlN4fAZCvxCKCeTsxI3Vz+GWazLQwC6Bfq341p4U
	 9ojVI6Ml7a6/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: jinbaohong <jinbaohong@synology.com>,
	stable@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Robbie Ko <robbieko@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 655/752] btrfs: continue trimming remaining devices on failure
Date: Sat, 28 Feb 2026 12:46:06 -0500
Message-ID: <20260228174750.1542406-655-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: jinbaohong <jinbaohong@synology.com>

[ Upstream commit 912d1c6680bdb40b72b1b9204706f32b6eb842c3 ]

Commit 93bba24d4b5a ("btrfs: Enhance btrfs_trim_fs function to handle
error better") intended to make device trimming continue even if one
device fails, tracking failures and reporting them at the end. However,
it used 'break' instead of 'continue', causing the loop to exit on the
first device failure.

Fix this by replacing 'break' with 'continue'.

Fixes: 93bba24d4b5a ("btrfs: Enhance btrfs_trim_fs function to handle error better")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: jinbaohong <jinbaohong@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a48ba97bb3694..08b7109299472 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6601,7 +6601,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
-			break;
+			continue;
 		}
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.51.0

