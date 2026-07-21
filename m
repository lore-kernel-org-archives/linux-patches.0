Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DEF478861;
	Tue, 21 Jul 2026 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649515; cv=none; b=EWLTxjuSh594V+cFCgWJ19U72O8o0F+kuo3uiKnJPLkmzvqk5NKYevErFHDRKFaK2hGUsM4uH5tUFyn76sbo51AaE/kLicERzf2j5hnePJZ/H+gmcikfW6DFzmmLtjSMDJPbRUSJ5gchlzL/qREhQei+XIK46f734fquio1Kk2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649515; c=relaxed/simple;
	bh=VIhSQblB0mWwXjEBn4YrS/FIWU0rREAbWs0/n2MEbVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9vZc7ES29TXiGINYU/kl6sPO/f7b7mF6PIU9bvV1NyCKu7BFfMfOo2mhIfE3yTaj7eBQSpbQKl8lDhqFUhC49LEuw1AeXUq0et8YodLMCfo8l0pNdKqPYe8SWBVmXe7FDn+dpVNQ6poDRqJZACBbOvb6Iw7fSjN6vWgeLRlTzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvFGtlQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvFGtlQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B4B1F00A3D;
	Tue, 21 Jul 2026 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649513;
	bh=Az5X7Mb91aOoKWsdXHW5E2XG/WcFzCPhDn0tS/337KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvFGtlQIttf7wI9oQ1l278OCrUqtUaspQz4HHzmG3J4LIJ/i0Vbdxxl8KExjrRpZS
	 xve0L6S6JBaDKCYqmSoXbv+bV40O21K3K/7TTNSih3NXWYloFdVa3U0kJOhfe20fuO
	 BgvXaWe6rJvtX1PkwrJZr6fHFge3YjBtdzcYEEIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0608/2077] btrfs: zoned: dont account data relocation space-info in statfs free space
Date: Tue, 21 Jul 2026 17:04:41 +0200
Message-ID: <20260721152607.149543892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64514d600eec71..ba70d727622e84 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1740,7 +1740,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
+		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
 			int i;
 
 			total_free_data += found->disk_total - found->disk_used;
-- 
2.53.0



