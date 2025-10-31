Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4621934D387;
	Fri, 31 Oct 2025 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919317; cv=none; b=SJLyC26fhoa5dVkegsB00udNa4u0b8ggagaoMyp7WLEuyXoCXViWNiVViUP3YbsAtbaF3Tt3NpiwcH6vKkgpux0MM/jipUHoVpj3GW0vcx6jyUQVWYFy2MZjxi49iUubiQh+XPrnKkeSw8Vo4CL7OTNkPM+nL4Yk98P2HOQN2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919317; c=relaxed/simple;
	bh=PEyEdkNCsUsLxy1zZRCKlciP9Z2fjWECMJm+dI8SyJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiIblCodrxDN2IxabnemYr/2Ec6JpF9DQvKZ1tEe81smhV2KNbkl/GuQUfaBXnF9zqBR4NL7BgfVdBywFx51x/ah9lZcX0kC9Uah0yh+yY0MnGvgFCB/IA0JkM9EdCTGqCEVZUHwYAxu6wYGr77AEdNLqAsCiICmtM83HtFrW6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFOK4KE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFOK4KE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FF0C4CEE7;
	Fri, 31 Oct 2025 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919316;
	bh=PEyEdkNCsUsLxy1zZRCKlciP9Z2fjWECMJm+dI8SyJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFOK4KE1+fG9fJBgFvlXSXOU1QHQ+iFqVuSt/ePj0XjYGWPC65n+BN66fbIMg9W3N
	 +YJvci2Bzr5GAJVg/I1zxd3Gha+EKIrvFbYx2aU9Vlb13ZrY+VBeOq6ihGBXc0+Ww/
	 XVqTwCeWKa4Wh4jcumr8l766p+BENK8RY6biKfTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/32] btrfs: zoned: refine extent allocator hint selection
Date: Fri, 31 Oct 2025 15:01:04 +0100
Message-ID: <20251031140042.663727707@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 0d703963d297964451783e1a0688ebdf74cd6151 ]

The hint block group selection in the extent allocator is wrong in the
first place, as it can select the dedicated data relocation block group for
the normal data allocation.

Since we separated the normal data space_info and the data relocation
space_info, we can easily identify a block group is for data relocation or
not. Do not choose it for the normal data allocation.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8248113eb067f..5e3d1a87b7e9d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4175,7 +4175,8 @@ static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
 }
 
 static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
-				    struct find_free_extent_ctl *ffe_ctl)
+				    struct find_free_extent_ctl *ffe_ctl,
+				    struct btrfs_space_info *space_info)
 {
 	if (ffe_ctl->for_treelog) {
 		spin_lock(&fs_info->treelog_bg_lock);
@@ -4199,6 +4200,7 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 			u64 avail = block_group->zone_capacity - block_group->alloc_offset;
 
 			if (block_group_bits(block_group, ffe_ctl->flags) &&
+			    block_group->space_info == space_info &&
 			    avail >= ffe_ctl->num_bytes) {
 				ffe_ctl->hint_byte = block_group->start;
 				break;
@@ -4220,7 +4222,7 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
 		return prepare_allocation_clustered(fs_info, ffe_ctl,
 						    space_info, ins);
 	case BTRFS_EXTENT_ALLOC_ZONED:
-		return prepare_allocation_zoned(fs_info, ffe_ctl);
+		return prepare_allocation_zoned(fs_info, ffe_ctl, space_info);
 	default:
 		BUG();
 	}
-- 
2.51.0



