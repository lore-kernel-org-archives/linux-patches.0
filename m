Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1FD4E80BD;
	Wed, 30 Sep 2026 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782938; cv=none; b=bKBvanmOj9J3JqTPHAykmkOSFFLYwUH5WowN0my2OokvMFRJkL7f7HlAsho1H7gUODBCt+acbDybybbBrijpg1QSBZQdF29U+dtonrjwhOhkwZkvN+Xgmot3Eu94ov/eDFvZOqL37oZ3IsZ6rRkSoJGxNiebphvv5ZT5DQH0n48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782938; c=relaxed/simple;
	bh=04QjaOMa9KEmlb8pICtrt3TSXyWWF1q/R9o5BruNYEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhyZwXeLJLZnqI8RNLmdm0Zt5qzF7mt0Seswq7sYNoL4ZnYFzciWONgH5QuZuDWMxyXzSxQc7IyHmmyUivHhY8tB0ZlzPVnw3t7HDKS8SCBK2YbE9P33bJtywYeDwMzkoGvFF4UoKo2Hn4cnO4cVbeerp7BK2sSi/Gkk17xFGFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxOpEHFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxOpEHFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6BA1F000FF;
	Wed, 30 Sep 2026 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782933;
	bh=yenM3mczCg89/KPEM12eGI2NbhePlemj0ecdMhdJ0PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxOpEHFj4O2XbSiKMFMYc/VM/0A78fIn0OpwFs051huLf64R3rlXTolD8Pj2VmNEP
	 9yGYw3h+IBxatZlE+q75DVeJsFfZJjy5VhGUXvMzwRwWtXtQLSQwnEZGzRpSGfk0+4
	 K/3LaTsNQVPUqQMGXee0b9Md2tLQk4SnCA0g4R3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/595] btrfs: return an error from btrfs_record_root_in_trans
Date: Wed, 30 Sep 2026 17:21:55 +0200
Message-ID: <20260930152352.503801226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 03a7e111a94961092e2832a6259d39c8c01d6def ]

We can create a reloc root when we record the root in the trans, which
can fail for all sorts of different reasons.  Propagate this error up
the chain of callers.  Future patches will fix the callers of
btrfs_record_root_in_trans() to handle the error.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: cacf35832292 ("btrfs: do not force reloc root creation during qgroup_account_snapshot()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f9b27cf776c91..5686bafa31c4b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -404,6 +404,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 			       int force)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret = 0;
 
 	if ((test_bit(BTRFS_ROOT_SHAREABLE, &root->state) &&
 	    root->last_trans < trans->transid) || force) {
@@ -452,11 +453,11 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		 * lock.  smp_wmb() makes sure that all the writes above are
 		 * done before we pop in the zero below
 		 */
-		btrfs_init_reloc_root(trans, root);
+		ret = btrfs_init_reloc_root(trans, root);
 		smp_mb__before_atomic();
 		clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
 	}
-	return 0;
+	return ret;
 }
 
 
-- 
2.53.0



