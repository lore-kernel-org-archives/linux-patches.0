Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71166348C6B;
	Wed, 30 Sep 2026 19:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796186; cv=none; b=gi056HddZG4641j5uhYw1uT8nfchA2pYS47CVfJfTbdWJo7EtesGUcqnu8ycXVwu80iX1DfWutc8A6fjcLuBzCwtbioK2MUi6o1VBzm3yRkYweVZKiddyzpZbnznev+cSTLlMWTzHerUGZAVCkFImCJaQuG4ATrJdgBz8WNtMps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796186; c=relaxed/simple;
	bh=DxEC2SIiMizWTN2nUlw2tGomv9TDOkaZ+TiC96xISvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGYddipFAivb4yESHs82CJ/fNl3T9onL7hmg5yLnJTPvIKn9K2QlzSIkFzdk7k449sqnK/24P85RN4B6mP+xZP1L8Smf10EAgwk1yMd2ckZyVVETtvBKSpa7prTTs6rYZGRUrsK+Avc/V0ACIt3hWmHwn6AwSxXB6NFDgK5ymQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bf/TocBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bf/TocBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6701F000FF;
	Wed, 30 Sep 2026 19:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796185;
	bh=wyKhPNi1VhAF9l5CDHvQPCKEzRQdv+vSPC1+BrsXwNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bf/TocBM8iP8G8GMit5UF+VkAUqBDf78bYtwRM7jDq9SGYV4BZezID1Ol6Q+qOJ0v
	 obrvOuP7o2fGqAYANuVDvoM3o1g+km1AVK4xpVQF2j92yqWbNeH38uC+IZdvqFw71d
	 2ZVAnGe6tD4sHosC4soM5AIXHvpbqRbwils3d0Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0824/1193] btrfs: simplify error check condition at btrfs_dirty_inode()
Date: Wed, 30 Sep 2026 17:25:08 +0200
Message-ID: <20260930152452.554709615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 2199cb0f5e04dc2fbbaf8e337ee097149aad3556 ]

The following condition at btrfs_dirty_inode() is redundant:

  if (ret && (ret == -ENOSPC || ret == -EDQUOT))

The first check for a non-zero 'ret' value is pointless, we can simplify
this to simply:

  if (ret == -ENOSPC || ret == -EDQUOT)

Not only this makes it easier to read, it also slightly reduces the text
size of the btrfs kernel module:

  $ size fs/btrfs/btrfs.ko.before
     text	   data	    bss	    dec	    hex	filename
  1641400	 168265	  16864	1826529	 1bdee1	fs/btrfs/btrfs.ko.before

  $ size fs/btrfs/btrfs.ko.after
     text	   data	    bss	    dec	    hex	filename
  1641224	 168181	  16864	1826269	 1bdddd	fs/btrfs/btrfs.ko.after

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 97fcd34aa9fd ("btrfs: abort transaction on failure to update inode for hole punching and reflinking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b99f849b3f787..3865d115e7db5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6106,7 +6106,7 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
 		return PTR_ERR(trans);
 
 	ret = btrfs_update_inode(trans, root, inode);
-	if (ret && (ret == -ENOSPC || ret == -EDQUOT)) {
+	if (ret == -ENOSPC || ret == -EDQUOT) {
 		/* whoops, lets try again with the full transaction */
 		btrfs_end_transaction(trans);
 		trans = btrfs_start_transaction(root, 1);
-- 
2.53.0



