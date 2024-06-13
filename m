Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0B1428FC;
	Thu, 13 Jun 2024 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279655; cv=none; b=Uuy1nMOFWAcj92zKaZqPstRy4wnJvOi8d1kUddUKBnbnlpxLYvPq4YPGAHKuQU0cubHEKsz1fFM3PPf6gVWBb5qiU301ntMtwBjgivUm2FiZ2jlO+cLeFFfkyPhiTT/nfoGSxMZcqSM0F78rFIuK0Enm5UW7cR+SEnm90NvxrhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279655; c=relaxed/simple;
	bh=nqjrYG6ZEsgvbfC3TL+dcAYfum4DFsaM2q9msx3EbhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0NfAtmYfHvq0x0XIGgmZmts63fW42ybRHrP3NOt+x2NrwfqJY75sA6OsTP/HJ2oDj4zgPvMdsjKt4CE8/bJYMjpKF880O2X138MAHsaTxoAXmA1qKAUq22+pQa7QldW+vcxWPyUIw6OxG1AB1lL4v5DepRYuJEPhUxdwz2rlZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3AWoryx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3AWoryx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EB0C2BBFC;
	Thu, 13 Jun 2024 11:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279654;
	bh=nqjrYG6ZEsgvbfC3TL+dcAYfum4DFsaM2q9msx3EbhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3AWoryx9sgPHyL3gS16hSIOi/3p0LRr0p3cw32HSbRvORebhjSuqOw2VxkyRpzY0
	 8l8Qds3Y5kgGwCXWC3MWlzmGMxXow1u+ddQf5dhO7olBDb6KCuXR3KBnoV1s5QXIv2
	 LesUcs/WDWeZmZbqYWv6YqOrAyzfBTyUhLojTWJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0fecc032fa134afd49df@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 149/157] btrfs: fix leak of qgroup extent records after transaction abort
Date: Thu, 13 Jun 2024 13:34:34 +0200
Message-ID: <20240613113233.170854727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit fb33eb2ef0d88e75564983ef057b44c5b7e4fded upstream.

Qgroup extent records are created when delayed ref heads are created and
then released after accounting extents at btrfs_qgroup_account_extents(),
called during the transaction commit path.

If a transaction is aborted we free the qgroup records by calling
btrfs_qgroup_destroy_extent_records() at btrfs_destroy_delayed_refs(),
unless we don't have delayed references. We are incorrectly assuming
that no delayed references means we don't have qgroup extents records.

We can currently have no delayed references because we ran them all
during a transaction commit and the transaction was aborted after that
due to some error in the commit path.

So fix this by ensuring we btrfs_qgroup_destroy_extent_records() at
btrfs_destroy_delayed_refs() even if we don't have any delayed references.

Reported-by: syzbot+0fecc032fa134afd49df@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/0000000000004e7f980619f91835@google.com/
Fixes: 81f7eb00ff5b ("btrfs: destroy qgroup extent records on transaction abort")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4544,18 +4544,10 @@ static void btrfs_destroy_delayed_refs(s
 				       struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *node;
-	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_root *delayed_refs = &trans->delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 
-	delayed_refs = &trans->delayed_refs;
-
 	spin_lock(&delayed_refs->lock);
-	if (atomic_read(&delayed_refs->num_entries) == 0) {
-		spin_unlock(&delayed_refs->lock);
-		btrfs_debug(fs_info, "delayed_refs has NO entry");
-		return;
-	}
-
 	while ((node = rb_first_cached(&delayed_refs->href_root)) != NULL) {
 		struct btrfs_delayed_ref_head *head;
 		struct rb_node *n;


