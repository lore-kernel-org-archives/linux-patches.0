Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEE653B359;
	Wed, 23 Sep 2026 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174663; cv=none; b=mvaGcr6TJYopxxhUEYz9W0eyLhI/skpYP/f3CftWT2eVjJhJdl39S7i8o2b3jRcpaW0B+6ju1lgB08f9Ofq3MySh5FVL1Hc9SedAvot9FVRe/xtvtPoBBYRiOGB60p3wJkUJvSsgBrM1spWVVQv6S6K1iTyrW3v0G22zKcDWQT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174663; c=relaxed/simple;
	bh=F3FfkV5PzMDuWyrj5+nRD3N2wqUXPvYbbg61YBnU+e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab2iWbk9sdTcNlwVG1he7Z3Ok3UJDEoV93FzGalHHamfYc3fkxhvuiWE5gHjKgFEElP2+Ckuhkuw9ybyEVh9VcUHio5mUPqxSDdj4qBDeAQnuMJKMXxlb48yCgxJTOJEacpvvn6GelsSpnTQsSSdTKGNqxU83RckmeU48AOVoQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITcodlOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITcodlOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1625D1F0089D;
	Wed, 23 Sep 2026 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174662;
	bh=MgLTxEVi3Muq1Z4eXNAzt7AGhYwsfXTPsap+4Ex+BbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITcodlOv3biEuckNLQTz0Ros2qjwjyC/bHKzNq1OVBiUGI1koKDjMPyDpNermFDxb
	 Q/xo69UdNDZ8uGgHALU0Xkuirnr70gkVheJTwft7gBtHJVkw0C9qZjWXbJAguH0vFT
	 zVlWBdf9mjLvKKS9gDI4QKehQJyLBQws19vjvNIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/398] btrfs: abort transaction on failure to update inode for hole punching and reflinking
Date: Wed, 23 Sep 2026 16:04:21 +0200
Message-ID: <20260923140648.277699365@linuxfoundation.org>
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

[ Upstream commit 97fcd34aa9fd73cefe3120ac9a82ca9d7763922f ]

If we fail to update the inode we error out without aborting the
transaction, which can result in a persistent inconsistency if after
the failure the transaction is committed, as we have dropped file
extent items from a range and either punched a hole or insert a new file
extent item for that range (for reflinks).

So add the missing transaction abort.

Fixes: 2aaa66558172 ("Btrfs: add hole punching")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a15062f976ba3..19f0f9df038cc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2498,8 +2498,10 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 					      inode_set_ctime_current(&inode->vfs_inode));
 
 		ret = btrfs_update_inode(trans, inode);
-		if (ret)
+		if (unlikely(ret)) {
+			btrfs_abort_transaction(trans, ret);
 			break;
+		}
 
 		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
-- 
2.53.0



