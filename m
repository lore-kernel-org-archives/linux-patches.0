Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B1F53E37;
	Tue, 14 May 2024 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686818; cv=none; b=r1TI4qAhrUuw09GY1wjfPoFZp0njPqBy5m0kA1AVpIjeBnOakRjkn6HuiCOs5D1ej2YKpM/XJTh6SCeMqI9JM+V4WqbpkFqiFM20xZDEb3Mj82psHzRrwuguhHAp2RdTVX+K2yv7r1bxcoAsmJTppfC4S6soXkctqBUp+Lh3ies=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686818; c=relaxed/simple;
	bh=mZdSFv+GbbPliUMYXmzO/nXjhv+/BU7S0Isc92vQeng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc9qY5hQF2BqBl/MZ5LXDaoLYCurkvzaeps0u0sDn+7celEb1blEe/wCpV1HBzjhX8tOYPu4e2WljDHhlo04Yx8aHbQp0XFgPaA+MtEO6XKeI1KC691P7iB99gDD1H+8gRDrgGqpeAM0L6F8eOe/8c9IEE3Vtau6Y23FEatGyvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN4DjqIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN4DjqIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C76AC2BD10;
	Tue, 14 May 2024 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686818;
	bh=mZdSFv+GbbPliUMYXmzO/nXjhv+/BU7S0Isc92vQeng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hN4DjqIlTiMO1ncvfumQJq90WruV3s/Jg+i/6iBOzuav4Kffz7ylMCCu1yO4EAqvS
	 RnOSV6LkRGjP2a+wKU2SYtNXsW6zqpYj0PUfTTEPo4VeZbJ1vlz6CGmjdO+OKH7BwD
	 6QiPB82MfgoATQ3B/8HW1SMxFP1GUqFvM4Elh7MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/63] btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve
Date: Tue, 14 May 2024 12:19:54 +0200
Message-ID: <20240514100949.266731883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 3c6f0c5ecc8910d4ffb0dfe85609ebc0c91c8f34 ]

Currently, this call site in btrfs_clear_delalloc_extent() only converts
the reservation. We are marking it not delalloc, so I don't think it
makes sense to keep the rsv around.  This is a path where we are not
sure to join a transaction, so it leads to incorrect free-ing during
umount.

Helps with the pass rate of generic/269 and generic/475.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e4a4074ef33da..7f675862ffb0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1906,7 +1906,7 @@ static void btrfs_clear_bit_hook(void *private_data,
 		 */
 		if (*bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
-- 
2.43.0



