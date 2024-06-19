Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BF13E409;
	Wed, 19 Jun 2024 13:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803719; cv=none; b=hqhKZDIjyfoCPheaPytXvmEAFbiNZnPdo7K+SD3PLjJ7jDDH0MNNhcOiwrhop2gDSVkp3CSMJSOyF0S3iADkw79wUgpSx03u3Ann05GcLCAAxnCw5m7Y5v3Mm9AJRJztsClV9YdpkrogP0UiEV+NK3gdr0RnNz5eMtRThoQmVFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803719; c=relaxed/simple;
	bh=mQz9zrbHUnBEq7WhH4TzeH//WKmA1mOmoRrsqeFLauk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuqBFlBsrPMTbDpkMO3xmxb7CBLRZg2lrvhi0MDRpPboNXyd3ZhO74dZG9Wrrj9537zQDZFSMUlgJhXN3HwREDycVHF3zdnsojV94X91ROVYbZoZX/NmJx9+Ce6flIFsTwg+mKq8QdOzIpsAng+iJOo8ZnZ1NDWipCviFUejUbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psePymm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psePymm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD72BC2BBFC;
	Wed, 19 Jun 2024 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803719;
	bh=mQz9zrbHUnBEq7WhH4TzeH//WKmA1mOmoRrsqeFLauk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psePymm4XaCB5+ro0UTmK3rLKoC5IZ1mYyXWY3dbiSI6FD2TvPtDF7uTWZxENHknw
	 xg17vG9zGh4I9sN7oMYIrFMl3Y+RrZaVxzOkZvasg+HbbxIe98MBIONY8P3kxNmgyj
	 WgUZV3hgu54BbQhzZdE0PoatOb+/K7b2/8b/ylUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0fecc032fa134afd49df@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/217] btrfs: fix leak of qgroup extent records after transaction abort
Date: Wed, 19 Jun 2024 14:55:24 +0200
Message-ID: <20240619125559.812001944@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit fb33eb2ef0d88e75564983ef057b44c5b7e4fded ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5eac900f5d168..c17232659942d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4943,18 +4943,10 @@ static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
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
-- 
2.43.0



