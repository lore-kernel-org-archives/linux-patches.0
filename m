Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E044376;
	Thu, 15 Aug 2024 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730710; cv=none; b=htsN4GtWqHj8nH8/c8hU1dgR7kvjwqwlATjKV1lyetzZgsvXsAjPMUVgC4UVraFJkBthsxXHesUD1Q4DegZGxVsB9EUMCjiDCdBZOhhiZ4rbng61bPuI5qbRy7oAdYFiY0wL1w3nxubiFPNrzaS9fKwwFKI1ZwQDCwhHhHwQgtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730710; c=relaxed/simple;
	bh=LZBVgxTukcRAI/MF/uftCkgLYeQ/2fOXZUR7ovrztHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7bSLXQbdj/VbZwiFlc/jVWQ5HrNvZRYqX1RoHw4PSkASWenndnA/je/qhkjcexJuc5cKN4uwybKVrKVYAcDAWvbgvNVy9+n4Nw+6PEY/Z3Iia4c7MzhHp3349GquaNbfSIXT9QKWhqwo/nodXC/RQBzbE/UnCaZcQhMuCf0dVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ml1q9bfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ml1q9bfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAABC32786;
	Thu, 15 Aug 2024 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730709;
	bh=LZBVgxTukcRAI/MF/uftCkgLYeQ/2fOXZUR7ovrztHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ml1q9bfz7bembGyVt7AiHcTTx9e/F896hJL4UeulAQ1kGMJ5bUlzoH+SgKYPQ+m+H
	 UNee1St5RVB/cdI/03Q93No18OHDf6ThLNQV1qVBCzCqtYIxQRJRLRgDQN1pBUKpBO
	 pt52jtenOLY40MLGhoMLlkf+s1IeSH/Rm+1alnVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7dbbb74af6291b5a5a8b@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 463/484] btrfs: fix double inode unlock for direct IO sync writes
Date: Thu, 15 Aug 2024 15:25:21 +0200
Message-ID: <20240815131959.359683022@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

commit e0391e92f9ab4fb3dbdeb139c967dcfa7ac4b115 upstream.

If we do a direct IO sync write, at btrfs_sync_file(), and we need to skip
inode logging or we get an error starting a transaction or an error when
flushing delalloc, we end up unlocking the inode when we shouldn't under
the 'out_release_extents' label, and then unlock it again at
btrfs_direct_write().

Fix that by checking if we have to skip inode unlocking under that label.

Reported-by: syzbot+7dbbb74af6291b5a5a8b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/000000000000dfd631061eaeb4bc@google.com/
Fixes: 939b656bc8ab ("btrfs: fix corruption after buffer fault in during direct IO append write")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2433,7 +2433,10 @@ out:
 
 out_release_extents:
 	btrfs_release_log_ctx_extents(&ctx);
-	btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
+	if (skip_ilock)
+		up_write(&BTRFS_I(inode)->i_mmap_lock);
+	else
+		btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
 	goto out;
 }
 


