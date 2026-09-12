Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76603345CCE;
	Sat, 12 Sep 2026 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227503; cv=none; b=RFhg6399NaoCuWZ6lcD6NP6zmoaPjo2r45sPfUSve/2Ss6dfdWUDNM8AVpBDd/0Y65XFQiSr11wlUfKSmA6Q2unlnBSr3HJPzK3ClsT14r2nfZxnDWw9VTV/fQ2fA3R2QfnD6s9ykrrN59zYyGyPe9Q5sNBuyr2ousUhAXQavbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227503; c=relaxed/simple;
	bh=f+8pm9xj4vu7etJ7ruJ0snxA7mZOyFP2jNC6m9FIrZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQVXe5Ttn8uNiBdGKFLY5LmNgmeAo0RWuNQJBvq8C7CT2m/zxgAZ3ED6H1BE1Ul4AmHIifyNRrcQ6SAOoh2alUywc+lmwWzB6T4l1QKfX8bOgrmte5yr8ueDp8MaLIgDg6rX/OM3U25r+lTeqOExLWW0MORgfpcBAkm7/TyHKMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSCQm4hz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSCQm4hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3E51F000FF;
	Sat, 12 Sep 2026 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227502;
	bh=R63pk6/b5BQ00dN3uIEgnBUn465gzgTNTaxvrE60onI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSCQm4hzIBPhPjFuxS4dDLPBNd26D1Q/y38wWo/g5H9zMoBFV/3e/m5jrLTqb/jKO
	 OLkestL4HniMIu9JxvjbY/NhaVoipUHDnpSgHevOtXmb8FEdYY20cVnuz1QJ8cJsXT
	 QR8H7Jhy4C9rCo+3QUAUsFcUPGeWy9EC/l6N6wMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0152/1191] ocfs2: validate rl_used against rl_count in refcount block validator
Date: Sat, 12 Sep 2026 08:48:00 +0200
Message-ID: <20260912065551.618541873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

commit 4ca62df6bc0708947b48da3f6a712ecb8e73929c upstream.

ocfs2_find_refcount_rec_in_rl() walks the on-disk refcount record array
with:

	for (; i < le16_to_cpu(rb->rf_records.rl_used); i++) {
		rec = &rb->rf_records.rl_recs[i];
		...

rl_recs[] lives in a single metadata block (4096 bytes on the common
configuration), so its real capacity is fixed by
ocfs2_refcount_recs_per_rb(sb) (247 records for a 4K block with the
16-byte ocfs2_refcount_rec).  rl_used and rl_count are both read directly
off disk by ocfs2_validate_refcount_block() and are never checked against
that capacity, nor against each other, before any refcount/reflink/CoW
operation walks the array.

A crafted (or corrupted) refcount block with rl_used == 0xffff makes the
loop above walk far past the end of the block, dereferencing rl_recs[i]
for i up to 65534.  The resulting index is then handed to the sibling
ocfs2_insert_refcount_rec(), whose insert-shift does:

	if (index < le16_to_cpu(rf_list->rl_used))
		memmove(&rf_list->rl_recs[index + 1],
			&rf_list->rl_recs[index],
			(le16_to_cpu(rf_list->rl_used) - index) *
			 sizeof(struct ocfs2_refcount_rec));

i.e.  a memmove() of up to (0xffff - index) * 16 bytes (~1 MiB) from an
offset already past the block.  This is reachable from an ordinary reflink
(FICLONE) against a crafted/corrupted ocfs2 image: attaching an extent
whose cpos sorts past every real record in the leaf forces the lookup to
run off the end instead of returning early on a match.  The attacker model
is local: CAP_SYS_ADMIN mounting a crafted or corrupted ocfs2 image, or a
raw write to the block device backing an already-mounted ocfs2 filesystem.

ocfs2_validate_refcount_block() already validates the block's ECC,
signature, rf_blkno and rf_fs_generation, but never rl_count/rl_used
against the block's actual on-disk capacity.  This is the same class of
gap that ocfs2_validate_extent_block() (fs/ocfs2/alloc.c) already closes
for the sibling extent-list header, which checks both the record capacity
and the "used" bound before any code walks h_list.l_recs[]:

	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
		rc = ocfs2_error(...);
		goto bail;
	}

	if (le16_to_cpu(eb->h_list.l_next_free_rec) >
	    le16_to_cpu(eb->h_list.l_count)) {
		rc = ocfs2_error(...);
		goto bail;
	}

Add the equivalent pair of checks to ocfs2_validate_refcount_block():
reject a refcount block whose rl_count does not match the fixed per-block
capacity returned by ocfs2_refcount_recs_per_rb(), and reject rl_used >
rl_count.  Both checks are skipped when OCFS2_REFCOUNT_TREE_FL is set,
because in that case the same union bytes hold an ocfs2_extent_list
(rf_list), not the refcount record list (rf_records) -- that layout is
already validated separately by ocfs2_validate_extent_block() when the
referenced extent block is read.  This mirrors the existing
"!(rb->rf_flags & OCFS2_REFCOUNT_TREE_FL)" guard used elsewhere in this
file (e.g.  ocfs2_get_refcount_rec()) to decide whether rf_records or
rf_list is the live member of the union.

With this in place, a forged rl_used/rl_count is caught at block
validation time (ocfs2_error()), consistent with every other corruption
check in this function, instead of driving an out-of-bounds read in
ocfs2_find_refcount_rec_in_rl() and a subsequent out-of-bounds memmove()
in ocfs2_insert_refcount_rec().

Verified against a crafted image on a v6.19 KASAN (KASAN_GENERIC) build:
replaying the same reflink (FICLONE) reliably hit a KASAN report in
__ocfs2_increase_refcount()/ocfs2_insert_refcount_rec() before this patch,
and triggers no report once ocfs2_validate_refcount_block() rejects the
forged rl_used/rl_count.

Link: https://lore.kernel.org/20260709132609.44233-1-security@auditcode.ai
Fixes: f2c870e3b12e ("ocfs2: Add ocfs2_read_refcount_block.")
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Assisted-by: AuditCode-AI:2026.07
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/refcounttree.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -116,6 +116,33 @@ static int ocfs2_validate_refcount_block
 				 le32_to_cpu(rb->rf_fs_generation));
 		goto out;
 	}
+
+	/*
+	 * rf_records (rl_count/rl_used/rl_recs[]) is only meaningful when
+	 * this block is not an interior tree block (OCFS2_REFCOUNT_TREE_FL);
+	 * in that case the same union bytes hold an extent list (rf_list)
+	 * instead, which is validated by ocfs2_validate_extent_block().
+	 */
+	if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL)) {
+		if (le16_to_cpu(rb->rf_records.rl_count) !=
+		    ocfs2_refcount_recs_per_rb(sb)) {
+			rc = ocfs2_error(sb,
+					 "Refcount block #%llu has an invalid rl_count of %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(rb->rf_records.rl_count));
+			goto out;
+		}
+
+		if (le16_to_cpu(rb->rf_records.rl_used) >
+		    le16_to_cpu(rb->rf_records.rl_count)) {
+			rc = ocfs2_error(sb,
+					 "Refcount block #%llu has an invalid rl_used of %u (rl_count %u)\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(rb->rf_records.rl_used),
+					 le16_to_cpu(rb->rf_records.rl_count));
+			goto out;
+		}
+	}
 out:
 	return rc;
 }


