Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9352FE29;
	Wed, 23 Sep 2026 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173267; cv=none; b=OrTv/+EJ3e1wWBesv8C+TrE05tUp5hfitPapWBc2ToC38tLCnP/Xtnsk59J0mflvuIUPltiWBdkJuQXqoC+9WU9Fo9A27sDM2HPMu2+6dEPtoWt8P4KUglg9uOYuBnWtl7tUB7qXJAhyxdnU7x/1UkO7S2PwNEqXZ4t1laloH7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173267; c=relaxed/simple;
	bh=3RG/BOFON0VdzIqqdaFTzOLDyiLv0w1SPwRtkdiNPac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2oNwLsHY7CsI6S3vNqCwMcNSdpZQS719o3xmkKvAnjoR8JbyWU+EL+NlAgd2MFHXgI7i8NDtCl+KSdk4XIKDUA180MH8BWLrEHDxEJn8qx1ZdCzL8hCXrnmYk4tSIHRu14SR5xRaNDznzdxvK/zxvshxtne6iMenkJadAkrNCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8QtkhE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8QtkhE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B521F000FF;
	Wed, 23 Sep 2026 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173265;
	bh=GoFzzHAq7dPAyaMydh1LCznhrSsGsqmnU4OVeGOdeYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8QtkhE5mOLQFzJXQZpCRePNyrxUYB0LeqB2IjcsJ7t81TsxG1XoFyVnQ2r051mBJ
	 rS/tnG7huDbHaNSu6+AIbudMuF93Z2FOMGqetmlms/aixmCCKlNk504Kw2Fsfk0lje
	 9roZyAbdrzgHH/Rjatky/p86FLw0CCGgZyhc1sfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 194/438] futex: Also allocate private hash on vfork()
Date: Wed, 23 Sep 2026 16:03:35 +0200
Message-ID: <20260923140649.786281247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit b61b6f95d6722ddbbbd09e689fa41b55fd36f9a5 ]

As Jann demonstrated, it is entirely feasible to access the mm through vfork().
Therefore we need to allocate a private hash on vfork() as well as any other
CLONE_VM user.

Specifically, it must be avoided to have (private) futex waiters before
allocating the private hash.

Fixes: ee9dce44362b ("futex: Drop CLONE_THREAD requirement for private default hash alloc")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260911090447.GT788244@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3340dbaf2bb4a..2c88568b0463d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1977,9 +1977,9 @@ static bool need_futex_hash_allocate_default(u64 clone_flags)
 {
 	/*
 	 * Allocate a default futex hash for any sibling that will
-	 * share the parent's mm, except vfork.
+	 * share the parent's mm.
 	 */
-	return (clone_flags & (CLONE_VM | CLONE_VFORK)) == CLONE_VM;
+	return clone_flags & CLONE_VM;
 }
 
 /*
-- 
2.53.0



