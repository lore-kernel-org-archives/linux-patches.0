Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16C2135B0;
	Thu, 12 Dec 2024 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018580; cv=none; b=Qy5l5If5zYeZTVg+aiOiW6au48wZLIkXovJ/+36u0hpv8FlpcWC7Qtzm59eNZjcAyi/XS8B+fxPxcOMguZutKiUbLL+qk1GkuHNeDq8mS+0JDywySJuthL3dPaWTXDry5i6Iz5vNamZ2fcN9BcUEDvfQq0lrGmHFl+8KrX5lHK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018580; c=relaxed/simple;
	bh=aRIix01378oFnUwNYDAxQ7iKmPgAxptFBlG8yJlhuC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usl5dAXtZlHPxzN2nlDvvEgRXP4lvpXax6Cp7bJCA6LWJ9ba/nF+Z6Axl/1I+6r57D6EHRPPfL/4D6kaeZqE9WTzulAD5zSg2pWSTy2nes9cgnkUYF/G3XSnIUydcsO7YTcz9c/UR0RqsYkC4PFwJe5uwtX5768FSa0w0k1cZaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhaDPJj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhaDPJj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED504C4CECE;
	Thu, 12 Dec 2024 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018580;
	bh=aRIix01378oFnUwNYDAxQ7iKmPgAxptFBlG8yJlhuC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhaDPJj4mpC7oLKMlcixWql96nT4c/dqhwzhCXeZbTjZUjSCjyJLdozpOComRStqf
	 uHnXU4EB0y0cL9/IcwwVbTEMjrBn8rSmMO9ByHc2qdtvTet0xEHClkxYGKAd9KDm91
	 HtWU4w6V1ioP/bn3XWRjdXRT4BZEeYsAFeGYIkrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 332/356] btrfs: fix missing snapshot drew unlock when root is dead during swap activation
Date: Thu, 12 Dec 2024 16:00:51 +0100
Message-ID: <20241212144257.678906663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9c803c474c6c002d8ade68ebe99026cc39c37f85 ]

When activating a swap file we acquire the root's snapshot drew lock and
then check if the root is dead, failing and returning with -EPERM if it's
dead but without unlocking the root's snapshot lock. Fix this by adding
the missing unlock.

Fixes: 60021bd754c6 ("btrfs: prevent subvol with swapfile from being deleted")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ea19ea75674d2..035815c439498 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10693,6 +10693,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (btrfs_root_dead(root)) {
 		spin_unlock(&root->root_item_lock);
 
+		btrfs_drew_write_unlock(&root->snapshot_lock);
 		btrfs_exclop_finish(fs_info);
 		btrfs_warn(fs_info,
 		"cannot activate swapfile because subvolume %llu is being deleted",
-- 
2.43.0



