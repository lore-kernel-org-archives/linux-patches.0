Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD5D13776F;
	Wed,  3 Jul 2024 11:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005406; cv=none; b=ZfiRc9RYEOADt7y6woG5XU7WOxafHuxB+0utxKfP2uBi7uYIQY1l8RP+k6dklnIr1+Fn9bHS68ZoX5mRlP+DhkGN2HQU2rUz0ffHXCc3T5tHiU1bFX+/7BYmy1JXa1sMFQvw55Orc3kLhuRwhEwgalwnmE/LcotDGMixoKXEMbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005406; c=relaxed/simple;
	bh=IoKPwwx6yCr1H6QrySVbiTmNbq7ip8YzqlCUl2nYXLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdOYNx4loISN5R0yR9xWc1ivZCy1nfzAV+ngKfhd4N69OeXkoClkSwQWS7Dcxgr2HwA5RC7142fDPkSs4+0k4c/sbtNF77p+1GCOIQCTAR7WKMp2xwLh2kJUM4JeeZ1JbCzVIwGtWmV4LNzoWbMHvRVrKNRoh/O47pLOSBRGSXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UP6iyXMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UP6iyXMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F01C32781;
	Wed,  3 Jul 2024 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005405;
	bh=IoKPwwx6yCr1H6QrySVbiTmNbq7ip8YzqlCUl2nYXLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UP6iyXMZ3T0HOAkLqIqq1eEpqBIa7LHwJGRyskl+AXSAhzc3tpqJ9sxMdv/9rmssu
	 Ld4zKlvT1HfhP1Oz7MPALr6I2pZCLqBg4TQ2IO1DYwseUaHiK+7ZzUEMNBcMDRWrqu
	 SuRjCsOYMMzdr488F35Pivv5xtgrsufwlKyb5umI=
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
Subject: [PATCH 5.15 070/356] btrfs: fix leak of qgroup extent records after transaction abort
Date: Wed,  3 Jul 2024 12:36:46 +0200
Message-ID: <20240703102915.747595735@linuxfoundation.org>
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
index c1dfde886b1e3..092ebed754b0c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4707,19 +4707,11 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *node;
-	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_root *delayed_refs = &trans->delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 	int ret = 0;
 
-	delayed_refs = &trans->delayed_refs;
-
 	spin_lock(&delayed_refs->lock);
-	if (atomic_read(&delayed_refs->num_entries) == 0) {
-		spin_unlock(&delayed_refs->lock);
-		btrfs_debug(fs_info, "delayed_refs has NO entry");
-		return ret;
-	}
-
 	while ((node = rb_first_cached(&delayed_refs->href_root)) != NULL) {
 		struct btrfs_delayed_ref_head *head;
 		struct rb_node *n;
-- 
2.43.0



