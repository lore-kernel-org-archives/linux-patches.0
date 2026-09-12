Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A8634A78E;
	Sat, 12 Sep 2026 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224272; cv=none; b=suRi9FpxOD/KvjxaSO0w/4CgePCt5yrsqvo1z5KNcEB5g4YcHFXCGf1HJeqisEuohbcnLWVJKZ+DDntNy20E17EOHU1Y89kdM3i1FaIW7NHFBRDrQ3MJcfRTwICwfZleUTYdLVLU8J5/UHD/ku3FuuE/GCG4b/+hQKKXItEuA68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224272; c=relaxed/simple;
	bh=y9rbesbrS2lDEnwR2sw3DdVq1l360FkJOZb+okHGwDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuDDdnEBAU3XDtcWjn4LHHjKF+rssjiRhiGm3BSzctM25a9H/lBv+Dga+XHppEVZ1bOA0BHp0bOI9X3ZUpjTRjJFPGTSg3qAeg/VN27WcVydnQnlFFyBBO9zf+21xp4I5CS+Ml3cG6w20aKXPubdUUDSxBZjoV7qWg9Iut987nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWlCCeLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWlCCeLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA0C1F000FF;
	Sat, 12 Sep 2026 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224270;
	bh=9lr4LXVDvoKKdMOA5b2tbQBbN8QA4jej51fPVstDT3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWlCCeLz4cIkOYKakRGYdMtVvBFhKcNl5jFDLUG/K570pl3tD4WIEKn4Bxl75NVzT
	 QqoX28AjD32UpuzcByg1V9d8A9mnok7RBEJuwh8uRv34s6yl+KT+wUH049IRrhwDk0
	 Uc94jNe6rxCcNgDIxTJA/g8d2n1FDXDjzKzYCLg4=
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
Subject: [PATCH 6.6 0960/1424] lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
Date: Sat, 12 Sep 2026 08:56:32 +0200
Message-ID: <20260912065628.812499008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index cb50065e37a34..943cb521429df 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -391,7 +391,7 @@ static int dmirror_fault(struct dmirror *dmirror, unsigned long start,
 
 	/* Since the mm is for the mirrored process, get a reference first. */
 	if (!mmget_not_zero(mm))
-		return 0;
+		return -EFAULT;
 
 	for (addr = start; addr < end; addr = range.end) {
 		range.start = addr;
-- 
2.53.0



