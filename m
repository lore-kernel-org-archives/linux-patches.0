Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD2A1DDE3
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYy+OtxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E99DC433C8;
	Tue, 31 Oct 2023 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698761627;
	bh=LxglA0UNCyPvBjf3yaaDGDAG38uxu8HYtT6gQZtbBRU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=zYy+OtxUmsknj/+9zic/jXhYFIFKd6+8vVfol+KV3yPlswQpV2veokP+EUxJHilQQ
	 f6b20NiBu4a4Gw/cUVq1ZBS8DmpHcrlaDdSBdmklb23nDvdv268xgtYscKiuhGOzJI
	 afJl1HpZqms3Y83sVJJLWBxo4GUGgOvIJsu+ZAqg=
Subject: Patch "ext4: avoid overlapping preallocations due to overflow" has been added to the 5.10-stable tree
To: gregkh@linuxfoundation.org,jack@suse.cz,libaokun1@huawei.com,patches@lists.linux.dev,ritesh.list@gmail.com,sashal@kernel.org,tytso@mit.edu,yangerkun@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Oct 2023 15:13:36 +0100
In-Reply-To: <20231028064009.766680-3-libaokun1@huawei.com>
Message-ID: <2023103136-reason-platinum-745b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ext4: avoid overlapping preallocations due to overflow

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-avoid-overlapping-preallocations-due-to-overflow.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Sat Oct 28 08:35:45 2023
From: Baokun Li <libaokun1@huawei.com>
Date: Sat, 28 Oct 2023 14:40:09 +0800
Subject: ext4: avoid overlapping preallocations due to overflow
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <tytso@mit.edu>, <jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>, <yangerkun@huawei.com>, <libaokun1@huawei.com>
Message-ID: <20231028064009.766680-3-libaokun1@huawei.com>

From: Baokun Li <libaokun1@huawei.com>

commit bedc5d34632c21b5adb8ca7143d4c1f794507e4c upstream.

Let's say we want to allocate 2 blocks starting from 4294966386, after
predicting the file size, start is aligned to 4294965248, len is changed
to 2048, then end = start + size = 0x100000000. Since end is of
type ext4_lblk_t, i.e. uint, end is truncated to 0.

This causes (pa->pa_lstart >= end) to always hold when checking if the
current extent to be allocated crosses already preallocated blocks, so the
resulting ac_g_ex may cross already preallocated blocks. Hence we convert
the end type to loff_t and use pa_logical_end() to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230724121059.11834-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3515,8 +3515,7 @@ ext4_mb_normalize_request(struct ext4_al
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int bsbits, max;
-	ext4_lblk_t end;
-	loff_t size, start_off;
+	loff_t size, start_off, end;
 	loff_t orig_size __maybe_unused;
 	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3624,7 +3623,7 @@ ext4_mb_normalize_request(struct ext4_al
 	/* check we don't cross already preallocated blocks */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
+		loff_t pa_end;
 
 		if (pa->pa_deleted)
 			continue;
@@ -3634,8 +3633,7 @@ ext4_mb_normalize_request(struct ext4_al
 			continue;
 		}
 
-		pa_end = pa->pa_lstart + EXT4_C2B(EXT4_SB(ac->ac_sb),
-						  pa->pa_len);
+		pa_end = pa_logical_end(EXT4_SB(ac->ac_sb), pa);
 
 		/* PA must not overlap original request */
 		BUG_ON(!(ac->ac_o_ex.fe_logical >= pa_end ||
@@ -3664,12 +3662,11 @@ ext4_mb_normalize_request(struct ext4_al
 	/* XXX: extra loop to check we really don't overlap preallocations */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
+		loff_t pa_end;
 
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0) {
-			pa_end = pa->pa_lstart + EXT4_C2B(EXT4_SB(ac->ac_sb),
-							  pa->pa_len);
+			pa_end = pa_logical_end(EXT4_SB(ac->ac_sb), pa);
 			BUG_ON(!(start >= pa_end || end <= pa->pa_lstart));
 		}
 		spin_unlock(&pa->pa_lock);


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.10/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-5.10/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-5.10/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
