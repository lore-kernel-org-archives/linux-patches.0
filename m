Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68952248886;
	Wed, 25 Feb 2026 01:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983678; cv=none; b=Stu0jsSwYNhxzRSIYo92TBqtdddLpG8HpHeSe9vZo+AR+Ke81v0H2VsU4upSnJCIEGN+51NvwASSMzotonfkh0RhR3Wt3wh6b5mjXUlLHfUa0X/eLyp9OtN4x0rUjk+6/tcyQIpIlj/BnhHyEkRSertanF4jOJnhQoIpx6qjhNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983678; c=relaxed/simple;
	bh=fn+pbtlfS47jeOfYk9u72wPYKeKxSbMZodt6EDY6ZzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emqHRMvnjyLdQ9gKCT6EZq+vBKVtR6DPTs9c0ai2trEuDUHikBq6rhDDB9IKz+IlzZTgDOJfb2prdK09KSwI+wTEfHnIb2N0U7lFBeUSbQTg9eepEBMbUmBqNS0zpCfRG0si4pWYKp9FN5fhGKVxOHWxd+uwoGOdkdCUHOBYIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHkGlc22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHkGlc22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3373EC116D0;
	Wed, 25 Feb 2026 01:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983678;
	bh=fn+pbtlfS47jeOfYk9u72wPYKeKxSbMZodt6EDY6ZzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHkGlc22Ty+xl7un9Fbi15bpeA3Di16mY/rK8S8bSOm90UMYbAjYDA1Kxe2fwzYZ+
	 H9TRPnlRcVr4i2uxrEFrELqWJROQ7q0nR9+dBE+WM+o3QCV5kKj3RRnJzy7gAEXJ9U
	 sRLkO7feSrzjNvWPUWQjkAzv7lF4kO/wbidshgs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 762/781] ext4: fix dirtyclusters double decrement on fs shutdown
Date: Tue, 24 Feb 2026 17:24:31 -0800
Message-ID: <20260225012418.409783752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

commit 94a8cea54cd935c54fa2fba70354757c0fc245e3 upstream.

fstests test generic/388 occasionally reproduces a warning in
ext4_put_super() associated with the dirty clusters count:

  WARNING: CPU: 7 PID: 76064 at fs/ext4/super.c:1324 ext4_put_super+0x48c/0x590 [ext4]

Tracing the failure shows that the warning fires due to an
s_dirtyclusters_counter value of -1. IOW, this appears to be a
spurious decrement as opposed to some sort of leak. Further tracing
of the dirty cluster count deltas and an LLM scan of the resulting
output identified the cause as a double decrement in the error path
between ext4_mb_mark_diskspace_used() and the caller
ext4_mb_new_blocks().

First, note that generic/388 is a shutdown vs. fsstress test and so
produces a random set of operations and shutdown injections. In the
problematic case, the shutdown triggers an error return from the
ext4_handle_dirty_metadata() call(s) made from
ext4_mb_mark_context(). The changed value is non-zero at this point,
so ext4_mb_mark_diskspace_used() does not exit after the error
bubbles up from ext4_mb_mark_context(). Instead, the former
decrements both cluster counters and returns the error up to
ext4_mb_new_blocks(). The latter falls into the !ar->len out path
which decrements the dirty clusters counter a second time, creating
the inconsistency.

To avoid this problem and simplify ownership of the cluster
reservation in this codepath, lift the counter reduction to a single
place in the caller. This makes it more clear that
ext4_mb_new_blocks() is responsible for acquiring cluster
reservation (via ext4_claim_free_clusters()) in the !delalloc case
as well as releasing it, regardless of whether it ends up consumed
or returned due to failure.

Fixes: 0087d9fb3f29 ("ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20260113171905.118284-1-bfoster@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc-test.c |    2 +-
 fs/ext4/mballoc.c      |   21 +++++----------------
 2 files changed, 6 insertions(+), 17 deletions(-)

--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -567,7 +567,7 @@ test_mark_diskspace_used_range(struct ku
 
 	bitmap = mbt_ctx_bitmap(sb, TEST_GOAL_GROUP);
 	memset(bitmap, 0, sb->s_blocksize);
-	ret = ext4_mb_mark_diskspace_used(ac, NULL, 0);
+	ret = ext4_mb_mark_diskspace_used(ac, NULL);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	max = EXT4_CLUSTERS_PER_GROUP(sb);
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4186,8 +4186,7 @@ out_err:
  * Returns 0 if success or error code
  */
 static noinline_for_stack int
-ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
-				handle_t *handle, unsigned int reserv_clstrs)
+ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac, handle_t *handle)
 {
 	struct ext4_group_desc *gdp;
 	struct ext4_sb_info *sbi;
@@ -4242,13 +4241,6 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	BUG_ON(changed != ac->ac_b_ex.fe_len);
 #endif
 	percpu_counter_sub(&sbi->s_freeclusters_counter, ac->ac_b_ex.fe_len);
-	/*
-	 * Now reduce the dirty block count also. Should not go negative
-	 */
-	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
-		/* release all the reserved blocks if non delalloc */
-		percpu_counter_sub(&sbi->s_dirtyclusters_counter,
-				   reserv_clstrs);
 
 	return err;
 }
@@ -6333,7 +6325,7 @@ repeat:
 			ext4_mb_pa_put_free(ac);
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
-		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_clstrs);
+		*errp = ext4_mb_mark_diskspace_used(ac, handle);
 		if (*errp) {
 			ext4_discard_allocated_blocks(ac);
 			goto errout;
@@ -6364,12 +6356,9 @@ errout:
 out:
 	if (inquota && ar->len < inquota)
 		dquot_free_block(ar->inode, EXT4_C2B(sbi, inquota - ar->len));
-	if (!ar->len) {
-		if ((ar->flags & EXT4_MB_DELALLOC_RESERVED) == 0)
-			/* release all the reserved blocks if non delalloc */
-			percpu_counter_sub(&sbi->s_dirtyclusters_counter,
-						reserv_clstrs);
-	}
+	/* release any reserved blocks */
+	if (reserv_clstrs)
+		percpu_counter_sub(&sbi->s_dirtyclusters_counter, reserv_clstrs);
 
 	trace_ext4_allocate_blocks(ar, (unsigned long long)block);
 


