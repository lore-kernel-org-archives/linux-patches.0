Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F831F99D;
	Tue, 31 Mar 2026 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976981; cv=none; b=BhvUPtpRcaXfEX4NPH6CABFQ1TNkYZ4ajvO7dIbJ4EDvIvT47SH/riBZI50UBPeQsfkMhfBIPrhqjFgAc9Fn9RGblEpIOOe5Maan1FMtKgMoGpo82w72Km8l7g+ZDvavEhKnagcZckiYAnf+jdMXPyeU93E7JlUH5qwI13GQv6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976981; c=relaxed/simple;
	bh=Us/YJY0mvr0H2O9ToGxGlhwshUE3T7CekMdlAkInk1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOCI0sVF96AAjzpukAe2vuMF1C4VaCFGT4YTnlSIZwFH4nWQj9DMvAPY7z3s8pR/S1nfLry1Cnj0yindzckhYtEGXog4W8F7auR/Pb9nZfCmjc5L6LGzcjW8mz7awz0yMm0LaFkDXfLeca58nxWxmPiDkfwF26D1or0HwQ3JiUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKvf0A7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKvf0A7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B64C2BCB4;
	Tue, 31 Mar 2026 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976980;
	bh=Us/YJY0mvr0H2O9ToGxGlhwshUE3T7CekMdlAkInk1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKvf0A7e7dmcCfLRZvKCHuB+xTSYTnphtVU0H24cKi23AKipEStb4PKpL8x0QJVxd
	 09/SD8p1R1MoUKrBF804MuLb5ppgjt+a4sgs3URbAsfy5y4P2+o3tF90gafBZqN1JC
	 mWfo3B1ZOyuM0H7AfY8d0AZhC0yWs0NEVt+e436A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/309] btrfs: fix super block offset in error message in btrfs_validate_super()
Date: Tue, 31 Mar 2026 18:23:24 +0200
Message-ID: <20260331161804.645707100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9c3a944cbc24a..0f87f30c8dd27 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2513,8 +2513,8 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 
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



