Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89301A256B;
	Tue, 26 Aug 2025 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208529; cv=none; b=Ib7Y4arO5/0ubgULsFGsZo7MHDYti252SqoMNSVLWerOxps91kgKbgitg7ymo0iatvgHWRq54rQLb/Q3jE+j86Oi5YFV1lg8jBkFW1zwQzVpuHTKO8i7XpYidyTBiBGpb1R8oHaYNvMXyXomJchrsC1xhIUuQncb6KvUKbt5/JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208529; c=relaxed/simple;
	bh=mF77cpGWMaXcsm2rlZGvEtWJ46c+xqzcLdN0n1PkGRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGPm0LfaGu2q9cYK/F3AC8x9qOOwmOWq7LFSfptQYNfAKCFTUF18fSzlnarFENVD36XNt4V1b6KmnPd4HDFtbyr4Nxd9QlpZ51UA8rfCuwHltXz4hyq5fc+uoDhdqq95HnF5v8omzKE52lf6W1HBNnVZeM1h08wXq9MRz6bSwVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4ucS3+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4ucS3+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423EEC16AAE;
	Tue, 26 Aug 2025 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208529;
	bh=mF77cpGWMaXcsm2rlZGvEtWJ46c+xqzcLdN0n1PkGRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4ucS3+Ts6Oq0LLUDiaFAr0MLRDFPt/5Ak5f6RoCt68K8uTohNg2zormVt+ypqlK7
	 GNOE7jcHSB5H19uRHQ+yXjEQL5PexT8cZR+jmp9MWTvqj02Wpt2MAka9lTbA0hGDvW
	 Gg/3tcLaFqqpsj+PqV3Y21n1iSWG18G8ZPGcZW+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/322] btrfs: explicitly ref count block_group on new_bgs list
Date: Tue, 26 Aug 2025 13:09:22 +0200
Message-ID: <20250826110919.438496207@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 7cbce3cb4c5cfffd8b08f148e2136afc1ec1ba94 ]

All other users of the bg_list list_head increment the refcount when
adding to a list and decrement it when deleting from the list. Just for
the sake of uniformity and to try to avoid refcounting bugs, do it for
this list as well.

This does not fix any known ref-counting bug, as the reference belongs
to a single task (trans_handle is not shared and this represents
trans_handle->new_bgs linkage) and will not lose its original refcount
while that thread is running. And BLOCK_GROUP_FLAG_NEW protects against
ref-counting errors "moving" the block group to the unused list without
taking a ref.

With that said, I still believe it is simpler to just hold the extra ref
count for this list user as well.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 62be7afcc13b ("btrfs: zoned: requeue to unused block group list if zone finish failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    2 ++
 fs/btrfs/transaction.c |    1 +
 2 files changed, 3 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2807,6 +2807,7 @@ next:
 		spin_lock(&fs_info->unused_bgs_lock);
 		list_del_init(&block_group->bg_list);
 		clear_bit(BLOCK_GROUP_FLAG_NEW, &block_group->runtime_flags);
+		btrfs_put_block_group(block_group);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
 		/*
@@ -2945,6 +2946,7 @@ struct btrfs_block_group *btrfs_make_blo
 	}
 #endif
 
+	btrfs_get_block_group(cache);
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
 	btrfs_inc_delayed_refs_rsv_bg_inserts(fs_info);
 
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2113,6 +2113,7 @@ static void btrfs_cleanup_pending_block_
 		*/
 	       spin_lock(&fs_info->unused_bgs_lock);
                list_del_init(&block_group->bg_list);
+	       btrfs_put_block_group(block_group);
 	       spin_unlock(&fs_info->unused_bgs_lock);
        }
 }


