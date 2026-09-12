Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34393815F8;
	Sat, 12 Sep 2026 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242846; cv=none; b=kxlU38BHlPLum/NJnA0iSmUuHzocLfHjNmQFI6/t84ovod0cO4q63fS5v/VM7QI5MuIPWNhAF1u5GeaqHZzGcbEg5adcWqw0GzVEmEYmIodN/RtKjTke4tzvPP3Ypwwz40vsQFzZdIs7qcA5hwTUsrs6o1xjX05sGOEh7V3/Rqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242846; c=relaxed/simple;
	bh=W2dW7voN9T5gKKear9XfGA4GR2aAgvZt9nmLcY9viqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxGMS9sL2dg9X+Q90KBkvzp7Ru5IEWVj3y9wOnA0Ez8kkobGW+omXqhPkhztGoFMiXsrKcAlWxjJCJ6i1IobS8Rr8h6FJig0m2cQNfaKp1KVKjhDEeXrhNwGQzhim6qLlYruDwBrZxMy45J4OA4JDcPK1+2A0ZP4abdF9ukCBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfbQ82Gl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfbQ82Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611881F000FF;
	Sat, 12 Sep 2026 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242844;
	bh=i5l3s/lAyyeXGjHx2b1YhOOJTktvcSqoAzjykAvftPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfbQ82Gl1sc4nGGI1zxX7TvizD836uub6QGrzWTiHnrqSD5a0kkD0qMOgWHL28vML
	 IhptFV+4upKtovWrXjX0nxfkpqA5um5JNnB8B8bzaiM6IOmxO0F703LhAvDMEwO5lk
	 PAum1U24j3pgMirg6hyiRbNzfr1LMJOV96tvTX6c=
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
Subject: [PATCH 5.10 547/798] lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone
Date: Sat, 12 Sep 2026 09:02:55 +0200
Message-ID: <20260912065529.663682409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a85613068d601..e602053ec3ca0 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -295,7 +295,7 @@ static int dmirror_fault(struct dmirror *dmirror, unsigned long start,
 
 	/* Since the mm is for the mirrored process, get a reference first. */
 	if (!mmget_not_zero(mm))
-		return 0;
+		return -EFAULT;
 
 	for (addr = start; addr < end; addr = range.end) {
 		range.start = addr;
-- 
2.53.0



