Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2506FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A833C433C7;
	Sun, 17 Sep 2023 19:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980580;
	bh=85QHQLH9ykH1BK1k+SKFqT7ndvWwwjQ1OLGFwKU2WZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0yBBsLXkWthrad0rpZKmMia3/GP/rl+EIrSBvqjCAIR+XjuJho1I8H/nGIbmo3PZ
	 AMwy/BnehFt1KWMXHF/hcyMp7dv28CMpXsOB3JxZQBnkaMvJC+A9Rbym6cukOCrTCD
	 XoNp/wibvWonahrMZdNpzqFrgccAS7+kWdsD4dMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 203/285] btrfs: fix start transaction qgroup rsv double free
Date: Sun, 17 Sep 2023 21:13:23 +0200
Message-ID: <20230917191058.603731703@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit a6496849671a5bc9218ecec25a983253b34351b1 upstream.

btrfs_start_transaction reserves metadata space of the PERTRANS type
before it identifies a transaction to start/join. This allows flushing
when reserving that space without a deadlock. However, it results in a
race which temporarily breaks qgroup rsv accounting.

T1                                              T2
start_transaction
do_stuff
                                            start_transaction
                                                qgroup_reserve_meta_pertrans
commit_transaction
    qgroup_free_meta_all_pertrans
                                            hit an error starting txn
                                            goto reserve_fail
                                            qgroup_free_meta_pertrans (already freed!)

The basic issue is that there is nothing preventing another commit from
committing before start_transaction finishes (in fact sometimes we
intentionally wait for it) so any error path that frees the reserve is
at risk of this race.

While this exact space was getting freed anyway, and it's not a huge
deal to double free it (just a warning, the free code catches this), it
can result in incorrectly freeing some other pertrans reservation in
this same reservation, which could then lead to spuriously granting
reservations we might not have the space for. Therefore, I do believe it
is worth fixing.

To fix it, use the existing prealloc->pertrans conversion mechanism.
When we first reserve the space, we reserve prealloc space and only when
we are sure we have a transaction do we convert it to pertrans. This way
any racing commits do not blow away our reservation, but we still get a
pertrans reservation that is freed when _this_ transaction gets committed.

This issue can be reproduced by running generic/269 with either qgroups
or squotas enabled via mkfs on the scratch device.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -591,8 +591,13 @@ start_transaction(struct btrfs_root *roo
 		u64 delayed_refs_bytes = 0;
 
 		qgroup_reserved = num_items * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta_pertrans(root, qgroup_reserved,
-				enforce_qgroups);
+		/*
+		 * Use prealloc for now, as there might be a currently running
+		 * transaction that could free this reserved space prematurely
+		 * by committing.
+		 */
+		ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reserved,
+							 enforce_qgroups, false);
 		if (ret)
 			return ERR_PTR(ret);
 
@@ -705,6 +710,14 @@ again:
 		h->reloc_reserved = reloc_reserved;
 	}
 
+	/*
+	 * Now that we have found a transaction to be a part of, convert the
+	 * qgroup reservation from prealloc to pertrans. A different transaction
+	 * can't race in and free our pertrans out from under us.
+	 */
+	if (qgroup_reserved)
+		btrfs_qgroup_convert_reserved_meta(root, qgroup_reserved);
+
 got_it:
 	if (!current->journal_info)
 		current->journal_info = h;
@@ -752,7 +765,7 @@ alloc_fail:
 		btrfs_block_rsv_release(fs_info, &fs_info->trans_block_rsv,
 					num_bytes, NULL);
 reserve_fail:
-	btrfs_qgroup_free_meta_pertrans(root, qgroup_reserved);
+	btrfs_qgroup_free_meta_prealloc(root, qgroup_reserved);
 	return ERR_PTR(ret);
 }
 


