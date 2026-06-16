Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAFF36A36C;
	Tue, 16 Jun 2026 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634054; cv=none; b=Idj2IYIBX6NQu37y1iEh3lVPMnUOqJfvBkeoYhknTWQr6fzJUwNFO5kK/rxH2z76S/QRFPI6kmhUYmcIZddqUoi6v+rPiKhTA/Kfs3Ux0RkD0SzUyoKNJ1owFtKbfRqUURFPM8hu+7ntt+mwVe3OBTi3kFUk+FNM7NNuE5kYcOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634054; c=relaxed/simple;
	bh=pdDuz5x3/Zi/P6Gh678DmFEa51RwhxApvPyfxqBjjjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amAr3UPla7ADT0CsTsxVOCsbkOXP4drWk5cXSr6sCXGY9lsG1xn3CuOWAWIWIyyZZneXfX5bnWEe3dYW47HgF8dfmqNkiSYFpa+XAGu/SMW6WG11+qSMAfr80Wqlc+kw4izESbywUI46/sm1sPn8h7UacA3uz2u/Lx9xoOJEVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHkDs8xB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHkDs8xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B251F00A3A;
	Tue, 16 Jun 2026 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634053;
	bh=7aJZtCloKiiTD6jk+rNzKfD1Ajamr9swigPeNZWr2pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHkDs8xBT7G1wN3un51UEigkEAlrZmaNgc6dwCIX88CA3eZh/Q+2skKUb0YD+aMUr
	 bO9ojZyqVlOM3OsKgY/pq+IdcjYDYukC6fFKQiqbdtTJ0WQ9fJBVO3N4x46IO9Nr8K
	 MBwunNXSOajtBkay3vEQpvQaHYCiR+uV9SkbEwDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/411] rds: mark snapshot pages dirty in rds_info_getsockopt()
Date: Tue, 16 Jun 2026 20:27:09 +0530
Message-ID: <20260616145110.861896051@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



