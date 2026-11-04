Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828992;
	b=IJpJdZHbcHDGjRAVsM6y7ex2ZsJCq1eWqtQ8vk3MPE1jeoLBg+wZraXp2T32JgiYfwjq
	 s7wmTQAjmDx3o1cFnGq+/lcYL4N3hA01ErdabyVSjlciVr3GxsbN76rZBZhH9NrhmJRtr
	 5cCuisjIJtokEl7tD/1nSRCvp9wsxLbb+G2FL1Y0gEWJUYMwZYL5fVAE36cJuPkd1kBD5
	 ee5IB8EXESN2kOo0afVubwZwE9u3j7uVhUtPXf5WnR8eTvjjDuO59a1FWymEegwOCh+hw
	 RAtk3KKmKjCzwkL+OdKvszwCtMK35fuoRyP6bS2YJJttQ4cYXKdnCkTwhP6S1HT+FSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=imStiQVxxfn9wWC4HilPS02IkuKp+prKqZdLvtMhHf0=;
	b=dwXkf/yYm1fNTzmm5Q2sJSq/TuCfEf2JQdvSZSB5oUhN7ofhGgCOP1hk6cRzvwBHLdOw
	 r2B781+SP3Z6WEbCMgsGBnqAIPa1HrMSw5m0FNMLbEvZ8KYqjJApFrxzNqtgrkHeu61Aw
	 KFXWSRvEtB4+Ia6FSj1D3h2i/hZT9dS6Rlp+W499pfdg2SRL2NI244OLmHFAxGcwUVvWa
	 ObkdRgHMlVchcGJCdK0xz/UavCQkH3DjCdzt6O2Lwqus9VKY+pC3vRAuityYcqx5rWsud
	 mfDCSzMGcRvQF1gDoaMv7G7T5ekj8rtS13vYo2LKy+9siJE/jVXHfAuRjnLQARS5WEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FVA6kebF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4B607F281;
	Wed,  4 Nov 2026 21:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FVA6kebF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7831F000C1;
	Wed,  4 Nov 2026 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828992;
	bh=imStiQVxxfn9wWC4HilPS02IkuKp+prKqZdLvtMhHf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVA6kebFLqHSpyk9tEhuRwje4j8mQ73372G5K+3EB8OrkzZC1dpTYNOjh5e/If2Sc
	 YZrcfmwHixMUJx1nByhdUJ7hEy8LtQQ2pDIy3KzQDCUsG6RoOZsQ2zk+wFx2D9LD5Y
	 U641AuDsQ4XcpXjtiGhsQ+n4wrpxyN2RlCfBC0Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 348/547] xfs: bound da-node entry count against the correct geometry
Date: Wed,  4 Nov 2026 16:08:52 -0500
Message-ID: <20261104211048.156319949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 3df5e5aaa3bc0913236c48ab29b7df3a785aa29f upstream.

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because, as a buffer verifier, it
cannot tell whether the block belongs to the directory or the attribute
tree. When the directory block size exceeds the fs block size (e.g.
mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
block that holds only m_attr_geo->node_ents entries, yet a crafted attr
node may claim a count up to m_dir_geo->node_ents and still pass the
verifier.

xfs_da3_node_lookup_int() then indexes btree[] up to that count during
its binary search -- an out-of-bounds read via getxattr/listxattr on a
mounted crafted image.

The buffer verifier is the wrong place to tighten this: it has no fork
context, and the transaction-less read path used by getxattr does not run
xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
hand, always runs on that path and holds args->geo, the geometry of the
fork actually being searched. Bound the entry count against
args->geo->node_ents there, before walking the entries.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_da_btree.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1787,6 +1787,20 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/*
+		 * The node verifier cannot tell whether this block belongs to
+		 * the directory or the attribute tree, so it only bounds the
+		 * entry count against the larger of the two geometries.  Here
+		 * args->geo is the geometry of the fork we are actually
+		 * searching, so reject a count that would walk btree[] off the
+		 * end of this node buffer.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 


