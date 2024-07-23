Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9437C158A29;
	Tue, 23 Jul 2024 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760293; cv=none; b=OIYz8YCXmLpqseZxO6Kgf+2KOuvf+K3nnTNFPN874n9QRWMW+7xzdxmZFng/g1Mztmw28zyLRKG8p8yrpkAT5ooiOvRrbYdTwrWo9zLqjhHCbzKrh5cofeYM4wDaPJc/ooKGHNMx0GQbJicK1gZln4RfvwrHJO7GC5L9tOvZm0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760293; c=relaxed/simple;
	bh=WtS5zO7AZbzOfg0rYHRvOlQGXikce4Irk+prG6LpDN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmzqav5g7tOGGd/lRm0FZ7oZiFPGmzg+8Ca17TAQS0jzf3QWgLMbMk9o3jiAS74pbN6A1aXroIgkCrSSHuAfbAod8tgicEdmD/OAwbkaVmhJmzeyMmh1JZ5Ix5jTHYMd4YlViNCFgIdBQ5ZQEWOwuK/6Lt1FJTwP7Olyw5YopuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQOivvag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQOivvag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1627AC4AF0F;
	Tue, 23 Jul 2024 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760293;
	bh=WtS5zO7AZbzOfg0rYHRvOlQGXikce4Irk+prG6LpDN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQOivvagKEKMR0SMxz4IGC/mUz9+NtnshGRlEJRphRMb1YH3C4h0K0GD976bcsyeo
	 LYrrdy59erq0Xcweqho8kRE6cJ3ehYbs/n3ze1HXpga/P3qq+xK44cochE92vPPqxH
	 0tT9b4e+nDaaTYJ7RFL+ZdRvZEkyQohhGiuAaRDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 139/163] btrfs: fix uninitialized return value in the ref-verify tool
Date: Tue, 23 Jul 2024 20:24:28 +0200
Message-ID: <20240723180148.843728351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9da45c88e124f13a3c4d480b89b298e007fbb9e4 ]

In the ref-verify tool, when processing the inline references of an extent
item, we may end up returning with uninitialized return value, because:

1) The 'ret' variable is not initialized if there are no inline extent
   references ('ptr' == 'end' before the while loop starts);

2) If we find an extent owner inline reference we don't initialize 'ret'.

So fix these cases by initializing 'ret' to 0 when declaring the variable
and set it to -EINVAL if we find an extent owner inline references and
simple quotas are not enabled (as well as print an error message).

Reported-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/59b40ebe-c824-457d-8b24-0bbca69d472b@gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ref-verify.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index 8c4fc98ca9ce7..aa7ddc09c55fa 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -441,7 +441,8 @@ static int process_extent_item(struct btrfs_fs_info *fs_info,
 	u32 item_size = btrfs_item_size(leaf, slot);
 	unsigned long end, ptr;
 	u64 offset, flags, count;
-	int type, ret;
+	int type;
+	int ret = 0;
 
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(leaf, ei);
@@ -486,7 +487,11 @@ static int process_extent_item(struct btrfs_fs_info *fs_info,
 						  key->objectid, key->offset);
 			break;
 		case BTRFS_EXTENT_OWNER_REF_KEY:
-			WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
+			if (!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA)) {
+				btrfs_err(fs_info,
+			  "found extent owner ref without simple quotas enabled");
+				ret = -EINVAL;
+			}
 			break;
 		default:
 			btrfs_err(fs_info, "invalid key type in iref");
-- 
2.43.0



