Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BDB84E1D;
	Tue, 14 May 2024 11:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685299; cv=none; b=rUPPi9FEi97+OCXse4Yv445T41PekVA3zRIHx0rmNL3OOnEBJ/VEcLWW6JxyTyPXHkvcLpGsbgJYYyye+6df+uRI3yTVTZaHo9Rp196lKcG6lF83otEl1YGiBqsVHa9Amhpsh57+pDfNtz0QHfeZIhryYcSaKZBdB01khsIaDG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685299; c=relaxed/simple;
	bh=8NpsOtwUBKiQN3/zetauamaImrJ7ZWh8t9qNigQ7IDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGvK9g4VwCLUEUO5aix5cIP5doBJ6EtysEl28Q58tHGwNaHyep2xOK4suW2zcDlW0cp66nzjqFLa4DatUnSIqFb5mJBKIOlEw87+EVKpCx3jA53snhUld9+sNa/qQY+w4TO+Fc3tVXb+ulT+oExCVqR/Lyab19P0iFwUvS0nSYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjTM5F2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjTM5F2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8483FC2BD10;
	Tue, 14 May 2024 11:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685299;
	bh=8NpsOtwUBKiQN3/zetauamaImrJ7ZWh8t9qNigQ7IDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjTM5F2p2kfpH+YuD1EKHjfN+S0+qoGRsBK5VGGsfNjlDAbBJbMKE+iizz2w8TuIL
	 Tj/EbR2EVwcPL/POB6bgHMGZuiSELErzJ6pEw/EHu/UGR7aKPUi7HUQg04GMpINBcA
	 CmH6omJgi9hJS0+06LiNBdARP1x4zmKegDvyBFu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/301] btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve
Date: Tue, 14 May 2024 12:16:45 +0200
Message-ID: <20240514101037.314866342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 33d0efa5ed794..5ddee801a8303 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2510,7 +2510,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		 */
 		if (bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
-- 
2.43.0



