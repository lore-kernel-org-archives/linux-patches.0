Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D71D328610;
	Tue, 16 Jun 2026 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629393; cv=none; b=p4R4QaaUTQpDWXu6HOpC9//GDdkNUSHcsCJVKexQMFCXw0D98A3svyIe7ju8qNwvbPbwoZlKfM2tA4X+43g3tZcLreHZG6tpU2ZV9XVEp9I326Tw1HxtHq0dAtq/Jbygz5rE2WUPeDVUeTlQzko2+WjJYfXWRnwwpNhu3K6G9xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629393; c=relaxed/simple;
	bh=1uRm54xE73AUE/i1r2inNg5uXiABvQaoLKE0/wSPTgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWqvRdqlwmvyy0ivSCxT6f5nd8nfcJ7MqgCJdbhB7uG0LojBryY8ELezWbBHkjdO0wDmJhpiQA1nrJpUXLyQvYI6UHCw6KTxmiwZ3cwWC0Ze/imDvZsZVHnfgf04rgXMtXuLod1Zt3B0TQxxTkjxXueSv05H6WwOjTqpUnnAX6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxmZZfPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxmZZfPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD5F1F000E9;
	Tue, 16 Jun 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629391;
	bh=G6WKqt59AbRgPj/wX+OQBBmZfX+vjE6+pXR9vWSAAZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxmZZfPlKtYIVT6bWqKM52mDcsRdLVAsCuwFGeUU4VavSXRCiqlkZvW1Jkp1S7v97
	 XKFL3gtQ1aEDVTrDmJM2/H+9vWUy7zId4kS4vw3MHjDsYECWUwh5hy1Zb8A4LcJaB3
	 M86VcovdiwXco/j5/zD/UMTiHwC1VJ61Y+JLQvrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/452] rds: mark snapshot pages dirty in rds_info_getsockopt()
Date: Tue, 16 Jun 2026 20:28:23 +0530
Message-ID: <20260616145132.148085005@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 512db8267b73a220a64180d95ab5eebe7c4964a8 ]

rds_info_getsockopt() pins the destination user pages with FOLL_WRITE and
the RDS_INFO_* producers memcpy the snapshot into them through
kmap_atomic(). Because that copy goes through the kernel direct map, the
dirty bit on the user PTE is never set, so unpin_user_pages() releases the
pages without marking them dirty. A file-backed destination page can then
be reclaimed without writeback, silently discarding the copied data.

Use unpin_user_pages_dirty_lock() with make_dirty=true so the modified
pages are marked dirty before they are unpinned.

Fixes: a8c879a7ee98 ("RDS: Info and stats")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260608-rds_fix-v1-1-006c88543408@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index b6b46a8214a0a5..b3ee5f8238c44d 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -235,7 +235,7 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 
 out:
 	if (pages)
-		unpin_user_pages(pages, nr_pages);
+		unpin_user_pages_dirty_lock(pages, nr_pages, true);
 	kfree(pages);
 
 	return ret;
-- 
2.53.0



