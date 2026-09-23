Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D553F6B8;
	Wed, 23 Sep 2026 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174670; cv=none; b=q3kmfMQzk7Ih3UqEzJnb8BC4aO2J7HQOWkgSPv1b4YGrfyYVgLd31sUcKkFBr4nRswzRguugeh2F+HCNukIm8zWkS/U7Lb7myv4Bhi4YuTjX3IdFCpfqavh6dOZVW3U3v6hQvW6oZppsl/e/Fzv8ZrA7MWwZElohG69xzrdFD2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174670; c=relaxed/simple;
	bh=wIv6mPSe30RFJhTgM21dxGJQHTMFlnVhqk5xoFfnjDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyqell+DrTrZco1dnkhl4PRtavs/dLQYenocEL1p2uBitVGduCphhBgKpdMKBHn1peOYfBk0RkMkKyxmR3STSyPtiWyteqJ/KjQu99HjR20YKnjaMUqjjRO7c+ScXymdNI8D78cPi7CYCC04b+dDb+c81SwFJl1pVR4wOKu4rj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UO11vnQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UO11vnQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7311F000FF;
	Wed, 23 Sep 2026 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174669;
	bh=DBhMV15t6hpukKb3OPPFuuApz/qqaWmxP66AF+jUBG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UO11vnQWtasLQjpH/d9gbxpXtw+lwnrRRZFofznRVkPID9t+btW5wPba1eeXtssBU
	 WiPzirFmKx7qQ/ZIsPQVr4vgc8Z9WXBEJ3BqL8XoxbBj366D0F+aKvww0d+S2tpTvD
	 gmdI3vaUoGG1co6Y2XDB85Wk45ItPIVVTGsMHlYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/398] btrfs: check if there is space for chunk item when validating sys chunk array
Date: Wed, 23 Sep 2026 16:04:22 +0200
Message-ID: <20260923140648.303757712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 8863479a19d3e..5396f900d5f12 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2338,6 +2338,10 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
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



