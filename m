Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326372FA64D;
	Tue, 17 Jun 2025 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178259; cv=none; b=qA4temZHB2i9ydAB3EjSAgD0kRiixaEBk2bbTLOuGxeI1rTsuG9fRbI8+ABMbCCPdu6ZOl80H5W5l0DU8COxA+B0bUM2gWeUZYhKERvH2w7ZoCi/Sou1Q/lZ4JT/NuGCQc3i7Jqr0z/cdgHjMq6fo8DrDXU3yvWZSIKnJwz/cv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178259; c=relaxed/simple;
	bh=gPP1eS0uAn9vbH2GrJ4mpa09TxPvFrBcq9ZZjKOFzlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyEU3uYwc3BJZnDMzsrRde5SCbpyKphNAAiqV0Vl2XEUqPxFRFMttslGzLFwsRSk47iQqEYueiC70/SoZM2c6+mnmV3okF4IZ45JedJRBn72bY6Q9NtOY+Lzpkg/uB9mwxQV9ocLOCP0YOnZf/M6nEigC7z6kG3K/6Ti81+XOU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEXfpjMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEXfpjMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9604CC4CEE3;
	Tue, 17 Jun 2025 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178259;
	bh=gPP1eS0uAn9vbH2GrJ4mpa09TxPvFrBcq9ZZjKOFzlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEXfpjMfI0uDosfw1QgYaLuC2sUNKh3oLU2sYUawgxSl2jcFhxJUOy+P+kgEvJs3a
	 IBVDcwVteLfGhewXLyO0m79BlrvpEncT2Aif8ZFZzxYAQ4B2BxR/VdEQyzejceAPcp
	 5tj85caTHB2m3gtj4aLovelj3gBE/EZzVKTlu3T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 470/512] btrfs: exit after state insertion failure at btrfs_convert_extent_bit()
Date: Tue, 17 Jun 2025 17:27:16 +0200
Message-ID: <20250617152438.624049259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6d08c100b01de..bb3aaf610652a 100644
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



