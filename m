Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99C2F9D88;
	Tue, 30 Sep 2025 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245159; cv=none; b=GRdgYJHQh9EQ9A9nfYx1xLjae05Wr9nL3WFi2V2/PnstGC9XsOiNXNd0zUCWJQL/mQCknTxfbWgvFkTPijs3rdz+R9KNgRk91HGA+JjbX5wjgDV1qVFVbPHZx6+G8uRdSKhic0mUUJLmOYI/90ICUMo+h2hOdEtvOAPz+Ezw6jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245159; c=relaxed/simple;
	bh=TuoxS7gvonhSGv9OaUhGqRgPVhJliINhjD5VnwGbOVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJknpWkJtPlbZgXK8bIEmjf8aXAYEjjF8jhj4kEoKBNwwrlHbRbO8JPFqutIRbU1zHfu4u3KPeLHrEJ2tWeWQhPuqpT3wxaUqUc5d+/pKn/nufMkKQ/X3cGSQ/3R+UbyFIclNRRKmrJVibcN00WiFXPRsDn4V+mBuIKU/vCWitA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXAnPTj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXAnPTj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73602C4CEF0;
	Tue, 30 Sep 2025 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245158;
	bh=TuoxS7gvonhSGv9OaUhGqRgPVhJliINhjD5VnwGbOVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXAnPTj9PjPe5VYa75obNtQnBEw/Xlg9A0LKOHCq+dt5bBVVtnHVaKG9hJDJL3dxQ
	 lPpDYr+bvKmJ+irH3lCnGMhzbwQTkx0uuyfVAuQ/RssIPiUEIukGaLjhUev8qnFQeR
	 D1tEn08wZid9OLUeiWsu6ZN2E8z450EfN9dPkDLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 081/151] btrfs: tree-checker: fix the incorrect inode ref size check
Date: Tue, 30 Sep 2025 16:46:51 +0200
Message-ID: <20250930143830.817215196@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 96fa515e70f3e4b98685ef8cac9d737fc62f10e1 upstream.

[BUG]
Inside check_inode_ref(), we need to make sure every structure,
including the btrfs_inode_extref header, is covered by the item.  But
our code is incorrectly using "sizeof(iref)", where @iref is just a
pointer.

This means "sizeof(iref)" will always be "sizeof(void *)", which is much
smaller than "sizeof(struct btrfs_inode_extref)".

This will allow some bad inode extrefs to sneak in, defeating tree-checker.

[FIX]
Fix the typo by calling "sizeof(*iref)", which is the same as
"sizeof(struct btrfs_inode_extref)", and will be the correct behavior we
want.

Fixes: 71bf92a9b877 ("btrfs: tree-checker: Add check for INODE_REF")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1595,10 +1595,10 @@ static int check_inode_ref(struct extent
 	while (ptr < end) {
 		u16 namelen;
 
-		if (unlikely(ptr + sizeof(iref) > end)) {
+		if (unlikely(ptr + sizeof(*iref) > end)) {
 			inode_ref_err(leaf, slot,
 			"inode ref overflow, ptr %lu end %lu inode_ref_size %zu",
-				ptr, end, sizeof(iref));
+				ptr, end, sizeof(*iref));
 			return -EUCLEAN;
 		}
 


