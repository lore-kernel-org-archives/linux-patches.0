Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891C646EF71;
	Tue, 21 Jul 2026 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656648; cv=none; b=XVcQOCqWJK1t9RElcCIhJL1FjD6+G1VhPbCU3zBd/pMIcw31GXEhSpjJ9I20mO0aJkIn8NqVdiEBjjonAiuuP4lxT0piK8yX/oT0waVU0hCNUFUjDlhN0sZecqb9nugvVeFY+Z8cSMSf4L/7BdgwrWUISbHZkC9Q4bGSEgkB84o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656648; c=relaxed/simple;
	bh=KITh/F1LIhTEXeoi14K52HGdXjL/dZYQln/xlTOT5F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMzbVtG2cyPYUU9u8/QP/u74y5Kn4Fo8EhSLYE9KDVXxf892QOzC+IR8AeHnSrsUZ91mskFwb+60Bq4TLDQzLHX+eM/LXkya/cTDNKGH1R45oCeUxvWAtXXU2I/RHDQempO4tMhhdSXmGasbCwinwPcxfnXEdQ2bcZ5/TxMREeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y3RRgYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y3RRgYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0B91F000E9;
	Tue, 21 Jul 2026 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656647;
	bh=qDRaa1rs/8LJxxyqaVDh8oKub/B0qPyjQqAYdnKScQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Y3RRgYTQJjCFRa8G5PsXGbnwvuLFxefoI/3MUi+FUHnT1zLck2dsm46h42H7DOaj
	 bNIhm5GK3HHLDZNXrT2bNSLqMvmEgP1YowDxmyQ/yqgIrLbLDUtHb5RZcZtsvkhRQo
	 U6aOp6puCQyHG8xLvlXrE5rw5Wfx9jin+3DFi278=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0423/1611] btrfs: zoned: dont account data relocation space-info in statfs free space
Date: Tue, 21 Jul 2026 17:08:59 +0200
Message-ID: <20260721152524.782765936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 35903afdd1e5b1..736575f9251794 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1741,7 +1741,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.53.0



