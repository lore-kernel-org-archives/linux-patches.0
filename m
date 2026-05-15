Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECAA3FF1DD;
	Fri, 15 May 2026 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860557; cv=none; b=CDGOpkIf2jysraylfsK/H61WAWqbOFNzGA7SjINLdLqOlNInvwLJ5gp8BgtBE9PhTCzvtsl4jaucRt0k0QkFmfarDJtLoLWJ8hToY9/IlY+aCf/OEz9Lb+ukqfIYS610tF17BfLiKg+bxvyRJ1+rBaDfp50dZ2GVHTVI4DnDEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860557; c=relaxed/simple;
	bh=8z0K9qK4J4m5YocgvbNNlKvyLYb8PCo+Ynqf54Kq0jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5rb2RTCguhhuim9uv38+lv2EBA7Z6GAQ8uEfP8xaSunYB6mU3M4QSsLZ3wTXEZ08rymxB9bFSGxBJhiZbjC+eQ6nfPbamRFmCm0IZJjBbeSSPeGQK61kKSeOnWeS3BBc4t9hQUFbTpIvnbHpe2yQTg9Vt8qzxSac8TsWUcTPJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJhHbpNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJhHbpNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07847C2BCB0;
	Fri, 15 May 2026 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860557;
	bh=8z0K9qK4J4m5YocgvbNNlKvyLYb8PCo+Ynqf54Kq0jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJhHbpNIvWCgc+e5l8KyahE/0D0S9cKSAaVnl1cWSsMru6q/aA/CLbjYh6gD/38p0
	 6AJ2g1GbO4a2RR8uDUrUWipcQfN41Xt2jjCyrpTp2XwzCwxFWsdqU+hVC1BhxRUgHf
	 IDoBAy+MoIhmW8ZMjjCu6o6wVWi+PcYj5mPXMWWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/144] btrfs: fix btrfs_ioctl_space_info() slot_count TOCTOU which can lead to info-leak
Date: Fri, 15 May 2026 17:49:20 +0200
Message-ID: <20260515154656.625953734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yochai Eisenrich <yochaie@sweet.security>

[ Upstream commit 973e57c726c1f8e77259d1c8e519519f1e9aea77 ]

btrfs_ioctl_space_info() has a TOCTOU race between two passes over the
block group RAID type lists. The first pass counts entries to determine
the allocation size, then the second pass fills the buffer. The
groups_sem rwlock is released between passes, allowing concurrent block
group removal to reduce the entry count.

When the second pass fills fewer entries than the first pass counted,
copy_to_user() copies the full alloc_size bytes including trailing
uninitialized kmalloc bytes to userspace.

Fix by copying only total_spaces entries (the actually-filled count from
the second pass) instead of alloc_size bytes, and switch to kzalloc so
any future copy size mismatch cannot leak heap data.

Fixes: 7fde62bffb57 ("Btrfs: buffer results in the space_info ioctl")
CC: stable@vger.kernel.org # 3.0
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ adapted upstream's `return -EFAULT;` to stable's `ret = -EFAULT;` fall-through to existing `out:` cleanup label ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3113,7 +3113,7 @@ static long btrfs_ioctl_space_info(struc
 		return -ENOMEM;
 
 	space_args.total_spaces = 0;
-	dest = kmalloc(alloc_size, GFP_KERNEL);
+	dest = kzalloc(alloc_size, GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
 	dest_orig = dest;
@@ -3169,7 +3169,8 @@ static long btrfs_ioctl_space_info(struc
 	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));
 
-	if (copy_to_user(user_dest, dest_orig, alloc_size))
+	if (copy_to_user(user_dest, dest_orig,
+		 space_args.total_spaces * sizeof(*dest_orig)))
 		ret = -EFAULT;
 
 	kfree(dest_orig);


