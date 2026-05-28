Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA62A32A3FF;
	Thu, 28 May 2026 20:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000018; cv=none; b=FMQE5pd20JiFMXM35ce53hwChNhCV7Pgxh8wBezSbSP24ywDTzWCmvMKUwxBWqAXZpJuz8ClJTtPwn268F3jz/z0yt8HY8PuB9/15bTx5q0tKJS0V4lRS/2Vy2hNvEdVAz+BxdiqKP14M8zgWuBUy5loVXO1BN0zZk0q/4hjsDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000018; c=relaxed/simple;
	bh=NEUV/d0TJe7/+MdjUXKMTYFQj+t/Q0SWkEzP43GDjTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYJCT+brPQk4sPov5Gap7Dm9jq9IkvgErlnHta3+JFKox9XpHmttJEF3hPoBjsFAxtA/EXLVmxxph7K4QpiZRhP845IC1TL4hSN5o8clYymUlu/2XMt1TXt2pDMzi5SOhbnWi6p6zVSiL60rP2G/budSVss2CB6UiyS0axwqwCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GehrZ58j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GehrZ58j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0381F000E9;
	Thu, 28 May 2026 20:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000017;
	bh=CCB1QA4JI/BThIw+gSgMlC6bv4qWbC6vi46d4VxsqkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GehrZ58jn73pnXXTny6Eg6FeWk3197F/sbm1D8MnlLu62CXowz4Mv0iw8XYCsrIs6
	 ziw2n1GbPtLkb/fx4ibUnS1NlORTmaH6Rue6PFxBslizAAryb/X9Llfn6YgFNw9l2+
	 I+mvJpipO+jGv3my+u5NFcjzLseXH6Sf5Gv0coqM=
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
Subject: [PATCH 6.18 236/377] netfs: Fix overrun check in netfs_extract_user_iter()
Date: Thu, 28 May 2026 21:47:54 +0200
Message-ID: <20260528194645.222309417@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



