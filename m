Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F4369990;
	Sat, 12 Sep 2026 08:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200777; cv=none; b=Q2lGa++WiCkDj/Uapp07oR1BHJQM1NK9ea2Br7DM/NhGba8htqogf95HmxKgkb+5zH4fFS9MJfW3XI/cbNI7Zk/C0disPRnDDuAtF1MBTXvIeGUjaG7+fYMLPN7oTCpDc3emJ1WRAWtmW+wc9GA2kVlt75S9fSgpMPQYLObwHPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200777; c=relaxed/simple;
	bh=o6rorzML9hwG6PhCjfK2bpp310t+7L+OzB4GeOjhq5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEeMoGpBa6XZkvAGnY9VrxtcnFHUJRs8VSlBbsG+Bc0SzVWUR70U7ow13MwWuMAscoJja1vXpy1giV8M/uLHmbJvsmIUGHjd4E/mFW5uzJAnAZMwmqtql+QlR0E3VUK3nIO1gKfPr98wdxqlzUddZcQnr545kSaYz5BI4cpaUhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU3WmX1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU3WmX1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8061F000FF;
	Sat, 12 Sep 2026 08:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200776;
	bh=F6v/Z4Xn7lTtKjxbw72PmYCNF/fpKwF6yZzn06adZXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HU3WmX1f28d7gaMJH0DboFdtP8L5gBPGUeFfsAhoY45BLHsnn2+rUaA0mkZeuWy+d
	 3kFcLopfT2P17O97QP3wkZPyConF7usAt6mF9EjczVyfBbcz1UtD71wWh5DG2WKFYA
	 jip38h7xugg7ZurP6MLejF8eW9LsAax1ce4JGDGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0823/1815] lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
Date: Sat, 12 Sep 2026 08:42:53 +0200
Message-ID: <20260912065708.233462547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 6a8024511ddf4877435c34fb3d6028aa8e590649 ]

dmirror_fault() is called from the dmirror_read() and dmirror_write()
retry loops after dmirror_do_read() or dmirror_do_write() finds a missing
device page table entry.

If the mirrored mm has already exited, mmget_not_zero() fails.  The
current code returns 0 in that case, which tells the caller that faulting
succeeded even though no page was faulted and no device page table entry
was installed.  The caller then retries the same address, hits -ENOENT
again, and can loop forever without making progress.

Return -EFAULT instead, so the ioctl fails when the mirrored mm is no
longer faultable.

Link: https://lore.kernel.org/178294308408.327222.3319445682023999403.stgit@skinsburskii
Fixes: b2ef9f5a5cb37 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_hmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index c4adbf98fac79..45c0cb9922184 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -407,7 +407,7 @@ static int dmirror_fault(struct dmirror *dmirror, unsigned long start,
 
 	/* Since the mm is for the mirrored process, get a reference first. */
 	if (!mmget_not_zero(mm))
-		return 0;
+		return -EFAULT;
 
 	for (addr = start; addr < end; addr = range.end) {
 		range.start = addr;
-- 
2.53.0



