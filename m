Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047604;
	b=IK5htdBzC3qjpccoJTwPuRU5LXnLS3EHSdSpNq228ik/7bOL1DuBWtZailOmitPD8GWW
	 WzAyFJOrjbS/QwrGLEPzQS/egAbs25TvLFv4lzQfTk6CO52VBfnnBszbxsWOUzH9we5zc
	 dvxybJP8lQeXfZV6XCTrKy9AQRiQUI2XNtZH/Tys7xuemAMrVDOukevCyFwqNEUSZ3jvV
	 grQSNlCRwURAh9eaFMrZjCQ8v+zhBplERmzbASYgLCflNaWWf2maFYzrmvIO1qAdGiFXp
	 /QWVVNMRAePEDgc/meBAFTY2Tp3VSfpXXAptrGTh1e20FlFkeibDvDk0h0DxjcOriwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ohB88lGMLH8aMVIc35syg29ucKyr3OUMsMTfRcNDOA0=;
	b=bk1lly+KLLpqXjmCIBBZaNawSalBcq+aWEuwrOhL41GsuxtW9mzp4RPbkNt0rOcniog+
	 aw78zQtFbUeaPLtXqWO6WoESMatS8weeA7yjMk7ZVciREmOClLybgsrRKP7nhBixcckgz
	 QlvyIt5iuYwI9hHaDn27jsTefRjDl8HnMU5GG0dyqpomUjUv72jLMUvltNaSZhZWw1INv
	 P+r7yi6hyuz5EOvqI71bT75TzEMz6ibnnMHKDVfuAJ0B4AKDZNec6U8pDYVuL2X7smZG2
	 tfllFZvLVZMeDGoqtT8yjTdLAS6GRFpCSA3+N49wHwkTtGh6+jIX6aFD/QrkIzaI8jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRWP7E5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F05A606A320;
	Thu, 19 Nov 2026 00:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRWP7E5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832B71F000C4;
	Thu, 19 Nov 2026 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047604;
	bh=ohB88lGMLH8aMVIc35syg29ucKyr3OUMsMTfRcNDOA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRWP7E5pZyEUd10XXjrG5xq60DrpOZC5PoGmj+kI0uRWQHDe1MuGndH3JgCq8ZpSk
	 f7PyFZ+czht6QvKx5cOjIyUJEXcym5ntZov2LewsIznZmUjVtudYtukEzlSFpMkfr2
	 ziG1HMkQiARIbxS9wAxjrADf4tEo+iTxlnH/fxxQ=
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
Subject: [PATCH 6.1 1699/2857] ocfs2: do not read the entry array of an empty xattr bucket
Date: Wed, 18 Nov 2026 15:45:33 +0100
Message-ID: <20261118150302.506052425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit e8de099f2958c84aa23186c5481e69f7ffd39355 ]

ocfs2_check_xattr_bucket_collision() decides whether splitting a bucket
can make room by comparing the hash being inserted against the first and
the last entry.  xh_count comes off disk and is never checked, and a
bucket is allowed to hold no entries: ocfs2_xa_remove_entry() keeps the
last slot when it removes the only one, so that an empty bucket still
carries the hash it is keyed by.  xh_count then reads back as 0 while
xh_entries[0] is still meaningful, and the second comparison indexes
xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header.  An entry is 16 bytes and xe_name_hash is its first
field, so the value read is xh_count | xh_free_start << 16.  It stays
inside the block, but the answer is arbitrary, and for an empty bucket
it says there is no collision, so a new bucket gets added on the
strength of it.

An empty bucket holds no entries to collide with.  Return before reading
the array.

One way to reach the test with an empty bucket is a set that removes the
bucket's only entry during cleanup and then fails for space again, since
it is that second -ENOSPC which calls this.  Growing a value past
OCFS2_XATTR_INLINE_SIZE is the easy route: the cluster allocation fails,
the "!orig_clusters" arm of ocfs2_xa_cleanup_value_truncate() removes
the entry, and although the "growing" caller does set ctxt->set_abort,
only ocfs2_xattr_block_set() and __ocfs2_xattr_set_handle() look at it,
so ocfs2_xattr_set_entry_index_block() goes straight on to the collision
check.

This sits on commit a9ea8b397864 ("ocfs2: use the stored hash when
checking xattr bucket collision"), which gave the collision check its two
argument form and is marked for 6.2 and later.  The read fixed here is
present in the three argument version too, but a tree without that
commit needs the hunk adapted by hand.

Link: https://lore.kernel.org/20261024151012.1059683-5-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fca9ed94ca17a..49b1b4e072ce3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5609,11 +5609,20 @@ static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
 					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 count = le16_to_cpu(xh->xh_count);
+
+	/*
+	 * An empty bucket keeps the hash of the entry that was removed in
+	 * xh_entries[0] so that it can still be found, but it holds no
+	 * entries to collide with.
+	 */
+	if (!count)
+		return 0;
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
 
-	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
+	if (xh->xh_entries[count - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
 		mlog(ML_ERROR, "Too much hash collision in xattr bucket %llu, "
 		     "hash = %u\n",
-- 
2.53.0



