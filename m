Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98EA2FAC06;
	Tue, 12 Aug 2025 18:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024840; cv=none; b=ptI14wOi1U/A4dvv7fzNXOkIj8SHmwzM+xA/hzt0PKXMQZl3ziGLIvyf009dJYMc+jTIRNuTmnpTS6+6yc65SQBAFy8mSGbVNlX8POJMYEWnEuFirPEwOkBlWdCOgPv+MlaMhmiEAm+wayZ6kD/2lZJIrIbZ+AyedRhYs8hzD8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024840; c=relaxed/simple;
	bh=TOR5CIw+QA/U82cBQxCQTv/eltIInPUu2376kklcXEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4phXw7nPKs/aR26NthNt/2y9XiYugidC7dmBmspd77dIbtJ2KARHeuJL4eE/Qmt28NHzru/IRHqlKJjDo7aQpbo2MvcYmhvyFGAJon/oEa/cVlK3N6JYYQamBHjuPxwZgWhAMT8jwExcYGyi5Sag/Pd7JCGZQ+FnhjOLwUAlzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzRYdkXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzRYdkXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE31C4CEF1;
	Tue, 12 Aug 2025 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024839;
	bh=TOR5CIw+QA/U82cBQxCQTv/eltIInPUu2376kklcXEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzRYdkXB7TYWteNggsiQljAQdtp/wIxU1gVBrzrXCMmqLuCzgnoZaQiXrXTda20iB
	 Y9L3TxZX39kQ9g3IP4VF1Lo2tXY2Kv+Jry6H0T3fN4YEJyNrW/ERY7TD6ZP+ZO3GeO
	 clBV70XluuGF87VFUIsgLPkrc2DSJ2KniZfNpclA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Chanho Min <chanho.min@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 459/627] squashfs: fix incorrect argument to sizeof in kmalloc_array call
Date: Tue, 12 Aug 2025 19:32:34 +0200
Message-ID: <20250812173438.801755537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 97103dcec292b8688de142f7a48bd0d46038d3f6 ]

The sizeof(void *) is the incorrect argument in the kmalloc_array call, it
best to fix this by using sizeof(*cache_folios) instead.

Fortunately the sizes of void* and folio* happen to be the same, so this
has not shown up as a run time issue.

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20250708142604.1891156-1-colin.i.king@gmail.com
Fixes: 2e227ff5e272 ("squashfs: add optional full compressed block caching")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 296c5a0fcc40..e7a4649fc85c 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -89,7 +89,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 	struct folio **cache_folios = kmalloc_array(page_count,
-			sizeof(void *), GFP_KERNEL | __GFP_ZERO);
+			sizeof(*cache_folios), GFP_KERNEL | __GFP_ZERO);
 #endif
 
 	bio_for_each_folio_all(fi, fullbio) {
-- 
2.39.5



