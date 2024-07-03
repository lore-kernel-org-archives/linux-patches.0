Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1302B13247D;
	Wed,  3 Jul 2024 11:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005857; cv=none; b=lG8HeQp9BO00arVyLi4SQvVZctkdJAiJAw4wXb/NyM3qWjTtpptdLoOGErZpjweOhJyUUWW+bJcRPnoaQ9Q/6izCcW+5/kwvneB7BA78eKiKTuKwzr+DmlyIVvU23sxiSCPgsiUD9m4oEI1hhrIb7CwuSE+avlRK/yaXmfTEiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005857; c=relaxed/simple;
	bh=dgipOHXC+gVOT5SD0DWDmA2I1MRmxAMCmBt3LRV4H5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOPmtut+xhoqjONTRHmZBJqdN5rVol2dkMtdtjRK5B3nXYjXtInvVUBtd+fwRdS9dCNygZt7Ss35zQ1DSQ9bG6Ux5e0vUODovHJq2LxKYfkWorDm5Oa7QAhVl7y89qyOesYSg4UNRD7kbP23jkkRA4IZBfVBGMLPPjx06YDxJSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKtXSsyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKtXSsyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D971C2BD10;
	Wed,  3 Jul 2024 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005856;
	bh=dgipOHXC+gVOT5SD0DWDmA2I1MRmxAMCmBt3LRV4H5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKtXSsyyO4p+PO3DdNB/wDP9JibvFYGc4+hLCOYFjLrbwl2lI3KPUgFBcG5xUgVn2
	 M6l2Hg2UD/j98pUP4p+1z1nZpCOJX/ylZIKR3AVOqSzo59oAyK3FRnKsqRvnOrYUZW
	 ay4iYrQz5vT59rxQpw7JN83ayg8e2LZ2xtdbYfXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 220/356] btrfs: retry block group reclaim without infinite loop
Date: Wed,  3 Jul 2024 12:39:16 +0200
Message-ID: <20240703102921.435878286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit 4eb4e85c4f818491efc67e9373aa16b123c3f522 upstream.

If inc_block_group_ro systematically fails (e.g. due to ETXTBUSY from
swap) or btrfs_relocate_chunk systematically fails (from lack of
space), then this worker becomes an infinite loop.

At the very least, this strands the cleaner thread, but can also result
in hung tasks/RCU stalls on PREEMPT_NONE kernels and if the
reclaim_bgs_lock mutex is not contended.

I believe the best long term fix is to manage reclaim via work queue,
where we queue up a relocation on the triggering condition and re-queue
on failure. In the meantime, this is an easy fix to apply to avoid the
immediate pain.

Fixes: 7e2718099438 ("btrfs: reinsert BGs failed to reclaim")
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1493,6 +1493,7 @@ void btrfs_reclaim_bgs_work(struct work_
 		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
 	struct btrfs_block_group *bg;
 	struct btrfs_space_info *space_info;
+	LIST_HEAD(retry_list);
 
 	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
 		return;
@@ -1583,8 +1584,11 @@ void btrfs_reclaim_bgs_work(struct work_
 		}
 
 next:
-		if (ret)
-			btrfs_mark_bg_to_reclaim(bg);
+		if (ret) {
+			/* Refcount held by the reclaim_bgs list after splice. */
+			btrfs_get_block_group(bg);
+			list_add_tail(&bg->bg_list, &retry_list);
+		}
 		btrfs_put_block_group(bg);
 
 		mutex_unlock(&fs_info->reclaim_bgs_lock);
@@ -1604,6 +1608,9 @@ next:
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 end:
+	spin_lock(&fs_info->unused_bgs_lock);
+	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
+	spin_unlock(&fs_info->unused_bgs_lock);
 	btrfs_exclop_finish(fs_info);
 	sb_end_write(fs_info->sb);
 }


