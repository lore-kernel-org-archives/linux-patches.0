Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8BA49659;
	Mon, 14 Oct 2024 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919949; cv=none; b=gAM/y0g32Xa89SaAojHwvIyruyQ4uAPC5cs6IeyRUq1cTO2iVKCu71FsJ8Bp6Xp9Bl3wz1ZODFKOW0JgKEbk99Eh8Ys1ct+9EM6EJHUXLyvPOmoOoKTVgizt8kCd11hQ4ravOOMAm9wUZdcXzxQ3woj5BWo+36hu1q8GtFkTWlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919949; c=relaxed/simple;
	bh=b8glmoQVLJgTojX3Wh1q+VbVipfJNb3AzcNfw+ToYw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FscobnmM9C8BVTjHUWMmiVXnMOf5HBJgxP4F6nDCCJWOiScBxX+SfPlsuNiUYXRtGJW+8AQfwRMenLJz6HIW0Q4wGsMpZ3JQwBa92wUiBFIH9JerqsS+FRU99rg8r0Hk7xOlUkfbIVgYFuSJYkSJZCxT69eQ0o4PsfWyo6wb8ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Coo29+/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Coo29+/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C43AC4CEC3;
	Mon, 14 Oct 2024 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919949;
	bh=b8glmoQVLJgTojX3Wh1q+VbVipfJNb3AzcNfw+ToYw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Coo29+/TbyVGvTuh5M7MQ5dSYh/IbM4PF4bm4q7Yb+Hb0NSFdjH17jW0XkfUY6i79
	 xsQjcB8QWFc+0zdLuymD4tB3yl7sPQSxg2Dmv+J6y939NgVhQz79pQh44pgf8SH4Ss
	 O/PezMZqtEwHVTAYubkrckbsGsff+q/oVse2C/J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 754/798] btrfs: zoned: fix missing RCU locking in error message when loading zone info
Date: Mon, 14 Oct 2024 16:21:48 +0200
Message-ID: <20241014141247.692843062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit fe4cd7ed128fe82ab9fe4f9fc8a73d4467699787 ]

At btrfs_load_zone_info() we have an error path that is dereferencing
the name of a device which is a RCU string but we are not holding a RCU
read lock, which is incorrect.

Fix this by using btrfs_err_in_rcu() instead of btrfs_err().

The problem is there since commit 08e11a3db098 ("btrfs: zoned: load zone's
allocation offset"), back then at btrfs_load_block_group_zone_info() but
then later on that code was factored out into the helper
btrfs_load_zone_info() by commit 09a46725cc84 ("btrfs: zoned: factor out
per-zone logic from btrfs_load_block_group_zone_info").

Fixes: 08e11a3db098 ("btrfs: zoned: load zone's allocation offset")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2c42e85a3e269..794526ab90d26 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1345,7 +1345,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 	switch (zone.cond) {
 	case BLK_ZONE_COND_OFFLINE:
 	case BLK_ZONE_COND_READONLY:
-		btrfs_err(fs_info,
+		btrfs_err_in_rcu(fs_info,
 		"zoned: offline/readonly zone %llu on device %s (devid %llu)",
 			  (info->physical >> device->zone_info->zone_size_shift),
 			  rcu_str_deref(device->name), device->devid);
-- 
2.43.0



