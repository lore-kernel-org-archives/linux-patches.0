Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC583B1034;
	Tue, 21 Jul 2026 20:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666036; cv=none; b=nuTEJToLWsjzAjlq9QFEuBoV62xPpyaABAXTUX0/++0otIoIRZ/Ii6ZtC4jreul2s0N+TTWSf+MWFzpNpgBvl44fxPdK74D7rFfQ+te9wra57en8YBlaPqgIGBQ1BZ0dz+lIdee0Ws6B6YmtqZHWsjGqoHSRNxjqdMnXL1dvofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666036; c=relaxed/simple;
	bh=SzkeTHkFqor2e5xVmmqdXB9dFsOBW4+XQHsQJZtw9l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIy80fulk3BKXlQhKru/YZPVuF4boZXIL185htf6hTkIpcPYLys903X5/vMbJOMNcF2QxCpjX+NqdkwgvgymEb9kNp1s9QF3WWTT60crNi62Mj0vdeYWa36o3cnJaZ9qkhVMSzww2U4z9u4WUYnHovJjYbrPMQgpI5tEWmrW2wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y37gJB2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y37gJB2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D60B1F000E9;
	Tue, 21 Jul 2026 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666034;
	bh=S1Q/5rSm8ymRDyuWDaJp9j3tQTyiZTGaE6uCOLRqRcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y37gJB2W+HAla3PWrVhquxnW/Gh6gXe4oxTQHDiw05TqDdSFNGsHaMzO3+lymhIc7
	 Y348qRwdfxIFQWEgT52QgKmA2cFfoonbOoKZ5RFQUdnMUEFACoOITNFK0dQQXKW1EM
	 Y/0wOQUxD+3GzHnoqhmlDU3Q/OfpaRp9tCoQsnsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0530/1266] btrfs: zoned: dont account data relocation space-info in statfs free space
Date: Tue, 21 Jul 2026 17:16:07 +0200
Message-ID: <20260721152453.718158438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 52416a27aabc43eab3792fd0ca9f5dabeab58f31 ]

Don't account the free space in a data relocation space-info sub-group as
usable free space in statfs.

This is misleading as no user allocations can be made in this space-info
sub-group. It is only a target for relocation.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2045ac3d94c4df..671f1eb26ec658 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2048,7 +2048,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.53.0



