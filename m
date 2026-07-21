Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6344AB7F;
	Tue, 21 Jul 2026 21:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669062; cv=none; b=o+7136EzrD+7JcMVQrFfKwxE/UViFoEyKyRABxP64+O0uImVVRmc8rpMQy92Svm91ewQe1vgEcV7hT3IWqYmSgiGW/qBSdSUjNgtqWTTabx0XxseA2VbntuqSceWShjSqQGnijKIXwyJ2ChWwcoHlCABWX75fGg1HFQUJaG5uCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669062; c=relaxed/simple;
	bh=bYnSeaR+xQcpB+UnC0745KRmBvvyqvYulVCgxEH5se0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7nD+l4Du2IvOpxOAePjdP9pn3NwlJphTgtnrIo8dd2Trx9148NG/Ri4z0CAOGI1x1KZBRHdQg3olwHCIaYgC4vMPSHICYgHcsVCM7VOvov6tO8IudGST2AAe2qpdZm35O26nV3ph8+lzN+eU/44hCynBosJ0D86Ck6Ixm6IfbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQD60crG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQD60crG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED211F000E9;
	Tue, 21 Jul 2026 21:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669061;
	bh=E5Ckl7Ikq+gFShXYpgUpXrCgnEji80sy9G8vMBjlCh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQD60crGfwrFO9bZbCv8AqK1h+5P+sWKNK/o5ffW0qGYu1CIaHiu4tohjpGhSLJTx
	 f4bqhWFZT3XE9RfTAYvJLWX9YKW0uOd94G+lDmB/jgddij921Qa7QgUQKjn7oZxrhv
	 3BawotGvt51McLYqheqYr0dA7IwzKIEXe4muu2Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0411/1067] btrfs: zoned: dont account data relocation space-info in statfs free space
Date: Tue, 21 Jul 2026 17:16:52 +0200
Message-ID: <20260721152433.822579968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 91b19d66449bc1..3b8afd05e37480 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2350,7 +2350,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.53.0



