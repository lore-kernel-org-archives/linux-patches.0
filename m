Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B263E0C57;
	Tue, 13 Oct 2026 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894422; cv=none; b=VII/6kziEQgjI2KxoKavPurI0Ej+3T+6/rS215Bxo7hm5qr17ZRkM2SfYgfdgLvCxBQ/sEeOPa11RpLdl5w89s35d3igkZjtNARXr2r1P9TgSdNXPJ018uG0f1hKrk0hOpy8qsOFhEc0oF3vSFktIZXM7Ye0RL6sTEvB9dQi7Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894422; c=relaxed/simple;
	bh=xCSbLglmoi2xMRmR7/GnMmbzWrO8MWQtSlwr+ieIEFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+MHolt78umemmuLb7cWh6Y4NMNfbzBnWon2v2UsU2RWd6+je3hOQr0sqV8G1olVJHfpUbfBHJNmKYrH7L9gSpcpIlhDYsJ2YOyStYYQlFuT7yw3/oCC1a47GqyK5W7w4Qk7l5G9nJPVw+/amRXMxmObqJknxLacdgMVxV6diaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvk6J85F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvk6J85F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6AD1F000FF;
	Tue, 13 Oct 2026 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894421;
	bh=1KH46zVhieTXoCsjLottZa+neFmheRoo6pZqz0H7ZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvk6J85FPoVLrinM3EceF5HB0+1R9STFvBPVjcIrLEsMyKXFlfp4ZP7R7DFW53GVB
	 ub0jO4zNelj2C8qzVQNeBPXmp0t2du/eXbEYeh6Oo1f7EFWy4/1Tavq7hiH7MnBbjg
	 PPdhl86p6oYo34nlF5qfQZiCt+rH904VkgUuSYM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 555/621] btrfs: fix lost error return value in btrfs_listxattr()
Date: Tue, 13 Oct 2026 13:39:10 +0200
Message-ID: <20261013112933.983384714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit 41c8899d59898f6fa51ceebd2b6e55257191a8ee ]

If the input buffer does not have enough space to store the current xattr,
we set 'iter_ret' to -ERANGE and then do "break", but that only exits the
while loop over the xattrs in the current btrfs_dir_item, and then we
continue the btrfs_for_each_slot() iteration, which overwrites the value
of 'iter_ret' causing us to lose the error return value and proceed as if
the buffer has enough space.

Fix this by returning -ERANGE directly (the path is automatically freed)
instead of breaking from the while loop.

Fixes: 184b3d190087 ("btrfs: use btrfs_for_each_slot in btrfs_listxattr")
Assisted-by: LLM (found the bug)
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/xattr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e8762e12f3e1e..cb001a211f557 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -329,10 +329,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			if (!size)
 				goto next;
 
-			if (!buffer || (name_len + 1) > size_left) {
-			        iter_ret = -ERANGE;
-				break;
-			}
+			if (!buffer || (name_len + 1) > size_left)
+				return -ERANGE;
 
 			read_extent_buffer(leaf, buffer, name_ptr, name_len);
 			buffer[name_len] = '\0';
-- 
2.53.0



