Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C89218FDAF;
	Tue, 10 Sep 2024 10:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963723; cv=none; b=F2hz7Gwmt0FLZqMrIelEDbLVu4ueF0nAUwE6zUGutDOwGy0KFLYoFOIwRqvMT7kx1Bq41L2gwL0VA2WI1rtUYy4PAITseJnVpZryKxbFWd1SXIqaaRQCEqdX3gh1W1asZtAPLG6wjx0so1kP1gyD3I1GErwuL1IpvQZ6vdKaywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963723; c=relaxed/simple;
	bh=FMSRezxVBTvwlBoCpYcJIgQ+h5JKCZnFvEpS/zYrgj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzkcVr6stuuE/LanUAZR8IMyt5Ht/AhIguUpZ5jrw5U7Y1setWYTKBwMxuM3nT6n1ebJrnX1PHgNGzLGpmp9246XoFQnpkpT/DeJbn/dBeW/+gOpAXSY4euhP92aESSKgLLdb3jIe+9PoZAp/9/x+nhFAtDIwp+WYZFQTFijWw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSEhZOVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSEhZOVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9982C4CECD;
	Tue, 10 Sep 2024 10:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963723;
	bh=FMSRezxVBTvwlBoCpYcJIgQ+h5JKCZnFvEpS/zYrgj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSEhZOVbG6DG6Rh0kq1+AKxDY3wKLt58gNJgiw8e8yqxN9IUmEAVol/BkTwI6bSuB
	 m+rGdcBpB0Nb9uZAG3fPZI+rq+4Ou/pBp4SMBf1xk2/6XJbIuau6+lsNjYKD3CyIoS
	 I+MTyHopuah8b4DIKmoKC6EmIpXNeP0vwizRkbMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/214] btrfs: replace BUG_ON() with error handling at update_ref_for_cow()
Date: Tue, 10 Sep 2024 11:32:57 +0200
Message-ID: <20240910092605.065703217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b53313bf3b2..0b8c8b5094ef 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -306,8 +306,16 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
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



