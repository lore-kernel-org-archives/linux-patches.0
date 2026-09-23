Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D97418368;
	Wed, 23 Sep 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173477; cv=none; b=FtnsJul/Ra8ZrmF6MBqT0ggTcjEBa+qgjiDHmAg6W07/AI2HvRxgS4WgickndX7bcpeJlGQXbcYA7z0YU4QvdpHcm7a2MGs2ob77fjQsS8eDUSDVJyp7WRn0nns5/TdCqeHAJeDTIVd+0kXiou9JKaJw68VdwEJNNO0nUEp49Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173477; c=relaxed/simple;
	bh=Eot9Yo96bXZsr0snBsZYk6WKix/PoulWEMOX9Zfc6FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3apYYBLt+Aoln2H/qpJM9WXdigrx+yY3srxuljxV2EOm9IdMsi3zTYM2cFJOpbxZ4Ka9rXt3nENhPHL0OfUkY0EqU1xOZoiT3mYcUY1I9lYcSqprzxXzCbm6GiM7S76Db09zWvWYmLmUjiX+OZZv8vCIYEH4GKg6Eb+o8CH1pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAaq1lDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAaq1lDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43041F000FF;
	Wed, 23 Sep 2026 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173476;
	bh=UwesviyCPRw1ZPFv0bx89qcKFLufpRQlXZRlu7FLqq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAaq1lDDoJTGi/PY/UmlVWItdIlnvtnzHOM1hW0etPYzfynPQC8ojMLFvHn1vbGJ0
	 p3WL+ufYNjRyoGTD/VWDCqBORn5Am+2ahDaqMouDR2D9VxX4QzkLdIVvdWJNCc1c50
	 NI1Hn5glmPk7lnd3rXSfl3Q3xn8OhdvY6f47/zg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 225/438] btrfs: check if there is space for chunk item when validating sys chunk array
Date: Wed, 23 Sep 2026 16:04:06 +0200
Message-ID: <20260923140650.598187645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit aeab4c62875748ecfd390a47ac1d91ea7c9a6abb ]

We checked if have enough remaining space for a key before dereferencing a
key, but we then dereference a chunk item, to get the number of stripes,
without checking if there is space for the item. So add a check to see if
there is enough space for a chunk item before dereferencing the item to
extract the stripe count.

Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de6e23b88b406..12b771bda43aa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2358,6 +2358,10 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
 				  key.type, cur);
 			return -EUCLEAN;
 		}
+
+		if (unlikely(cur + sizeof(*chunk) > sys_array_size))
+			goto short_read;
+
 		chunk = (struct btrfs_chunk *)(sb->sys_chunk_array + cur);
 		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
 		if (unlikely(cur + btrfs_chunk_item_size(num_stripes) > sys_array_size))
-- 
2.53.0



