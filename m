Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73D42DA53;
	Tue, 21 Jul 2026 19:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662033; cv=none; b=YI7V2ikmhidhvc+1YF560fEj6nHai0/YMhiKrhx+YKQMKJ/JB3s7MaTquSV2lVqC4UwRPI1Hk0LQIHtctPt+40MI5YjT2ZoHSD6pjk/KRKjML6xIilYkn72T99PhhrpmkatJ1USYEabbVinPUspwIAqGflwTExR6c/Jovq0A8FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662033; c=relaxed/simple;
	bh=Rvw4Cwstd5SOBDPC315vGpX0mnQ2+TMaRDnZa7A3A+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoCiPGDTXTStC8lrZCZcpqOf4Pr8Voeh7n1wvo0/7Q3ISt28RTeLr6oZxMlywVVc0zSalM3QekGERIpNoY+AnNizTtDlE9d2gMez2t0e0TAI0Puo4l2AF/QcoxYuCbIOffE0rjS2mFEwEW4Z7pe+zX1o+H1vVq4X6grQ2rSMzpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/RCdrK7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/RCdrK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08481F000E9;
	Tue, 21 Jul 2026 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662032;
	bh=/+7CwpjCY23Ng3JnTXJ9uojKCv3ZFkCpEYc8iYALa7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/RCdrK7K7TYnMQCCkLi704Wcn9hMgtuKiRjDRq3EH4sS/XKN+vx7oxMPf+t4hUS7
	 zEsQKV8C4kpRQXXeS70KmFYdFSt6RWqCkkcHUMGFDHv7sd8v0Uca+4ctZCvn0S1wcR
	 s4WChrFWhawqH6QBQPZnRtjXwrFWWq4N+Dp+NrDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0292/1276] btrfs: zoned: dont account data relocation space-info in statfs free space
Date: Tue, 21 Jul 2026 17:12:15 +0200
Message-ID: <20260721152452.623911475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 833602511f62d4..21419bc33863be 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1732,7 +1732,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.53.0



