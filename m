Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC21CA4B;
	Tue, 17 Jun 2025 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179367; cv=none; b=F48e18E8IeVU3P6JubC/5Xl4ZSMcm6vg9ssPldKIjR+W9eV4o5RGAEljyeSIenCW2ZGpiDJMyDF1LqrrtKuzehY22gdZ2b7YOj7/Z6PqmUZ+LTnyyDNnI2WiIKCapm1YjaNWkSGO6R7biykShlbEAjCPuh3KcCuQdusY4JyFhBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179367; c=relaxed/simple;
	bh=HUJmnm6QzfM5YxHOq788X8krKx80e2BGeJTsh5SPccg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZUWI3IS242JpJobctMir098oR2PpwH3GdXVmf7uypYWxSBEMy58AIAVw9NYbjbC8SG1cA6g+XswcqqVI6jkNi+/JCkgx0jp41WIEWCarw0cbFeOgLc7pyZCAHNUS8WCXQfBEcDHpxUOO9FQZqQe67Rj4IegfJN7X7gnDgIlXGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9TnHEqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9TnHEqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFEAC4CEE3;
	Tue, 17 Jun 2025 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179367;
	bh=HUJmnm6QzfM5YxHOq788X8krKx80e2BGeJTsh5SPccg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9TnHEqgSJyNWOPdk4NG8rd7K51H2fK8gOqAZrLYn5tL/mN79rHA4UJBLXhryKKZ1
	 TFEfUcfCSD4syoP1KY918gq7k5h0FxJncu7wTMHN/9Y/WpOXu+gxdpI4YDf/GrOAwz
	 Wnti8+7LS7WpDNJDJzRi9i3SiYwrob6iZyx2JvOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 724/780] btrfs: exit after state insertion failure at btrfs_convert_extent_bit()
Date: Tue, 17 Jun 2025 17:27:12 +0200
Message-ID: <20250617152520.976125044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 3bf179e36da917c5d9bec71c714573ed1649b7c1 ]

If insert_state() state failed it returns an error pointer and we call
extent_io_tree_panic() which will trigger a BUG() call. However if
CONFIG_BUG is disabled, which is an uncommon and exotic scenario, then
we fallthrough and call cache_state() which will dereference the error
pointer, resulting in an invalid memory access.

So jump to the 'out' label after calling extent_io_tree_panic(), it also
makes the code more clear besides dealing with the exotic scenario where
CONFIG_BUG is disabled.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-io-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 13de6af279e52..92cfde37b1d33 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -1456,6 +1456,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (IS_ERR(inserted_state)) {
 			ret = PTR_ERR(inserted_state);
 			extent_io_tree_panic(tree, prealloc, "insert", ret);
+			goto out;
 		}
 		cache_state(inserted_state, cached_state);
 		if (inserted_state == prealloc)
-- 
2.39.5



