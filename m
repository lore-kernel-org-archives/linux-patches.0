Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F215334FF76;
	Thu, 28 May 2026 20:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000852; cv=none; b=gf1pPuDUBejlF3xcbL0jtUIkLZGxdRpcfB246PGTt7sWS8SEhhZIXP6Q4t2t8e1SgxRn99QBPQXdpNA8KfEHj7VR5LRZCeHBgd/oFdJtiJFimAcamL9E3V0H/HH9xdCCQzwGbYf8hJik3H16xirGXIQ7feNxu7Pk0CHkzgZQagc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000852; c=relaxed/simple;
	bh=D1w9Jz1I1NlOYLWYZIZUvYeSPEU6BuRpvaO1EmTaxDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJYx9a7MNcBxoMTz7MC5du5H1KRzL5iOq68/9bQGKGwOrRKxP2sAcBnDTmvW2M3rcOsoB5ODJI3GSQA4l6S1yi+WTnJazGFdgkaUEAZev4HSD/H9urwk06/YVmR0ex6OUJmq4xrb42g0KiHct1vDQLNBRJkG9ExgaHGrkU9P5Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QKmLWZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QKmLWZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241461F000E9;
	Thu, 28 May 2026 20:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000850;
	bh=g26zRb/fmMs5M7bAk5IIIllQ8EAyiDhcBz3ViZBqwoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QKmLWZlvNKV949kTf1up1amb1hA5uoHfmMfGLy5Y/FGHQd7cFFAhL8Ugzq5NeCQc
	 NZ3LiTs4HBHLifvSwx4RykRbDlaZ+ij8OUjqlGF04cn2QE/iz5eONSjLelaOVyAPq3
	 OoSYV5vsMIq3P0YGF3qQBpvEIvOUi+gMCe/goP2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/272] netfs: Fix overrun check in netfs_extract_user_iter()
Date: Thu, 28 May 2026 21:49:25 +0200
Message-ID: <20260528194634.616007767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0ef37eef83fad3542ee06db2940433ae1a92b39d ]

Fix netfs_extract_user_iter() so that if iov_iter_extract_pages() overfills
pages[], then those pages don't get included in the iterator constructed at
the end of the function.  If there was an overfill, memory corruption has
already happened.

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Closes: https://sashiko.dev/#/patchset/20260427154639.180684-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-11-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/iterator.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 429e4396e1b00..b375567e0520e 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -72,21 +72,24 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 			break;
 		}
 
-		if (ret > count) {
-			pr_err("get_pages rc=%zd more than %zu\n", ret, count);
+		if (WARN(ret > count,
+			 "%s: extract_pages overrun %zd > %zu bytes\n",
+			 __func__, ret, count)) {
+			ret = -EIO;
 			break;
 		}
 
-		count -= ret;
-		ret += offset;
-		cur_npages = DIV_ROUND_UP(ret, PAGE_SIZE);
-
-		if (npages + cur_npages > max_pages) {
-			pr_err("Out of bvec array capacity (%u vs %u)\n",
-			       npages + cur_npages, max_pages);
+		cur_npages = DIV_ROUND_UP(offset + ret, PAGE_SIZE);
+		if (WARN(cur_npages > max_pages - npages,
+			 "%s: extract_pages overrun %u > %u pages\n",
+			 __func__, npages + cur_npages, max_pages)) {
+			ret = -EIO;
 			break;
 		}
 
+		count -= ret;
+		ret += offset;
+
 		for (i = 0; i < cur_npages; i++) {
 			len = ret > PAGE_SIZE ? PAGE_SIZE : ret;
 			bvec_set_page(bv + npages + i, *pages++, len - offset, offset);
@@ -97,6 +100,11 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 		npages += cur_npages;
 	}
 
+	/* Note: Don't try to clean up after EIO.  Either we got no pages, so
+	 * nothing to clean up, or we got a buffer overrun, memory corruption
+	 * and can't trust the stuff in the buffer (a WARN was emitted).
+	 */
+
 	if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
 		for (i = 0; i < npages; i++)
 			unpin_user_page(bv[i].bv_page);
-- 
2.53.0



