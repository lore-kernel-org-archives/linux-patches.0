Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0642BCF5;
	Mon, 14 Oct 2024 14:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916369; cv=none; b=s2mx7LN+YYHwNqPGPwDkgSW5aRE1zXXI5DLvdSyhngDlmqOiLkC3mUCeeZFYVZSWsXNZJpfVht75N5DNW87BFmh+Hjosq+zb3iqEqcnpCMC5nWpR8xftbVQB2SFxJfdGYTUtWMHfSjWKQPShKc4HU1eDSpoocaP9Ns1ACQzI9NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916369; c=relaxed/simple;
	bh=2cTfGKQVu/eZ2KlQd9a0AoWLHk5K/DvQovSnZQ0efRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsrwcY0F+ZwE5j1ZJJ0zBxwzNpiB4aYXjg7t4PKms0upcscPduYWm0gwm7btfcdjQF1D7k+HeTIEhVkhoUzoMf6PWgp+EbYsOcCtUmRQuGOmT+AQi/OXKUM/v38lPOzdnuvc/94Bz3fSuKSn21dwprk1hdo105JVjyDell2+qBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1c52fis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1c52fis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A77DC4CEC3;
	Mon, 14 Oct 2024 14:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916368;
	bh=2cTfGKQVu/eZ2KlQd9a0AoWLHk5K/DvQovSnZQ0efRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1c52fisRNkNV4o0bC4HOcmsQROSIwTYnDdwzdZUixqmy+1G+6ca7bP1cRGsfdjk+
	 0D3uniROIDHvHi1UIM/BawmXOolgyexIQeXiZSkjVyiSN+y3ozPLLyM7AhoWbKY9pw
	 Gl6TBMYZT5uE746Vk8+4aowbY5R+I5wYw1MQq7LQ=
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
Subject: [PATCH 6.11 132/214] btrfs: zoned: fix missing RCU locking in error message when loading zone info
Date: Mon, 14 Oct 2024 16:19:55 +0200
Message-ID: <20241014141050.143224431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 047e3337852e1..ff02fd44fb7cd 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1352,7 +1352,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
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



