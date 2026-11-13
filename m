Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585626;
	b=BcdDGsAem9wubZ4W0xeHTqYvLVqeDvEfyqzFolugyszHCN9FfiESEycSPS76uB7BveOS
	 T5Ryo5QF6v7PIS37jz07fKHiJffeeU2vb4uHB/xkXWhdKe6+HLlr5pVI48/emnQfKzDPC
	 9qm7k5O/9s0J/IQsm1riAGH2qTOZBVMMSDPFR9AtY8IFu8jbRWfS5+3/Up9ALWUKsr3X5
	 7FIobNwoLCf0Jd1N7kIKioYCE+nl5eTnZ6fowMzxo2/N7RC/QwF6ZuAVclXu7oQchiLa5
	 pl0aFKB4Kxi4Q4JZqjarVjvQ1nsGyYcB3WDH/1948ovqQXl3j576i6h6Uu99WuqomFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0XQ/mqDnOkaLJ0H9g8I7oNMqsHMIpxcMu0w5r1tIi6Y=;
	b=HICfm+utEZZPd1IjKU1t4eWQuPebkg3ntPMEzjLR4C2nzXkluhIF8g6TH336WNqjwgsM
	 /1ecNOsdcKIEIEny1v/jHNQ6yuG/nROE+ofPGCrMY49u8oexoJKdzFFCSA7Lsya6btBWk
	 sZQZQK54wDuHwRPYpyjF/RDpS0LjbfBursIxtJZvfR9mzNGf+BQ6RAQ2EF0vxozYyQsUt
	 kE4aH6C9Z1xsE4oVEiD5ycDPGaJ7TSnDQlzteaX7RIQoWsJyqJGeCGvf9AeAXDelVdS1O
	 XtfD6Iygrs0kuSI02HGl4Y2A13awSX1eqFid93jASnsJQz/+Ghgi2d9fLqXolocrDxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ap9aDXIM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F9B6070FEA;
	Fri, 13 Nov 2026 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ap9aDXIM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078171F000C4;
	Fri, 13 Nov 2026 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585626;
	bh=0XQ/mqDnOkaLJ0H9g8I7oNMqsHMIpxcMu0w5r1tIi6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ap9aDXIMy8z4la1aPFjgWZU6qdgpw3/zlSkF4i/0Pa/RyiSbqud1fYMYxn+DCDs+1
	 29uahdeo3RDL6xB2wDmEregnQuJRsbucby1oZRvtqMVvW2Go6WHFG+OXz/jxCrqug9
	 uhz/hLOuWuayOBiK/49zycfdBnylMj1L2+bQHvyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 248/507] ocfs2: find the xattr entry again after defragmenting a bucket
Date: Fri, 13 Nov 2026 10:49:12 -0500
Message-ID: <20261113153802.974354338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 9a40c050f58344615a0604701b5d299519833163 ]

ocfs2_xattr_set_entry_bucket() hands loc.xl_entry to ocfs2_xa_set() twice:
once for the bucket as it stands, and, if that reports -ENOSPC, once more
after ocfs2_defrag_xattr_bucket() has packed the name/value pairs down.

Defragmenting ends by sorting the entry array on xe_name_hash.  Buckets
are kept sorted, so the sort only permutes entries that share a hash, but
lib/sort.c is an unstable heapsort and it does permute them.  loc.xl_entry
is an address inside xh_entries[], so afterwards it denotes whichever
entry landed in that slot rather than the one the search found.

The second ocfs2_xa_set() then works on the wrong entry.  Nothing on that
path compares the entry's name with xi->xi_name, so what happens depends
on how the two entries compare in size: ocfs2_xa_reuse_entry() trips its
BUG_ON() when the padded name sizes differ, and otherwise the new value is
written into the neighbouring attribute's value slot while the attribute
being set is left untouched.  setxattr() reports success either way.

Remember the entry's hash before defragmenting and look the entry up
again afterwards, the way ocfs2_xattr_bucket_find() does.  An entry that
cannot be found again means the bucket no longer holds what the search
found, so fail with -EFSCORRUPTED rather than writing through the stale
pointer.

Link: https://lore.kernel.org/20261024151012.1059683-3-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 18ebe3cc64ec1..4b9f742cef554 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5873,13 +5873,18 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 					struct ocfs2_xattr_search *xs,
 					struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret;
+	int ret, found = 0;
+	u16 xe_index;
+	u32 name_hash;
 	struct ocfs2_xa_loc loc;
 
 	trace_ocfs2_xattr_set_entry_bucket(xi->xi_name);
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
+	/* Defragmenting below may move this entry, so remember its hash. */
+	name_hash = loc.xl_entry ? le32_to_cpu(loc.xl_entry->xe_name_hash) : 0;
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
@@ -5898,6 +5903,29 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * ocfs2_defrag_xattr_bucket() sorts the entries by name hash and
+	 * lib/sort.c is not stable, so entries sharing a hash may have traded
+	 * slots.  Look the entry up again before writing through it.
+	 */
+	if (loc.xl_entry) {
+		ret = ocfs2_find_xe_in_bucket(inode, xs->bucket,
+					      xi->xi_name_index, xi->xi_name,
+					      name_hash, &xe_index, &found);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		if (!found) {
+			mlog(ML_ERROR, "xattr entry not found in bucket %llu after defrag\n",
+			     (unsigned long long)bucket_blkno(xs->bucket));
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		loc.xl_entry = &bucket_xh(xs->bucket)->xh_entries[xe_index];
+		xs->here = loc.xl_entry;
+	}
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
-- 
2.53.0



