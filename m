Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E357E27A455;
	Tue, 26 Aug 2025 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215004; cv=none; b=d+sfB+UcZH86VQaNvMPbNUghzUiGfyuvkjsfWjaN5ZbmdLrG5mRSf1yPVrqEAbGVoqQhGR3G/OeZVJalwCz2h4A9YfCc3pNaJTfaXNvdydAY6ZMJj3q+4cZmpI9uSA3EV11nmi8E/xiHCqMAs2Nj8h9fMzMtD7M4gimnHekWOYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215004; c=relaxed/simple;
	bh=xdelo/lVKSV/CI8/eiCOt0xjNrHV9wH5pI2/BZKgaS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf3ym+p0964K29r5TvHoqNgF7yVZynkjB4Io19DhqnpgOkO1Dj8YGyboWwWcJtprhHSeMscbWzKsXuUcltYL6jxqbHVrPmRAzEazBF1tPN0YoFe/Zeee8VyEUHu6qDEOZ0qXpyW3MZM4rGENvm4MqfmxrlbopIRVdikc8LbREsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQ60TcbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQ60TcbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5142CC4CEF1;
	Tue, 26 Aug 2025 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215003;
	bh=xdelo/lVKSV/CI8/eiCOt0xjNrHV9wH5pI2/BZKgaS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQ60TcbJKovxBD8c5iel4C/il992GqhtkV6csiZOoIodlF3wDzjjoHMMO0aoH9Swk
	 mHV88J+Qn3Q+lcBTsdaMiNbI1dmUpM832b9ur7ERNejey4BwVnUsFiC76QBnk3Ic/A
	 uTDgPjutn539SUtfZBd9/OcoDVEALNSjU4x/ohH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 349/482] btrfs: fix qgroup reservation leak on failure to allocate ordered extent
Date: Tue, 26 Aug 2025 13:10:02 +0200
Message-ID: <20250826110939.455285465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1f2889f5594a2bc4c6a52634c4a51b93e785def5 ]

If we fail to allocate an ordered extent for a COW write we end up leaking
a qgroup data reservation since we called btrfs_qgroup_release_data() but
we didn't call btrfs_qgroup_free_refroot() (which would happen when
running the respective data delayed ref created by ordered extent
completion or when finishing the ordered extent in case an error happened).

So make sure we call btrfs_qgroup_free_refroot() if we fail to allocate an
ordered extent for a COW write.

Fixes: 7dbeaad0af7d ("btrfs: change timing for qgroup reserved space for ordered extents to fix reserved space leak")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ adjust to code movements ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ordered-data.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -173,9 +173,10 @@ int btrfs_add_ordered_extent(struct btrf
 	struct btrfs_ordered_extent *entry;
 	int ret;
 	u64 qgroup_rsv = 0;
+	const bool is_nocow = (flags &
+	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
 
-	if (flags &
-	    ((1 << BTRFS_ORDERED_NOCOW) | (1 << BTRFS_ORDERED_PREALLOC))) {
+	if (is_nocow) {
 		/* For nocow write, we can release the qgroup rsv right now */
 		ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
 		if (ret < 0)
@@ -191,8 +192,13 @@ int btrfs_add_ordered_extent(struct btrf
 			return ret;
 	}
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
-	if (!entry)
+	if (!entry) {
+		if (!is_nocow)
+			btrfs_qgroup_free_refroot(inode->root->fs_info,
+						  btrfs_root_id(inode->root),
+						  qgroup_rsv, BTRFS_QGROUP_RSV_DATA);
 		return -ENOMEM;
+	}
 
 	entry->file_offset = file_offset;
 	entry->num_bytes = num_bytes;


