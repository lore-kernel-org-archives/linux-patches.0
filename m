Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00141F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287AAC433CA;
	Tue,  1 Aug 2023 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882652;
	bh=y/bIETCGL3gNQXWpf1U/fD4YwtGOlxsVggONvGCkbZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB6sZM6ENDjPchyu2l6iN/GFuWQfSb2An5Fm42EzrdRtxtusjp/pjZMsirCukF/yg
	 XSd5YplcemQgVLs89dh420N6xuLhdogAuYu8X3awnDIOwoVeerKCf5pmA9mat4y1+e
	 RMPzq+73eLPKyriK0rsEMNs/aHi7aUFVwL0uLBF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 183/228] btrfs: account block group tree when calculating global reserve size
Date: Tue,  1 Aug 2023 11:20:41 +0200
Message-ID: <20230801091929.470263077@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit 8dbfc14fc736eb701089aff09645c3d4ad3decb1 upstream.

When using the block group tree feature, this tree is a critical tree just
like the extent, csum and free space trees, and just like them it uses the
delayed refs block reserve.

So take into account the block group tree, and its current size, when
calculating the size for the global reserve.

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-rsv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -377,6 +377,11 @@ void btrfs_update_global_block_rsv(struc
 	}
 	read_unlock(&fs_info->global_root_lock);
 
+	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE)) {
+		num_bytes += btrfs_root_used(&fs_info->block_group_root->root_item);
+		min_items++;
+	}
+
 	/*
 	 * But we also want to reserve enough space so we can do the fallback
 	 * global reserve for an unlink, which is an additional 5 items (see the


