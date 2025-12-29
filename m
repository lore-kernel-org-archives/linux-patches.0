Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CF1330319;
	Mon, 29 Dec 2025 16:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024908; cv=none; b=UElJrXfZ33YUS53raexVvulUajeewnoz+MvWihROsO5vg3Ue1ETRN/uWnJoSK3o2AlS/VQ5NPnJ/33KZaTsHefRGVrJSGinC1Q6Cg+GbXOFfNTQH4Zg89q8JKunG8fe/FvSTHwJ0lflrkpoN21uctaWTh+KxVXPvYIxFHiOsFek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024908; c=relaxed/simple;
	bh=4RfjEzs/KG+i5FNqFmMpLyklnjcPTnixTegAYMH02MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMfzkpmh70S1kJ6wvYHy8rpks902obgnyLTmo9JJDVk4DPOBfLna98FQk95b1tehiS6zIgs4FrJRKRsdVdvLqn/D2aScliEskewAJW3YOkgvIG8KSDyC9Fi3Cej5DQsOWrTMXyPOowREa+5yHCm6tULvpO3Os82uu3RdbjwHwg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcX/sf3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcX/sf3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89293C116C6;
	Mon, 29 Dec 2025 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024907;
	bh=4RfjEzs/KG+i5FNqFmMpLyklnjcPTnixTegAYMH02MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcX/sf3xuZPYEDIetdMZwUiPZFkbTm+Aq869QIVScD5yzA6nd6/sy+SBCDkanuSl8
	 BwtdtbDYRlPcoo7bU7cC6nBdYn1Nhck7d/W1nByECrylD34CfbMpcOWBXRKGbf4CK/
	 DA6X6ZNuZczup4PivRhE/OIzvjzER6gqbzHa6VDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2f8aa76e6acc9fce6638@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/430] btrfs: fix changeset leak on mmap write after failure to reserve metadata
Date: Mon, 29 Dec 2025 17:06:49 +0100
Message-ID: <20251229160724.420363016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

[ Upstream commit 37343524f000d2a64359867d7024a73233d3b438 ]

If the call to btrfs_delalloc_reserve_metadata() fails we jump to the
'out_noreserve' label and there we never free the extent_changeset
allocated by the previous call to btrfs_check_data_free_space() (if
qgroups are enabled). Fix this by calling extent_changeset_free() under
the 'out_noreserve' label.

Fixes: 6599716de2d6 ("btrfs: fix -ENOSPC mmap write failure on NOCOW files/extents")
Reported-by: syzbot+2f8aa76e6acc9fce6638@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/693a635a.a70a0220.33cd7b.0029.GAE@google.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fa82def46e395..0fee45d35a5f8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2018,13 +2018,14 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	else
 		btrfs_delalloc_release_space(inode, data_reserved, page_start,
 					     reserved_space, true);
-	extent_changeset_free(data_reserved);
 out_noreserve:
 	if (only_release_metadata)
 		btrfs_check_nocow_unlock(inode);
 
 	sb_end_pagefault(inode->vfs_inode.i_sb);
 
+	extent_changeset_free(data_reserved);
+
 	if (ret < 0)
 		return vmf_error(ret);
 
-- 
2.51.0



