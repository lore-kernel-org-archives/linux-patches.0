Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065081;
	b=4LrzeY8sXjyx/Q6vL8mcR7S9mmx3+/ryPrJrs7K56lu8kkK+sPFfR53YW+FFLMjihazf
	 5QPeCTaUx6b7N+/hG7gSBltYi+/IVjTuTSsvQwBSOmQUzvTZ8C62gnS8eThsEAGPULxwv
	 tVzSzq894eaOR4kiN01Sw7jYAYKbHx1ifIkl3bi8miZ0QSLfzkQIa9sirEGl9nVeEgYB6
	 jAkj5HWOYJnAedBuH2WOLA3ZZt14sVl8/wUMzC8Rs3uhSML97Yje34bNhPXUwXe0lnSuC
	 b6VaBVhbQw44QOv5F7Q/eE4Ozw1dKdUl9kJyBdzEFM6x6qLI3NLfJ6JlJO9C/uIYqgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C094w1DDp2Vhd/QX0XfVG2mnMkfV9N9IURESMZ+fnj8=;
	b=BJX9KFb0OZqzQopfQbcLgSyNjnb0Z1XJObRtTmJI/Ftof1CXP2tdzFu2IjV+nDfCs8Eq
	 vs2XvlheIwcy3N17kj+iT4lHkAw917f4yU/+WIJERvhbtKPoGkOaRSuoThG9cuHOWpsCR
	 y9uNyKn/dS9pTLBdhDc4K4YnpUGtTg8wJ1M6GE4TDecv7sKlTzn8put9iAVVIG9Pp3ZL2
	 TDGcVfLyrxT2EcJ0zj+70xauByXNCL3tjIOY3/8/Mo83QntBvZFgpExcyq5quVfuUWrcb
	 fZli487PL/PHKfKSlvJyIgIrAJ+GbULKGyv5aNfG1Wlnjmfp4s8wwFa1Ndc7CS6ZnrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNA3WaBs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ADA606A334;
	Sat,  7 Nov 2026 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNA3WaBs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8E51F0089F;
	Sat,  7 Nov 2026 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065081;
	bh=C094w1DDp2Vhd/QX0XfVG2mnMkfV9N9IURESMZ+fnj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNA3WaBspX7bzY1i81Rl+Z0lEFZpWi7seqy8L04KJk6Za0DPLaLmdOd4LX8/DGsQ1
	 qNbQDzBwOuRLXTTA70rxffXofY5ief/RZQy9hjsiGMFEUVdFq7ZWYuzKZtQnGYvDiK
	 YhreCESayARt1BcKBLxCTiwko43vsvlQKrOYaZUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0917/1257] ntfs: avoid truncate and writeback deadlock
Date: Sat,  7 Nov 2026 08:53:33 -0500
Message-ID: <20261107135004.674366701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit fca746064d56329cd81b4f2b1961a3b928c3fe5a ]

ntfs_non_resident_attr_shrink() drops page-cache folios after freeing
clusters and truncating the runlist. The VFS truncate path calls it with
mrec_lock held. A folio writeback can need the same lock to resolve its
iomap mapping, so truncate can wait for writeback while writeback waits
for mrec_lock.

A hung-task call stack:

    truncate: mrec_lock -> truncate_inode_pages() -> folio lock/writeback

    writeback: folio lock/writeback -> ntfs_write_iomap_begin() ->
               mrec_lock

ntfs_setattr_size() already calls truncate_setsize() before
ntfs_truncate_vfs() acquires mrec_lock. Reuse that page-cache truncation
in the VFS path and skip the duplicate truncation under mrec_lock. Keep
the cleanup for internal attribute callers, which do not call
truncate_setsize(). This avoids synchronously flushing the whole
discarded tail while preserving page-cache correctness.

Fixes: 4e646ecd4475 ("ntfs: drop stale page-cache when shrinking a non-resident attr")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index c7c09a751c6a4..b01cbc9eea4ad 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -4234,12 +4234,14 @@ static int ntfs_attr_make_resident(struct ntfs_inode *ni, struct ntfs_attr_searc
  * ntfs_non_resident_attr_shrink - shrink a non-resident, open ntfs attribute
  * @ni:		non-resident ntfs attribute to shrink
  * @newsize:	new size (in bytes) to which to shrink the attribute
+ * @pagecache_truncated: page cache was already truncated to @newsize
  *
  * Reduce the size of a non-resident, open ntfs attribute @na to @newsize bytes.
  */
 static int ntfs_non_resident_attr_shrink(struct ntfs_inode *ni,
 					 const s64 newsize,
-					struct ntfs_inode *locked_ni)
+					struct ntfs_inode *locked_ni,
+					bool pagecache_truncated)
 {
 	struct ntfs_volume *vol;
 	struct ntfs_attr_search_ctx *ctx;
@@ -4389,7 +4391,8 @@ static int ntfs_non_resident_attr_shrink(struct ntfs_inode *ni,
 	 * later writeback map a vcn past the new allocation, which fails with
 	 * -ENOENT and loses the write.
 	 */
-	truncate_inode_pages(VFS_I(ni)->i_mapping, newsize);
+	if (!pagecache_truncated)
+		truncate_inode_pages(VFS_I(ni)->i_mapping, newsize);
 
 	/* Update data size in the index. */
 	if (ni->type == AT_DATA && ni->name == AT_UNNAMED)
@@ -4991,7 +4994,7 @@ int __ntfs_attr_truncate_vfs(struct ntfs_inode *ni, const s64 newsize,
 			up_write(&ni->runlist.lock);
 		} else
 			err = ntfs_non_resident_attr_shrink(
-					ni, newsize, NULL);
+					ni, newsize, NULL, true);
 	} else
 		err = ntfs_resident_attr_resize(ni, newsize, 0,
 						NVolDisableSparse(ni->vol) ?
@@ -5104,7 +5107,7 @@ int ntfs_attr_truncate_i_locked(struct ntfs_inode *ni, const s64 newsize,
 					ni, newsize, 0, holes, locked_ni);
 		else
 			err = ntfs_non_resident_attr_shrink(
-					ni, newsize, locked_ni);
+					ni, newsize, locked_ni, false);
 	} else
 		err = ntfs_resident_attr_resize(ni, newsize, 0, holes);
 	ntfs_debug("Return status %d\n", err);
-- 
2.53.0



