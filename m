Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0A71C1ADB;
	Mon, 22 Sep 2025 19:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569951; cv=none; b=GNq6v/fr0ZLlZIsq3ka1V6dii6sF3ABu8UDicePLhVrSbfy4WTd+leyIBjJrtLtRHTD1/sDg2uNsNWG6DTukI8GlYn0da5WH8hc3fnxPfa2zFtDLLK67zn8AWzgGPyBVNb6OsS61EB7VnnGk0zHbthsPietddgJhu98Ka1Qj7OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569951; c=relaxed/simple;
	bh=vdRhyoF+f67Dkylm054p+MoX0HFbuWdQ525p0FfEWPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMjYHzQSheZvqesDrwSpd8k1gNbS52jN0fTJf6wv2Jf4IeGPNNCt3tun3Rj/ajqDeIuzF1xv8kmGEC0bY8GGpdbs0869BJgrD2WevCTn+BMOl6w6Tj0LLRjs6yRo2dELUmeho/DVhIaTY7mFysP30wBFUGsK739c9+XcmRIF2OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTm//THJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTm//THJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE6DC4CEF0;
	Mon, 22 Sep 2025 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569951;
	bh=vdRhyoF+f67Dkylm054p+MoX0HFbuWdQ525p0FfEWPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTm//THJ2zy0wC6ruGhdLiByCRCv3CMx8T+wpvy4SHO8EX5CzL6rGLGirnW9GVJ6r
	 8AFLh15HzWxUNyDPy9K65TbATMoo2i3ffZDkvCJMQ/YyD4TEu/GTiVDGVN56xB13ia
	 xNTpJKB8rWNuYNYla9Jg9sEs0vh8KE5GbWpuTXOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 053/105] btrfs: tree-checker: fix the incorrect inode ref size check
Date: Mon, 22 Sep 2025 21:29:36 +0200
Message-ID: <20250922192410.303744774@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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
@@ -1744,10 +1744,10 @@ static int check_inode_ref(struct extent
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
 


