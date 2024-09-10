Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C71922D6;
	Tue, 10 Sep 2024 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964396; cv=none; b=ewweL6oCWsIKUNyyjG64ZX4FbAytXuJNd3ZQwdNLOGqDp2Xbfq6WmUJRAbavwiDer8GbRo8/nhkX0UCObNwMoNWTytkaacdRBcrr2aXeEGiy3v6tay+ViuW2WGGEmzCHMxG5Gx/MHLepHtJSEu3ScV06dGoii2Z8sUX/SySEExk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964396; c=relaxed/simple;
	bh=X7P6mGIhtpkZL2SnuW163H2P6YWCc0A3g33NmJyeAI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P613xndRwT1WeOAADH/7htr01pieZqT8LFAPcTlYhJX9cLCvYxtPeKDvqwmseecGbw8X3Xj2WGWrCzkb5UID8RHyfZH47iYqq3gVlA4XUZGrX0ABJN8+stiMcFzbV1g5Pdzf38lDKvtvw4ATYJf1ilCIkITNsKE/dPUD9mhu1SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APosx2eY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APosx2eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C643C4CEC6;
	Tue, 10 Sep 2024 10:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964396;
	bh=X7P6mGIhtpkZL2SnuW163H2P6YWCc0A3g33NmJyeAI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APosx2eYKcqz8dCV4pzVir3qa5LhJFA3Fp/ALKf+ZLRURhPgjhNpRe1k4ZXYXETNs
	 hWf1aK1uKsxsC+M2IlbOxeMQfI6lG3eFziNulTwCH/xIvM0uOILqNUnlbvxj3TNoY3
	 Qo/VLNBVd9U0w9rscEpMsHbpzhjVmQa0IcM/k5FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/269] btrfs: replace BUG_ON() with error handling at update_ref_for_cow()
Date: Tue, 10 Sep 2024 11:32:35 +0200
Message-ID: <20240910092614.146011126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b56329a782314fde5b61058e2a25097af7ccb675 ]

Instead of a BUG_ON() just return an error, log an error message and
abort the transaction in case we find an extent buffer belonging to the
relocation tree that doesn't have the full backref flag set. This is
unexpected and should never happen (save for bugs or a potential bad
memory).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 118ad4d2cbbe..2eb4e03080ac 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -451,8 +451,16 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	}
 
 	owner = btrfs_header_owner(buf);
-	BUG_ON(owner == BTRFS_TREE_RELOC_OBJECTID &&
-	       !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+	if (unlikely(owner == BTRFS_TREE_RELOC_OBJECTID &&
+		     !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF))) {
+		btrfs_crit(fs_info,
+"found tree block at bytenr %llu level %d root %llu refs %llu flags %llx without full backref flag set",
+			   buf->start, btrfs_header_level(buf),
+			   btrfs_root_id(root), refs, flags);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
 
 	if (refs > 1) {
 		if ((owner == root->root_key.objectid ||
-- 
2.43.0



