Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD14FDE4D;
	Tue, 13 Oct 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892729; cv=none; b=o5oA0bDMKH+u7Nt/9cYCH2GCEkReHMvOSzfKCvjyZ4zkK+ftmDjNeaqMjB2Lj7lD47WlwygA/OHBolno2ffeue30GTQknVIHcBBjG4ro+htb7o2kh/xwlfc2vxKHdO5c4Bb5r680PVslR1LU/vx9/SPwaPe1qI4HAzFkp55sFuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892729; c=relaxed/simple;
	bh=GlaW560wXQpCN0yXwRS5ndjYEsS7dHU5Dz5UL6cmv34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+X105x8OhkgkpFYZIazlEBsMRZzm2/0lSa/rNhEDne50hhlyc3batZdoYwF316XrMeM94leht9l9SYjFSPRGbBGU3O/J39RIqJvfBuv3E+gfSgpXhihvoQAv0mfR/0Zax3IOF4pwy+lVau5P4KSqjb6WoCIowgjOBZdP2Jjyis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMhxDNwn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMhxDNwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EF51F00893;
	Tue, 13 Oct 2026 11:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892728;
	bh=0vkuCC3TgLVQMUBRd9O4C087g2n+dpDMQYqZJFZ/nQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMhxDNwnsJGt3Dxu7Uk7p+6LfKu0nqTVzlqXLsPzYYIWNUmDJ7gBnAJISAcWkaU07
	 wKSCEd7bm/elNPfmizzdioxu9m4kfsS1T+mHcPCmr9lci9vNvN4zgkQU9C2gKTqM8W
	 bui+Sq7mONjFYiae7CxQIxboALOJbC2DraxpoARQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 216/281] btrfs: fix lost error return value in btrfs_listxattr()
Date: Tue, 13 Oct 2026 13:38:52 +0200
Message-ID: <20261013112900.404226225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



