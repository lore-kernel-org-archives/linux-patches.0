Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB27139CE4;
	Tue, 14 May 2024 10:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683003; cv=none; b=Xe8q6DphcbF5ELh9cdxjAgYNlfhj+N+Fw4TW2CJDixYC7Xj5zuBZw+rP9DUu3U0vk1jmhH07K1ZkyXprT2gFMfxlFyd+BmPthV7fxvBj9SHTeF5QBiqn7EXUcTCLEcEPskEbE7GohJt6VEjEpZHApP5NT/eaRppk+I7cGyHtSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683003; c=relaxed/simple;
	bh=kSSUE5tPfbq47A6gZFXGy4T6E6n4Mvu41oWI6OsoNqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roQNcMyGq+trcy6NrheblSV1mbEDY89TW9ZNWPFrshDXeUmcbQGnq356ASK3zu7tK/o+fK6eJGRTilRSGk0Z4hSXHlp2yBm1K+t1XOVgS4HiIgrG8JGVQ/uqNdCVbB8uPTv7H5+3UeacRcTSSaOXL95iBouqLuMvTDQKevdSWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X29RFXhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X29RFXhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDB1C2BD10;
	Tue, 14 May 2024 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683003;
	bh=kSSUE5tPfbq47A6gZFXGy4T6E6n4Mvu41oWI6OsoNqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X29RFXhVpKbHL6xpEREQh1T45uvHvxzaJ3DPTeUpb7ao8you435LecIoQGwV0gYFz
	 t5K2ICt3NpEEXInC8TdFPABch0vXxUXFr3e+nv8f4RN8QP2EfCc0L6hZzzm73OeJwJ
	 diMpL2J/RO/4OvdqbJy6FT2va9E0Nt5vzJ7+8JP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 142/336] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:15:46 +0200
Message-ID: <20240514101043.961245921@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 6e68de0bb0ed59e0554a0c15ede7308c47351e2d ]

It is possible to clear a root's IN_TRANS tag from the radix tree, but
not clear its PERTRANS, if there is some error in between. Eliminate
that possibility by moving the free up to where we clear the tag.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f1705ae59e4a9..b93cdf5f179cf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1496,6 +1496,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1520,7 +1521,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



